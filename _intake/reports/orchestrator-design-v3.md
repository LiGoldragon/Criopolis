# Orchestrator design v3 — final, integrating explorer findings

*Filed by mayor 2026-05-04. Supersedes v1 (Stop hooks) and v2 (database events, designed without prior art).*
*Source briefs: `_intake/explorer/cr-fc8go4-orchestrator-pattern.md`, `research/answers/cascade-canonical-pattern.md`, `_intake/synthesis-013-multi-agent-patterns.md`.*

## What v3 changes from v2

v2 designed a shell daemon for cascade dispatch *as if from scratch*. Explorer found prior art:

1. **`gc convoy control --serve` is already a persistent deterministic dispatcher in gc itself.** Long-running worker, wakes on bead created/closed/updated events plus periodic sweeps, processes ready control beads. (`cmd/gc/cmd_convoy_dispatch.go:51-82`, `cmd/gc/dispatch_runtime.go:320-405`). Currently scoped to graph.v2 workflow control. This is the shape we want.
2. **Kit (third-party `bmt/gascity-explore`) implements a patrol-agent pattern.** Steward agent's startup loop: check assigned + `gc.routed_to` work, loop while work exists, exit when idle. A cooldown order watches stuck states and mails mayor. This is the LLM-pulse variant of the same shape.
3. **Code-writer's earlier refusal on event-triggered orders was correct for the naive shape, but the cursor + body-filter pattern sidesteps the limitations.** Use `gc events --since <cursor>`, advance cursor on each pass, body filters by label.

## Architecture (v3)

```
┌─────────────────────────────────────────────────────────────────┐
│           CASCADE LOOP — borrowed from control-dispatcher       │
└─────────────────────────────────────────────────────────────────┘

  ┌──────┐
  │MAYOR │ ─── creates chain beads with cascade metadata ────────┐
  │      │     (does NOT sling — orchestrator handles all slings)│
  └──────┘                                                       │
                                                                 │
                                                                 ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                        BEAD STORE (dolt)                         │
  │                                                                  │
  │  cr-A: routed_to=satya,    cascade_position=1, cascade_next=cr-B│
  │  cr-B: routed_to=viveka,   cascade_position=2, cascade_next=cr-C│
  │  cr-C: routed_to=dharma,   cascade_position=3, cascade_final=true│
  └──────────────────────────────────────────────────────────────────┘
                       ▲                            │
                       │                            │
                       │ each agent picks up its bead via WorkQuery
                       │ (default: gc.routed_to=<me>)
                       │ each agent does work, closes bead
                       │
  ┌────────────────────┴─────────────────────────────────────────────┐
  │              AGENTS (satya, viveka, dharma...)                   │
  │  Wake on sling → find bead → do work → close bead.               │
  │  No --notify discipline. No mail. Just close.                    │
  └────────────────────┬─────────────────────────────────────────────┘
                       │
                       │ bead-created + bead-closed events
                       ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │           GC EVENT BUS (already exists, already paying)          │
  └────────────────────┬─────────────────────────────────────────────┘
                       │
                       │ orchestrator subscribed via cursor pattern
                       ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │              ORCHESTRATOR (shell daemon — Path A from v2)        │
  │                                                                  │
  │  Loop:                                                           │
  │    new_events = gc events --since $cursor --type bead.created,bead.closed
  │    for event in new_events:                                      │
  │      bead = gc bd show $event.subject --json                     │
  │      if cascade-chain not in bead.labels: skip                   │
  │      if bead.metadata.label == "order-tracking": skip            │
  │                                                                  │
  │      if event == bead.created and cascade_position == 1:         │
  │        gc sling $bead.routed_to $bead.id    # start chain        │
  │      elif event == bead.closed and bead.cascade_next:            │
  │        next = gc bd show $bead.cascade_next --json               │
  │        gc sling $next.routed_to $bead.cascade_next  # advance    │
  │      elif event == bead.closed and bead.cascade_final == "true": │
  │        gc mail send --notify mayor                               │
  │           -s "cascade complete: $bead.cascade_id"                │
  │           -m "Final bead $bead.id closed."                       │
  │                                                                  │
  │    save_cursor $new_max_seq                                      │
  │    sleep 5  # OR block on next event via streaming               │
  └──────────────────────────────────────────────────────────────────┘
                       │
                       │ if cascade_final: --notify wakes mayor
                       ▼
  ┌──────┐
  │MAYOR │ ←── reads + synthesizes when convenient
  │      │
  └──────┘
```

## Mechanism (resolved)

**Subscription:** `gc events --since <cursor>` is the pull-mode interface. Cursor stored in a small file (`/home/li/Criopolis/.gc/orchestrator-cursor`). Each loop iteration reads new events since cursor, advances cursor.

Why pull (cursor) not stream (`--watch`):
- Simpler error handling (no stream-disconnect edge cases)
- Survives daemon restarts cleanly (cursor persists)
- Same mechanism gc's own control-dispatcher uses (per explorer finding `cmd/gc/dispatch_runtime.go:320-405` — wakes on events plus sweeps)
- Streaming can be added later if pull proves slow

**How the daemon runs:** open question for code-writer. Three options:
1. **Custom gc provider** pointing at a shell wrapper (per researcher cr-kbg2ir, providers support custom `command`/`args`/`env`/`path_check`).
2. **Run as a regular agent** with the shell script as its prompt's startup command (codex agent that immediately delegates to a script).
3. **Run outside gc as systemd service** (cleanest separation, but loses gc lifecycle integration).

Code-writer to verify which mechanism gc actually supports cleanly. Path 1 or 2 preferred (keeps lifecycle inside gc).

## What's borrowed vs invented

| Component | Borrowed from | What it does |
|---|---|---|
| `gc.routed_to` | gc core | composition edges; agents already understand |
| bead.closed event subscription | `gc convoy control --serve` shape | persistent dispatcher loop |
| Cursor + sweep pattern | `cmd/gc/dispatch_runtime.go:320-405` | reliable event processing |
| Patrol-agent escape hatch | Kit's Steward | for cases where the dispatcher needs LLM judgment |
| Cooldown health-check order | Kit's pr-pipeline-health | watches stuck cascades, mails mayor |
| Cascade metadata schema | invented | the chain composition language |
| Dispatcher script body | invented (small) | the actual cascade routing logic |

## Composition (chain definition — same as v2)

Lives in bead metadata:
- `cascade_id`: chain name
- `gc.routed_to`: target agent
- `cascade_position`: 1, 2, 3, ... — orchestrator slings position=1 on bead.created
- `cascade_next`: bead-id of next stage (absent on last)
- `cascade_final`: `"true"` only on last bead
- Label `cascade-chain` on every bead in chain

Mayor never slings. Just creates beads.

## Health monitoring (borrowed from Kit)

Add a cooldown order that periodically checks for stuck cascades:
- Cascades open >2h with no progress
- Beads where `cascade_position=1` was never slung (orchestrator missed bead.created)
- Beads where `cascade_next` points to a non-existent bead

Order body mails mayor: "cascade <id> appears stuck at <position>; investigate."

This is Kit's `pr-pipeline-health.toml` pattern adapted for cascades.

## Build plan (final)

1. **Code-writer task (file now):**
   - Write `agents/orchestrator/start.sh` — the shell daemon body with cursor + body-filter pattern.
   - Verify pack.toml mechanism for running it (custom provider OR script-as-prompt).
   - Add orchestrator entry to pack.toml.
   - Write the cooldown health-check order at `orders/cascade-health.toml` (Kit pattern, with proper trigger filter to avoid self-fire).
   - Risk note: how the cursor pattern avoids self-fire on order-tracking beads; how the daemon recovers from restart.

2. **After code-writer closes:** mayor reloads city, verifies orchestrator session is alive.

3. **Test:** mayor creates 3 cascade-tester beads with chain metadata. **DO NOT SLING.** Watch:
   - Orchestrator detects bead.created with cascade_position=1 → slings tester 1
   - Tester 1 closes → orchestrator slings tester 2
   - Tester 2 closes → orchestrator slings tester 3
   - Tester 3 closes (cascade_final=true) → orchestrator mails mayor with --notify
   - Mayor wakes with `cascade complete` message

4. **If test passes:** generalize. Update operating-rules to reflect new pattern. Drop cascade-discipline from agent prompts. File any further work as needed.

5. **If test fails:** diagnose, iterate.

## What this design preserves vs prior versions

- Mayor / dispatcher split (per all 5 council seats in synthesis-013 — preserved as "mayor / orchestrator" naming).
- Cascade metadata as composition language.
- Mayor receives final wake via --notify (only place we use --notify, only at chain end).
- Cascade-discipline burden removed from agents.

## What this design changes from v2

- No invention from scratch. Borrows `gc convoy control --serve` shape, Kit's patrol-agent pattern, Kit's health-check order pattern.
- Cursor + body-filter pattern (instead of trying to make orders themselves filter — which gc can't do).
- Adds cooldown health-check order to catch stuck cascades.
- Cleaner mechanism path: pull-mode cursor over `gc events --since` (matches what gc itself uses internally).

## Open mechanism question (still to resolve)

Code-writer must choose between:
- **Custom provider** in pack.toml pointing at the shell daemon
- **Codex agent with script as startup command** (mechanism may be cleaner)
- **External systemd service** (cleanest separation, loses gc integration)

Verdict deferred to code-writer's source survey. Whichever path proves cleanest for "long-running shell process registered in gc lifecycle."

## Risks I want to flag (no recommendations)

- Cursor file must be locked or atomically written to handle daemon restart edge cases.
- If gc's event log truncates or rotates, cursor may become invalid. Need to detect and recover.
- The cooldown health-check order must itself be filter-safe (its own tracking bead emissions must not match its filter — same lesson as forum-round-watcher).
- If multiple cascade chains run concurrently and use overlapping bead IDs (shouldn't, but defensively), the orchestrator must handle distinct `cascade_id` values cleanly.

---

**Status:** filing code-writer bead now (separate doc). Build can proceed once code-writer accepts.

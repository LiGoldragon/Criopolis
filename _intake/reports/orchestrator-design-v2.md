# Orchestrator design v2 — database events, not hooks

*Filed by mayor 2026-05-04 in response to Li's correction of v1.*
*Supersedes `_intake/reports/orchestrator-design.md` (v1, hook-based).*

## What changed from v1

v1 proposed: every agent's Stop hook fires `gc mail send --notify orchestrator -s "session.stopped: $GC_AGENT"`. Orchestrator wakes on each mail, looks up cascade state, slings next.

**Li's correction:** we already pay for the `bead.closed` event in the database. Installing a per-stop shell hook adds startup overhead on every turn end, just to recreate a signal that's already in the event bus. Use the database events directly.

v2: orchestrator subscribes to `bead.closed` events from gc's event bus. No Stop hook. No mail-relay round-trip. Lower overhead.

## Architecture (v2)

```
┌─────────────────────────────────────────────────────────────────┐
│              CASCADE LOOP (event-bus-driven)                    │
└─────────────────────────────────────────────────────────────────┘

  ┌──────┐
  │MAYOR │ ─── pre-creates chain beads with cascade metadata ───┐
  │      │     (does NOT sling — orchestrator handles all slings)│
  └──────┘                                                       │
                                                                 │
                                                                 ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                        BEAD STORE (dolt)                         │
  │                                                                  │
  │  cr-A: routed_to=satya,    cascade_next=cr-B                    │
  │  cr-B: routed_to=viveka,   cascade_next=cr-C                    │
  │  cr-C: routed_to=dharma,   cascade_final=true                   │
  └──────────────────────────────────────────────────────────────────┘
                          ▲
                          │
                          │ each agent picks up its bead via WorkQuery
                          │ each agent does work, closes bead
                          │
  ┌──────────────────────────────────────────────────────────────────┐
  │              AGENTS (satya, viveka, dharma...)                   │
  │  Wake on sling → find bead → do work → close bead.               │
  │  No --notify discipline. No mail. Just close.                    │
  └────────────────────┬─────────────────────────────────────────────┘
                       │
                       │ bead-close triggers gc internal event bus
                       ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │              GC EVENT BUS (already exists, already paying)       │
  │                                                                  │
  │  - bead.created + bead.closed events in .gc/events.jsonl + dolt  │
  │  - Cursor tracking built in (gc events --since <cursor>)         │
  │  - Subscription via gc events --watch --type bead.created,bead.closed│
  └────────────────────┬─────────────────────────────────────────────┘
                       │
                       │ orchestrator subscribed
                       ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                      ORCHESTRATOR                                │
  │                                                                  │
  │  Per event:                                                      │
  │  1. Read bead metadata (gc bd show <id> --json)                  │
  │  2. Has cascade-chain label? If no → skip.                       │
  │  3. event=bead.created + cascade_position=1 (or cascade_first=true)│
  │     → gc sling <routed_to> <id>  (start the chain)               │
  │  4. event=bead.closed + cascade_next set                         │
  │     → gc sling <next_agent> <next_bead>  (advance the chain)     │
  │  5. event=bead.closed + cascade_final=true                       │
  │     → gc mail send --notify mayor  (chain complete)              │
  │                                                                  │
  │  Cursor advances; loop continues.                                │
  └──────────────────────────────────────────────────────────────────┘
                       │
                       │ if cascade_final
                       ▼
  ┌──────┐
  │MAYOR │ ←── --notify wake (final-stage signal)
  │      │     reads + synthesizes when convenient
  └──────┘
```

## What runs the orchestrator (this is the design choice that needs your input)

The orchestrator subscribes to a stream. An LLM agent doesn't naturally hold a stream open — sessions are turn-based. Three implementation paths:

### Path A: Shell daemon (no LLM in the loop)

Orchestrator is a shell script run as a session. Body:

```bash
#!/bin/bash
gc events --watch --type bead.closed | while read event; do
  closed_id=$(echo "$event" | jq -r .subject)
  bead_data=$(gc bd show "$closed_id" --json)
  
  # only act on cascade-chain beads
  has_label=$(echo "$bead_data" | jq -r '.labels[]' | grep -c cascade-chain)
  [ "$has_label" -eq 0 ] && continue
  
  next=$(echo "$bead_data" | jq -r '.metadata.cascade_next // empty')
  is_final=$(echo "$bead_data" | jq -r '.metadata.cascade_final // empty')
  
  if [ -n "$next" ]; then
    target=$(gc bd show "$next" --json | jq -r '.metadata."gc.routed_to"')
    gc sling "$target" "$next"
  elif [ "$is_final" = "true" ]; then
    cascade_id=$(echo "$bead_data" | jq -r '.metadata.cascade_id')
    gc mail send --notify mayor \
      -s "cascade complete: $cascade_id" \
      -m "Final bead $closed_id closed. Read seat replies via bd list --label cascade-chain --metadata cascade_id=$cascade_id."
  fi
done
```

**Pros:** dumb, fast, cheap (no LLM tokens), matches Steve Yegge principle (cascade routing IS dumb).
**Cons:** if anything unexpected happens (malformed metadata, missing next bead, etc.), the daemon doesn't reason about it — just logs and continues. May silently drop edge cases.

### Path B: LLM agent with subscription loop

Orchestrator is a codex agent (low/medium effort). Its prompt has a startup script that runs `gc events --watch` in background and pipes events into the agent's input. The agent reads each event, decides, dispatches.

**Pros:** LLM can handle edge cases, malformed metadata, reason about ambiguous cascades.
**Cons:** expensive (LLM tokens per event), slower per event, complex prompt-with-background-process pattern (untested in this city).

### Path C: Hybrid — shell daemon + LLM consultation

Daemon handles the 95% case (cascade-chain bead with clean metadata → sling or mail). For the 5% (malformed, ambiguous, unexpected), daemon mails an LLM agent for a one-shot decision.

**Pros:** cheapest steady-state, LLM only when needed, matches Steve Yegge perfectly.
**Cons:** more moving parts (two components, the consultation channel).

**My read: Path A.** The cascade routing is genuinely dumb; an LLM is overhead for it. Edge cases (missing next bead, etc.) can mail mayor for direction. Mayor handles the rare cases via prompt; daemon handles the steady state.

## Key APIs / mechanisms

| Component | What it is | Authored by |
|---|---|---|
| `agents/orchestrator/start.sh` (Path A) | Shell daemon body — subscription loop + dispatch logic | code-writer (CODE) |
| `pack.toml` orchestrator entry | Agent definition pointing to the script (provider may need to be a custom shell wrapper, or use exec provider) | mayor (SAFE INTERFACE) — needs verification on whether pack.toml supports raw-script agents |
| Cascade metadata on beads | `cascade_chain` label + `cascade_id` / `cascade_next` / `cascade_final` metadata | mayor when filing chain |
| `gc events --watch --type bead.closed` | The subscription mechanism | gc-provided (already exists) |

## Open mechanism question

**Does pack.toml support a "shell daemon" agent provider?** The `provider` field maps to known providers (claude, codex, gemini, etc.). For Path A, we need either:
- A custom provider that runs a shell script
- An "exec" provider type
- A wrapper executable masquerading as one of the known providers

Per researcher cr-kbg2ir findings: providers are user-definable with `command`, `args`, `env`, `path_check`. So a custom provider pointing at a shell script is feasible. Code-writer would verify this when writing the implementation.

Alternative: skip the agent system entirely — run the daemon as a systemd service or supervised process outside gc. This sidesteps the pack.toml question but makes the orchestrator less integrated with gc's lifecycle (won't restart with city, won't show in `gc status`, etc.).

## What replaces the `--notify` discipline at the agent end

In v1, agents would NOT call `--notify` themselves; the Stop hook would do it.

In v2, agents do nothing special — they just `bd close`. The bead-close fires `bead.closed` in the event bus automatically (this is gc-internal, not a hook). Orchestrator picks it up.

**This means the cascade-discipline section can be removed from agent prompts entirely.** Agents close beads; the city handles the rest. (Per the synthesis-013 finding that prompt-discipline is structurally unreliable.)

## Composition (the chain definition)

Lives in bead metadata. Mayor creates all chain beads with these fields; orchestrator handles every sling from there.

- `cascade_id`: short name for the chain
- `gc.routed_to`: the agent (set by mayor at create-time as metadata, OR by orchestrator at sling-time — either works)
- `cascade_position`: 1, 2, 3, ... — orchestrator slings position=1 on bead.created
- `cascade_next`: bead-id of next stage (absent on last)
- `cascade_final`: `"true"` only on last bead
- Label `cascade-chain` on every bead in the chain

Chain composition lives in beads themselves. No separate file. **Mayor never slings — orchestrator slings all stages including the first.**

## Build plan (in order, after Li's go)

1. **Wait for explorer cr-fc8go4** (orchestrator-AI pattern survey) to return. May surface prior art that simplifies or redirects this design.
2. **Mayor / Li:** decide Path A vs B vs C.
3. **Code-writer task (new bead):** implement chosen path. For Path A, write `agents/orchestrator/start.sh` (subscribes to BOTH bead.created and bead.closed) + verify pack.toml provider config.
4. **Mayor:** add orchestrator to pack.toml, gc reload to register.
5. **Mayor:** create 3 cascade-tester beads with chain metadata. **DO NOT SLING.**
6. **Test:** orchestrator detects bead.created on the first bead → slings cascade-tester → cascade auto-runs through all 3 → final close → mayor receives `cascade complete` mail.

## Test pass/fail (same as v1)

- **Pass:** mayor receives exactly ONE `cascade complete` mail after all 3 testers close, in order.
- **Fail mode A:** orchestrator doesn't subscribe to events correctly. Diagnosis: subscription mechanism wrong.
- **Fail mode B:** orchestrator wakes on every event but doesn't filter to cascade-chain. Diagnosis: filter logic.
- **Fail mode C:** orchestrator slings wrong next agent. Diagnosis: metadata reading.
- **Fail mode D:** events arrive out of order or duplicated. Diagnosis: cursor handling.

## What this v2 design preserves vs v1

- Orchestrator role still preserved (mayor/dispatcher split, per all 5 seats in synthesis-013).
- Cascade metadata on beads still the composition language.
- Mayor still receives the final wake via `--notify` (only place we use --notify, and only mayor receives, only at end of cascade).
- Cascade-discipline burden REMOVED from agents (huge simplification, addresses 5/5 cascade-test-1 failures).

## What this v2 design changes vs v1

- No Stop hooks installed. Lower overhead per session-end.
- No per-agent mail spam to orchestrator.
- Orchestrator subscribes to events directly, not to mail.
- Orchestrator is plausibly a shell daemon (no LLM), not a full codex agent.
- The "fast not smart" requirement is satisfied by removing the LLM from the loop entirely.
- **Mayor does not sling at all.** Orchestrator subscribes to bead.created events too, slings the first agent (cascade_position=1) when chain beads appear. Mayor's only acts: create the chain, eventually receive the cascade-complete mail.

## Risks I want to flag (no recommendations)

- We don't know yet if pack.toml supports a shell-daemon agent shape. Code-writer needs to verify before implementing.
- `gc events --watch` long-running subscription may have its own failure modes (disconnect, restart behavior, cursor reset). Untested.
- Shell daemon doesn't handle malformed metadata gracefully. Edge cases are silent failures unless we add explicit logging + mayor-mail fallback.
- If gc supervisor restarts the city, the daemon needs to reconnect to the event stream and resume from cursor. Lifecycle management is real work.

---

**Status:** awaiting Li's direction on Path A/B/C, and awaiting explorer cr-fc8go4 (may surface prior art).

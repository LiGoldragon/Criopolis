# Orchestrator design + test plan

*Filed by mayor 2026-05-04 in response to Li's directive: build an orchestrator agent + test it with cascade-tester chain.*

## What I understood from your directive

- Build an **orchestrator** agent that keeps cascading work flowing.
- Orchestrator receives **all session-stop signals** from agents.
- Orchestrator knows the **composition** (the chain definition) — it's the conductor pointing at the next musician.
- Orchestrator must be **fast, not smart**. xhigh effort is wrong because it slows down the wake-act loop. Use a faster setting.
- Test it with a 3-tester cascade once built.
- Skip my opinions about whether cascading is needed. Just build.

## The architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  THE CASCADE LOOP (event-driven)                │
└─────────────────────────────────────────────────────────────────┘

  ┌──────┐
  │MAYOR │ ─── pre-creates chain beads with cascade metadata ───┐
  │      │ ─── slings the FIRST agent ──────────────────────────┤
  └──────┘                                                       │
                                                                 │
                                                                 ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                        BEAD STORE                                │
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
  │                    AGENTS (satya, viveka, dharma...)             │
  │  - Wake when slung                                               │
  │  - Find their bead via WorkQuery                                 │
  │  - Do work, close bead                                           │
  │  - That's it. NO --notify discipline. NO mail.                   │
  │  - Their session ends.                                           │
  └──────────────────────────────────────────────────────────────────┘
                          │
                          │ session.Stop event fires
                          │ (gc-controlled, not agent discipline)
                          ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                    STOP HOOK (gc-installed)                      │
  │                                                                  │
  │  Configured in .gc/settings.json AND .codex/hooks.json           │
  │  Body: gc mail send --notify orchestrator                        │
  │           -s "session.stopped: $GC_AGENT"                        │
  │           -m "session $GC_SESSION_ID stopped"                    │
  │  Skips: mayor, orchestrator, control-dispatcher                  │
  │                                                                  │
  │  This hook is INFRASTRUCTURE. It always fires.                   │
  │  No agent-discipline involved.                                   │
  └──────────────────────────────────────────────────────────────────┘
                          │
                          │ wakes orchestrator via --notify
                          ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                  ORCHESTRATOR (always-on agent)                  │
  │                                                                  │
  │  On wake:                                                        │
  │  1. Read all unread mail (gc mail inbox)                         │
  │  2. For each session.stopped mail:                               │
  │     a. Find recently-closed bead routed to that agent            │
  │     b. Read its metadata: cascade_next? cascade_final?           │
  │     c. If cascade_next: gc sling <next-agent> <next-bead>        │
  │     d. If cascade_final: mail mayor with --notify                │
  │     e. Otherwise: skip (close was not part of any chain)         │
  │  3. Mark mail read, sleep                                        │
  │                                                                  │
  │  Provider: codex                                                 │
  │  Effort: medium (NOT xhigh — speed > thinking)                   │
  │  Mode: always-on                                                 │
  └──────────────────────────────────────────────────────────────────┘
                          │
                          │ if cascade_final
                          ▼
  ┌──────┐
  │MAYOR │ ←── --notify wakes mayor with "cascade complete" mail
  │      │     reads + synthesizes when convenient
  └──────┘
```

## Key APIs / mechanisms

| Component | What it is | Authored by |
|---|---|---|
| Stop hook in `.gc/settings.json` | Fires `gc mail send --notify orchestrator` on every claude session stop | code-writer (CODE) |
| Stop hook in `.codex/hooks.json` | Same, for codex agents | code-writer (CODE) |
| `agents/orchestrator/prompt.template.md` | Orchestrator's role prompt | mayor (PROSE) |
| `pack.toml` orchestrator entry | Agent definition | mayor (SAFE INTERFACE) |
| Cascade metadata on beads (`cascade_next`, `cascade_final`, `cascade_id`) | The "composition" — encoded directly in beads | mayor when filing chain |
| `$GC_AGENT` / `$GC_SESSION_ID` env vars in hook context | Identifies which agent's session stopped | gc-provided |

## Composition (the chain definition)

The composition lives in **bead metadata**, not a separate file. Each bead in the chain carries:

- `cascade_id`: short name for the chain (e.g., `multi-agent-patterns-1`)
- `gc.routed_to`: the agent for this bead (set by `gc sling`)
- `cascade_next`: bead-id of the next stage (or empty/absent on last bead)
- `cascade_final`: `"true"` only on the last bead

That's the entire composition. Orchestrator reads metadata; no external file needed.

## What the orchestrator does NOT do

- Doesn't think about content of the work
- Doesn't synthesize
- Doesn't make editorial decisions
- Doesn't do anything that requires xhigh reasoning

It is a **dispatcher**. Read mail → look up next → sling. Fast loop.

## Build plan (in order)

1. **Mayor:** draft `agents/orchestrator/prompt.template.md` (compact, ~80 lines)
2. **Mayor:** add orchestrator to pack.toml (codex / medium effort / always-on)
3. **Mayor:** `gc reload` to register orchestrator
4. **Code-writer (NEW BEAD):** add Stop hook to `.gc/settings.json` + `.codex/hooks.json`
   - Body fires `gc mail send --notify orchestrator -s "session.stopped: $GC_AGENT"`
   - Excludes mayor, orchestrator, control-dispatcher (skip if `$GC_AGENT` matches)
   - Risk note: confirm Stop hook doesn't fire on orchestrator itself (would loop)
5. **Mayor:** create 3 cascade-tester beads with metadata chain
6. **Mayor:** `gc sling cascade-tester cr-A` (the first one)
7. **Watch:** does the chain auto-cascade? Does mayor get the final wake?

## Test pass/fail criteria

- **Pass:** Mayor receives exactly ONE `cascade complete` mail after all 3 testers close, in order.
- **Fail mode A:** Stop hook doesn't fire (orchestrator never wakes). Diagnosis: hook config wrong.
- **Fail mode B:** Orchestrator wakes but doesn't sling next. Diagnosis: orchestrator prompt or metadata reading.
- **Fail mode C:** Stop hook fires for orchestrator itself → infinite loop. Diagnosis: missing exclusion.
- **Fail mode D:** Stop hook fires multiple times per session (turn-stop vs session-stop). Diagnosis: codex/claude provider semantics differ from session.stopped.

## Open questions to resolve during build

1. Does Stop hook fire on session END or per-turn? If per-turn, we need to filter to "session ended" specifically (probably via the `hook_event_name` env or differentiating in body).
2. Does codex have a SessionEnd event distinct from Stop? (Needs verification — we know codex has Stop hook but not necessarily SessionEnd.)
3. When the orchestrator slings the next agent, does the order of mail-receive matter (multiple stop events arriving)? Orchestrator should de-duplicate by checking bead state, not by mail count.

These are answerable during implementation. Code-writer can verify in source.

## Where this sits relative to prior architecture

- Replaces majordomo (which was already dropped) with a leaner, dispatch-only agent.
- Replaces the failed agent-prompt-discipline cascade-notify with infrastructure-side hook firing.
- Removes the "mayor babysits when cascade fails" failure mode.
- Doesn't depend on event-triggered orders (which we've now confirmed gc can't safely support).

## Risks I want to flag (no recommendations, just facts)

- Stop hook fires every Claude/Codex turn end, not just session end. May produce noisy mail.
- Per-provider hook configuration means BOTH `.gc/settings.json` and `.codex/hooks.json` need editing to cover all agents.
- The orchestrator becomes a single point of failure for cascades. If orchestrator's session breaks, cascades stop.
- We don't yet know if the Stop hook itself reliably fires for codex agents in current gc — needs verification.

---

**Status:** awaiting Li's approval to start the build (or correction).

# City investigation status — 2026-05-05

Single-file status report. What was filed, what surfaced, what's in flight, and what the prior research on disk already says about your three-day pain.

---

## TL;DR

1. **Three P0 beads in flight, both agents now spawned and working.** `cr-9dw438 (researcher: maintainer prompt + manual scaffold)`, `cr-t5r5wr (researcher: does gas-city already have an orchestrator?)`, `cr-hjw2hd (code-writer: rebase fork to v1.0.0 stable)`. The `code-writer` is mid-cherry-pick onto v1.0.0 right now (`git cherry-pick --continue` just returned).
2. **Prior research on disk already answers most of your hardest questions** — and was apparently never read carefully. Specifically `research/answers/notification-mechanisms.md` and `research/answers/cascade-canonical-pattern.md` say native gas-city *already has* a push primitive for "agent done" notifications. The decision to build `LiGoldragon/orchestrator` was made on top of this evidence, not in spite of its absence.
3. **Dolt write amplification is a known upstream issue class** — `research/answers/dolt-write-amplification.md` enumerates eight upstream PRs/issues that match your symptoms. We are not the first to hit this.
4. **The "supervisor doesn't auto-materialize on_demand sessions on slings" failure** that I discovered today is also already explained in source: `notification-mechanisms.md` §5 says `gc session nudge <name>` is the canonical materialization primitive, not `gc sling`. I used `gc session new <template> --no-attach` to work around it; that worked but isn't the documented path.

---

## What got filed today (this session)

| Bead | Task | Routed to | Status |
|---|---|---|---|
| `cr-9dw438` | researcher: draft maintainer role prompt + scaffold gas-city manual | researcher | open, claim-pending |
| `cr-hjw2hd` | code-writer: rebase fork to v1.0.0 (directive-overridden from earlier "investigate + recommend" framing) | code-writer | **in progress** — cherry-picking |
| `cr-t5r5wr` | researcher: does gas-city already have an orchestrator? convoy/control-dispatcher source investigation | researcher | open, queued behind `cr-9dw438` |
| `cr-55mmsa` | (closed) researcher: city-expert prompt + canonical-healthy-gas-city. Replaced by `cr-9dw438` per your "maintainer not expert" reframing. | — | closed |

Three auto-convoys created on slings: `cr-72iy39`, `cr-ddpmqf`, `cr-hqj839`. None have driven dispatch — auto-convoy creation appears to be cosmetic in the current city until/unless `control-dispatcher` is actually following them.

---

## What I had to do manually because the city didn't

**Slings did not auto-materialize the on_demand named sessions.** All three target sessions (`researcher`, `code-writer`) sat as `reserved-unmaterialized` for 30+ minutes after slings landed. Manual fix: `gc session new researcher --no-attach` and `gc session new code-writer --no-attach`. Sessions spawned (as adhoc, not as the named-session reservation) and immediately picked up the routed work via `gc.routed_to=<template>` metadata.

This is the symptom that prompted the convoy/orchestrator investigation in the first place. Notes already on disk (see "Prior research" below) suggest `gc session nudge <template> "<text>"` would have been the more idiomatic primitive — that's the canonical "deliver and wake" call, per `gascity cmd_nudge.go:607-630` (cited in `notification-mechanisms.md` §5).

---

## In-flight agent progress (peeked just now)

**Researcher** (`cr-luw9x9` / `researcher-adhoc-ed31b20f32`, codex gpt-5.5 xhigh)
- Read both queued P0 beads (`cr-9dw438` maintainer + `cr-t5r5wr` orchestrator-investigation)
- Has read source: `cmd_formula.go`, `cmd_agent.go`, `cmd_session.go`, `session_reconcile.go`, `session_reconciler.go`
- Verified `gc formula` subcommands by running their `--help`
- **Context window down to 9% free** — concerning; researcher may finish current bead and need a fresh session for the second one. Will surface a note in the next update if that triggers.
- Working roughly 4+ minutes in.

**Code-writer** (`cr-xfviwa` / `code-writer-adhoc-0049ab6e2d`, codex gpt-5.5 xhigh)
- Read `AGENTS.md`, `INTENTION.md`, the operating rules (`push-not-pull.md`, `micro-components.md`, `naming.md`, `vocabulary.md`, `city.md`, `agents.md`)
- Currently mid-rebase: `git cherry-pick --continue` just returned successfully — meaning the codex-model-choices patch (`gascity 4e8fc326`) hit at least one merge conflict on top of `v1.0.0`, and the agent resolved it.
- Working ~4 minutes in. **Context 69% free** — healthy.
- Diff so far touches `internal/worker/builtin/profiles.go` (3 files / 21+/4-) — that's where the codex-model-choices patch lives.

**Mail to mayor:** empty. No completion notifications surfaced. Both agents still working; will report when either closes their bead or sends the canonical `gc mail send --notify mayor "done: <bead>"`.

---

## Prior research already on disk (apparently never integrated)

This is the most important section of this report. The questions you've been asking — *does gas-city have an orchestrator? why is dolt hammered? why don't agents wake on slings?* — were already investigated by previous researcher runs. The answers exist but were not promoted into operating rules, the manual (which doesn't exist yet), or mayor's working knowledge.

### `research/answers/notification-mechanisms.md`

> **§4 — "Authoritative 'agent done' event today":** Use `bd close` as the source of truth for completion. Gas City forwards bd `on_close` to a `bead.closed` event with the closed bead ID as subject. The event bus supports `gc events --watch --type bead.closed`, and event-triggered orders read after a cursor.
>
> Citation: `gascity internal/beads/beads.go:147-149`, `gascity cmd/gc/hooks.go:11-16`, `gascity cmd/gc/cmd_events.go:123-180`.

**Implication:** native push primitive for "agent done" exists today. We do not need a custom Rust daemon to subscribe to bead-close events.

> **§5 — "On-demand materialization on nudge":** `gc session nudge <name>` resolves the target by calling `resolveSessionIDMaterializingNamed`, which reopens a closed configured named session or calls `ensureSessionIDForTemplateWithOptions` when materialization is allowed. Default `wait-idle` delivery tries live delivery; if not delivered, the CLI queues the nudge.
>
> Citation: `gascity cmd/gc/cmd_session.go:1619-1630`, `cmd/gc/cmd_nudge.go:607-630`, `cmd/gc/session_resolve.go:67-85`.

**Implication:** the right way to deliver work-and-wake-an-agent is `gc session nudge`. The fact that mayor reached for `gc sling` and then had to manually `gc session new` is exactly the failure mode the maintainer's manual will document.

> **§6 — "Cascade primitive recommendation":** Build the minimum primitive around `bd close` plus `gc mail send --notify`. Do not use provider `Stop`, handoff, or `session.stopped` as completion signals.

**Implication:** the canonical native cascade *exists already*. The minimum-shape pattern is "A closes its bead → A sends `gc mail send --notify B`". This does most of what `LiGoldragon/orchestrator` is hand-rolling.

### `research/answers/cascade-canonical-pattern.md` (cr-kbg2ir)

> **Headline finding:** "I did not find a current canonical 'agent A finishes, Stop hook fires, Stop hook sends gc mail send --notify B' pattern. The current Gas City pattern is bead/store driven: create or route durable work, wake a session if needed, and let provider turn hooks surface pending work, mail, and queued nudges."
>
> "Everyone communicates through the store."

**Implication:** the bead store IS the orchestration substrate. Agents poll `bd ready` (default `work_query` finds assigned/routed beads), or react to mail nudges, or react to event subscriptions. This is the design intent.

### `research/answers/dolt-write-amplification.md` (cr-zsyawg)

Lists upstream issues/PRs documenting the *exact* class of failure we're seeing. Top candidates:

| Upstream | Symptom |
|---|---|
| `gascity` PR #563 | Named-session respawn loop generating heavy dolt writes; "starved btrfs I/O for the entire desktop session" |
| `gascity` PR #568 | Adds Linux PSI filesystem-pressure backpressure because a buggy named session generated continuous Dolt writes and the supervisor kept adding work |
| `gascity` PR #1377 + #1412 | Cache-reconcile loops causing repeated bead-close events and high Dolt CPU under load |
| `gascity` PR #1586 | Rollback storm: each rollback fires three `bd` subprocess writes; fork-per-call/Dolt cost called out |
| `gascity` issue #1118 | `.gc/events.jsonl` grows without bound; observed 109 MB / 125k lines |
| `gascity` issue #1510 | `CachingStore.SetMetadata` no-op writes still shell out to `bd update`, open Dolt connections, commit "nothing to commit" |
| `beads` PR #3165 | `bd batch` exists specifically because loops of `bd` calls cause severe write amplification on Dolt SQL server + btrfs+compression |
| `beads` issue #3414 | Every mutating `bd` command hangs 10-15s in auto-export hydrate-labels on a Dolt remote backend |

**Implication:** dolt write amplification is a known, ongoing upstream concern. Several PRs are in flight to fix specific cases. Our current build is post-`v1.0.0`, so it has *some* of these fixes but not all.

---

## Plausible root causes for your live symptoms (synthesizing prior research + today's evidence)

| Symptom | Most-likely root cause (citing prior research) | Confidence |
|---|---|---|
| `dolt sql-server` 60% CPU idle | Cache-reconcile loop (PR #1377/#1412 class) firing repeated bead-close events. Compounded by 30s patrol interval x N sessions x N orders × per-tick `bd ready --assignee` shell spawns. | Medium-high |
| `bd show --json cr-a6dk5` hot-loop | Convoy controller (`gc convoy control --serve --follow control-dispatcher`) repeatedly inspecting its own session bead. Source not yet read by mayor; the in-flight `cr-t5r5wr` answers this directly. | Medium (pending researcher findings) |
| Dogs respawn when killed | `mol-dog-doctor` formula fires every 5 min; dogs are *supposed* to exit after their check; they don't. The reaper (`mol-dog-reaper`, every 30 min) was supposed to clean up zombies — `gascity 945ffc55 (#1631 dog-pool reaper qualifier fix)` is on our fork but apparently doesn't catch the failure. | Medium |
| Slings don't auto-materialize agents | `gc sling` routes by metadata only; `gc session nudge` is the materialization primitive. Mayor (and the orchestrator project) used the wrong primitive. Documented in `notification-mechanisms.md` §5. | High |

---

## Actual mayor failure modes documented today (for the maintainer's runbook)

These are the specific commands mayor invented that don't exist or work differently than expected. They are runbook-worthy entries because they keep happening across mayor incarnations:

| What mayor did | What's actually correct |
|---|---|
| `gc agent list` | Doesn't exist. Use `gc session list` (runtime view) or read `pack.toml` + `city.toml` (static config). |
| `gc mail inbox --all` | `--all` flag doesn't exist. Use `gc bd list --type message --include-infra` for full mail-bead listing. |
| `gc agent suspend dog` | `dog` is not an `[[agent]]` — it's a formula-spawned molecule. Investigate `.beads/formulas/mol-dog-*.toml` and `gc order list`. |
| `gc bd close ... --notes "..."` | `--notes` flag doesn't exist on close. Use `--reason "..."`. |
| `gc sling researcher cr-X` (expecting it to wake the agent) | `gc sling` only routes; doesn't materialize on_demand. Use `gc session nudge researcher "..."` or `gc session new researcher --no-attach`. |
| Reflexive use of `gc supervisor stop` to "refresh" config | **Forbidden** city-lifecycle command — only Li runs it. (Already in operating rules; mayor temptation persists.) |

Memory updates already saved (`feedback_mayor_must_know_gc.md`, `project_gascity_maintainer_initiative.md`) so future mayor incarnations carry this forward.

---

## Architecture observation worth your attention

The cluster of evidence is now strong enough to suggest:

> **`LiGoldragon/orchestrator` may be re-implementing functionality that gas-city already provides natively.**

Specifically: the orchestrator subscribes to `gc events`, watches for `bead.closed`, and dispatches the next bead in a cascade chain. Native gas-city already provides:

- `gc events --watch --type bead.closed` — push subscription primitive
- `[[agent]]` `work_query` defaults that match `gc.routed_to=<self>` metadata — automatic claim-and-work pickup
- `gc mail send --notify` — durable cross-agent notification + nudge
- `gc session nudge` — materialize-and-deliver in one call
- Order triggers with `on = "bead.closed"` filtered by label — declarative "when this class of bead closes, fire that workflow"

The in-flight `cr-t5r5wr (researcher: does gas-city already have an orchestrator?)` is the formal investigation of this hypothesis. The answer expected within 10–20 minutes (researcher is currently context-bound).

If the verdict is "yes, native primitives suffice," the recommended action is: **shelve `LiGoldragon/orchestrator`**, configure cascades using event-triggered orders + `gc mail send --notify`, and close the cascade-orchestrator project. That eliminates one moving part with a known bug (`cr-ikfo2u (orchestrator skips real cascade-chain beads — bug)`) and one source of stale-binary risk (the nix package isn't rebuilt to pick up the fix commits anyway).

---

## What I'm waiting on next

| Trigger | Action I'll take |
|---|---|
| `cr-hjw2hd` closes (rebased fork pushed) | Surface to you for sign-off; the bump-flake-lock PR will need your approval to merge. |
| `cr-9dw438` closes (maintainer prompt + manual scaffold drafted) | Read deliverable; copy proposed prompt into `agents/maintainer/prompt.template.md`; add `[[agent]]` block to `pack.toml`; sling first diagnosis bead to the new maintainer. |
| `cr-t5r5wr` closes (orchestrator-or-not verdict) | Surface verdict; if "native suffices," file a bead to wind down `LiGoldragon/orchestrator` and migrate to event-triggered orders. |
| Researcher context exhausted before second bead | Spawn fresh `gc session new researcher --no-attach`; second researcher claims `cr-t5r5wr` from the routed metadata. |

I'll keep this report updated as findings land. Or write a successor file (`2026-05-05-city-investigation-status-2.md` etc.) when this one gets long. Standing by — not poking the running sessions.

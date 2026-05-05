# Session status — 2026-05-05 (post-restart through ~14:30)

## Right now

- **Mayor** (me) — active.
- **Control-dispatcher** — active.
- **Researcher (`cr-2jte42`, adhoc)** — spawning, will pick up `cr-9dw438 (maintainer prompt + manual scaffold + debugger expansion)`.
- **Code-writer** — pool empty (last one finished cr-hjw2hd and got reaped). Resumed; will spawn on next routed bead.

## Done in this session

1. Verified post-restart — gc 1.0.0, supervisor on new nix-store path, all four checkpoints green.
2. Stopped two pool-cycling incidents (code-writers racing on cr-hjw2hd; researchers spawning failed slots in a loop). Working pattern: suspend agent + manual single-spawn.
3. **`cr-hjw2hd (gascity fork rebase to v1.0.0 + model patch)`** closed — gascity branch pushed at `gascity 76f46b45 (codex model choices on v1.0.0)` with gpt-5.4-mini preserved, gascity-nix PR #1 opened, validations pass.
4. **`cr-ikfo2u (orchestrator cascade-chain skip bug)`** closed — work was already pushed; closed to prevent pool clobber.
5. **`cr-3maa85 (post-restart damage survey)`** closed — `research/answers/2026-05-05-post-restart-damage-survey.md`. No reset-level damage.
6. **`cr-9dw438 (maintainer scaffold)`** expanded with debugger powers per Li directive — un-deferred, in flight.
7. **`cr-2vb4st (MCP audit)`** deferred 30d — redirected to maintainer.
8. **mayor.md §1 + mayor prompt template** fixed — `gc supervisor logs / status / reload` now allowed; only true lifecycle subcommands forbidden.

## Open / awaiting Li

- **gascity-nix PR #1** — review/merge; drops ~360 post-v1.0.0 commits including some real fixes.
- **Maintainer integration** after researcher draft lands — mayor integrates prompt + adds `pack.toml` block, Li reloads, maintainer goes live.
- **City repo commits** — many legitimate in-progress files ready to commit pending Li approval (per damage survey triage).
- **`keel/` and `library/`** nested repos — unregistered; Li decides move/register/leave.
- **`.gitkeep`** — stale; safe to delete on Li nod.
- **Orchestrator package rebuild** — deployed binary still 0.1.0 broken; needs Home Manager activation by Li.
- **Broader operating-rules audit** — Li asked about other "stupid fucking rules." Mayor will draft proposal as separate prose pass; flag candidate: §8 (mayor-never-writes-code) is broad enough that even one-line shell snippets defer to code-writer.

## Past reports (one-line each)

- `research/answers/2026-05-05-post-restart-damage-survey.md` (researcher-1) — no reset-level damage; gascity branch pushed cleanly; pool clobber is active risk.
- `_intake/operating-rules/supervisor-restart.md` "How it went" — systemd ExecStart hardcoded to nix-store path; `gc supervisor install` is what rewrites unit; two dolt-lock failure modes characterized.
- `research/answers/does-gascity-have-orchestration.md` (cr-t5r5wr) — gascity has graph.v2 control-dispatcher natively but only for fixed control kinds; external orchestrator still required for arbitrary cascades.
- `research/answers/gc-update-and-services.md` — how to bump system gc binary; service-management primitives.
- `research/answers/gascity-fork-stability.md` (code-writer-1, secondary deliverable from cr-hjw2hd) — what changed between v1.0.0 and `4e8fc326`.
- `_intake/reports/2026-05-05-city-investigation-status.md` (pre-restart, 12:30) — single-file status doc.

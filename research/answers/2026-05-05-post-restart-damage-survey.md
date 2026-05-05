# 2026-05-05 post-restart damage survey

## Headline

No reset-level damage found, but work should resume only with one explicitly-directed agent at a time. `cr-hjw2hd (gascity fork rebase)` is no longer mid-cherry-pick: `/git/github.com/LiGoldragon/gascity` is clean on `rebase-v1.0.0`, and `gascity 76f46b45 (codex model choices on v1.0.0)` is already at `origin/rebase-v1.0.0`. It preserves the model choices, including `gpt-5.4-mini`, but the packaging/deployment half is not done: `/git/github.com/LiGoldragon/gascity-nix/flake.nix` still builds `gascity 4e8fc326 (codex model choices on post-v1.0.0 main)` and `/home/li/git/CriomOS-home/flake.lock` still pins `gascity-nix f1218bd (stock v1.0.0 anchor)` (`/git/github.com/LiGoldragon/gascity-nix/flake.nix:11-23`, `/home/li/git/CriomOS-home/flake.lock:521-527`). `cr-9dw438 (maintainer prompt + manual scaffold)` has no surviving manual/prompt artifacts and should restart fresh. `cr-ikfo2u (orchestrator cascade-chain skip bug)` is fixed in the repo, but not deployed in Home Manager; CriomOS-home still locks `LiGoldragon/orchestrator` at `7a8f8e0 (document live integration risk)`, before the four fix commits (`/home/li/git/CriomOS-home/flake.lock:844-850`). The city working tree is mostly legitimate in-progress documentation/config, plus one stale `.gitkeep` and two nested-repo uncertainties.

## Per-bead status

### `cr-hjw2hd (gascity fork rebase)`

State: safe to continue from current state; do not reset. The branch is clean and pushed at `gascity 76f46b45 (codex model choices on v1.0.0)`, with no local-only commits (`git rev-list origin/rebase-v1.0.0...rebase-v1.0.0` returned `0 0`). The commit contains the expected provider code: Codex defaults now include `model = "gpt-5.5"` (`/git/github.com/LiGoldragon/gascity/internal/worker/builtin/profiles.go:147-154`) and the model choice list includes `gpt-5.5`, `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.4-nano`, and `gpt-5.3-codex-spark` with `--model` flag args (`/git/github.com/LiGoldragon/gascity/internal/worker/builtin/profiles.go:183-194`).

The tests also preserve the point of the patch: `TestBuiltinProviders_CodexHasNilArgsAndOptionDefaults` asserts the `gpt-5.5` default and checks the `gpt-5.4`, `gpt-5.4-mini`, and `gpt-5.4-nano` schema choices (`/git/github.com/LiGoldragon/gascity/internal/config/options_test.go:703-729`). `TestResolveProviderWorkspaceProvider` expects the default Codex args to include `--model gpt-5.5` before xhigh effort (`/git/github.com/LiGoldragon/gascity/internal/config/resolve_test.go:100-124`).

One non-reset concern: the cherry-pick commit also adds generated `docs/reference/cli.md` content for `gc dolt`, which was not part of original `gascity 4e8fc326 (codex model choices)`. It appears as doc-only generated CLI reference: the top-level command table now includes `gc dolt` (`/git/github.com/LiGoldragon/gascity/docs/reference/cli.md:20-33`). This is noise, not a reason to reset, but Li should decide whether to keep it before promoting the branch.

Remaining work from Li's directive:

- Update `gascity-nix` to build `gascity 76f46b45 (codex model choices on v1.0.0)` instead of `4e8fc326`; current `gascity-nix` still says it tracks post-v1.0.0 main and uses rev `4e8fc326...` (`/git/github.com/LiGoldragon/gascity-nix/flake.nix:11-23`).
- Update `/home/li/git/CriomOS-home/flake.lock` from `gascity-nix f1218bd (stock v1.0.0 anchor)` to the new `gascity-nix` commit; current lock lines still point at `f1218bd8...` (`/home/li/git/CriomOS-home/flake.lock:521-527`).
- Produce the promised build/test evidence and close `cr-hjw2hd (gascity fork rebase)`. I found no bead note confirming the build/test step after the branch push.

Recommendation: let exactly one code-writer continue, starting from the clean branch. Tell it not to redo conflict resolution; it should package and lock the already-pushed branch.

### `cr-9dw438 (maintainer prompt + manual scaffold)`

State: fresh start. The bead is deferred until after this survey, and the pre-restart artifact locations are empty or absent: `_intake/proposals/` is absent, `gascity-manual/` is absent, and `research/notes/` has no files. The only related artifacts I found are inputs, not deliverables: `research/answers/does-gascity-have-orchestration.md` is the `cr-t5r5wr (convoy/control-dispatcher orchestration research)` answer, with its verdict at lines 3-9 (`/home/li/Criopolis/research/answers/does-gascity-have-orchestration.md:3-9`), and `_intake/reports/2026-05-05-city-investigation-status.md` records that the pre-restart researcher had read some source but was context-low and not finished (`/home/li/Criopolis/_intake/reports/2026-05-05-city-investigation-status.md:37-52`).

Recommendation: resume `cr-9dw438 (maintainer prompt + manual scaffold)` from the bead description, not from disk. Treat `research/answers/does-gascity-have-orchestration.md` and `research/answers/gc-update-and-services.md` as source inputs, not as partial manual output (`/home/li/Criopolis/research/answers/gc-update-and-services.md:3-15`).

### `cr-ikfo2u (orchestrator cascade-chain skip bug)`

State: repo fix exists and is pushed, but deployment is not done and the repo has new uncommitted harness hardening. The four claimed commits are present on `/git/github.com/LiGoldragon/orchestrator` main: `orchestrator 5927ace (skip log bead id)`, `47a81db (cascade dispatch on label update)`, `04bd1e2 (flake include test fixtures)`, and `d443382 (risk note cascade label race)`.

`orchestrator 47a81db (cascade dispatch on label update)` does address the original skip symptom. `src/event.rs` now treats `bead.updated` as cascade-relevant alongside created/closed events (`/git/github.com/LiGoldragon/orchestrator/src/event.rs:18-33`), filters non-cascade updates (`/git/github.com/LiGoldragon/orchestrator/src/event.rs:120-128`), and recognizes cascade markers from either the `cascade-chain` label or cascade metadata (`/git/github.com/LiGoldragon/orchestrator/src/event.rs:149-185`). `src/dispatch.rs` handles `BeadCreated` and `BeadUpdated` with the same start-candidate path (`/git/github.com/LiGoldragon/orchestrator/src/dispatch.rs:121-125`), and the skip reason now includes the bead id before logging (`/git/github.com/LiGoldragon/orchestrator/src/dispatch.rs:114-118`, `/git/github.com/LiGoldragon/orchestrator/src/dispatch.rs:29-34`). To prevent create/update double-slinging, dispatch checks previous side-effect actions before executing (`/git/github.com/LiGoldragon/orchestrator/src/dispatch.rs:217-230`), backed by the redb action scan in `EventCursor.has_recorded_action` (`/git/github.com/LiGoldragon/orchestrator/src/state.rs:90-104`).

The tests are no longer only hand-built happy path. Unit tests parse a real `bead.updated` cascade marker and ignore a non-cascade update (`/git/github.com/LiGoldragon/orchestrator/tests/events.rs:5-25`), and dispatch tests assert that an updated position-1 bead starts the chain after the label arrives (`/git/github.com/LiGoldragon/orchestrator/tests/dispatch.rs:53-75`). The isolated integration script creates cascade beads through real `gc bd create --labels cascade-chain --metadata ...` calls (`/git/github.com/LiGoldragon/orchestrator/tests/scripts/orchestrator-isolated-gc-test.sh:518-533`) while the orchestrator is running, waits for each stage, closes beads, and verifies completion/mail (`/git/github.com/LiGoldragon/orchestrator/tests/scripts/orchestrator-isolated-gc-test.sh:715-753`). That exercises the real GC create/update event sequence in an isolated city. It is still a successful-cascade test, not an explicit raw-event assertion that `bead.created` lacks labels.

`RISK.md` says the main residual risk is still the label/metadata event contract: if Gas City stops including labels or cascade metadata in update payloads, a position-1 bead whose create event races the label write could still wait (`/git/github.com/LiGoldragon/orchestrator/RISK.md:3-17`). It also calls out the redb duplicate-action scan as small-scale today and a future indexing candidate (`/git/github.com/LiGoldragon/orchestrator/RISK.md:14-17`), and it tells reviewers to inspect the event parser and duplicate side-effect guard first (`/git/github.com/LiGoldragon/orchestrator/RISK.md:41-50`).

Deployment gap: CriomOS-home still pins orchestrator rev `7a8f8e086...`, so the running package does not include `5927ace`, `47a81db`, `04bd1e2`, or `d443382` (`/home/li/git/CriomOS-home/flake.lock:844-850`). The orchestrator repo also has uncommitted edits to `RISK.md` and `tests/scripts/orchestrator-isolated-gc-test.sh`; current working-tree lines add production-city guards and stronger artifact-chain assertions (`/git/github.com/LiGoldragon/orchestrator/tests/scripts/orchestrator-isolated-gc-test.sh:35-68`, `/git/github.com/LiGoldragon/orchestrator/tests/scripts/orchestrator-isolated-gc-test.sh:424-458`, `/git/github.com/LiGoldragon/orchestrator/tests/scripts/orchestrator-isolated-gc-test.sh:618-650`). Keep them only if Li wants the extra hardening committed; otherwise the repo is dirty after a closed bead.

## Working-tree triage

### Commit or keep as legitimate in-progress

- `_intake/operating-rules/version-pinning.md`: legitimate new rule. It states the forward-pin principle directly (`/home/li/Criopolis/_intake/operating-rules/version-pinning.md:7-18`) and records the 2026-05-05 gascity pinning example (`/home/li/Criopolis/_intake/operating-rules/version-pinning.md:79-105`). Commit after Li approves.
- `_intake/operating-rules/supervisor-restart.md`: legitimate postmortem/runbook. It documents the critical systemd `ExecStart` binary-swap trap (`/home/li/Criopolis/_intake/operating-rules/supervisor-restart.md:10-36`) and the actual 2026-05-05 failure/workaround (`/home/li/Criopolis/_intake/operating-rules/supervisor-restart.md:198-287`). Commit after Li approves.
- `_intake/operating-rules/README.md`: legitimate index update for those two new rules (`/home/li/Criopolis/_intake/operating-rules/README.md:15-38`).
- `agents/code-writer/prompt.template.md`: legitimate prompt update requiring code-writer to read the version-pinning rule before lockfile work (`/home/li/Criopolis/agents/code-writer/prompt.template.md:24-32`). This is prompt-scope; commit only after mayor/Li accepts the authorship boundary.
- `pack.toml`: likely intentional compatibility drift. It currently sets `cascade-tester` and `committer` back to `gpt-5.5` (`/home/li/Criopolis/pack.toml:84-100`), reversing `criopolis 46ae7e1 (switch committer + cascade-tester to gpt-5.4-mini)`. Keep while the deployed `gc` is stock v1.0.0; reconsider after the rebased model-choice fork is deployed.
- `_intake/reports/2026-05-05-city-investigation-status.md`: useful historical status report but stale now. Its TL;DR documents the pre-restart state and prior findings (`/home/li/Criopolis/_intake/reports/2026-05-05-city-investigation-status.md:7-13`), while the "waiting on next" section is superseded by this survey (`/home/li/Criopolis/_intake/reports/2026-05-05-city-investigation-status.md:153-160`). Commit as a dated report, not as current truth.
- `research/answers/does-gascity-have-orchestration.md`: legitimate completed answer for `cr-t5r5wr (convoy/control-dispatcher orchestration research)`, with a clear verdict and citations (`/home/li/Criopolis/research/answers/does-gascity-have-orchestration.md:3-10`).
- `research/answers/gc-update-and-services.md`: legitimate completed answer about supervisor binary replacement and service-management primitives (`/home/li/Criopolis/research/answers/gc-update-and-services.md:3-15`).

### Delete or clean

- `.gitkeep`: stale root-level untracked file with no useful content. Delete unless Li knows why it exists.

### Unsure; ask Li before touching

- `keel/`: nested clean git repo for `LiGoldragon/keel`, but it has no tracked files at `HEAD` and is not registered by `gc rig list` (which listed only `criopolis`). It may be an abandoned local clone under the city root. Do not delete without Li.
- `library/`: nested dirty repo for `LiGoldragon/bibliography`. Its own `CLAUDE.md` describes it as a curated reference library (`/home/li/Criopolis/library/CLAUDE.md:1-17`) and mandates `jj` (`/home/li/Criopolis/library/CLAUDE.md:35-37`). It is not registered by `gc rig list`, and its dirty state is gas-city scaffolding (`.gc`, `.beads`, `.claude/skills`, `.codex/hooks.json`, `.runtime/session_id`). This looks like a real repo accidentally initialized as a nested city/rig. Ask Li whether to move/register/ignore it; do not delete.

## Other in flight

- `cr-2vb4st (MCP audit + prune broken servers)` is the only non-survey P0 I found in `IN_PROGRESS`. Its write scope is MCP config plus `research/answers/2026-05-05-mcp-audit.md`, not the gascity/orchestrator/code-writer path.
- Session state is still unsafe. Active/open sessions include mayor, `control-dispatcher`, one `code-writer`, and `researcher-1`; while I was surveying, fresh `researcher` and `researcher-2` session beads appeared in `creating` with `pending_create_claim=true`. That matches the restart-respawn hazard described in the survey bead and means the pool is not settled.
- `_intake/replies/` has no recent forum-round replies after 2026-05-03, so I found no current reply synthesis half-written there.
- Recent commit activity is concentrated in the city repo (`criopolis 46ae7e1 (switch committer + cascade-tester to gpt-5.4-mini)` and related prompt/report commits), orchestrator (`orchestrator 5927ace`, `47a81db`, `04bd1e2`, `d443382`), gascity (`gascity 76f46b45` plus fresh upstream main commits), gascity-nix (`gascity-nix 758917c (bump: gascity fork model schema)`), and CriomOS-home (`CriomOS-home a179bbf (gascity pin to stock v1.0.0 anchor)`). `keel/` and `library/` show no commits since 2026-05-04 18:00.
- `gc bd list --updated-after 2026-05-04T12:00:00Z --include-infra --all` returned 5408 issues, dominated by closed order/patrol beads. That volume is consistent with the known Dolt/order noise; use filtered open/in-progress views for operational decisions.

## Recommended next steps for mayor

1. Keep pools constrained. Do not let multiple researchers/code-writers auto-resume until the open `creating` researcher session beads are cleared or understood.
2. Give exactly one code-writer `cr-hjw2hd (gascity fork rebase)` with a narrow directive: no gascity reset; update `gascity-nix` to `gascity 76f46b45`, update CriomOS-home lock to the new `gascity-nix` commit, run the promised build/test, push/PR, then close the bead.
3. Decide whether to keep the unrelated generated `gc dolt` docs in `gascity 76f46b45 (codex model choices on v1.0.0)`. It is doc-only, but it is not part of the original model patch.
4. For `cr-ikfo2u (orchestrator cascade-chain skip bug)`, either commit/drop the uncommitted harness hardening, then bump CriomOS-home orchestrator from `7a8f8e0` to `d443382`, or explicitly shelve deployment if the native graph.v2 path is now preferred.
5. Commit the legitimate city docs/reports/prompts after Li review; delete `.gitkeep`; leave `keel/` and `library/` untouched until Li decides their intended home.
6. Resume `cr-9dw438 (maintainer prompt + manual scaffold)` as a fresh documentation bead after the above stabilization, using `does-gascity-have-orchestration.md` and `gc-update-and-services.md` as inputs.

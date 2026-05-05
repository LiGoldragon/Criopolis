# Gas City Fork Stability

## Answer

Li's directive chose the right containment move: the old fork sat on
`gascity dfe314b3 (protect active test dolt cleanup roots)`, which is
360 commits past `gascity v1.0.0 67c821c7 (release tag final warning fix)`.
The new branch `rebase-v1.0.0` keeps upstream `v1.0.0` and adds only
`gascity 76f46b45 (codex model choices on v1.0.0)`.

That drops every post-tag change listed below. The dropped range contains
multiple commits in the exact areas Criopolis was hurting: control follow
loops, session reconciliation, dog maintenance scripts, and managed Dolt
cleanup. This note does not prove one commit as the regression; it records
the risk cluster the stable-tag pin removes.

## Published Artifacts

- `gascity rebase-v1.0.0` points at `gascity 76f46b45 (codex model choices on v1.0.0)`.
- `gascity-nix pin-gascity-rebase-v1.0.0` points at `gascity-nix 9692d4e (gascity pin to rebased v1.0.0)`.
- Draft PR: `LiGoldragon/gascity-nix#1 (pin gascity to rebased v1.0.0 branch)`.

## High-Risk Dropped Changes

### Control Dispatcher And Convoy

- `gascity ca336a86 (control follow idle exponential backoff)` changed `gc convoy control --follow` pacing.
- `gascity fd304613 (pending follow loops base interval)` adjusted pending follow-loop behavior.
- `gascity 176065b3 (control dispatcher store scan reduction)` changed `cmd/gc/dispatch_runtime.go` and `internal/dispatch/runtime.go`.
- `gascity c457b557 (read-only control work queries)` changed control work query paths and `gc bd` bridge behavior.
- `gascity 4be4d44b (workflow source chains across stores)` changed convoy dispatch and `internal/dispatch/runtime.go`.
- `gascity 56fac6da (orphaned workflow finalizers close safely)` changed dispatch finalizer behavior.

These are direct candidates for the observed control-dispatcher heat and
`bd show` amplification because they alter the code that follows, scans,
and finalizes control work.

### Session Reconciler And Respawn

- `gascity d4046d75 (reconciler broad tick scan avoidance)` changed `cmd/gc/build_desired_state.go`, `cmd/gc/cmd_wait.go`, and bead cache reads.
- `gascity 027b2bf3 (startup timeout no success outcome)` changed session start result reporting.
- `gascity b31fd6c5 (named session respawn circuit breaker)` added respawn circuit-breaker logic.
- `gascity 155029ce (rollback stale pending-create beads)` changed desired-branch reconciliation.
- `gascity 523c8b95 (release terminal named-session alias)` changed terminal named-session alias release.
- `gascity f1d10797 (clean dead runtime artifacts)` changed session cleanup and lifecycle code.

These are plausible candidates for instant dog/session respawns and
control-session churn because they touch named-session reconciliation,
pending-create recovery, and runtime cleanup.

### Dog And Maintenance Formulas

- `gascity 42cdc0b2 (mol-dog-backup interval six hours)` changed dog backup cadence.
- `gascity 67de5b41 (replace deprecated gc nudge in packs)` changed dog formulas and maintenance prompt assets.
- `gascity b6c51f6b (probe user dolt database)` changed `mol-dog-doctor`, `mol-dog-stale-db`, and maintenance scripts.
- `gascity b56c4186 (skip test-pattern DBs in reaper)` changed `examples/gastown/packs/maintenance/assets/scripts/reaper.sh`.
- `gascity 945ffc55 (dog pool reaper qualifier fix)` changed `examples/gastown/packs/maintenance/assets/scripts/orphan-sweep.sh`.
- `gascity 0d762d60 (harden dolt cleanup workflow)` added the `gc dolt-cleanup` stale database workflow and changed `mol-dog-stale-db`.

These are direct candidates for dog accumulation and missed reaping
because they edit the formula layer and the scripts that decide what the
dogs clean up.

### Managed Dolt And Bead Store

- `gascity d4c749d0 (retry transient managed Dolt init)` changed Dolt init paths.
- `gascity 885d07c2 (scheduled Dolt GC nudge)` added Dolt nudge, doctor checks, and recovery scripts.
- `gascity 48a1e9b9 (disable upstream Dolt auto GC scheduler)` changed managed Dolt startup and embedded bd scripts.
- `gascity 46cf2724 (drop slow bd config set calls)` changed `gc-beads-bd.sh` init behavior.
- `gascity 8ed1001f (kill bd subprocess trees on timeout)` changed bd subprocess timeout handling.
- `gascity dfe314b3 (protect active test dolt cleanup roots)` changed `cmd/gc/dolt_cleanup_*`.

These are direct candidates for idle Dolt CPU and cleanup surprises
because they change managed Dolt startup, GC scheduling, bd subprocess
timeouts, and stale database cleanup.

### Sling Classification

- `gascity e78cf8d1 (sling refuses missing bead IDs)` changed `cmd/gc/cmd_sling.go`.
- `gascity a82268bc (sling consults bead store first)` changed bead-ID versus inline-text classification.

These are plausible contributors to automatic convoy/session creation
behavior because they alter the routing path for slung bead IDs.

## Validation Notes

The rebased Gas City branch validates the patch surface:

- `go test ./internal/worker/builtin ./internal/config` passes on
  `gascity 76f46b45 (codex model choices on v1.0.0)`.
- `make build` passes and produces `bin/gc`.
- `bin/gc version` runs.

The full `make check` gate fails on the `v1.0.0` baseline and on the
rebased branch in the same unrelated packages, including
`internal/convergence` and `internal/api`. A clean detached `v1.0.0`
worktree reproduced representative failures:

- `TestRunConditionUsesWorkDir`
- `TestRunConditionOutputTruncation`
- `TestResolveWorkerSessionRuntimePreservesStoredResolvedCommandAndBackfillsCurrentResumeSettings`
- `TestWorkerFactorySessionByIDUsesResolvedTemplateRuntime`

The `gascity-nix` pin validates successfully:

- `nix build .#gascity`
- `result/bin/gc version` prints `1.0.0-codex-2026-05-05`

## Risk Note

The stable rebase removes the post-tag fixes too, not only suspected
regressions. The most visible dropped fix is `gascity 46cf2724 (drop slow
bd config set calls)`, which the old `gascity-nix` comment said avoided a
30-second `gc start` timeout on slow `bd config set` calls. Li chose the
stable-tag line anyway; this is the main known tradeoff to watch first.

Second-review should inspect the Codex provider option resolution in
`internal/worker/builtin/profiles.go` and `internal/config/options_test.go`,
then the `gascity-nix` source hash and version string.

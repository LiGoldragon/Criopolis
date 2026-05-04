# Dolt write amplification / iowait upstream scan

Bead: `cr-zsyawg` (dolt write-amplification upstream scan/profile)

## Verdict

I found upstream reports for the same class of failure, but not one exact report that packages this city's current pattern as "attached config-drift marker churn + order dispatch cycle creates a 7-8 Dolt-write/iowait storm."

Adjacent upstream items already exist:

- `gascity` PR #563: named-session respawn loop "generating heavy dolt writes that starved btrfs I/O for the entire desktop session" — https://github.com/gastownhall/gascity/pull/563.
- `gascity` PR #568: adds Linux PSI filesystem-pressure backpressure because a buggy named session generated continuous Dolt writes and the supervisor kept adding work — https://github.com/gastownhall/gascity/pull/568.
- `gascity` issue #1510: `CachingStore.SetMetadata`/`SetMetadataBatch` no-op writes still shell out to `bd update`, open Dolt connections, and often commit "nothing to commit" — https://github.com/gastownhall/gascity/issues/1510.
- `gascity` PR #1586: rollback storm where each rollback fires three `bd` subprocess writes and the fork-per-call/Dolt cost is called out separately — https://github.com/gastownhall/gascity/pull/1586.
- `gascity` issue #1118: `.gc/events.jsonl` grows without bound; observed 109 MB / 125k lines — https://github.com/gastownhall/gascity/issues/1118.
- `gascity` issue #1487: events HTTP API timeouts under load, co-occurring with `events.jsonl` growth — https://github.com/gastownhall/gascity/issues/1487.
- `gascity` PR #1377 and #1412: cache-reconcile loops caused repeated bead-close events and high Dolt CPU under load — https://github.com/gastownhall/gascity/pull/1377 and https://github.com/gastownhall/gascity/pull/1412.
- `beads` PR #3165: `bd batch` explicitly says loops of `bd` calls cause severe write amplification on Dolt SQL server + btrfs+compression; its source comment says batching collapses N invocations into one transaction and one Dolt commit (`/git/github.com/gastownhall/beads/cmd/bd/batch.go:35-43`).
- `beads` issue #3414: every mutating `bd` command completes the primary write, then hangs 10-15s in auto-export hydrate-labels on a Dolt remote backend — https://github.com/gastownhall/beads/issues/3414.

What I did not find:

- `gascity` source/docs have no `iowait`, `io wait`, or `write amplification` text matches in the cloned tree. `rg` over `/git/github.com/gastownhall/gascity` returned no matches for those exact terms.
- `gascity-nix` has no matches for `iowait`, `write amplification`, `events.jsonl`, `cache-reconcile`, `attached_config_drift`, `GC_BEADS=file`, SQLite, or KV in `/git/github.com/LiGoldragon/gascity-nix`.
- GitHub issue/PR search found no exact `iowait` issue/PR in the three repos; the closest terms are btrfs I/O starvation, filesystem pressure, Dolt CPU, and `bd` subprocess write storms.
- GitHub discussion search returned no matching `gascity` or `gascity-nix` discussions for Dolt write amplification/iowait/events/cache-reconcile. `beads` discussions do contain Dolt/SQLite/backing-store concerns, notably https://github.com/gastownhall/beads/discussions/2332, https://github.com/gastownhall/beads/discussions/1836, and lock-contention discussion https://github.com/gastownhall/beads/discussions/1778, but I did not find a discussion for this exact Gas City marker/order churn pattern.

## Code-path map

Gas City opens `.gc/events.jsonl` through `events.NewFileRecorder(filepath.Join(cityPath, ".gc", "events.jsonl"))` during start (`/git/github.com/gastownhall/gascity/cmd/gc/cmd_start.go:524-530`). `FileRecorder` is an append-only JSONL recorder; `Record` locks the file, reads latest sequence, increments, marshals JSON, and writes one line (`/git/github.com/gastownhall/gascity/internal/events/recorder.go:15-19`, `/git/github.com/gastownhall/gascity/internal/events/recorder.go:55-94`). These event writes are file appends, not Dolt commits.

The controller loop dispatches orders before session reconciliation (`/git/github.com/gastownhall/gascity/cmd/gc/city_runtime.go:689-691`). Patrol ticks use `cfg.Daemon.PatrolIntervalDuration()` (`/git/github.com/gastownhall/gascity/cmd/gc/city_runtime.go:509-516`), and the default patrol interval is 30s if unset or invalid (`/git/github.com/gastownhall/gascity/internal/config/config.go:1325-1326`, `/git/github.com/gastownhall/gascity/internal/config/config.go:1365-1375`).

Order dispatch uses raw store opening, not the controller's `CachingStore`: `buildOrderDispatcher` sets `storeFn` to `openStoreAtForCity(target.ScopeRoot, cityPath)` (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:120-124`). The dispatcher comment says it creates the tracking bead before launching the goroutine to prevent re-fire (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:26-34`).

For a successful exec order, the structural bead mutations are:

- `store.Create` creates an order tracking bead before dispatch (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:240-245`).
- `dispatchOne` records `order.fired` to the event recorder, then dispatches exec or wisp (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:318-337`).
- `dispatchExec` records `order.completed` or `order.failed` to the event recorder, then `store.Update` labels the tracking bead (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:340-370`).
- The deferred `store.Close(trackingID)` runs at the end of `dispatchOne` (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:318-320`).

Under the `bd` provider, those three bead mutations are three `bd` calls: `bd create`, `bd update`, and `bd close`. `BdStore.Create` shells out to `bd create` (`/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:503-568`), `BdStore.Update` shells out to `bd update` (`/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:589-640`), and `BdStore.Close` shells out to `bd close --force` (`/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:751-767`).

So the "7-8 writes/cycle" claim is not structurally correct if "writes" means Dolt commits for an exec order. The exec path has 3 bead-store mutations. It can produce about 8 observable append-like records when event hooks are included: 3 bead mutations, 2 controller events (`order.fired`, `order.completed`/`failed`), and 3 bd-hook bead events (`bead.created`, `bead.updated`, `bead.closed`). Hooks map create/update/close to bead event types (`/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:11-16`) and call `gc event emit` in background (`/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:18-31`, `/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:34-55`).

For a successful wisp/formula order, the count is higher and recipe-dependent:

- Tracking bead create happens first (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:240-245`).
- `molecule.Instantiate` creates one bead per recipe step (`/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:391-398`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:498-507`).
- `molecule.Instantiate` may also write parent/dependency/assignee updates after creation (`/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:511-534`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:537-550`).
- The dispatcher updates the root wisp with order labels/routing metadata (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:457-469`) and updates the tracking bead with the `"wisp"` outcome label (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:483-490`).
- The deferred tracking close still runs (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:318-320`).

A one-step formula therefore has at least `tracking create + root create + root update + tracking update + tracking close = 5` bead-store mutations, plus dependency/parent/assignee writes for richer recipes. That can easily look like 7-8 or more event/log records, but the exact Dolt write count depends on formula step count and dependency shape.

## Cache-reconcile is not a Dolt write

`newControllerState` wraps BdStores in `CachingStore` (`/git/github.com/gastownhall/gascity/cmd/gc/api_state.go:72-103`). `wrapWithCachingStore` records cache notifications as events with actor `"cache-reconcile"` (`/git/github.com/gastownhall/gascity/cmd/gc/api_state.go:110-134`), primes the cache, then starts the reconciler after full prime (`/git/github.com/gastownhall/gascity/cmd/gc/api_state.go:145-157`).

`CachingStore` writes pass through to the backing store, but its reconciler is a watchdog scan: it calls `c.backing.List(ListQuery{AllowScan: true})` and fetches deps (`/git/github.com/gastownhall/gascity/internal/beads/caching_store_reconcile.go:63-88`). Reconcile then emits cache notifications when fresh backing state differs from cached state (`/git/github.com/gastownhall/gascity/internal/beads/caching_store_reconcile.go:94-185`, `/git/github.com/gastownhall/gascity/internal/beads/caching_store_reconcile.go:188-250`), and `notifyChange` only marshals an event payload and calls `onChange` (`/git/github.com/gastownhall/gascity/internal/beads/caching_store_events.go:335-355`).

The event bus watcher applies `bead.created`, `bead.updated`, and `bead.closed` events to caching stores (`/git/github.com/gastownhall/gascity/cmd/gc/api_state.go:223-272`). It explicitly does not poke the controller when the event actor is `cache-reconcile` (`/git/github.com/gastownhall/gascity/cmd/gc/api_state.go:270-272`), and the test asserts that a cache-reconcile event should not poke the controller (`/git/github.com/gastownhall/gascity/cmd/gc/api_state_test.go:1657-1664`).

`CachingStore.SetMetadata` and `SetMetadataBatch` currently call the backing store before touching the cache (`/git/github.com/gastownhall/gascity/internal/beads/caching_store_writes.go:205-249`). This source matches upstream issue #1510's complaint about no-op metadata writes causing avoidable `bd update` calls.

## Marker-update mechanism

The attached config-drift marker keys are constants:

- `attached_config_drift_deferred_at`
- `attached_config_drift_deferred_key`

They are declared next to the named-session drift marker keys (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1295-1303`).

When a session's stored config hash differs from the current hash, the reconciler checks attachment first. If the session is attached, it calls `recordSessionAttachedConfigDriftDeferral`, cancels any drift drain, records a deferred trace, and `continue`s, so it does not restart or drain that cycle (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:780-805`).

`recordSessionAttachedConfigDriftDeferral` always writes a fresh RFC3339 timestamp and drift key via `store.SetMetadataBatch` (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1400-1412`). Because it writes `now`, an attached drifting session can produce one metadata write per reconcile cycle while the hash mismatch and attachment both remain true.

The false-negative guard keeps deferring only if the same drift key was recorded within `sessionAttachedConfigDriftFalseNegativeLimit`, which is 30s (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1295-1302`, `/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1414-1433`). Tests pin the intended behavior: while attached, multiple cycles should not drain; after detach, config drift should drain (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler_test.go:3085-3137`).

Named-session bounded deferrals are different. `shouldDeferNamedSessionConfigDrift` uses bounded deferral only for `activity_unknown` and `recent_activity` (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1320-1331`). The bounded path writes marker metadata only when the drift key changes, timestamp is missing, or timestamp parse fails; otherwise it stops deferring after the limit (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1334-1370`). The test checks that unknown-activity deferral stops after the threshold and gets a fresh deferral for a new drift key (`/git/github.com/gastownhall/gascity/cmd/gc/session_model_phase0_rare_state_spec_test.go:395-433`).

Markers stop being populated when the hashes match, because the reconciler calls `clearSessionConfigDriftDeferral` outside the mismatch branch (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:893-895`). `clearSessionConfigDriftDeferral` skips writes if all four marker keys are already empty and otherwise clears them in one `SetMetadataBatch` (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1382-1398`). Config-drift reset for a named session also clears all four keys in the reset batch (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1559-1565`).

## Storage layer and alternatives

Gas City defaults to the `bd` provider. The README says `bd` is default and `GC_BEADS=file` or `[beads] provider = "file"` selects a file-backed store without Dolt/bd/flock (`/git/github.com/gastownhall/gascity/README.md:35-45`). `rawBeadsProvider` uses `GC_BEADS`, then city config, then default `"bd"` (`/git/github.com/gastownhall/gascity/cmd/gc/providers.go:469-478`).

`openStoreAtForCity` returns a file store only for provider `"file"`; otherwise `"bd"` or unrecognized providers require `bd` and call `openBdStoreAt` (`/git/github.com/gastownhall/gascity/cmd/gc/main.go:845-881`). `openBdStoreAt` returns `bdStoreForCity` for the city root and `bdStoreForRig` for rigs (`/git/github.com/gastownhall/gascity/cmd/gc/main.go:902-910`). The city `bd` runner sets `BEADS_DIR=dir/.beads` (`/git/github.com/gastownhall/gascity/cmd/gc/bd_env.go:21-39`) and `bdRuntimeEnv` disables bd auto-start while projecting the managed Dolt env (`/git/github.com/gastownhall/gascity/cmd/gc/bd_env.go:454-471`).

`BdStore` says it shells out to `bd` and delegates persistence to bd's embedded Dolt database (`/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:99-100`). Beads itself says Dolt is the database, with embedded mode storing data under `.beads/embeddeddolt/` and server mode under `.beads/dolt/` (`/git/github.com/gastownhall/beads/README.md:90-109`). Beads also says "The Dolt database is the storage backend" (`/git/github.com/gastownhall/beads/README.md:158-159`), and current config code says `GetBackend` always returns Dolt (`/git/github.com/gastownhall/beads/internal/configfile/configfile.go:214-216`).

The SQLite alternative is historical, not current. Beads' changelog says the "Beads Classic SQLite backend" and migration infrastructure were removed and "Dolt is the only backend" (`/git/github.com/gastownhall/beads/CHANGELOG.md:529-533`). Gas City's own archive says "Gas City never had SQLite beads" (`/git/github.com/gastownhall/gascity/engdocs/archive/analysis/gastown-upstream-audit.md:1033-1034`).

There is a Beads `bd kv` subcommand, but it is not a storage backend. It stores keys under a `kv.` prefix (`/git/github.com/gastownhall/beads/cmd/bd/kv.go:12-13`), writes through `store.SetConfig` (`/git/github.com/gastownhall/beads/cmd/bd/kv.go:80-84`), and lists through `store.GetAllConfig` filtered by `kv.` (`/git/github.com/gastownhall/beads/cmd/bd/kv.go:192-207`). The changelog calls it a "Key-value store" subcommand (`/git/github.com/gastownhall/beads/CHANGELOG.md:1189-1191`), not an alternative issue-storage backend.

Gas City's real non-Dolt alternative is the file provider. `OpenFileStore` opens/creates a file-backed store (`/git/github.com/gastownhall/gascity/internal/beads/filestore.go:31-35`), and its create/update/close/metadata paths mutate an in-memory store and save to disk (`/git/github.com/gastownhall/gascity/internal/beads/filestore.go:90-124`, `/git/github.com/gastownhall/gascity/internal/beads/filestore.go:137-145`, `/git/github.com/gastownhall/gascity/internal/beads/filestore.go:208-239`).

## Cheap local observation

I did not run a stress profile or count Dolt commits. A cheap static sample of the current city showed `.gc/events.jsonl` at 73,004 lines and 56,026,847 bytes. In the last 5,000 events, the top counts were 2,367 `bead.updated`, 663 `bead.created`, 662 `bead.closed`, 634 `order.completed`, and 633 `order.fired`; only 30 of those last 5,000 had actor `cache-reconcile`.

## Credible upstream report shape

A credible upstream issue should not say "7-8 Dolt writes" without separating Dolt mutations from JSONL appends. The source-backed report should say:

1. Default bd-backed Gas City turns `Store.Create/Update/Close/SetMetadataBatch` into `bd` subprocesses and Dolt persistence (`/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:99-100`, `/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:503-568`, `/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:589-680`, `/git/github.com/gastownhall/gascity/internal/beads/bdstore.go:751-767`).
2. Exec order success structurally emits 3 bead-store mutations and 2 controller JSONL events; bd hooks add bead-created/updated/closed JSONL events (`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:240-245`, `/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:318-370`, `/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:11-31`).
3. Wisp order success emits `N + 4 + dependency/assignee/parent` bead-store mutations where `N` is recipe steps (`/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:391-398`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:498-550`, `/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:444-490`).
4. Attached config-drift writes a fresh `attached_config_drift_*` timestamp/key every reconcile cycle while attached and drifting (`/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:780-805`, `/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1400-1412`).
5. `cache-reconcile` records are event-file notifications from the cache path, not Dolt commits (`/git/github.com/gastownhall/gascity/cmd/gc/api_state.go:124-134`, `/git/github.com/gastownhall/gascity/internal/beads/caching_store_reconcile.go:63-88`, `/git/github.com/gastownhall/gascity/internal/beads/caching_store_events.go:335-355`).

The report should include measured evidence: `iostat -xz 1`, `/proc/pressure/io`, load average, `bd` latency histogram, Dolt commit count per minute, `.gc/events.jsonl` append rate, counts by event type/actor, number of sessions with stable config drift while attached, and sample formulas/orders that reproduce the loop. It should propose either rate-limiting or making `recordSessionAttachedConfigDriftDeferral` episode-based instead of timestamp-refreshing every tick, plus batching order tracking writes or using `bd batch` where the source-compatible operation set permits it.

# Researcher answer — pc-tftl: Gas City lifecycle

**Source pinned:** `github.com/gastownhall/gascity` @ commit
`4be4d44b` (the exact commit baked into the running binary, per
`-X main.commit=...` in the Nix derivation). Companion: 
`github.com/gastownhall/beads`. Both cloned via ghq at
`/git/github.com/gastownhall/{gascity,beads}`.

All file paths below are relative to those clones.

---

## Q1 — On-demand named-session materialization, and why librarian sat as `reserved-unmaterialized`

### 1.1 Trace

`gc reload` → controller socket → `CityRuntime.handleReloadRequest` →
`reloadConfigTraced` → `tryReloadConfig` → revision compare →
`buildDesiredState` (next reconciler tick) → for each `[[named_session]]`:
materialize iff `Mode == "always"` OR a canonical session bead exists
OR `namedWorkReady[identity]` is true.

### 1.2 Citations

**`gc reload` is a thin client over the controller socket.**
`cmd/gc/cmd_reload.go:179`:

```go
resp, err := sendControllerCommandWithReadTimeout(cityPath, "reload:"+string(data), readTimeout)
```

The controller socket handler at `cmd/gc/controller.go:182-183` routes
`reload:<json>` into `handleReloadSocketCmd`, which enqueues a
`reloadRequest` consumed by the runtime. The runtime's reload entry is
`CityRuntime.handleReloadRequest` (`cmd/gc/city_runtime.go:786-810`),
which simply marks `configDirty` and pokes the reconciler — the *actual*
work happens on the next tick in `reloadConfigTraced`.

**"No config changes detected" is a hash equality.**
`cmd/gc/city_runtime.go:906-916`:

```go
if cr.configRev != "" && result.Revision == cr.configRev {
    ...
    return reloadControlReply{
        Outcome:  reloadOutcomeNoChange,
        Message:  "No config changes detected.",
        Revision: result.Revision,
        ...
    }
}
```

The revision is a SHA-256 over the resolved config bundle, computed in
`internal/config/revision.go:22-118`. It hashes:
- every file in `prov.Sources` (city.toml, pack.toml — pack.toml is
  appended to `prov.Sources` at `internal/config/compose.go:178`)
- recursive hash of every rig pack `Includes` directory
- recursive hash of every city-pack `Includes` directory
- `packs.lock` if PackV2 imports are tracked
- recursive hash of v2-resolved pack dirs (`PackDirs`, `RigPackDirs`)
- recursive hash of convention-discovered dirs (`agents/`, `commands/`,
  `doctor/`, `formulas/`, `orders/`, `template-fragments/`, `skills/`,
  `mcp/`) — `internal/config/revision.go:243`

`PackContentHashRecursive` reads every file under each tree
(`internal/config/pack.go:2489-2506`). So a `pack.toml` edit *does*
change the revision. The most likely reason `gc reload` reported
"no config changes detected" twice is that the supervisor's fsnotify
watcher (`cr.restartConfigWatcher` / `WatchTargets` at
`internal/config/revision.go:131-205`) had already auto-applied the
edit before you ran `gc reload` manually — `cr.configRev` was already
the new revision, so the manual reload's tryReloadConfig produced the
same hash. This is consistent with the user's recorded memory
"reload fingerprint excludes prompt bodies" being a *narrower* effect
(prompt bodies *are* in the hash, via convention-discovered `agents/`,
unless your prompt files live somewhere outside the discovered tree).

**Materialization gate (this is the actual answer to "why did
librarian not spawn").** `cmd/gc/build_desired_state.go:323-396`:

```go
// Named sessions: materialize session beads for configured [[named_session]]
// entries. "always" mode sessions are unconditionally materialized; "on_demand"
// sessions are materialized only when they already have a canonical bead or
// when their work query returns ready work.
...
for identity := range namedSpecs {
    for _, wb := range assignedWorkBeads {
        if wb.Status != "open" && wb.Status != "in_progress" {
            continue
        }
        assignee := strings.TrimSpace(wb.Assignee)
        if assignee == identity {
            ...
            namedWorkReady[identity] = true
            break
        }
    }
}
...
for identity, spec := range namedSpecs {
    if spec.Mode == "always" || namedWorkReady[identity] || !namedSessionAllowsControllerWorkQuery(cityPath, cfg, spec) {
        continue
    }
    // (controller-side work_query probe; only runs when allowed)
}
for identity, spec := range namedSpecs {
    canonicalBead, hasCanonical := findCanonicalNamedSessionBead(...)
    ...
    if spec.Mode != "always" && !hasCanonical && !namedWorkReady[identity] {
        continue   // <-- librarian dies here
    }
    // ... materialize ...
}
```

Two crucial details:

1. The comment at lines 343-347 is explicit:
   > "Raw `gc.routed_to` metadata is intentionally NOT treated as direct
   > named demand here. Routed metadata feeds the named agent's
   > work_query, and the on-demand session only materializes from that
   > path once the work is actually actionable."

   `assignedWorkBeads` is built in `collectAssignedWorkBeadsWithStores`
   (`build_desired_state.go:527-599`) and filtered by
   `appendAssignedUnique` (`build_desired_state.go:635-642`):
   ```go
   if strings.TrimSpace(b.Assignee) == "" { continue }
   ```
   A bead with `gc.routed_to=librarian` but `Assignee=""` is *excluded*.

2. The controller's work-query probe at lines 364-387 is gated by
   `namedSessionAllowsControllerWorkQuery`
   (`cmd/gc/build_desired_state.go:1289-1297`):
   ```go
   if spec.Named != nil && strings.TrimSpace(spec.Named.Dir) != "" {
       return true
   }
   return configuredRigName(cityPath, spec.Agent, cfg.Rigs) != ""
   ```
   For a city-scoped named session whose underlying agent has no `dir`
   (your librarian: city-level entry in `pack.toml`, no `dir` field on
   the agent), this returns false. **The controller does not probe the
   librarian's work_query at all.**

**What `gc sling` actually writes.**
`internal/config/config.go:1987`:

```go
func (a *Agent) DefaultSlingQuery() string {
    return "bd update {} --set-metadata gc.routed_to=" + a.QualifiedName()
}
```

So `gc sling librarian li-63f` runs (effectively):
`bd update li-63f --set-metadata gc.routed_to=librarian` — it writes
metadata, never `Assignee`. Combined with the gates above, the librarian
session has no path to materialize.

### 1.3 Answer

The librarian sat at `reserved-unmaterialized` because it is a
**city-scoped on_demand named session**, and city-scoped named sessions
need an explicit `Assignee=librarian` work bead (or a canonical session
bead from a prior run) to materialize. `gc sling` writes
`gc.routed_to` only; the controller refuses to probe city-scoped
work_queries; and `assignedWorkBeads` filters out the unassigned
routed-only bead. The auto-convoy error was a separate cosmetic failure
(see Q3) — not load-bearing.

**Shortest correct sequence (no restarts):**

```sh
gc sling librarian li-63f                  # routes; pokes controller (irrelevant)
bd update li-63f --assign librarian        # THIS is what materialization gates on
gc poke                                    # immediate reconciler tick (optional;
                                           # next patrol_interval would do it)
```

A cleaner alternative, applicable in `pack.toml`, is to give the
librarian `dir = "library"` (making it rig-scoped). Then
`namedSessionAllowsControllerWorkQuery` returns true and the controller
will probe its work_query, so a routed-only bead would be enough.

### 1.4 Open questions

- Whether the existing aesthete/pragmatist/theorist/devil sessions
  materialize *via canonical session bead* (line 389) on subsequent
  ticks — i.e., whether a canonical bead survives across mayor sessions
  — is plausible from the code but I didn't trace
  `findCanonicalNamedSessionBead` (`cmd/gc/named_sessions.go:57`) end
  to end. If aesthete materialized once via `--assign`, it would persist
  on the canonical bead for all subsequent slings.

---

## Q2 — Supervisor → controller → session

### 2.1 Architecture

```
gc supervisor       ── one process per host ─────────────────────
│  PID file: ~/.gc/supervisor/...                                 │
│  Socket : ~/.gc/supervisor/supervisor.sock                       │
│  HTTP   : 127.0.0.1:<port> (api.NewSupervisorMux)                │
│  Reconciles registry (~/.gc/supervisor/registry) every            │
│  patrol_interval; on tick, starts/stops managedCity goroutines    │
│  in-process.                                                      │
│                                                                   │
│  ┌─ managedCity (goroutine, in supervisor process) ───────────┐ │
│  │   *CityRuntime cr  + *controllerState cs  + own ctx/cancel  │ │
│  │   Socket: <city>/.gc/controller.sock                         │ │
│  │   Reconciler loop: ticker + pokeCh + reloadReqCh             │ │
│  │   Owns the session provider (tmux/subprocess/...)            │ │
│  │                                                              │ │
│  │   For each desired agent: provider.Start → tmux session     │ │
│  │   ┌─ tmux session "philosophy-city-mayor" ────────────────┐ │ │
│  │   │   the actual Claude/Codex CLI process the user types  │ │ │
│  │   │   into runs in here                                    │ │ │
│  │   └────────────────────────────────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────┘
```

Citations:

- Supervisor main loop: `cmd/gc/cmd_supervisor.go:631-855`. Single
  process; goroutines per city (`managedCity` struct at
  `cmd_supervisor.go:545-554`).
- Supervisor's HTTP API + socket are bound at
  `cmd_supervisor.go:711-754`. Reconcile cadence at
  `cmd_supervisor.go:783-817`; on each tick it calls `reconcileCities`
  (`cmd_supervisor.go:879`) and pokes every running city's
  `controllerState.Poke()`.
- Per-city Unix socket: `controllerSocketPath` returns
  `<city>/.gc/controller.sock` for short paths
  (`cmd/gc/controller.go:77-86`). Bound in `startControllerSocket`
  (`controller.go:108-137`) by the city's runtime.
- Per-city control commands handled in `handleControllerConn`
  (`controller.go:142-210`): `stop`, `ping`, `poke`, `reload`,
  `reload:<json>`, `control-dispatcher`, `converge:<json>`,
  `trace-arm:`, `trace-stop:`, `trace-status`.
- Sessions are started by the runtime provider configured in city.toml
  (default `tmux`; selectable via `[session].provider` and
  `GC_SESSION` env). Sessions belong to the CityRuntime; canceling the
  city ctx tears them down via `gracefulStopAll`.

### 2.2 Command kill table

| Command | Supervisor | CityRuntime / controller | Sessions in city (incl. mayor) |
| --- | --- | --- | --- |
| `gc supervisor` (start) | starts | — | — |
| `gc supervisor stop`<br>or SIGTERM to supervisor | exits cleanly, then loops over all `managedCity` and runs `stopManagedCity` | **all dead** (`cmd_supervisor.go:818-852`, `stopManagedCity:583-629`) | **all dead** |
| `gc unregister` | survives | **dead for that city** — `unregisterCityFromSupervisor` (`cmd_supervisor_city.go:437-495`) drops the city from `supervisor.Registry` and reloads supervisor; reconciler then calls `stopManagedCity` | **all dead** for that city (incl. mayor) |
| `gc stop` | survives | when supervisor is alive: equivalent to `gc unregister` (`cmd_stop.go:59-68`); standalone: connects to controller socket, sends `stop`, controller cancels ctx | **all dead** |
| `gc restart` | survives | `cmdStop` then `doStartWithNameOverride` (`cmd_restart.go:35-45`) — same teardown as stop, then re-register | **all dead → restarted by next reconcile tick** |
| `gc init` | varies — bootstraps a city directory and may call register | survives if city wasn't previously registered | unaffected unless followed by start/restart |
| `gc reload` | survives | survives (no kill) — *unless* `[session].provider` changed, in which case `reloadConfigTraced` calls `gracefulStopAll` on all running sessions during a provider swap (`city_runtime.go:1005-1035`) | only killed on provider swap |
| `gc rig restart <name>` | survives | survives | sessions for agents with `dir == <rig>` are killed (`cmd_restart.go:135-193`); the reconciler restarts them |
| `gc sling`, `gc bd`, `gc mail`, `gc rig add`, `gc poke` | survives | survives | unaffected directly (sling pokes the controller, which may *create* sessions but never tears them down) |

The "may cascade into per-session restarts" caveat in the reload doc is
the provider-swap path above (line 1024-1027). In ordinary use — adding
agents, renaming agents, adjusting `option_defaults`, editing prompts —
**reload does not kill the mayor's session**. The reconciler may
restart individual *worker* sessions if their session-template
fingerprint changes (e.g., a new prompt body, env var, or copy_files
list); see `resolveTemplate*` and the fingerprint plumbing in
`build_desired_state.go:398-407`. The mayor template would only restart
if its own fingerprint changed.

### 2.3 Why `gc restart` killed the mayor session

The mayor session is a tmux session managed by the city's runtime
provider. `gc restart` ran `cmdStop` first, which (because supervisor
is alive) ran `unregisterCityFromSupervisor`, which dropped the city
from the supervisor registry and reloaded the supervisor. The
supervisor's next reconcile saw the city gone from desired and called
`stopManagedCity`, canceling the city ctx; `gracefulStopAll` killed
every session including the mayor's tmux session — that's why your
mayor terminal closed. The runtime channel you mentioned was the tmux
PTY itself: when tmux killed the session, your mayor process exited.

`gc start` then re-registered the city, and the supervisor's reconcile
re-spawned all the `mode = "always"` sessions (mayor) and recreated
canonical session beads. But because nothing in this dance preserves
the mayor's bead state, anything in-flight on a non-canonical bead was
lost — hence Li had to recover manually.

### 2.4 Open questions

- Standalone (no-supervisor) mode: a `gc start` without supervisor
  spawns its own controller process per `runController`
  (`controller.go:1039`). Path differs slightly. The user is in
  supervisor mode, so I didn't trace standalone in depth.

---

## Q3 — Cross-rig sling and the auto-convoy error

### 3.1 Trace

`gc sling librarian li-63f` →
`cmd/gc/cmd_sling.go:177-351 cmdSling` → `openSlingStoreForSource` →
`resolveSlingStoreRoot` (picks the store for the bead's prefix; for
`li-` that's the `library` rig store) → `slingDeps.Store` → 
`doSlingBatch` → `finalize` → executes `sling_query` (writes
`gc.routed_to`) → `deps.Store.Create({Type:"convoy"})` → beads validates
issue type → fails when convoy is not in the store's `types.custom`.

### 3.2 Citations

**Convoy creation (single point):** `internal/sling/sling_core.go:367-408`.

```go
// Auto-convoy.
if !opts.NoConvoy && !opts.IsFormula && deps.Store != nil {
    createAutoConvoy := true
    ...
    if createAutoConvoy {
        var convoyLabels []string
        if opts.Owned {
            convoyLabels = []string{"owned"}
        }
        convoy, err := deps.Store.Create(beads.Bead{
            Title:  fmt.Sprintf("sling-%s", beadID),
            Type:   "convoy",
            Labels: convoyLabels,
        })
        if err != nil {
            result.MetadataErrors = append(result.MetadataErrors,
                fmt.Sprintf("creating auto-convoy: %v", err))
        } else {
            ...
            result.ConvoyID = convoy.ID
        }
    }
}
```

The error string `"creating auto-convoy: %v"` (line 397) is appended to
`result.MetadataErrors`, **not returned as an error from `finalize`** —
finalize keeps going, sets `result.BeadID`, pokes the controller, and
returns nil. That's why your sling reported `Slung li-63f → librarian`
despite the convoy failure: the routing already succeeded at line 343
(`Router.Route`) before the convoy attempt.

**Which store gets the convoy?** `cmd/gc/cmd_sling.go:403-425`
`resolveSlingStoreRoot`:

```go
if bp := beadPrefix(cfg, beadOrFormula); bp != "" && !looksLikeInlineText(...) {
    if sling.IsHQPrefix(cfg, bp) {
        return storeDir
    }
    if rig, found := findRigByPrefix(cfg, bp); found && strings.TrimSpace(rig.Path) != "" {
        return resolveStoreScopeRoot(cityPath, rig.Path)
    }
}
```

So for `li-63f` (prefix `li`, matched to your `library` rig per its
`.beads/config.yaml issue_prefix: li`), `deps.Store` is the
**library rig's bead store**, not the city store. The convoy is
created there.

**Why beads rejects `convoy`.** `beads/internal/types/types.go:544-546`
explicitly says:

```
// Note: Most orchestrator types (convoy, merge-request, slot, agent, role, rig)
// were removed from beads core. They are now purely custom types with no built-in constants.
// Use string literals like types.IssueType("convoy") if needed, and configure types.custom.
```

The validator at `beads/internal/storage/issueops/create.go:155-157`
calls:

```go
if err := issue.ValidateWithCustom(customStatuses, customTypes); err != nil {
    return fmt.Errorf("validation failed for issue %s: %w", issue.ID, err)
}
```

`Issue.ValidateWithCustom` (`beads/internal/types/types.go:221-258`)
returns `invalid issue type: <type>` (line 235) when the type is not
built-in and not in `customTypes`. Built-ins are listed at line 558:
`bug, feature, task, epic, chore, decision, message, molecule, gate,
spike, story, milestone` — convoy is NOT among them. The reported
"invalid issue type: convoy" therefore means the **library rig store**'s
`.beads/config.yaml types.custom` did not contain `convoy` *at the time
sling ran*.

Your `library/.beads/config.yaml` *currently* has:

```
types.custom: molecule,convoy,message,event,gate,merge-request,agent,role,rig,session,spec,convergence
```

so subsequent slings won't show that error. The error you saw was
likely from before that line was added (or from a fresh
`gc rig add library` that copied a stricter default).

### 3.3 Answer

The convoy error is **cosmetic for materialization** — `finalize`
records it on `result.MetadataErrors` and returns nil; sling reports
success and the routing (`bd update {} --set-metadata gc.routed_to=...`)
already happened. The librarian's failure to materialize is unrelated
(see Q1).

For a cross-rig sling to a city-level named session:
- **Where the convoy lives:** in the *bead's* store (the library rig
  store), per `resolveSlingStoreRoot` matching by prefix — not in the
  city store and not in any store keyed to the named-session target.
- **What type it should have:** the code unconditionally creates type
  `"convoy"` (`sling_core.go:392`); to make this succeed, every rig
  store whose beads might be slung must include `convoy` in its
  `.beads/config.yaml types.custom`. There is no "make it city-scoped"
  toggle in the source — the type is hardcoded and the store is picked
  by bead prefix.

If you want to suppress the noise without modifying configs, pass
`--no-convoy` on the sling (`cmd_sling.go:126`).

### 3.4 Open questions

- Whether the convoy is ever *consumed* downstream in cross-rig setups
  (e.g., for batch close-on-convoy semantics) — `internal/sling/sling.go`
  uses ConvoyID for batch tracking, but I didn't verify that
  cross-rig convoys actually wire into anything beyond the parent-link
  on the routed bead (`sling_core.go:399-405`). For your single-bead
  workflow, the convoy is dead weight either way.

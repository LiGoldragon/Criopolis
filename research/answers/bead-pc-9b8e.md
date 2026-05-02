# Researcher answer — pc-9b8e: dolt polling reduction knobs

**Source pinned:** `github.com/gastownhall/gascity` @ commit `4be4d44b`
(same commit baked into running gc, no drift since pc-tftl).
Companion: `github.com/gastownhall/beads`. Both at
`/git/github.com/gastownhall/{gascity,beads}`.

All paths below are relative to those clones unless noted.

---

## Q1 — Where does `sleep=30s` come from?

### 1.1 Trace
`gc convoy control --serve --follow control-dispatcher` →
`runConvoyControlServe` → `runWorkflowServe` →
`runWorkflowServeFollow` → `followSleepDuration(idleSweeps)`
(emits `sleep=Xs`) → `waitForRelevantWorkflowWakeWithTrace` (emits
`wake-sweep ... sleep=Xs`).

### 1.2 Citations
**The constant.** `cmd/gc/dispatch_runtime.go:75-79`:

```go
workflowServeIdlePollInterval  = 100 * time.Millisecond
workflowServeIdlePollAttempts  = 3
workflowServeWakeSweepInterval = 1 * time.Second
workflowServeMaxIdleSleep      = 30 * time.Second
```

**The growth function.** `dispatch_runtime.go:86-100`:

```go
func followSleepDuration(idleSweeps int) time.Duration {
    if idleSweeps <= 0 {
        return workflowServeWakeSweepInterval        // 1s
    }
    ...
    d := workflowServeWakeSweepInterval << uint(shift)
    if d <= 0 || d > workflowServeMaxIdleSleep {
        return workflowServeMaxIdleSleep              // cap = 30s
    }
    return d
}
```

After ~5 idle sweeps (1s, 2s, 4s, 8s, 16s, 32s→cap), the sleep is
pinned at 30s for as long as the queue stays empty.

**Emit sites.** `dispatch_runtime.go:325-333` writes
`serve wait ... sleep=Xs`; line 395 writes
`serve wake-sweep idle_sweeps=N sleep=Xs` when the timer fires.

### 1.3 Answer
The trace's `sleep=30s` is `workflowServeMaxIdleSleep`. It is **not**
a config field. It is a package-level `var` (declared in a `var (
... )` block, not a `const`, only because tests mutate it via
`prevMax := workflowServeMaxIdleSleep; workflowServeMaxIdleSleep =
...` — see `cmd_convoy_dispatch_test.go:3124-3129`). No production
code path reads a TOML value or env var into it.

`patrol_interval` controls a different clock: the city
**reconciler** tick (`city_runtime.go:509`,
`config.go:1325-1326`, default 30s). The reconciler tick does
buildDesiredState + scale_check + materialization decisions; it
does *not* run the dispatcher's `bd ready` chain. The dispatcher is
its own session running `gc convoy control --serve --follow` with
its own sleep/event loop.

### 1.4 Open questions
None — the constant has no override path in source.

---

## Q2 — pack.toml / city.toml / agent.toml knob?

**None for `workflowServeMaxIdleSleep`.** `DaemonConfig`
(`config.go:1314-1363`) exposes only `formula_v2`,
`patrol_interval`, `max_restarts`, `restart_window`,
`shutdown_timeout`, `wisp_gc_interval`, `wisp_ttl`,
`drift_drain_timeout`, `observe_paths`, `probe_concurrency`,
`max_wakes_per_tick` — none wire into `dispatch_runtime.go`.

`gc convoy control --serve` accepts only `--serve` and `--follow
<agent>` (`cmd_convoy_dispatch.go:81-82`); no sleep flag.

`idle_timeout`/`sleep_after_idle` exist on `[[agent]]`
(`config.go:1702-1708`) and `[[agent.override]]`
(`config.go:494-498`) but affect **session lifecycle** (kill or
park), not bd-poll cadence. See Q5.

**Conclusion:** to change `sleep=30s` without a recompile, your
only structural lever is to shadow the implicit `control-
dispatcher` with an explicit `[[agent]]` whose `start_command`
runs a different polling binary (i.e., not gc's built-in serve).

---

## Q3 — Per-tick `bd ready` fan-out

### 3.1 Trace
`drainWorkflowServeWork` (`dispatch_runtime.go:211-282`) calls
`workflowServeList(workflowServeWorkQuery(agentCfg, ...), ...)`
once per drain. For a control-dispatcher,
`workflowServeWorkQuery` returns the multi-tier shell from
`workflowServeControlReadyQuery`.

### 3.2 Citations
**The chain.** `dispatch_runtime.go:439-467`:

```go
func workflowServeControlReadyQuery(agentCfg config.Agent) string {
    ...
    query := queryPrefix + ` sh -c '` +
        `for id in "$GC_SESSION_ID" "$GC_SESSION_NAME" "$GC_ALIAS" "$GC_CONTROL_TARGET"; do ` +
        `[ -z "$id" ] && continue; ` +
        `legacy=""; case "$id" in *control-dispatcher) legacy="${id%control-dispatcher}workflow-control";; esac; ` +
        `for cand in "$id" "$legacy"; do ` +
        `[ -z "$cand" ] && continue; ` +
        `r=$(bd ready --assignee="$cand" --json --limit=20 2>/dev/null); ` +
        `[ -n "$r" ] && [ "$r" != "[]" ] && printf "%s" "$r" && exit 0; ` +
        `done; ` +
        `done; ` +
        `r=$(bd ready --metadata-field "gc.routed_to=$GC_CONTROL_TARGET" --unassigned --json --limit=20 2>/dev/null); ` +
        `[ -n "$r" ] && [ "$r" != "[]" ] && printf "%s" "$r" && exit 0; `
    ...
    query += `bd ready --metadata-field "gc.routed_to=$GC_CONTROL_LEGACY_TARGET" --unassigned --json --limit=20 2>/dev/null'`
    ...
}
```

When the queue is **empty** (the steady-state case — every drain
that produces `idle-exit`), every branch runs to completion with
no early exit. Worst case: 4 identifiers × 2 (real + legacy) + 2
metadata-field calls = **10 fresh `bd` processes per drain**.
Practical case for your city's dispatcher (`GC_SESSION_NAME` and
`GC_ALIAS` likely both `control-dispatcher` so legacy=`workflow-
control`; `GC_SESSION_ID` is a bead like `pc-...` with no legacy):
~6–8 calls — matches Li's audit.

The shell loop **does not dedupe** non-empty identifiers, so
duplicates re-fire bd. (`for cand in "$id" "$legacy"; do` only
short-circuits empty values.)

### 3.3 Knob to reduce
**Yes — set a custom `work_query` on the control-dispatcher
agent.** `dispatch_runtime.go:422-431`:

```go
func workflowServeWorkQuery(agentCfg config.Agent, expandedWorkQuery ...string) string {
    if agentCfg.WorkQuery == "" && isWorkflowServeControlDispatcherAgent(agentCfg) {
        return workflowServeControlReadyQuery(agentCfg)
    }
    workQuery := agentCfg.EffectiveWorkQuery()
    ...
    return workflowServeQuery(workQuery)
}
```

When `agentCfg.WorkQuery != ""`, the entire fallback chain is
**bypassed**. You can put a single-call query on the dispatcher.

But `control-dispatcher` is created **implicitly** at
`config.go:2381-2402`:

```go
if !existing[agentKey{"", ControlDispatcherAgentName}] {
    cfg.Agents = append(cfg.Agents, newControlDispatcherAgent(""))
    ...
}
```

The implicit-injection guard (`!existing[...]`) means an explicit
`[[agent]] name = "control-dispatcher"` in `pack.toml` shadows
the built-in. You'd have to also reproduce
`StartCommand: ControlDispatcherStartCommandFor(qualifiedName)`,
`MaxActiveSessions: &one`, etc. — see
`newControlDispatcherAgent` at `config.go:2406-2421`.

### 3.4 Open questions
- bd is invoked as a fresh process each time per `cmd/bd/main.go`,
  so any per-process connection pool does not amortize across
  calls. The dolt sql-server is the daemon doing the work.

---

## Q4 — `bd ready --watch` / long-poll?

**No.** `bd ready` (`beads/cmd/bd/ready.go`) has no `--watch` flag —
verified by `grep -n "watch\|Watch" cmd/bd/ready.go`: only
incidental "Ready" appearances; no flag definition.

`bd list --watch` and `bd show --watch` exist, **but they poll dolt
internally**. From `beads/cmd/bd/list.go:149-151`:

```go
// watchIssues polls for changes and re-displays (GH#654)
// Uses polling instead of fsnotify because Dolt stores data in a server-side
// database, not files — file watchers never fire.
```

Switching to `--watch` would make CPU **worse**, not better — same
queries, run continuously instead of every 30s.

**Important:** the dispatcher already has an event-driven wake
path. `runWorkflowServeFollow` (`dispatch_runtime.go:294-345`) opens
`openCityEventsProvider` (a **file-backed JSONL** provider, NOT
dolt — see `providers.go:678-680: events.NewFileRecorder(eventsPath,
stderr)` and `cmdName "gc convoy control --serve"`). On
`BeadCreated/BeadUpdated/BeadClosed`, the dispatcher wakes
immediately (line 384-390). The 30s poll is the *safety net* for
events the file recorder might have missed; the events stream does
the responsiveness work.

So the architecture is already what you'd want — events for
responsiveness, periodic poll as fallback. The only knob you don't
have is to lengthen the fallback poll.

---

## Q5 — `idle_timeout` and `sleep_after_idle` for `[[agent]]`

### 5.1 Field definitions
**`idle_timeout`** (`config.go:1702-1705`):
> "the maximum time an agent session can be inactive before the
> controller kills and restarts it. Duration string (e.g., '15m',
> '1h'). Empty (default) disables idle checking."

**`sleep_after_idle`** (`config.go:1706-1708`):
> "overrides idle sleep policy for this agent. Accepts a duration
> string (e.g., '30s') or 'off'."

Difference: `idle_timeout` **kills+restarts**; `sleep_after_idle`
**parks the session** (cleaner, preserves continuity). Validation
at `internal/config/validate_semantics.go:67-69` warns:

```
%s: agent %q: idle_timeout and sleep_after_idle are both set;
idle_timeout takes precedence and sleep_after_idle only applies
when the session survives the idle_timeout check
```

So pick one — `sleep_after_idle` is the gentler choice.

### 5.2 Where it gates
`compute_awake_set.go:288-306`:

```go
case hasAgent && agent.SleepAfterIdle > 0:
    idleTimeout = agent.SleepAfterIdle
case isOnDemandSession(input.NamedSessions, bead):
    idleTimeout = defaultOnDemandIdleTimeout    // 5 * time.Minute (line 13)
```

So `on_demand` named sessions like aesthete/pragmatist/theorist/
devil **already have a 5-minute idle-sleep default** with no config.
`sleep_after_idle = "5m"` is redundant; `"1m"` would park them
faster.

### 5.3 Important caveat for the dispatcher
The control-dispatcher itself is `mode = "always"`
(`config.go:2386, 2398`). At
`compute_awake_set.go:290-291`:

```go
if decision.ShouldWake && ... && !isAlwaysNamedSession(input.NamedSessions, bead) {
```

— always-mode sessions are **exempt from idle-sleep**. And
validation at `config.go:2629-2633` rejects `sleep_after_idle` on
mode-always templates. **You cannot park the dispatcher.**

### 5.4 Recommendation for conversational seats
Aesthete/pragmatist/theorist/devil are already on_demand and
auto-sleep at 5min. They don't poll bd themselves — only their
control-dispatcher does. Tightening their sleep doesn't help dolt.

---

## Q6 — Practical recommendation

### 6.1 What's actually loading dolt
Steady-state load = **bd subprocess fan-out from each running
control-dispatcher**, ~6–10 `bd ready` calls every 30s per
dispatcher. Each call: spawn `bd` process → TCP+auth to dolt sql-
server → query → close.

### 6.2 Current city shape
`city.toml` has `library` and `research` rigs marked
`suspended = true`. Suspended-rig agents are skipped in
`build_desired_state.go:241-243`:

```go
if rigName != "" && suspendedRigPaths[filepath.Clean(rigRootForName(...))] {
    continue
}
```

So **only the city control-dispatcher should be running**. If three
dispatchers are still running, `bd list --json` on the supervisor's
session beads will show it; if only one is running you're already
at the floor for *this* lever.

### 6.3 The biggest remaining lever
Shadow the implicit dispatcher with a custom-`work_query` agent.
Add to `pack.toml`:

```toml
[[agent]]
name = "control-dispatcher"
description = "Built-in deterministic graph.v2 workflow control worker"
start_command = "sh -c 'export GC_WORKFLOW_TRACE=\"${GC_WORKFLOW_TRACE:-${GC_CITY}/control-dispatcher-trace.log}\"; exec \"${GC_BIN:-gc}\" convoy control --serve --follow control-dispatcher'"
max_active_sessions = 1
work_query = "bd ready --metadata-field gc.routed_to=control-dispatcher --unassigned --json --limit=20"
```

Effect: drains call **1 `bd` process** instead of 6–10. ~6× fewer
bd-spawns/dolt-connections. (Drop the `--assignee=...` tiers if
you're confident no work in this city is `bd assign`-routed —
your slings always write `gc.routed_to`.)

Caveat: this loses the legacy `workflow-control` fallback. If any
ancient bead in the city has `gc.routed_to=workflow-control`, it
will not be picked up. `grep gc.routed_to=workflow-control` in
your bead store first to verify.

### 6.4 What `patrol_interval = "5m"` already buys you
The reconciler tick (separate from the dispatcher) drops from
30s→5m. The reconciler runs `scale_check` per pool agent
(`build_desired_state.go:79-124`); your config has *no pool
agents* (everything is on_demand named_session), so this wasn't
heavy anyway. The win is real but small.

### 6.5 What you cannot fix without a code change
The dispatcher's 30s `workflowServeMaxIdleSleep` cap is hardcoded.
Bumping it to e.g. 5m is a 1-line patch at
`cmd/gc/dispatch_runtime.go:78`. If you control your gas-city
build, this is the single biggest dolt-CPU lever — it cuts poll
frequency 10×. Combined with the custom work_query (~6×), you'd
see roughly 60× fewer bd→dolt connections — well under 5%.

### 6.6 Summary
Config-only floor: shadow `[[agent]]` above (~6× fewer bd-spawns
per drain). If 28–38% drops to 5–7%, that's the floor without
patching `dispatch_runtime.go:78`.

### 6.7 Open questions
- `<city>/.gc/events.jsonl` is read by each dispatcher's `Watch()`;
  I didn't measure read amplification at higher agent counts (would
  show as I/O, not dolt CPU).
- `probe_concurrency` (default 8, `config.go:1358`) is irrelevant
  here — you have no pool agents.

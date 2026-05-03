# pc-frro — How should `gc` wake mayor when seats finish?

> Researcher answer for `pc-frro (mayor-wake architecture for batch
> seat-close)`. All citations are paths inside the cloned
> `gastownhall/gascity` source unless otherwise noted (resolved via
> `ghq` to `/git/github.com/gastownhall/gascity/`).

## TL;DR

1. `gc session nudge mayor "..."` is the right primitive for waking a
   resident mayor session. It types text into mayor's tmux pane, which
   Claude reads as a user-prompt — that fires mayor's
   `UserPromptSubmit` hooks (`gc nudge drain --inject`, `gc mail check
   --inject`) and resumes the conversation. **Nudge content does end up
   driving UserPromptSubmit.**
2. `gc hook --inject` is a documented no-op left in for compatibility;
   the modern claim protocol fires at *SessionStart*, not Stop. Stop
   hooks have no special "exit-2 / blocking-stop" semantics in this
   codebase.
3. `gc mail send mayor "..."` *does not* wake mayor on its own. Only
   `gc mail send --notify mayor "..."` (or `--all` with `notify`)
   triggers a nudge; otherwise the bead lands in mayor's inbox and is
   only drained the next time mayor's pane receives a user-prompt.
4. The `control-dispatcher` session is a deterministic worker for
   graph.v2 / formula control beads (`check`, `fanout`, `retry-eval`,
   `retry`, `ralph`, `workflow-finalize`). It does **not** observe seat
   `bead.closed` events to nudge mayor. Wrong tool for this job.
5. **Recommended architecture:** drop a city-local `event`-triggered
   exec order at `philosophy-city/orders/forum-round-watcher.toml`. The
   controller fires it on every `bead.closed`; the script reads round
   metadata from the closed bead, counts how many seats remain, and
   only `gc session nudge mayor` when the round is complete. **No new
   agent required, no LLM cost, no upstream PR.** A future v2
   "assistant" agent is sketched at the end if shell logic outgrows
   what's reasonable to keep there.

---

## 1a. Nudge mechanism (what `gc session nudge` does under the hood)

### Entry point

`gc session nudge <id-or-alias> <message>` is wired in
`cmd/gc/cmd_session.go:1507-1535` (`newSessionNudgeCmd`). It dispatches
to `cmdSessionNudge` (`cmd/gc/cmd_session.go:1619-1630`), which
resolves the target and calls `deliverSessionNudge`
(`cmd/gc/cmd_nudge.go:482-489`).

The default delivery mode is **wait-idle** (line 1533: `--delivery`
default `string(nudgeDeliveryWaitIdle)`); other modes are `immediate`
and `queue`.

### Wait-idle path (the common case)

`deliverSessionNudgeWithWorker` (`cmd/gc/cmd_nudge.go:491-519`) calls
`worker.Handle.Nudge(ctx, NudgeRequest{Text, Delivery, Source})`. For
the tmux provider this lands in
`internal/runtime/tmux/adapter.go:334-346`:

```go
// Nudge sends a message to the named session to wake or redirect the agent.
// By default, waits for the agent to be idle before sending (wait-idle mode)
// to avoid interrupting active tool calls. If the agent doesn't become idle
// within NudgeIdleTimeout, sends immediately as a fallback.
func (p *Provider) Nudge(name string, content []runtime.ContentBlock) error {
    if idleTimeout := p.tm.cfg.NudgeIdleTimeout; idleTimeout > 0 {
        _ = p.tm.WaitForIdle(context.Background(), name, idleTimeout)
    }
    return p.NudgeNow(name, content)
}
```

`NudgeNow` (`internal/runtime/tmux/adapter.go:349-387`) ultimately
calls `tm.NudgeSession(name, message)` — `tmux send-keys` against the
session's input. **From Claude's point of view this is identical to a
user typing into the terminal.** Hence `UserPromptSubmit` hooks fire
afterward, draining the queues:

```
.gc/settings.json (Stop hook):     gc hook --inject              ← no-op
.gc/settings.json (UserPromptSubmit): gc nudge drain --inject    ← drains queue
                                       gc mail check --inject    ← drains mail
```

(See `philosophy-city/.gc/settings.json:26-50`. The tail injects any
**queued** nudges as additional context; the typed nudge itself
already arrived in-band.)

### Queued path (when the recipient is asleep / not running)

`queueSessionNudgeWithWorker` (`cmd/gc/cmd_nudge.go:548-558`) writes a
`queuedNudge` record and starts a background **nudge poller** if the
session is running. The poller is launched at SessionStart by `gc
prime --hook` via `maybeStartNudgePoller` (`cmd/gc/cmd_prime.go:262`)
→ `ensureNudgePoller` (`cmd/gc/cmd_nudge.go:932-957`), which spawns
`gc nudge poll --city <path> --session <name> <agent>` (line 942).
That child runs the loop in `cmdNudgePoll` (`cmd/gc/cmd_nudge.go:400-468`):
observe the target every `interval`, attempt to deliver any queued
items, exit when no work remains within the startup grace.

`gc nudge drain --inject` (the UserPromptSubmit hook,
`cmd/gc/cmd_nudge.go:289-391`) reads claimed queued nudges, formats
them via `writeProviderHookContextForEvent(stdout, "",
"UserPromptSubmit", out)` (line 367), which for Claude is just raw
stdout. Claude Code treats Stop / UserPromptSubmit stdout as
*additional context* injected into the conversation.

**Bottom line:** `gc session nudge mayor "X"` ⇒ tmux send-keys ⇒
Claude reads "X" as a user prompt ⇒ UserPromptSubmit hooks drain any
piled-up nudges/mail as additional context ⇒ mayor responds.

## 1b. Stop-hook semantics (`gc hook` vs `gc hook --inject`)

### `gc hook --inject`

`cmd/gc/cmd_hook.go:53-56`:

```go
func cmdHookWithFormat(args []string, inject bool, hookFormat string,
    stdout, stderr io.Writer) int {
    if inject {
        return 0
    }
    ...
}
```

Unconditional `return 0`. **Pure no-op.** Documented at
`cmd/gc/cmd_hook.go:27`: *"With `--inject`: silent legacy Stop-hook
compatibility; skips the work query and always exits 0."*

This is what mayor's `philosophy-city/.gc/settings.json:30` runs.

### `gc hook` (no flag)

Same file, lines 53-159 + 217-241 (`doHook`). Resolves the agent
identity, expands the agent's `EffectiveWorkQuery()`
(`internal/config/config.go:1887-1956` — the standard 3-tier query
when no `work_query` is set), runs it under the right rig/scope env
(`controllerWorkQueryEnv`,
`cmd/gc/work_query_probe.go:48-74`), and:

* Prints the raw query stdout (line 239).
* Returns 0 when the result decodes to a non-empty array / when the
  raw output is non-empty and not the literal "No ready work found"
  (line 243-264).
* Returns 1 otherwise (line 238).

**There is no exit-code-2 / blocking-stop behavior in gascity.** The
only `decision: "block"` payload in the codebase is the *codex*-format
Stop wrapper (`cmd/gc/hook_output.go:32-40`); there is no equivalent
for Claude. `gc hook` just shells stdout out — Claude Code by default
ignores Stop-hook stdout unless the script returns 2 with a specific
JSON shape, which gascity never emits.

### `work_query` field in pack/agent.toml

Defined on `config.Agent.WorkQuery` (`internal/config/config.go:1689`,
toml tag `work_query`). When unset, `EffectiveWorkQuery()` falls back
to the built-in 3-tier shell pipeline:

```
Tier 1: bd list --status in_progress --assignee=<id>   (crash recovery)
Tier 2: bd ready --assignee=<id>                       (pre-assigned)
Tier 3: bd ready --metadata-field gc.routed_to=<target> --unassigned
        (only fires for ephemeral / no-session-context probes)
```

(`internal/config/config.go:1897-1955`). The same query is invoked by
the controller's reconciler probe (`cmd/gc/build_desired_state.go:380-385`)
to decide whether a session should be **woken** because work is
available — that's the controller-side `WorkSet` that drives
`ComputeAwakeSet` (`cmd/gc/compute_awake_set.go:91`) and ultimately
the `WakeWork` reason (`cmd/gc/compute_awake_bridge.go:153`).

### How the modern claim protocol actually delivers work

The legacy "Stop hook injects work" pattern is gone. Per the
upstream tutorial `docs/tutorials/06-beads.md:387`:

> The legacy Stop-hook form, `gc hook --inject`, is silent
> compatibility behavior and **no longer injects work into the agent**.

Today the claim protocol is rendered into the **SessionStart**
prompt:

* SessionStart hook (`philosophy-city/.gc/settings.json:15-25`) runs
  `gc prime --hook`.
* `gc prime --hook` (`cmd/gc/cmd_prime.go:130-322`) loads the agent's
  `prompt_template`, expands it with rig context, prints it as
  additional context, and (line 262) starts the nudge poller for the
  session.
* The prompt template itself is what tells the agent to run `gc bd
  list --assignee=$GC_ALIAS --status=in_progress` etc. (e.g.
  `examples/gastown/packs/gastown/agents/deacon/prompt.template.md:60-72`).

So `gc hook` lives only as: (a) a controller probe for "is there
demand?", and (b) a CLI helper an agent can call to ask "do I have
work?". It is **not** a wake mechanism.

## 1c. Mail delivery (`gc mail send mayor ...`)

Entry point: `cmd/gc/cmd_mail.go:1047-1091` (`doMailSend`).

```go
m, err := mp.Send(sender, to, subject, body)
...
fmt.Fprintf(stdout, "Sent message %s to %s\n", m.ID, to)

// Nudge recipient if requested and recipient is not human.
if nudgeFn != nil && to != "human" {
    if err := nudgeFn(to); err != nil { ... }
}
```

`nudgeFn` is **only** non-nil when the user passes `--notify`
(`cmd/gc/cmd_mail.go:1001-1004`):

```go
var nf nudgeFunc
if notify && store != nil {
    nf = newMailNudgeFunc(sender)
}
```

`newMailNudgeFunc` (`cmd/gc/cmd_mail.go:28-36`) calls `sendMailNotify`
(`cmd/gc/cmd_nudge.go:560-565`), which is the same nudge path as
`gc session nudge` but with text `"You have mail from <sender>"` and
`Source: "mail"`, `Wake: NudgeWakeLiveOnly`
(`cmd/gc/cmd_nudge.go:572-605`).

**Without `--notify`, `gc mail send mayor "..."` does nothing to
mayor's session.** The bead is created; mayor will only see it the
next time their pane runs UserPromptSubmit (because `gc mail check
--inject` only fires there). For an idle mayor, that means "never,
until something else nudges or the human types."

Practical implication: don't rely on `gc mail send mayor` to wake
mayor. Either:

* Use `gc mail send --notify mayor "..."`, **or**
* Use `gc session nudge mayor "..."` directly (and skip mail entirely
  if the message is short-lived).

## 1d. The control-dispatcher session

The control-dispatcher is an *implicit, built-in* agent injected by
`injectControlDispatcherAgents` (`internal/config/config.go:2189`,
referenced at line 2189 of `internal/config/config.go`; constants at
lines 31-39). Its `start_command` is

```sh
gc convoy control --serve --follow control-dispatcher
```

(`internal/config/config.go:38`). That command lands in
`cmd/gc/cmd_convoy_dispatch.go:51-83` (`newConvoyControlCmd`) →
`runConvoyControlServe` (`cmd/gc/dispatch_runtime.go:104-115`) →
`runWorkflowServe` (`cmd/gc/dispatch_runtime.go:158-199`).

The serve loop polls the agent's work query and, for each ready bead,
invokes `runControlDispatcherWithStore`
(`cmd/gc/cmd_convoy_dispatch.go:160`). It dispatches **only**
formula/graph control beads (`cmd/gc/cmd_convoy_dispatch.go:164-169`):

```go
switch bead.Metadata["gc.kind"] {
case "check", "fanout", "retry-eval", "retry", "ralph":
    loadCfg = true
case "workflow-finalize":
    ...
}
```

`pc-x9v` is therefore a deterministic Go worker for graph.v2 control
flow. **It does not subscribe to `bead.closed`** for arbitrary beads,
does not know what a "forum round" is, and is the wrong place to add
seat-batch detection. Co-opting it would mean an upstream PR + a new
`gc.kind`.

## 2. Watcher / assistant precedents in the source

### a. The deacon agent (closest precedent)

`examples/gastown/packs/gastown/agents/deacon/prompt.template.md`
defines a city-scoped, always-on LLM "sidekick to the controller." It
runs the formula `mol-deacon-patrol`
(`examples/gastown/packs/gastown/formulas/mol-deacon-patrol.toml`),
which is a self-pouring loop where each iteration:

1. Checks mail.
2. Performs town-wide health checks.
3. Pours the next wisp.
4. **Long-polls the event bus**
   (`mol-deacon-patrol.toml:347-355`):

   ```sh
   SEQ=$(gc events --seq)
   gc events --watch --type=bead.updated --after=$SEQ --timeout 30s
   ```

5. Burns this wisp; new wisp re-reads the formula from the top.

This is the precedent for an "assistant agent that observes other
agents' state." It exists upstream and has been load-tested. We don't
have it in `philosophy-city` (no deacon / witness in
`pack.toml:5-94`); we'd have to bring one in.

Cost: another always-on Claude session per city. With the seat traffic
volume in this city (sub-daily rounds), that's a real ongoing cost
(API tokens + Dolt activity from the patrol loop). Not free.

### b. The Event Bus + `gc events --watch` primitive

`engdocs/architecture/event-bus.md` documents an append-only JSONL
event log at `.gc/events.jsonl` with a Watch API. Event types include
`bead.closed`, `bead.created`, `mail.sent`, `session.idle_killed`
(`internal/events/events.go:19-72`). Anything that closes a bead
records one of these events.

The CLI surface is `gc events` (`cmd/gc/cmd_events.go:120-184`):

* `gc events --seq` — current head cursor.
* `gc events --watch --type bead.closed --timeout 30s` — block until a
  matching event arrives or timeout.
* `gc events --follow --type bead.closed` — continuous stream (one
  line per event, JSONL).

Either can drive a watcher loop without writing Go.

### c. Orders (declarative event-trigger dispatch)

`engdocs/architecture/orders.md` + `internal/orders/order.go`. Orders
live as `<root>/orders/<name>.toml` (or `<root>/orders/<name>/order.toml`).
Triggers: `cooldown`, `cron`, `condition`, `event`, `manual`. Actions:
`exec` (shell script run by the controller, default 60s timeout) or
`formula` (instantiate a wisp).

The `event` trigger
(`internal/orders/triggers.go:175-196`):

```go
matched, err := ep.List(events.Filter{
    Type:     a.On,
    AfterSeq: cursor,
})
if len(matched) == 0 {
    return TriggerResult{Due: false, ...}
}
return TriggerResult{Due: true, ...}
```

Fires once whenever there are any new events of `a.On` type since the
last cursor; advances the cursor on completion.

City-local orders are picked up automatically by
`cityOrderRoots` (`cmd/gc/cmd_order.go:243-277`) which scans
`citylayout.OrdersPath(cityRoot)` =
`<cityRoot>/orders/`
(`internal/citylayout/layout.go:78-79`). **No registration step
beyond dropping a TOML file.**

Combined: an `event` order on `bead.closed` whose `exec` is a
short shell script can replace an entire watcher agent for the
narrow "did the round finish" question.

## 3. Recommended architecture

> **Constraint check:**
> * Mayor woken once per *batch*, not per individual close. ✓ (script
>   gates the nudge).
> * No spurious nudges from unrelated bead closures. ✓ (filter on
>   round metadata).
> * Implementable today with config alone. ✓ (no upstream PR; uses
>   existing order + nudge primitives).
> * Bonus state surfacing (failed beads, stuck sessions, mail
>   backlog). Partial — order shell can grep, but ambiguous /
>   judgment-style state surfacing wants the v2 "assistant" agent
>   sketched below.

### 3a. Phase 1 — declarative order, zero new agent

Create `philosophy-city/orders/forum-round-watcher.toml`. To keep the
shell readable inside TOML (and avoid the `'`-inside-`'` trap), keep
the script in a separate file under the order's discovered directory,
and call it from `exec`:

```toml
# philosophy-city/orders/forum-round-watcher.toml
[order]
description = "When all forum-round seats have closed for a round, nudge mayor."
trigger     = "event"
on          = "bead.closed"
exec        = "sh ${ORDER_DIR}/run.sh"
timeout     = "30s"
```

`ORDER_DIR` is exported by the controller into the order's exec env
(it's the directory containing the order TOML file). To use it, place
the order in a subdirectory rather than a flat file:

```
philosophy-city/orders/forum-round-watcher/
├── order.toml         # the [order] block above (tweak Source path)
└── run.sh             # the script below
```

The fallback subdirectory layout is supported by `discoverRoot`
(`internal/orders/discovery_test.go:50-79`) — it logs a "rename to
flat" warning but works. If we want to stick with flat, we can hard-
code the script path: `exec = "sh philosophy-city/orders/forum-round-watcher.sh"`
since orders run with the city as cwd
(`internal/citylayout/layout.go` + `cmd/gc/order_dispatch.go`).

`run.sh` (illustrative — refine when implementing):

```sh
#!/bin/sh
set -eu
: "${GC_CITY:?missing}"
cd "$GC_CITY"

# Find the active round-marker bead. Convention: it is the unique open
# bead tagged with the literal label "forum-round-active". Mayor sets
# its `round` metadata to the round number when slinging.
MARKER=$(bd list --status open --label forum-round-active --json --limit=1)
[ "$MARKER" = "[]" ] && exit 0
ROUND=$(printf "%s" "$MARKER" | jq -r '.[0].metadata.round // empty')
[ -z "$ROUND" ] && exit 0

# Count open seat-reply beads for this round. Convention: each seat
# reply is tagged kind:seat-reply and has metadata round=<N>.
REMAINING=$(bd list --status open --label kind:seat-reply \
              --metadata-field "round=$ROUND" --json | jq 'length')
[ "$REMAINING" -gt 0 ] && exit 0

# Idempotency: only nudge once per round.
marker_file=".gc/tmp/forum-round-${ROUND}-mayor-nudged"
[ -f "$marker_file" ] && exit 0
mkdir -p "$(dirname "$marker_file")"
: > "$marker_file"

gc session nudge mayor "Forum round ${ROUND}: all seats closed. Pour synthesis."
```

(Verify `bd list --metadata-field key=value` is the right invocation —
the work_query in `internal/config/config.go:1916` uses
`bd ready --metadata-field gc.routed_to=...`, so the syntax exists; we
just need to confirm `--metadata-field` works on `bd list` too. If
not, drop down to `bd list --label kind:seat-reply --status open
--json | jq '[.[] | select(.metadata.round == "'"$ROUND"'")] | length'`.)

#### Conventions that need to exist for this to work

This requires mayor (and any other entrypoint that creates a forum
round) to label and tag the beads consistently. The bd CLI uses
`--labels foo,bar` for `bd create` and `--metadata '<json>'`, vs.
`--add-label`, `--set-metadata key=value`, etc. for `bd update`
(verified against `bd create --help` / `bd update --help`).

Concretely, when mayor opens round N:

```sh
# 1. Round-marker bead. One per round. The label `forum-round-active`
#    is what the watcher looks for; the metadata key `round` carries
#    the number.
RID=$(bd create --type task --title "Forum round $N — active" \
        --labels forum-round-active \
        --metadata "{\"round\":\"$N\"}" \
        --json | jq -r '.id')

# 2. Seat-reply beads — one per seat.
for seat in satya viveka dharma prayoga rasa; do
  bd create --type task --title "Round $N: $seat reply" \
    --labels kind:seat-reply \
    --metadata "{\"gc.routed_to\":\"$seat\",\"round\":\"$N\"}"
done
```

When the round closes (after mayor consumes the synthesis prompt):

```sh
bd close $RID                                       # removes forum-round-active from open set
rm -f .gc/tmp/forum-round-${N}-mayor-nudged
```

This convention is the only "wire" needed; everything else is
existing primitives.

#### What the user sees

* Each seat closes its bead → controller fires the order → script
  finds seats still open → exits silently (no nudge).
* Last seat closes → script finds 0 remaining → writes idempotency
  marker → calls `gc session nudge mayor "..."` → tmux send-keys
  delivers the message → mayor's UserPromptSubmit hooks drain queues
  → mayor responds.

#### Risks

* **Convention drift.** If a seat-reply is created without the
  `round:<N>` and `kind:seat-reply` labels, it won't count and the
  nudge fires early. Add a smoke test on mayor's round-pour script
  that re-greps the labels post-create.
* **Round-marker hygiene.** If mayor forgets to close the round-marker
  bead before pouring round N+1 (or to remove the idempotency marker
  file), the order will think "round N is still active" and never
  nudge. Make round-pour an idempotent shell helper.
* **Order tick latency.** `gc events --watch` is real-time, but the
  order *dispatcher* polls on each controller patrol tick, which is
  `patrol_interval = "30s"` in `philosophy-city/city.toml:7`. So the
  nudge is delayed up to 30 s after the final close. Acceptable.
* **Exec timeout.** Default is 60 s; this script finishes in under a
  second (a couple of `bd list`s + maybe `gc session nudge`). Setting
  `timeout = "30s"` gives margin while still erroring fast on a
  pathological hang.
* **Order failure obscurity.** Order exec failures emit
  `events.OrderFailed` (`internal/events/events.go:60`) but otherwise
  don't surface to mayor. If the script fails silently, no one
  notices. Mitigation: log to `${GC_CITY}/orders.log` from the script
  when it nudges, so we can audit.
* **No automatic backoff on shell errors.** If `bd list` errors mid-
  flight, the order will fire again on the next `bead.closed`. That's
  fine for our case but could thrash if `bd` is wedged.

#### Bonus: surface other state

The same order pattern can spawn *additional* orders without entangling
the round logic:

* `orders/mail-backlog-watch.toml` — `trigger = "cron"`,
  `schedule = "0 */6 * * *"`, exec checks `bd list --type message
  --metadata-field to=mayor --status open` and nudges if backlog > 0.
* `orders/stuck-seat-detect.toml` — `trigger = "cron"`,
  `schedule = "*/15 * * * *"`, exec finds `bd list --status
  in_progress --label kind:seat-reply` older than 60 min, nudges
  mayor with the IDs.

Each is a < 30-line TOML file, no LLM, no new agent.

### 3b. Phase 2 — assistant agent (only if shell becomes hairy)

If we accumulate orders to the point that the shell scripts duplicate
each other or need judgment ("is this seat *actually* stuck or just
slow because of an external API rate limit?"), promote the watcher to
an LLM agent. Sketch:

```toml
# pack.toml addition
[[agent]]
name            = "assistant"
prompt_template = "agents/assistant/prompt.template.md"
provider        = "claude"
work_query = """sh -c '
  bd ready --assignee=\\"$GC_ALIAS\\" --json --limit=1 2>/dev/null
'"""
[agent.option_defaults]
effort = "low"   # cheap: assistant is mostly grep + nudge

[[named_session]]
template = "assistant"
mode     = "always"
```

Trigger for the assistant: a thin order whose exec **creates** an
assistant work bead on every `bead.closed` (instead of doing the
batching itself):

```toml
[order]
trigger = "event"
on      = "bead.closed"
exec    = """sh -c '
  bd create --type task --title \\"Inspect: $(date -Iseconds)\\" \\
    --assignee assistant --priority 3 \\
    --label kind:assistant-tick
'"""
```

The assistant wakes (controller's `WakeWork` reason fires because
`bd ready --assignee=assistant` returns non-empty), reads the recent
event log via `gc events --watch --type bead.closed --after $SEQ
--timeout 5s` (or `gc events --follow`), checks round state, and
nudges mayor when appropriate. The assistant's own work bead is
closed at the end of each iteration — same self-pouring pattern as
`mol-deacon-patrol` but city-shaped to our 5-seat forum.

Costs vs. Phase 1:

| | Phase 1 (order)              | Phase 2 (assistant) |
|---|---|---|
| Always-on sessions | 0                            | +1 Claude session |
| Wake latency       | ≤ patrol_interval (30 s)     | ≤ patrol_interval + assistant boot (~few s) |
| Judgment           | shell-grep only              | full LLM |
| Failure visibility | order events only            | mayor mail / nudge from assistant |
| Implementation     | one TOML file                | agent dir + prompt + order + supporting bead conventions |

Stay in Phase 1 until something concretely demands Phase 2.

### 3c. Required edits for Phase 1

| Path | Change |
|---|---|
| `philosophy-city/orders/forum-round-watcher.toml` | **NEW.** As above. |
| `philosophy-city/agents/mayor/prompt.template.md` | Document the round-marker / seat-reply labeling convention; ensure mayor uses it when slinging seats. |
| `philosophy-city/agents/{satya,viveka,dharma,prayoga,rasa}/prompt.template.md` | No change needed if seats already close their assigned beads. They don't need to know about the order. |
| `philosophy-city/.gc/settings.json` | No change. Existing `Stop = gc hook --inject` and UserPromptSubmit hooks are correct. |
| `philosophy-city/pack.toml` | No change for Phase 1. |

### 3d. What needs an upstream PR vs. is doable today

Doable today, no PR:

* The order + exec script (uses public `gc events`, `gc session
  nudge`, `bd` CLI surfaces).
* All the convention work (labels, round markers).
* Phase 2's optional `assistant` agent.

Would only need an upstream PR if we wanted:

* A native "batch complete" trigger type
  (`trigger = "batch"` with a count threshold), so we wouldn't need to
  encode the count in shell. **Not worth it.** The shell script is 8
  lines of `bd list | jq length` and makes the convention explicit.
* `gc hook` Stop-hook exit-2 / `decision: block` for Claude (which
  would make Stop hooks symmetric to the codex variant at
  `cmd/gc/hook_output.go:33`). **Also not needed for our case** —
  resident-mayor + nudge does the same work without changing Stop
  semantics.

---

## Appendix: file/line citations

Primary citations referenced above:

* `cmd/gc/cmd_hook.go:18-44` — `newHookCmd`, `--inject` flag.
* `cmd/gc/cmd_hook.go:53-159` — `cmdHookWithFormat`; agent resolution + env.
* `cmd/gc/cmd_hook.go:217-264` — `doHook`, `workQueryHasReadyWork`.
* `cmd/gc/cmd_session.go:1507-1535` — `newSessionNudgeCmd`.
* `cmd/gc/cmd_session.go:1619-1630` — `cmdSessionNudge`.
* `cmd/gc/cmd_nudge.go:159-225` — `newNudgeDrainCmd`, `newNudgePollCmd`.
* `cmd/gc/cmd_nudge.go:289-391` — `cmdNudgeDrainWithFormat`.
* `cmd/gc/cmd_nudge.go:400-468` — `cmdNudgePoll`.
* `cmd/gc/cmd_nudge.go:482-558` — `deliverSessionNudge*`,
  `queueSessionNudgeWithWorker`.
* `cmd/gc/cmd_nudge.go:560-605` — `sendMailNotify*`.
* `cmd/gc/cmd_nudge.go:814-957` — `maybeStartNudgePoller`,
  `ensureNudgePoller`.
* `cmd/gc/cmd_mail.go:23-36` — `nudgeFunc`, `newMailNudgeFunc`.
* `cmd/gc/cmd_mail.go:1001-1091` — mail send flow / nudgeFn gating.
* `cmd/gc/cmd_prime.go:130-322` — `gc prime --hook` flow,
  `maybeStartNudgePoller` invocation at line 262.
* `cmd/gc/cmd_convoy_dispatch.go:51-83` — `newConvoyControlCmd`,
  `--serve --follow` semantics.
* `cmd/gc/cmd_convoy_dispatch.go:160-200` —
  `runControlDispatcherWithStore`; control-bead kinds.
* `cmd/gc/dispatch_runtime.go:104-199` — `runConvoyControlServe`,
  `runWorkflowServe`.
* `cmd/gc/cmd_events.go:120-184` — `gc events` command surface.
* `cmd/gc/cmd_order.go:243-288` — city/rig order scan roots.
* `cmd/gc/build_desired_state.go:380-387` — controller-side work_query
  probing.
* `internal/runtime/tmux/adapter.go:320-387` — tmux Provider.Nudge,
  NudgeNow.
* `internal/config/config.go:30-45` — control-dispatcher constants.
* `internal/config/config.go:1689-1956` — Agent.WorkQuery field;
  EffectiveWorkQuery 3-tier shell.
* `internal/orders/order.go` — Order struct (Trigger, On, Exec, etc.).
* `internal/orders/triggers.go:60, 148-196` — `event` trigger eval.
* `internal/citylayout/layout.go:19, 78-79` — `OrdersRoot`,
  `OrdersPath`.
* `internal/events/events.go:19-72` — KnownEventTypes incl.
  `bead.closed`.
* `internal/hooks/hooks.go:198-212`, `internal/hooks/config/claude.json` —
  Claude provider hook installer + canonical defaults.
* `engdocs/architecture/event-bus.md` — Event Bus design.
* `engdocs/architecture/orders.md` — Orders design.
* `examples/gastown/packs/gastown/agents/deacon/prompt.template.md` — deacon role.
* `examples/gastown/packs/gastown/formulas/mol-deacon-patrol.toml:347-355` —
  `gc events --watch` long-poll.
* `docs/tutorials/06-beads.md:382-413` — modern claim protocol;
  legacy Stop-hook behavior.

City-side citations:

* `philosophy-city/.gc/settings.json:26-50` — Stop +
  UserPromptSubmit hooks.
* `philosophy-city/city.toml:7` — `patrol_interval = "30s"`.
* `philosophy-city/pack.toml:5-94` — agents (mayor, 5 seats,
  librarian, researcher) + named_session modes.

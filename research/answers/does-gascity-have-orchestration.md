# cr-t5r5wr (convoy/control-dispatcher orchestration research)

## Verdict

**Verdict: (b) Gas City has a built-in orchestration/control primitive, but it is incomplete for Criopolis' current arbitrary cascade metadata.** The built-in primitive is the graph.v2 workflow/control lane: formulas compile into graph recipes, graph routing assigns control beads to `control-dispatcher`, and `gc convoy control --serve --follow control-dispatcher` runs a resident deterministic dispatcher over those control beads. `/git/github.com/gastownhall/gascity/internal/formula/compile.go:155-177`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:398-471`, `/git/github.com/gastownhall/gascity/internal/config/config.go:2368-2420`, `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:104-115`

That lane is **not** a general "when any bead closes, read `cascade_next` and sling the next bead" orchestrator. `ProcessControl` only accepts the built-in control kinds `retry`, `ralph`, `check`, `retry-eval`, `fanout`, `scope-check`, and `workflow-finalize`; unsupported `gc.kind` values error. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:53-62`

So Gas City already has the durable loop shape Criopolis wanted, but only for graph.v2 formula workflows. Criopolis can drop most custom orchestration code only if its cascades are rewritten as graph.v2 formulas or bridged into graph.v2 control beads; for the existing `cascade_id` / `cascade_next` / `cascade_final` metadata chain, the missing policy layer still has to exist somewhere. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`, `/home/li/Criopolis/_intake/reports/orchestrator-design-v3.md:54-76`

## What A Convoy Is

The `gc convoy` command describes convoys as "graphs of related work beads"; it says simple convoys are parent-child bead collections and complex convoys are formula-compiled DAGs with control beads. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:20-28`

The simple data model is a bead with `Type: "convoy"` plus child beads whose `ParentID` is the convoy bead id. The create path constructs a `beads.Bead{Title: name, Type: "convoy"}`, and the add/link path sets each child's parent id to that convoy id. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:167-185`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:199-219`, `/git/github.com/gastownhall/gascity/internal/convoy/convoy.go:41-64`

Convoy progress is computed by listing beads with `ParentID == convoyID`, counting closed children, and treating the convoy as complete only when all children are closed. `/git/github.com/gastownhall/gascity/internal/convoy/convoy.go:76-108`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:522-588`

Simple convoy closing is mostly lifecycle bookkeeping. `gc convoy check` scans open convoy beads, skips owned convoys, and auto-closes a convoy when all children are closed. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:789-878`

The close hook also invokes `gc convoy autoclose "$1"` whenever a bead closes, and that helper closes an open non-owned parent convoy only after all siblings are closed. `/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:34-53`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:1088-1176`

`gc sling` may create a simple parent convoy automatically while routing work: `finalize` creates a `Type: "convoy"` parent and links the routed bead unless `--no-convoy` was passed. `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:327-424`, `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:367-408`

When an operator slings an existing convoy, `DoSlingBatch` recognizes the convoy container, lists open children by `ParentID`, and routes each open child; closed or non-open children are skipped. `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:817-887`, `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:953-1070`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:700-727`

The important distinction is that simple convoys group and auto-close work; graph.v2 formulas provide the DAG/control behavior. The source separates those paths: simple convoy code uses `Type: "convoy"` plus `ParentID`, while formula compilation and graph controls live in `internal/formula`, `internal/molecule`, `internal/graphroute`, and `internal/dispatch`. `/git/github.com/gastownhall/gascity/internal/convoy/convoy.go:41-108`, `/git/github.com/gastownhall/gascity/internal/formula/compile.go:22-34`, `/git/github.com/gastownhall/gascity/internal/formula/graph.go:21-111`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`

## What `gc convoy control --serve --follow <name>` Does

The CLI command is under `gc convoy control`. If either `--serve` or `--follow` is set, the command appends the optional positional name and calls `runConvoyControlServe`; without those flags it requires a control bead id and calls `runControlDispatcher`. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy_dispatch.go:51-83`

`runConvoyControlServe` is a thin entry point into the workflow/control serving runtime. It passes the optional agent name to `runWorkflowServe(agentName, true, ...)`, so `--follow <name>` becomes "serve the control lane as this agent/session name and keep following events." `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:104-115`

`runWorkflowServe` resolves the city and config, chooses an agent name from the CLI arg, environment, template, or default `control-dispatcher`, resolves the agent identity, prepares the work directory/environment/query, and then either drains once or enters the follow loop. `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:158-200`

The drain loop runs the configured work query, filters candidates to built-in control-dispatcher kinds, and processes one candidate at a time through `controlDispatcherServe`; it treats `dispatch.ErrControlPending` as a pending state rather than a hard failure. `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:207-282`

The default work query looks for work assigned to the current session id, session name, alias, or control target; it also looks for unassigned ready beads with `gc.routed_to=$GC_CONTROL_TARGET`; and it includes a legacy `workflow-control` fallback when applicable. `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:422-467`, `/git/github.com/gastownhall/gascity/internal/config/config.go:1887-1956`

The follow loop opens an event provider, starts watching from the latest sequence, drains ready control work, then sleeps until a relevant bead event or sweep interval. `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:294-344`

The relevant events for waking the control loop are exactly `bead.created`, `bead.closed`, and `bead.updated`. `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:404-411`

The per-bead processing call loads config for check, fanout, retry-eval, retry, ralph, and workflow-finalize options, then calls `dispatch.ProcessControl`, then prints `control dispatch: bead=... action=...`. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy_dispatch.go:160-225`

`dispatch.ProcessControl` is the canonical action switch. It skips non-open beads, reads `gc.kind`, and dispatches only the built-in control kinds `retry`, `ralph`, `check`, `retry-eval`, `fanout`, `scope-check`, and `workflow-finalize`. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`

Those actions are graph-workflow actions, not arbitrary cascade actions. Retry controls wait on attempts and spawn or close retry state; ralph controls run iterative checks; fanout controls compile and attach expansion fragments; workflow-finalize resolves blocker outcomes, closes the workflow root, and closes the source bead chain on success. `/git/github.com/gastownhall/gascity/internal/dispatch/control.go:20-124`, `/git/github.com/gastownhall/gascity/internal/dispatch/control.go:126-223`, `/git/github.com/gastownhall/gascity/internal/dispatch/fanout.go:21-177`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:502-556`

## What `control-dispatcher` Is

`control-dispatcher` is a built-in agent name, not a separately-authored local daemon. The config constants name it `ControlDispatcherAgentName = "control-dispatcher"` and set its start command to `gc convoy control --serve --follow <qualifiedName>` with workflow tracing enabled. `/git/github.com/gastownhall/gascity/internal/config/config.go:30-45`

`[daemon] formula_v2 = true` enables graph infrastructure: implicit `control-dispatcher` agents, graph.v2 formula compilation, and batch graph-apply support. `/git/github.com/gastownhall/gascity/internal/config/config.go:1313-1319`

When formula_v2 is enabled, config injection creates city-scoped and rig-scoped `control-dispatcher` agents and named sessions. Those sessions are configured with mode `always`, so the session reconciler is expected to keep them resident. `/git/github.com/gastownhall/gascity/internal/config/config.go:2177-2235`, `/git/github.com/gastownhall/gascity/internal/config/config.go:2368-2403`

The injected agent description is "Built-in deterministic graph.v2 workflow control worker"; its start command is the same `gc convoy control --serve --follow ...` command, and its maximum active session count is one. `/git/github.com/gastownhall/gascity/internal/config/config.go:2405-2420`

The generic session reconciler explains the process lifecycle: session beads are reconciled into running processes, named sessions are config-eligible when their mode is `always` or when they have active demand, and manual multi-session agent sessions stay alive. `/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1-8`, `/git/github.com/gastownhall/gascity/cmd/gc/session_reconcile.go:137-164`

The `gc nudge poll` process seen beside `control-dispatcher` is the ordinary nudge queue poller. It resolves a target session, acquires a lease, loops while running, claims due queued nudges, calls `handle.Nudge`, and acknowledges delivered nudges. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_nudge.go:211-231`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_nudge.go:400-468`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_nudge.go:729-787`

## Workflow Primitive Map

**Formula.** A formula is a high-level workflow template that compiles into proto beads; graph-only constructs such as ralph, retry, on-complete, and graph metadata require `contract = "graph.v2"`. `/git/github.com/gastownhall/gascity/internal/formula/types.go:1-9`, `/git/github.com/gastownhall/gascity/internal/formula/types.go:196-286`, `/git/github.com/gastownhall/gascity/internal/formula/types.go:882-976`

**Graph recipe.** Formula compilation applies retry and ralph transforms, applies graph controls, and emits a graph recipe whose root metadata includes `gc.kind=workflow` and `gc.formula_contract=graph.v2`. `/git/github.com/gastownhall/gascity/internal/formula/compile.go:155-177`, `/git/github.com/gastownhall/gascity/internal/formula/compile.go:235-303`

**Control beads.** `ApplyGraphControls` creates fanout controls, scope-check controls, and a workflow-finalize control; these controls carry `gc.kind` values that `ProcessControl` later accepts. `/git/github.com/gastownhall/gascity/internal/formula/graph.go:21-111`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`

**Molecule.** Molecules instantiate compiled recipes as beads, wire dependencies, keep graph steps unassigned until dependencies are wired, and support late-bound sub-DAG attachment. `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:1-7`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:196-216`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:356-363`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:389-550`

**Graph routing.** Graph routing stamps workflow metadata, skips topology-only kinds, assigns normal steps to execution routes, and assigns control steps directly to the control-dispatcher session. `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:1-4`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:136-184`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:398-527`

**Sling.** `gc sling` routes existing beads, inline text beads, and formula workflows; `--formula` instantiates a workflow root, `--on` attaches a formula to a bead, `--no-convoy` disables the automatic simple convoy parent, and graph workflows are promoted/routed through the graph workflow path. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:53-88`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:120-133`, `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:41-67`, `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:174-320`, `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:426-462`

**Order.** Orders are scheduled or event-driven dispatch declarations for formulas or scripts; their event trigger schema has an `on` event type and the runtime lists events by type and cursor. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_order.go:22-31`, `/git/github.com/gastownhall/gascity/internal/orders/order.go:13-52`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`

**Event stream.** The event API has `List`, `LatestSeq`, and `Watch`; the CLI exposes JSONL list/watch/follow with filters by type, sequence, and payload match. `/git/github.com/gastownhall/gascity/internal/events/events.go:99-136`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_events.go:110-183`

**Agent/session.** Agents and sessions are the process/lifecycle layer; `session new` creates a session bead, and the session reconciler turns session beads into running processes. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_session.go:34-72`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_session.go:140-145`, `/git/github.com/gastownhall/gascity/cmd/gc/session_reconciler.go:1-8`

**Nudge.** Nudges are wakeups delivered to existing sessions through a queue and poller; they are not the graph-control scheduler. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_nudge.go:156-170`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_nudge.go:400-468`, `/git/github.com/gastownhall/gascity/internal/nudgequeue/state.go:24-50`

## Does This Replace `LiGoldragon/orchestrator`?

It replaces a custom daemon only for workflows expressed as graph.v2 formulas. In that path, formula compilation creates the workflow/control beads, graph routing assigns control beads to `control-dispatcher`, `control-dispatcher` follows bead events, and `ProcessControl` mutates the graph deterministically. `/git/github.com/gastownhall/gascity/internal/formula/compile.go:155-177`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:398-527`, `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:294-344`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`

It does not directly replace a daemon whose policy is "watch `bead.closed`, read arbitrary cascade metadata, sling the next pre-created bead, and mail the mayor at the final step." The control dispatcher does not read `cascade_id`, `cascade_next`, or `cascade_final`; it reads `gc.kind` and runs the fixed graph-control switch. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/home/li/Criopolis/_intake/reports/orchestrator-design-v2.md:57-71`, `/home/li/Criopolis/_intake/reports/orchestrator-design-v3.md:54-76`

Orders also do not fully replace the custom daemon for that metadata policy. Event triggers filter by event type and cursor, while the order schema only requires an `on` event type for event orders; label or bead-metadata matching is not part of the trigger evaluation shown in source. `/git/github.com/gastownhall/gascity/internal/orders/order.go:13-52`, `/git/github.com/gastownhall/gascity/internal/orders/order.go:140-187`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`

The simple auto-convoy path also does not replace the custom daemon. It creates a parent convoy and auto-closes that parent after all children close; it does not evaluate a next-stage policy when one child closes. `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:367-408`, `/git/github.com/gastownhall/gascity/cmd/gc/cmd_convoy.go:1088-1176`

## Example Packs And Field Evidence

The official `github-intake` pack is already organized around `gc sling ... --on <formula>`: the service creates a fix bead, runs `gc sling <target> <bead> --on <formula>`, and the formula defines sequential work such as implementation, quality gate, and PR submission. `/git/github.com/gastownhall/gascity-packs/github-intake/scripts/github_intake_service.py:320-345`, `/git/github.com/gastownhall/gascity-packs/github-intake/formulas/mol-github-fix-issue.formula.toml:1-17`, `/git/github.com/gastownhall/gascity-packs/github-intake/formulas/mol-github-fix-issue.formula.toml:237-275`

The official `discord-intake` pack uses the same shape: an issue-fix formula attached to a bead, with implementation, quality pass, completion posting, lock release, and bead closure encoded in the formula. `/git/github.com/gastownhall/gascity-packs/discord-intake/formulas/mol-discord-fix-issue.formula.toml:1-17`, `/git/github.com/gastownhall/gascity-packs/discord-intake/formulas/mol-discord-fix-issue.formula.toml:230-271`

The third-party Kit exploration shows a non-graph workaround in the other direction: it routes review beads with `gc sling --no-formula`, uses steward prompt logic, and documents that default formulas materialized step beads with dependencies invisible to `bd ready` in that environment. `/git/github.com/bmt/gascity-explore/docs/pr-review-pipeline.md:84-125`, `/git/github.com/bmt/gascity-explore/docs/pr-review-pipeline.md:263-291`, `/git/github.com/bmt/gascity-explore/packs/kit/agents/steward/prompt.template.md:183-202`

Those packs support the same split as the code: formula-native workflows should go through native formulas/control-dispatcher, while bespoke operational policies may still be implemented as service or patrol logic around beads. `/git/github.com/gastownhall/gascity-packs/github-intake/scripts/github_intake_service.py:320-345`, `/git/github.com/bmt/gascity-explore/docs/pr-review-pipeline.md:242-291`

## Fork Check

The `LiGoldragon/gascity` fork has the same `gc convoy control` serve/follow command shape: `--serve` or `--follow` calls `runConvoyControlServe`, while direct invocation processes a single control bead. `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_convoy_dispatch.go:51-83`

The fork also has the same built-in `control-dispatcher` identity and start command, and formula_v2 still injects implicit control-dispatcher named sessions. `/git/github.com/LiGoldragon/gascity/internal/config/config.go:30-44`, `/git/github.com/LiGoldragon/gascity/internal/config/config.go:1211-1215`, `/git/github.com/LiGoldragon/gascity/internal/config/config.go:2251-2303`

The fork's serve loop still follows bead events and filters candidates to control kinds before processing them. `/git/github.com/LiGoldragon/gascity/cmd/gc/dispatch_runtime.go:137-178`, `/git/github.com/LiGoldragon/gascity/cmd/gc/dispatch_runtime.go:180-240`, `/git/github.com/LiGoldragon/gascity/cmd/gc/dispatch_runtime.go:243-323`

The fork's `ProcessControl` switch is still fixed to graph-control kinds, so the fork does not add a generic cascade metadata orchestrator. `/git/github.com/LiGoldragon/gascity/internal/dispatch/runtime.go:40-82`

One material upstream difference is workflow finalization. Upstream closes the successful source bead chain after closing the workflow root; the fork's finalizer closes the root and finalizer but does not include the upstream source-chain closure path in the cited finalizer. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:502-556`, `/git/github.com/LiGoldragon/gascity/internal/dispatch/runtime.go:469-495`

That fork difference affects cleanup/propagation for native workflows, not the main verdict about arbitrary `cascade_next` metadata. The fork still dispatches by `gc.kind` through the fixed graph-control switch. `/git/github.com/LiGoldragon/gascity/internal/dispatch/runtime.go:40-82`

## Prior Research Reconciliation

The earlier "event orders are not enough" conclusion is still right for Criopolis' metadata-driven cascade policy: prior research said event orders are not label-filtered, and source shows event trigger evaluation filters only by event type and cursor. `/home/li/Criopolis/research/answers/gc-cascade-infrastructure.md:13-27`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`

The earlier v2/v3 design correctly moved away from Stop hooks and toward `bead.closed` event consumption. Gas City's own hook says workflow-control watches the event stream directly and no longer needs the close hook to poke it, and the serve loop wakes on bead events. `/home/li/Criopolis/_intake/reports/orchestrator-design-v2.md:8-12`, `/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:34-53`, `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:294-344`

The v3 report's claim that `gc convoy control --serve` is a persistent deterministic dispatcher scoped to graph.v2 is confirmed by the source: implicit control-dispatcher sessions run `gc convoy control --serve --follow`, graph routing assigns control steps to that dispatcher, and `ProcessControl` only handles graph-control kinds. `/home/li/Criopolis/_intake/reports/orchestrator-design-v3.md:1-13`, `/git/github.com/gastownhall/gascity/internal/config/config.go:2368-2420`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:398-527`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`

The older "convoy is CRUD/status/autoclose, not cross-rig reactive feeding" result is still right for simple convoys, but incomplete for graph.v2 workflows. Simple convoy source is parent-child grouping and autoclose; graph.v2 source adds formula controls, graph routing, molecule instantiation, and a resident control dispatcher. `/git/github.com/gastownhall/gascity/engdocs/archive/analysis/gastown-upstream-audit.md:582-600`, `/git/github.com/gastownhall/gascity/internal/convoy/convoy.go:41-108`, `/git/github.com/gastownhall/gascity/internal/formula/graph.go:21-111`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:398-527`, `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:104-115`

The prior "control-dispatcher is not a mayor wake tool" result remains accurate. Control-dispatcher work is graph-control bead work; mayor/user notification remains outside the fixed `ProcessControl` switch unless encoded as workflow steps, formula actions, or separate service logic. `/home/li/Criopolis/research/answers/bead-pc-frro.md:24-27`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/git/github.com/gastownhall/gascity-packs/discord-intake/formulas/mol-discord-fix-issue.formula.toml:230-271`

## Roadmap Recommendation

For new Criopolis cascades that fit a DAG, use graph.v2 formulas and the built-in `control-dispatcher` lane. That path already supports graph compilation, dependency wiring, control routing, fanout, retry/ralph/check controls, workflow finalization, and resident follow-mode dispatch. `/git/github.com/gastownhall/gascity/internal/formula/compile.go:155-177`, `/git/github.com/gastownhall/gascity/internal/molecule/molecule.go:356-550`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:398-527`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:502-556`

For the existing Criopolis cascade metadata contract, do not delete the custom orchestrator without either a bridge or an upstream patch. The bridge would translate `cascade_next` chains into graph.v2 formulas/control beads; the upstream patch would add a new deterministic control kind or event-order predicate capable of matching bead metadata and routing the next stage. The current source does neither: control dispatch is a fixed `gc.kind` switch, and event orders filter by event type/cursor. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`, `/home/li/Criopolis/_intake/reports/orchestrator-design-v3.md:54-76`

The best near-term direction is to keep the orchestrator policy thin and aligned with native primitives: use the event stream/wakeup/sweep shape from `control-dispatcher`, reuse `gc.routed_to` and `gc sling`, and aim to migrate stable cascade templates into graph.v2 formulas over time. Gas City's source already provides the event-follow loop, graph workflow lane, and sling routing primitives; Criopolis' custom piece is the arbitrary metadata policy. `/git/github.com/gastownhall/gascity/cmd/gc/dispatch_runtime.go:294-344`, `/git/github.com/gastownhall/gascity/internal/graphroute/graphroute.go:136-184`, `/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:41-67`, `/home/li/Criopolis/_intake/reports/orchestrator-design-v3.md:103-114`

## Bottom Line

`control-dispatcher` is real native orchestration for graph.v2 formula workflows. It should replace custom code where Criopolis is willing to model the work as formulas and graph controls. `/git/github.com/gastownhall/gascity/internal/config/config.go:2405-2420`, `/git/github.com/gastownhall/gascity/internal/formula/graph.go:21-111`, `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`

`control-dispatcher` is not a native implementation of Criopolis' current free-form `cascade_next` metadata chain. Until that chain is translated to graph.v2 or Gas City grows a generic metadata-aware control primitive, `LiGoldragon/orchestrator` or a smaller equivalent bridge is still needed. `/git/github.com/gastownhall/gascity/internal/dispatch/runtime.go:73-115`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`, `/home/li/Criopolis/_intake/reports/orchestrator-design-v3.md:54-76`

# cr-fc8go4 (explorer: orchestrator-AI pattern survey)

## Headline

Partial. I did not find a shipped Gas City "orchestrator AI" matching the proposed pattern: a persistent LLM agent that receives completion signals, reads a chain/composition definition, and slings the next work unit. The ecosystem does contain several adjacent patterns:

- deterministic workflow control-dispatcher in Gas City core;
- event/cooldown orders that dispatch formulas or exec scripts;
- pack services that create beads and sling formula-backed work from Discord/GitHub-like ingress;
- prompt-level or patrol-agent dispatch patterns in Criopolis and third-party Kit.

The closest Gas-City-shaped pattern to borrow is not Stop-hook orchestration. It is "beads are the durable source of truth; route via `gc.routed_to`; wake/surface via hooks, nudge, or mail." Current research and source both warn against treating `session.stopped` as the completion source.

## Where It Exists

- `/git/github.com/gastownhall/gascity`: core routing is bead/store driven. Tutorial 04 says mayor slings a bead, Gas City wakes/routes sessions, agents close beads, and everyone communicates through the store (`docs/tutorials/04-communication.md:116-126`). The agent schema default `work_query` finds assigned or `gc.routed_to=<qualified-name>` work, and default `sling_query` stamps that metadata (`internal/config/config.go:1677-1701`).

- `/git/github.com/gastownhall/gascity`: deterministic control-dispatcher exists. It is explicitly "built-in deterministic graph.v2 workflow control worker," with implicit always-on city/rig sessions when formula v2 is enabled (`internal/config/config.go:31-44`, `2368-2418`). `gc convoy control --serve` continuously processes ready control beads (`cmd/gc/cmd_convoy_dispatch.go:51-82`), and its follow loop wakes on bead created/closed/updated events plus sweeps (`cmd/gc/dispatch_runtime.go:320-405`). This is a persistent dispatcher, but not an LLM agent.

- `/git/github.com/gastownhall/gascity`: orders are a source-supported event/condition/cooldown dispatcher. Event orders can fire on `bead.closed` with cursor tracking (`docs/tutorials/07-orders.md:198-213`), and the dispatcher runs due orders as wisps or exec scripts while creating a tracking bead before launch to prevent immediate refire (`cmd/gc/order_dispatch.go:26-32`). Manual orders are filtered from auto-dispatch (`cmd/gc/order_dispatch.go:102-110`). This is a good deterministic trigger mechanism, not an AI dispatcher.

- `/git/github.com/gastownhall/gascity`: Stop-hook continuation is legacy, not current canonical. Current changelog says `gc hook --inject` is silent compatibility and fresh hook configs no longer install it (`CHANGELOG.md:23-26`). The command help says inject mode skips the work query and always exits 0 (`cmd/gc/cmd_hook.go:18-39`, `53-59`). Current embedded Claude/Codex hooks include SessionStart/UserPromptSubmit surfaces, not Stop (`internal/hooks/config/claude.json:4-43`; `internal/bootstrap/packs/core/overlay/per-provider/codex/.codex/hooks.json:1-30`).

- `/git/github.com/gastownhall/gascity-packs`: Discord pack has ingress dispatch. It owns Discord services/state/prompt fragments and provides slash-command `/gc fix`, workflow status projection, chat bindings, named-session delivery, and publishing (`discord/README.md:1-24`). Channel/rig mappings point to workflow targets (`discord/README.md:100-110`). The service creates/updates a bead, runs `gc sling <target> <bead> --on <formula>`, records dispatch status, and recovers incomplete dispatches (`discord/scripts/discord_intake_service.py:622-712`, `778-821`). This is external intake plus deterministic dispatch, not completion-chain orchestration.

- `/git/github.com/gastownhall/gascity-packs/flywheel/mcp-agent-mail`: MCP agent-mail pack is inbox coordination. It provides an MCP server, `/coordinate` skill, and a `UserPromptSubmit` inbox hook (`README.md:1-10`). It is a communication surface, not a completion dispatcher.

- `/git/github.com/LiGoldragon/gascity-nix`: packaging only. It pins/builds Gas City and patches shell shebangs for NixOS (`flake.nix:1-45`, `74-92`). I found no orchestration pattern beyond packaging the core.

- `/git/github.com/gastownhall/beads`: Beads is the durable substrate, not the orchestrator. `bd mail` delegates mail to an external provider because mail is "typically provided by the orchestrator" (`cmd/bd/mail.go:12-24`).

- `/git/github.com/bmt/gascity-explore`: strongest third-party customization found locally. Kit replaces direct merge with a PR pipeline: Polecat -> Steward -> Reviewer -> Human, with GitHub feedback translated back into beads (`README.md:27-44`). Steward is a patrol agent that triages/routes/rejects and dispatches reviewer beads (`README.md:57-69`; `packs/kit/agents/steward/prompt.template.md:185-205`). Its startup loop explicitly checks assigned and `gc.routed_to` work, loops while work exists, and exits when idle (`packs/kit/template-fragments/propulsion-steward.template.md:11-20`). A cooldown order monitors stuck pipeline states and mails mayor (`packs/kit/orders/pr-pipeline-health.toml:1-14`; `packs/kit/scripts/pr-pipeline-health.sh:88-105`). This is close in spirit, but it is prompt/patrol-script workflow, not a generic orchestrator AI.

- `/home/li/Criopolis`: current city prompts have a manual durable cascade primitive. Researcher requires `bd update`, `bd close`, then `gc mail send --notify majordomo` (`agents/researcher/prompt.template.md:91-117`). Council prompts explicitly say Stop/session-stopped do not encode the work bead and that polling is avoided (`agents/dharma/prompt.template.md:14-20`, `71-75`). Mayor prompt describes majordomo as always-on cascade receiver/state tracker/routine dispatcher (`agents/mayor/prompt.template.md:101-155`), but this checkout has no `agents/majordomo/prompt.template.md` or `agents/orchestrator/prompt.template.md` present, and `pack.toml` has no orchestrator/majordomo entry found by search.

- `/home/li/Criopolis/_intake/reports/orchestrator-design.md`: the proposed Stop-hook orchestrator exists as a design artifact, not as implementation. It proposes Stop hooks mailing `orchestrator` on `session.stopped`, bead metadata `cascade_id`/`cascade_next`/`cascade_final`, and a Codex always-on orchestrator (`_intake/reports/orchestrator-design.md:48-80`, `96-112`). Its own risks list asks whether Stop is per-session or per-turn and flags the orchestrator as a single point of failure (`_intake/reports/orchestrator-design.md:139-164`).

## What We Could Borrow

- Use the existing `gc.routed_to` contract for composition edges. It is already the core route marker and all work-query/sling paths understand it.

- Use bead close or `bead.closed` as the completion source, not `session.stopped`. Prior notification research says bead close is the durable truth; event-log `bead.closed` is a subscription surface but should be verified against bead state for durability (`research/answers/notification-mechanisms.md:19-36`).

- Use event orders for deterministic "on bead.closed, run a script/formula" cases. The source already has cursor tracking and duplicate suppression.

- Borrow the control-dispatcher shape for any resident non-LLM dispatcher: one named/implicit worker, event wake plus sweep, ready-query over control beads, trace file.

- Borrow Kit's patrol-agent pattern if an LLM really must decide routing: check assigned/routed work, perform bounded triage, sling the next bead, exit or sleep; pair it with a health order that catches stuck/routing-mismatch states.

- Borrow generic LLM precedent only for planning/synthesis policy, not for Gas City plumbing. Prior research maps CrewAI manager agents, AutoGen group-chat managers, LangGraph state graphs, Swarm handoffs, and Anthropic lead/subagent research (`research/answers/multi-agent-patterns/00-overview.md:9-24`; `04-implementations.md:41-57`, `65-71`).

## Gas-City-Shaped vs Generic-LLM-Shaped

- Gas-City-shaped: durable beads, `gc.routed_to`, work queries, `gc sling`, mail/nudge/hook surfacing, event orders, and control-dispatcher. This is recoverable across sessions and process restarts.

- Generic-LLM-shaped: manager agent, group-chat manager, graph scheduler, lead/subagent fanout, handoff loops. These are useful precedents for reasoning about who decides next, but they do not replace the bead/store completion substrate.

- Criopolis-shaped: mayor/majordomo/council split with manual `bd close + mail --notify` cascade. Prior multi-agent research says Criopolis borrows manager-worker and event thinking but makes it durable (`research/answers/multi-agent-patterns/07-criopolis-self-comparison.md:5-21`) and should evolve toward explicit state metadata (`07-criopolis-self-comparison.md:35-47`).

## Bottom Line

Do not reinvent the deterministic plumbing: borrow `gc.routed_to`, bead close, event orders, control-dispatcher loop structure, and Kit-style health monitoring. If the goal is a generic persistent AI dispatcher, that exact artifact was not found in the shipped local Gas City ecosystem. Build only the thin missing layer: explicit cascade metadata plus a dispatcher that verifies closed beads and slings next work. Avoid Stop/session-stopped as the authority; it is legacy/noisy and does not identify the completed work bead.

External web search was not used. Local `ghq list` showed only these Gas City/Gas Town Hall clones and one visible third-party customization (`bmt/gascity-explore`). A researcher pass with web search could check non-cloned public customizations.

# Output Synthesis Patterns

## Final-Arbiter Synthesis

Final-arbiter synthesis means one agent reads the others and writes the answer. Criopolis makes this explicit: mayor watches seat beads close, pushes back on real disagreement, and synthesizes a position mayor would defend (`agents/mayor/prompt.template.md:121-130`). Majordomo may produce a first-pass digest, but mayor refines or redirects and remains the final editorial voice (`agents/majordomo/prompt.template.md:96-108`). Anthropic Research uses a lead agent to synthesize subagent findings, then passes the result to a CitationAgent for citation processing (Anthropic, "How we built our multi-agent research system", 2025-06-13, https://www.anthropic.com/engineering/multi-agent-research-system).

This is the best default for Criopolis. The council seats do not share a single metric, so voting can hide why a minority objection matters (`agents/satya/prompt.template.md:71-101`, `agents/viveka/prompt.template.md:71-92`, `agents/dharma/prompt.template.md:71-92`, `agents/prayoga/prompt.template.md:71-85`, `agents/rasa/prompt.template.md:71-92`).

## Role-Owned Merging

Role-owned merging assigns each agent a section or concern. The Claude Code feature-dev plugin uses distinct explorer, architect, and reviewer phases, and the main agent reads or consolidates their outputs after each phase (`/git/github.com/anthropics/claude-code/plugins/feature-dev/commands/feature-dev.md:36-53`, `/git/github.com/anthropics/claude-code/plugins/feature-dev/commands/feature-dev.md:73-82`, `/git/github.com/anthropics/claude-code/plugins/feature-dev/commands/feature-dev.md:101-109`). MetaGPT's role-company shape also implies role-owned work because `Team` owns roles and SOPs and runs multi-agent activity through its environment (`/git/github.com/geekan/MetaGPT/metagpt/team.py:32-36`, `/git/github.com/geekan/MetaGPT/metagpt/environment/base_env.py:175-212`).

Criopolis should use role-owned merging for reports where each seat's section remains valuable as a separate artifact. For mayor-level decisions, role-owned sections should feed a final stance rather than replace it, because mayor is explicitly editor rather than stenographer (`agents/mayor/prompt.template.md:121-130`).

## Critic-Refiner Loop

Critic-refiner synthesis uses one output as a draft and another agent as reviewer or improver. CAMEL `RolePlaying` supports an optional critic role (`/git/github.com/camel-ai/camel/camel/societies/role_playing.py:36-90`). Reflexion proposes that language agents convert feedback into verbal reflection stored in memory for later trials (Shinn et al., "Reflexion: Language Agents with Verbal Reinforcement Learning", 2023-03-20, https://arxiv.org/abs/2303.11366). AutoGPT includes a `reflexion` prompt strategy as one of its selectable strategies (`/git/github.com/Significant-Gravitas/AutoGPT/classic/original_autogpt/autogpt/agents/agent.py:613-618`).

Criopolis's council can act as a critic-refiner layer when mayor sends a draft proposition to specific seats. Satya's falsification ledger, Viveka's terminology audit, Dharma's absent-party roll call, Prayoga's application ledger, and Rasa's form checks are all specialized refinement criteria (`agents/satya/prompt.template.md:71-101`, `agents/viveka/prompt.template.md:71-92`, `agents/dharma/prompt.template.md:71-92`, `agents/prayoga/prompt.template.md:71-85`, `agents/rasa/prompt.template.md:71-92`).

## Validation Filter

Validation filters separate issue generation from issue confirmation. Claude Code's code-review plugin first launches review agents, then launches validation subagents for issues found by bug agents, and filters out unvalidated issues (`/git/github.com/anthropics/claude-code/plugins/code-review/commands/code-review.md:30-57`). The same workflow tells reviewers to flag only high-signal issues, not subjective style or unvalidated potential problems (`/git/github.com/anthropics/claude-code/plugins/code-review/commands/code-review.md:41-57`).

This pattern is directly portable to Criopolis. For code review beads, Satya or a validation researcher should confirm cited findings before mayor or code-writer acts. For architectural beads, a second-pass "is this objection grounded?" validation prevents council output from becoming a pile of unranked anxieties.

## Voting / Consensus

Voting and consensus are useful only when candidate answers are commensurable. Self-consistency samples multiple reasoning paths and chooses the most consistent answer (Wang et al., "Self-Consistency Improves Chain of Thought Reasoning in Language Models", 2022-03-21, https://arxiv.org/abs/2203.11171). Multiagent debate asks multiple model instances to debate and converge on a final answer over rounds (Du et al., "Improving Factuality and Reasoning in Language Models through Multiagent Debate", 2023-05-23, https://arxiv.org/abs/2305.14325). AutoGen has manager policies that choose next speakers and can support repeated multi-agent turns at the runtime level (`/git/github.com/microsoft/autogen/python/packages/autogen-agentchat/src/autogen_agentchat/teams/_group_chat/_base_group_chat_manager.py:134-193`).

Voting is a weak fit for Criopolis's high council because seats do not answer the same question. A 4-1 majority against a Rasa objection may still leave a form problem that matters to Li, and a 4-1 majority against Satya may still leave a fatal factual defect. The seat prompts show different contracts, not a shared ballot (`agents/satya/prompt.template.md:71-101`, `agents/rasa/prompt.template.md:71-92`).

## Weighted Aggregation

Weighted aggregation gives different agents different weights. The surveyed source did not show an explicit general-purpose weighted vote mechanism in the main frameworks. CrewAI has only `sequential` and `hierarchical` process enum values, with `consensual` left as a commented placeholder (`/git/github.com/crewAIInc/crewAI/lib/crewai/src/crewai/process.py:4-11`). AutoGen's group chat manager selects speakers and applies termination, but the base manager code does not define weighted aggregation of claims (`/git/github.com/microsoft/autogen/python/packages/autogen-agentchat/src/autogen_agentchat/teams/_group_chat/_base_group_chat_manager.py:86-193`).

Criopolis should implement weighting as editorial salience rather than numeric scoring. For example, Satya's falsification can veto factual claims, Prayoga can veto impractical execution paths, and mayor can record why a minority seat controlled the outcome (`agents/satya/prompt.template.md:71-101`, `agents/prayoga/prompt.template.md:71-85`, `agents/mayor/prompt.template.md:121-130`).

## Tournament / Elimination

Tournament synthesis pits candidate solutions against critique or tests and eliminates weaker ones. AutoGPT's prompt strategy list includes `tree_of_thoughts` and `lats`, both names associated with search over candidate reasoning/action paths; the source evidence here is only that these strategies are selectable, not their algorithmic internals (`/git/github.com/Significant-Gravitas/AutoGPT/classic/original_autogpt/autogpt/agents/agent.py:620-632`). Voyager uses iterative prompting with environment feedback, execution errors, and self-verification for program improvement (Wang et al., "Voyager: An Open-Ended Embodied Agent with Large Language Models", 2023-05-25, https://arxiv.org/abs/2305.16291). Claude Code's feature-dev plugin asks architect agents to produce different approaches, then asks the main agent to compare tradeoffs and recommend one (`/git/github.com/anthropics/claude-code/plugins/feature-dev/commands/feature-dev.md:73-82`).

Criopolis can use tournament synthesis for implementation approaches. It should not use it for every council question, because council seats are not candidate implementations; they are lenses over one proposition (`agents/mayor/prompt.template.md:83-130`).

## Citation Synthesis

Citation synthesis separates factual claim generation from source grounding. Criopolis researcher enforces source-grounded claims by cloning source, tracing call graphs, citing file:line, writing formal answers, updating bead notes, and closing (`agents/researcher/prompt.template.md:27-44`, `agents/researcher/prompt.template.md:74-117`). Anthropic Research describes a CitationAgent that processes documents and the research report to identify citation locations after lead-agent synthesis (Anthropic, "How we built our multi-agent research system", 2025-06-13, https://www.anthropic.com/engineering/multi-agent-research-system).

This is one of Criopolis's strongest design choices. It makes "cited or not cited" a first-class difference before council review begins, rather than asking council to retroactively guess which claims are grounded.

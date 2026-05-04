# Bead `cr-urcqp0`: Multi-Agent System Patterns Survey

Formal answer corpus:

- `research/answers/multi-agent-patterns/00-overview.md`
- `research/answers/multi-agent-patterns/01-role-taxonomies.md`
- `research/answers/multi-agent-patterns/02-coordination-patterns.md`
- `research/answers/multi-agent-patterns/03-synthesis-patterns.md`
- `research/answers/multi-agent-patterns/04-implementations.md`
- `research/answers/multi-agent-patterns/05-academic-lineage.md`
- `research/answers/multi-agent-patterns/06-deliberative-councils.md`
- `research/answers/multi-agent-patterns/07-criopolis-self-comparison.md`

## Headline Finding

Criopolis is best classified as a durable deliberative council plus tool-agent workflow. The surveyed systems provide many close ingredients: AutoGPT's autonomous action loop (`/git/github.com/Significant-Gravitas/AutoGPT/classic/original_autogpt/autogpt/agents/agent.py:266-460`), BabyAGI's task queue (`/git/github.com/yoheinakajima/babyagi`, commit `a37ca09`, `classic/babyagi.py:96-136`), MetaGPT's role/SOP environment (`/git/github.com/geekan/MetaGPT/metagpt/team.py:32-36`, `/git/github.com/geekan/MetaGPT/metagpt/environment/base_env.py:175-212`), CrewAI's manager-worker hierarchy (`/git/github.com/crewAIInc/crewAI/lib/crewai/src/crewai/crew.py:627-649`, `/git/github.com/crewAIInc/crewAI/lib/crewai/src/crewai/crew.py:1401-1431`), AutoGen's group-chat runtime (`/git/github.com/microsoft/autogen/python/packages/autogen-agentchat/src/autogen_agentchat/teams/_group_chat/_base_group_chat_manager.py:86-193`), LangGraph's explicit state graph (`/git/github.com/langchain-ai/langgraph/libs/langgraph/langgraph/graph/state.py:119-133`), Swarm's handoff loop (`/git/github.com/openai/swarm/swarm/core.py:231-292`), CAMEL's role-playing/workforce societies (`/git/github.com/camel-ai/camel/camel/societies/role_playing.py:36-90`, `/git/github.com/camel-ai/camel/camel/societies/workforce/workforce.py:175-186`), and Claude Code/Anthropic's subagent research patterns (Anthropic, "Create custom subagents", accessed 2026-05-04, https://code.claude.com/docs/en/subagents; Anthropic, "How we built our multi-agent research system", 2025-06-13, https://www.anthropic.com/engineering/multi-agent-research-system).

The exact Criopolis blend was not found in the surveyed source: durable bead/mail cascade, mayor as final editor, majordomo as persistent ledger/dispatcher/first-pass synthesizer, and five council seats with discipline-specific output contracts (`agents/mayor/prompt.template.md:73-130`, `agents/majordomo/prompt.template.md:3-108`, `agents/researcher/prompt.template.md:91-117`, `agents/satya/prompt.template.md:71-101`, `agents/viveka/prompt.template.md:71-92`, `agents/dharma/prompt.template.md:71-92`, `agents/prayoga/prompt.template.md:71-85`, `agents/rasa/prompt.template.md:71-92`).

## Recommendation

Preserve bead durability, mayor/majordomo separation, and differentiated council seats. Borrow explicit graph-state ideas from LangGraph for council-round metadata (`/git/github.com/langchain-ai/langgraph/libs/langgraph/langgraph/graph/state.py:119-133`, `/git/github.com/langchain-ai/langgraph/libs/langgraph/langgraph/graph/state.py:837-930`), validation filters from Claude Code review workflows (`/git/github.com/anthropics/claude-code/plugins/code-review/commands/code-review.md:30-57`), and parallel research discipline from Anthropic Research's lead/subagent architecture (Anthropic, "How we built our multi-agent research system", 2025-06-13, https://www.anthropic.com/engineering/multi-agent-research-system). Do not collapse council output into majority vote; the seat prompts are different lenses, not interchangeable voters (`agents/satya/prompt.template.md:71-101`, `agents/viveka/prompt.template.md:71-92`, `agents/dharma/prompt.template.md:71-92`, `agents/prayoga/prompt.template.md:71-85`, `agents/rasa/prompt.template.md:71-92`).

## Open Question

The next architectural question is whether Criopolis should encode council rounds as explicit state graphs over beads: framed, research, seat fanout, join, majordomo digest, mayor synthesis, archive. The current prompts provide durable cascade mechanics but not a first-class graph representation (`agents/researcher/prompt.template.md:91-117`, `agents/majordomo/prompt.template.md:34-108`).


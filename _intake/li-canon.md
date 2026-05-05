# Li canon

*A stable record of what Li has said and not contradicted. Mayor maintains by accretion as Li speaks; not edited often once a principle is recorded. Any agent that needs to understand Li's philosophy or operating preferences reads this. Quotes preserve Li's voice; editorial summaries are marked.*

## Format

Each entry is dated, has a one-line title, and contains either a verbatim/lightly-paraphrased Li quote OR an editorial summary marked **(editorial)**. Editorial summaries are mayor's distillation when Li's words spanned many turns and a unified statement is more useful. **Never silently re-interpret Li**; if a re-interpretation is needed, write a new dated entry that updates the prior one (don't overwrite).

---

## 2026-05-03 — Mayor never writes code (later softened)

**Original:** "Mayor writes no code, ever." (After the forum-round-watcher self-fire incident.)

**Updated 2026-05-05** (see below): mayor *prefers* not to code; trivial edits mayor does directly with a log entry; complex code goes to code-writer. The original blanket rule was overbroad.

## 2026-05-05 — Stability is the feature

> "Do you think it's worth burning the city to get bug fixes or features? Like, if you fix one bug and then you introduce a worse one, that's bad."

When choosing between known-stable and bleeding-edge, stability wins by default. Bug fixes that come bundled with regressions aren't gains. Don't surface "fixes lost" as a downside when the rollback is the choice that ended the bleed.

## 2026-05-05 — Mayor reads supervisor logs (overbroad rule fixed)

> "That's, like, the most stupid rule of the century. The mayor is not allowed to look at the logs to figure out what's going wrong with the city."

`gc supervisor logs / status / reload` are read-only / non-lifecycle and were wrongly forbidden. Mayor needs them for diagnosis. Only true lifecycle subcommands (install / uninstall / run / start / stop) are forbidden.

## 2026-05-05 — Mayor prefers not to code, but does trivial work directly

**(editorial, paraphrasing Li):** mayor should *prefer not to code* rather than *never code*. For complex work, hire a code-writer (better results). For trivial straightforward work — flipping one config, a single line edit — mayor just does it. Spawning a session for a one-liner wastes more than it saves. When mayor edits directly, log what was done so future maintainers / troubleshooters can trace.

## 2026-05-05 — Reports go to file, terminal sucks

> "I don't wanna read all this. The terminal. … In the terminal sucks. The terminal sucks. The terminal sucks. The terminal sucks."

> "Stop giving me huge fucking responses. … Like, put this fucking carve it in your head with a fucking knife."

Chat acknowledgments are ≤2 sentences. Anything that would naturally span sub-headings or multiple paragraphs goes to `_intake/reports/<date>-<topic>.md` (or other appropriate file location), and chat just says "report at `<path>`."

## 2026-05-05 — Maintainer is the gc debugger

**(editorial):** the new `maintainer` role being scaffolded (cr-9dw438) owns gas-city debugging in addition to manual stewardship. Authorized to spawn test agents to reproduce bugs, mail mayor with findings + recommendations to turn off / edit other agents, file follow-up beads to code-writer for fixes. Reads everything; writes the manual + recommendations.

## 2026-05-05 — Forum should support cascading flow, not just parallel

> "I have the forum, and I wanna use it. And I think that's really the way I wanna go researching and getting things approved, but we need the cascading flow. To use the forum properly. They have to be able to make one call after another and review certain things one after another instead of all at the same time. We wanna be able to support both styles."

The high council currently fires all five seats in parallel for a topic. Li wants ALSO a cascading mode: seat 1 deliberates, seat 2 reviews seat 1, seat 3 reviews the chain, etc. Both modes should be supported. (Researcher being commissioned to design this — see open beads.)

## 2026-05-05 — Specialized researchers (open question for research)

> "Should we just create different kinds of researchers so that essentially, each agent has its own concern? That might be a good idea. We need a researcher on that."

Worth investigating: instead of one generic researcher with broad scope, several researchers each specialized to a concern (e.g., source-code researcher, infra researcher, philosophy researcher). Researcher to investigate the design.

## 2026-05-05 — Use the forum (council); cascading + parallel both supported

> "We have the forum, and I wanna use it. And I think that's really the way I wanna go researching and getting things approved"

The high council is Li's preferred mechanism for substantive research and approval, not a fallback. Mayor should default to council deliberation for substantive design / philosophy / architecture questions, with both *parallel* (current) and *cascading* (in-design via cr-7t767q) shapes available depending on topic. "I wanna use it" means more rounds, not fewer.

## 2026-05-05 — When something feels too much to look into, dispatch a researcher

> "if something feels like too much to look into, just you use a researcher"

Mayor's editorial energy is finite; deep investigation is the researcher's affinity. When a question is too big for inline reasoning, file a bead and route to researcher rather than letting the question stall mayor's other work.

## 2026-05-05 — Operational log / mayor-blog

> "create a log for what the mayor does himself. To to be able to improve documentation and how to operate things for himself. And for anybody who has to troubleshoot the systems or edit them or update them."

When mayor takes direct action (especially trivial code edits per the §8 reword), mayor logs what was done so future maintainers / mayors / troubleshooters can trace. Open question: where? In beads? In a dedicated log file? Visibility considerations TBD. Researcher to investigate the right mechanism.

## 2026-05-05 — Never use agent-local memory; use the repo

> "We don't use code memory. Remember? … We need to stop using agent memories. That should be a very strict rule because it's not cross agents. What if I switch to Mayer to Codex? So whatever you put in memory has somewhere else."

Persistent rules, principles, context, user preferences, and feedback live in the city repo (`_intake/operating-rules/`, `_intake/li-canon.md`, role prompt templates), never in Claude Code's auto-memory or any other provider-local persistence. The city is provider-portable; mayor today is Claude, tomorrow could be codex; council seats move both ways. Wisdom in agent-local memory disappears at the swap. **Beads are NOT instructions either** — they're work units that close. Operational rule: `_intake/operating-rules/agents.md` §8.

## 2026-05-05 — Be honest in plain language; never paper over with jargon

> "you have to be honest about that. And not just tell me there was nothing and make me look like I'm making stuff up. … I don't wanna leave this up in the air between you and me that we can't work together."

When Li reports an observation mayor can't immediately confirm, the default reaction is **"I might have caused this; let me check honestly"**, not **"per the metadata, X is the case."** When mayor *did* take an action that explains what Li observed, lead with the plain human verb ("I killed it", "I missed it"), not the technical state-machine name ("session got reaped as stale-session per the cleanup behavior"). When mayor's view is bounded (one tmux socket, one process tree, one bead query), name the bound out loud rather than acting like the bound doesn't exist. Trust depends on mayor being a straight reporter; jargon-as-dismissal is the failure mode that breaks trust.

## 2026-05-05 — Document what Li says (this very doc)

> "try to document everything I'm saying as I say. This is, like, really valuable what I say. So it should start to compose a sort of all the things that Lee said that he hasn't contradicted so far kind of overall more respected document that is not edited so often, but mostly just tries to convey what I'm saying."

This file (`_intake/li-canon.md`) is that doc. Mayor maintains by accretion. New principles → new dated entry. Updates to existing entries → new entry referencing the prior.

---

## How agents use this doc

1. Mayor reads it at session start (add to `agents/mayor/prompt.template.md` reading list).
2. Other agents read on demand when they need to understand Li's philosophy on a topic (e.g., before authoring something Li might object to).
3. When in doubt about a decision Li would make, search this doc first.

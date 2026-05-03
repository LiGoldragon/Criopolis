# Operating rules

*Migrated from Claude's auto-memory system per Li's directive
(May 2026): stop using Claude memories because they're agent-local
(only the Claude-running mayor saw them) and break under
provider-switches. These rules now live in the repo, visible to
every agent that reads from `~/Criopolis/_intake/`.*

*Mayor reads everything in this directory at session start. Other
agents read the relevant rule on-demand: `vocabulary.md` for
anyone parsing Li's dictation; `city.md` for anyone needing a
city-overview; `agents.md` for anything about codex/claude
operation; `mayor.md` is mayor-only.*

Files:

- `vocabulary.md` — Li's speech-to-text vocabulary + project-name
  spellings.
- `city.md` — overview of Criopolis: the council, the rigs, the
  ratified architecture intent (hybrid-with-subsidy + role cohort).
- `agents.md` — operational rules every agent must know
  (bead durability, citation style, codex process_names, agent
  scoping, reload semantics, ghq convention).
- `mayor.md` — mayor-specific rules (token economy on
  diagnostics, no city-lifecycle commands, always-push-at-session-
  end, cite beads with description, forum-round labeling so the
  watcher can wake mayor).
- `keel.md` — keel's contract: three labels (rule / guideline /
  practice note), required six-field shape per rule, enforcement
  by the code-reviewer role.

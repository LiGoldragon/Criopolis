# Operating rules

*Migrated from Claude's auto-memory system at
`/home/li/.claude/projects/-home-li-philosophy-city/memory/` per
Li's directive: stop using Claude memories because they're agent-
local (only the Claude-running mayor saw them) and break under
provider-switches. These rules now live in the repo, visible to
every agent that reads from `~/philosophy-city/_intake/`.*

*Mayor reads everything in this directory at session start. Other
agents read the relevant rule on-demand: `vocabulary.md` for
anyone parsing Li's dictation; `city.md` for anyone needing a
city-overview; `agents.md` for anything about codex/claude
operation; `mayor.md` is mayor-only.*

Files:

- `vocabulary.md` — Li's speech-to-text vocabulary + project-name
  spellings.
- `city.md` — overview of philosophy-city / Criopolis setup, the
  council, the rigs.
- `agents.md` — operational rules every agent must know
  (bead durability, citation style, codex process_names, agent
  scoping, reload semantics, ghq convention).
- `mayor.md` — mayor-specific rules (token economy on
  diagnostics, no city-lifecycle commands, always-push-at-session-
  end, cite beads with description).

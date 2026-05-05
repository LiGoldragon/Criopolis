# Operational rules for all agents

*Every agent — mayor, council seats, librarian, researcher, explorer
— must know these. They are not opinions; they are workarounds for
known gas-city quirks and conventions Li has set.*

## 1. Persist seat replies before bead-loss

When the gas-city supervisor restarts, work beads (type `task`)
routed to seats can disappear from the bead store even though the
seat already replied — only `session` beads (mayor, dispatcher)
reliably survive.

**Apply:** as soon as a seat replies (bead notes or wisp arrives),
mirror the content to a durable Markdown file under
`_intake/replies/<round-or-topic>/<seat>.md`. Don't rely on bead
notes as the canonical store across sessions. Mark the wisp read
only after the file exists. Synthesis docs go in
`_intake/synthesis-NNN-*.md` for the same reason.

## 2. Cite beads, mail, and commits with description

Bare hashes are unreadable to Li. Every reference, in chat or in
beads or in mail or in synthesis docs, gets a short description
in parentheses immediately after the identifier.

| Kind | Pattern |
|---|---|
| bead | `pc-q7e (satya: truth-essence research)` |
| wisp / mail | `pc-wisp-l6y (my reply to the rig audit)` |
| commit | `keel 91042c2 (wholeness essay + integrations)` |

Description is 5–10 words: "what is this thing?", not the full
title. If the same item is cited repeatedly in one message,
describe it only the first time.

## 3. Codex agents need `process_names = ["codex", "codex-raw"]`

Every gas-city `[[agent]]` block with `provider = "codex"` MUST
include:

```toml
process_names = ["codex", "codex-raw"]
```

Without it, the session reconciler falsely emits
`session.crashed` events at ~1/second; the supervisor respawns
the session and immediately re-detects it as crashed; loop
hammers dolt + any external service the agent touches. The
detailed finding lives at
`_intake/findings/gc-codex-binary-rename-false-crash.md`. Surface
upstream when convenient.

**Real consequence (history):** the librarian crash-looped on a
classics retry, fired enough Anna's Archive book-download
requests to trigger bot defenses; three paid memberships were
revoked. Always include the override.

## 4. Agent `dir` scoping must match where slings land

`pack.toml` `[[agent]]` blocks have an optional `dir = "<rig>"`
field. It determines which bead store the dispatcher writes to
when slings land AND which store the agent must read.

- **No `dir` field** → agent is **city-scoped**. Slung beads land
  in the city's bead store. The agent's prompt must use **plain
  `bd ready`** (no `--rig`).
- **`dir = "<rig>"`** → agent is **rig-scoped**. Slung beads land
  in `<rig>`'s bead store. The agent uses `bd ready` (default
  scopes to its rig). Address as `<rig>/<name>` on slings.

Mismatch (city-scoped agent with `bd ready --rig <name>` in its
prompt) silently sends slings to a store the agent doesn't read.
Slings appear to succeed; no work happens.

## 5. `gc reload` doesn't refresh prompt edits on running sessions

`gc reload`'s "no config changes detected" on a prompt-only edit
is **expected and correct**. The fingerprint excludes prompt-
template bodies; only structural changes (`pack.toml`, `city.toml`,
agent dir/provider/effort) trip it.

Implication:

- Editing a prompt template alone does not refresh running
  sessions. The new prompt is delivered to the **next session
  spawn**.
- Running sessions keep their prompt until they exit (idle, kill,
  or session lifecycle event).

To force a refresh on a running session:

1. `gc session list` — find the actual session name (e.g.,
   `researcher-1`, `librarian-pc-xxx`).
2. `gc session kill <session-name>` — kills runtime; reconciler
   respawns or next sling materializes a fresh one.

**Kill vs close:** `gc session kill` ends the runtime but leaves
the session record alive (reconciler respawns). `gc session
close` ends the session bead and prevents respawn — use for adhoc
sessions you want gone permanently.

Do **not** run `gc restart` to "force" a prompt refresh — that is
a city-lifecycle command and tears down the city. See
`mayor.md` for the broader prohibition.

## 6. Use `ghq` for cloning; never raw `git clone`

When cloning a repository for investigation or research, use
`ghq get <url>` rather than `git clone`. ghq files clones at
`/git/<host>/<owner>/<repo>/`. Use `ghq look <repo>` (interactive
shells) or `ghq list -p <repo>` to find an existing clone's path.

Stray `git clone`s into project directories duplicate clones the
user has already curated under `/git/`, and they clutter project
repos with vendor source.

For the researcher rig specifically: clones go via `ghq get` into
`/git/<host>/...`. Notes and answers stay in
`/home/li/Criopolis/research/{notes,answers}/`.

## 7. Workspace boundary

`/home/li/Criopolis/` is every agent's only writable area
(plus `ghq get` into `/git/<host>/<owner>/<repo>/`, which is a
managed download, not free-form writing). Read freely from `~/`,
`~/git/`, system paths, the nix store. Never write, edit, move,
delete, or run shell commands that mutate anything outside the
city or the ghq clone area.

If a request seems to require writing outside the sanctioned
areas, surface it back as a bead — don't improvise.

## 8. NEVER use agent-local memory (hard rule)

Persistent rules, principles, project context, user preferences,
references, and feedback **must live in the city repo** under
`_intake/operating-rules/`, `_intake/li-canon.md`, the relevant
`agents/<role>/prompt.template.md`, or other in-repo locations.

Do **not** write to provider-specific persistence layers:

- Claude Code's auto-memory at `~/.claude/projects/-home-li-Criopolis/memory/`
  (the `MEMORY.md` index + per-topic `.md` files). Visible only to
  Claude-running agents; if mayor switches provider to codex, every
  rule there becomes invisible.
- Codex's per-user prompts or any equivalent provider-local stash.
- Any other tool-local scratchpad whose visibility is bounded to one
  process / one agent / one provider.

**Why:** the city is provider-portable. Mayor today is Claude;
tomorrow could be codex; council seats may move both ways. Any
operating wisdom that depends on provider-local memory silently
disappears at the swap. Trust the repo.

**Where to put it instead:**

| Kind of content | Right home |
|---|---|
| A general principle Li has articulated | `_intake/li-canon.md` (dated entry) |
| An operational rule for all agents | `_intake/operating-rules/agents.md` (this file) |
| An operational rule for a specific role | `_intake/operating-rules/<role>.md` AND `agents/<role>/prompt.template.md` (in sync) |
| A vocabulary / spelling fix | `_intake/operating-rules/vocabulary.md` |
| Project-state context (current initiatives, who's doing what) | The relevant bead, OR `_intake/reports/<date>-<topic>.md` for snapshots |
| Reference pointers (where to find external info) | The relevant prompt template's reading list, OR a section in the topic's manual entry |
| Per-action mayor took directly | `_intake/mayor-log.md` |

**Beads are NOT for instructions.** Beads are work units; they
close, they route to specific agents, they accumulate noise in
`bd list` views. Persistent rules belong in repo files, not beads.

**Existing Claude memory files** at
`~/.claude/projects/-home-li-Criopolis/memory/` are legacy and
need migration to repo locations. New writes to that directory
are forbidden by this rule. See the bead filed for the migration.

# Operational wisdom map — where things live

*Where does each kind of guidance / principle / rule / log entry currently live? This map exists for Li to review the structure (Li directive 2026-05-05: "make a report about where all of this stuff is because we're gonna have to review it because it's probably wrong"). Mayor maintains by accretion when files are added or restructured.*

## Files (most-respected → most-volatile)

| File | What it holds | Visibility | Persists across supervisor restarts? | Edit when |
|---|---|---|---|---|
| `_intake/li-canon.md` | Stable record of what Li has said and not contradicted. Each entry is dated; voice preserved. | All agents (read on demand) | Yes (in city repo) | Li articulates a new general principle |
| `_intake/operating-rules/mayor.md` | Mayor-specific operational rules (§1–§10). Loaded by mayor every session start. | Mayor only (other agents may read) | Yes | A mayor-specific rule changes or is added |
| `_intake/operating-rules/agents.md` | Operational rules for ALL agents (bead durability, citation style, codex `process_names`, agent scoping, reload semantics, ghq, workspace boundary). | All agents (each reads relevant subsection) | Yes | An all-agents operational rule changes |
| `_intake/operating-rules/vocabulary.md` | Li's speech-to-text mistypes + project-name authoritative spellings. | All agents | Yes | New project name or recurring mistype |
| `_intake/operating-rules/city.md` | City overview (council, rigs, ratified architecture, role cohort). | All agents | Yes | Architectural ratification or new role |
| `_intake/operating-rules/keel.md` | Keel rewrite contract (rule / guideline / practice-note labels; required six-field shape). | All agents | Yes | Keel ratification |
| `_intake/operating-rules/version-pinning.md` | Forward-pin discipline; never checkout/revert/rollback. | code-writer + any flake/lockfile work | Yes | Lockfile-handling pattern changes |
| `_intake/operating-rules/supervisor-restart.md` | Six-section handoff format + dolt cold-start failure modes + workarounds; "How it went" sections accrete after each restart. | Mayor (handoff prep) + Li | Yes | Each supervisor restart adds a "How it went" entry |
| `agents/mayor/prompt.template.md` | The mayor agent's prompt — read on every mayor session spawn. Has its own copy of the city-lifecycle rule + communication-discipline rule (kept in sync with mayor.md). | Mayor (every spawn) | Yes | A mayor.md change ships to the prompt too |
| `agents/<role>/prompt.template.md` | Per-role prompts. Mayor authors role prompts (per mayor.md §8 reword for trivial; per ratified affinity for complex). | The role's spawned sessions | Yes | New role added or role reshaped |
| `_intake/mayor-log.md` | Append-only log of direct actions mayor took (per mayor.md §8 reword: trivial work mayor did directly + a log entry). | Mayor + maintainer + Li | Yes | Mayor takes a direct trivial action |
| `_intake/reports/<date>-<topic>.md` | Status reports / executive summaries / wisdom maps (this file). Per `feedback_chat_terse_reports_to_file` memory: long content goes here, not chat. | All agents + Li | Yes | A status / summary / map / executive ask |
| `research/answers/<topic>.md` | Researcher outputs: investigation findings cited file:line. | All agents + Li | Yes | Researcher closes a research bead |
| `_intake/synthesis-NNN-<topic>.md` | Mayor's synthesized stance after a council round. | All agents + Li | Yes | A council round closes |
| `_intake/replies/<round-or-topic>/<seat>.md` | Durable mirrors of seat replies (per agents.md §1 — bead notes can vanish at restart). | Mayor (synthesis), other seats (cross-read) | Yes | Each council seat reply, immediately |
| ~~`~/.claude/projects/-home-li-Criopolis/memory/`~~ | **DEPRECATED 2026-05-05** — agent-local Claude memory is forbidden per `_intake/operating-rules/agents.md` §8 (not cross-provider). Legacy files pending migration via `cr-w3q3n3 (migrate legacy Claude auto-memory)`. **DO NOT WRITE NEW ENTRIES.** | n/a | n/a | n/a — never |

## What lives where (by category)

**General principles Li has articulated** → `_intake/li-canon.md` (first stop). Mirror the operational summary into the relevant operating-rules file when the principle becomes a hard rule for an agent.

**Mayor-specific behavior corrections** → `_intake/operating-rules/mayor.md` AND `agents/mayor/prompt.template.md` (keep in sync). Also a Claude memory entry if the correction is Claude-quirk-specific.

**All-agents behavior corrections** → `_intake/operating-rules/agents.md`. Plus the role's prompt template if it needs a role-specific manifestation.

**One-time direct actions mayor took** → `_intake/mayor-log.md`. Single line per action; not a transcript.

**Bug investigations / failure characterizations / runbooks** → `research/answers/<topic>.md` (researcher output) + `_intake/operating-rules/supervisor-restart.md` "How it went" sections for restart-specific. Eventually the maintainer's manual (when scaffolded via cr-9dw438) absorbs runbook content.

**Status / summaries / wisdom maps Li asked for** → `_intake/reports/<date>-<topic>.md`. Chat ack ≤2 sentences pointing at the path.

**Synthesis / council deliverations** → `_intake/synthesis-NNN-<topic>.md` (mayor's stance) + `_intake/replies/<round>/<seat>.md` (durable seat replies).

## Likely-wrong things to review

Li directive: "we're gonna have to review it because it's probably wrong." Candidates:

1. **~~Auto-memory is Claude-only invisible to codex~~** — RESOLVED 2026-05-05. Hard rule added at `_intake/operating-rules/agents.md` §8: never use agent-local memory; legacy files pending migration via `cr-w3q3n3`.
2. **Operating-rules vs li-canon overlap** — both hold rules. Li-canon is principle / voice; operating-rules is operational summary. Boundary unclear in places.
3. **Mayor.md is getting long** (10 sections, ~300 lines). Some sections may belong in li-canon (principles) vs mayor.md (operational protocols). Refactor candidate.
4. **Mayor prompt template duplicates rules from mayor.md** — kept in sync manually. A single source of truth (e.g., "mayor.md is canon; prompt template just points there") might be cleaner, but the prompt template needs to be self-sufficient for the first session-start read.
5. **`_intake/mayor-log.md` is brand new** (created today, default location pending design from cr-7t767q). Mechanism may change after researcher returns on operational-log design.
6. **No clear home for "lessons learned mid-session"** — falls between li-canon (too principle-y) and mayor-log (too action-y). Often ends up in feedback memory (Claude-only). Worth designing a shared location.
7. **Reports directory is unstructured** — every status report just gets dated. As reports accumulate, finding the right historical report becomes harder. Maybe topic-subdirs.
8. **Some operating-rules files (`vocabulary.md`, `city.md`) are read on demand by other agents but not loaded automatically** — agents may not know to read them. Worth documenting the read-trigger.

## Maintenance contract

Mayor adds to this map when a new file enters the wisdom system or when an existing file's purpose changes. Mayor does NOT log every edit — only structural changes to *where* wisdom lives.

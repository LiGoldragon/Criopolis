# City overview

*What this gas-city is, where it lives, who runs in it, what its
purpose is. Read this if you don't already know the city.*

## Identity

This city is **Criopolis** (envisioned name; transitioning from the
working name `philosophy-city`). It is the gas-city on which the
**high council** sits.

Path: `/home/li/philosophy-city/` (subject to a council-deliberated
relocation question; for now stays in `~/`).

Remote: `git@github.com:LiGoldragon/philosophy-city.git`.

## Purpose

Originally: distill engineering design guidelines for the criome
sema-ecosystem from the corpus at `~/git/workspace/` and surrounding
repos, into a separate repo called **keel**.

Currently: the council is iterating its own structure first
(rounds 1–6 to date). Keel was wiped at `keel 492143d (wipe — fresh
start)`; the council will rewrite once its shape converges and
real-content questions begin firing. Li is steering toward
broadening Criopolis's scope — the council may also be the
"coding council" that produces engineering rules, deployment
discipline, and review patterns for criome itself.

## Roster (as of 2026-05-03)

Configured in `pack.toml`:

**The high council** (five seats, on_demand):

- `satya` (codex) — truth / correspondence
- `viveka` (codex) — discrimination / cutting
- `dharma` (claude) — right-order / who-is-missing
- `prayoga` (codex) — application / under-load
- `rasa` (claude) — felt-disclosure / form-savor

**The mayor**: `mayor` (claude, always-on) — orchestrates,
synthesizes, files beads, runs commits.

**Tools** (on_demand):

- `librarian` (codex) — fetches and catalogs the library rig.
- `researcher` (codex) — investigates source-code questions; cites
  file:line; outputs to `research/answers/`.
- `explorer` (codex) — surveys `~/git/` and produces briefs;
  outputs to `_intake/explorer/`.

History: the seats migrated from a prior four-seat shape (aesthete /
pragmatist / theorist / devil) at commit `philosophy-city a75e12b
(forum migration)`. Old prompts archived under `agents/_archive/`.

## Workspace boundary (hard rule)

The council and tools may **read** anywhere on the filesystem;
**write** only inside `/home/li/philosophy-city/`. Each agent's
`prompt.template.md` carries this under "Workspace boundary (hard
rule)". Do not relax it without Li's explicit say.

## Working notes layout (`_intake/`)

- `_intake/operating-rules/` — this directory; rules every agent
  reads.
- `_intake/glossary.md` — council vocabulary index (Sanskrit /
  Greek / Latin / Hebrew / Chinese / modern Western technical
  terms the seats use).
- `_intake/replies/<round-or-topic>/<seat>.md` — durable mirrors
  of seat replies (kept rolling; usually last 2 rounds).
- `_intake/synthesis-NNN-*.md` — mayor's synthesized stances; the
  most recent is `synthesis-010-repos-under-ghq.md`.
- `_intake/explorer/<bead-id>-<topic>.md` — explorer briefs.
- `_intake/criopolis-structure-prep.md` — staging doc for the
  upcoming structure round.
- `_intake/system-inspection.md` — pointer to the running gc
  binary and matching gascity source clone.

## Adjacent rigs (separate VCS roots inside the city)

- `keel/` — destination corpus (currently wiped; council rewrites
  later). Remote: `LiGoldragon/keel`.
- `library/` — jj-managed reference library. Remote:
  `LiGoldragon/bibliography`. Note: jj uses git as the underlying
  store; the library is git-backed, so VCS-flavor doesn't exempt
  it from any future cross-repo policy.
- `research/` — researcher's output rig (notes + answers).

## Output destinations

- Council deliberations + syntheses → `_intake/`.
- Engineering guidelines (when keel rewrite begins) → `keel/`.
- Library acquisitions → `library/`.
- Research answers → `research/answers/`.
- Workspace briefs → `_intake/explorer/`.

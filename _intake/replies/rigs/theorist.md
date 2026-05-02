# Theorist — rig integration architecture

*Bead pc-v7b9. Three sharp answers. No sixth axiom.*

## A. Where does library live?

**Option 2: rename `~/git/bibliography/` → `~/git/library/`, register
as a rig at that path.**

Library and city are two concerns: source canon vs. engineering
guidelines. Axiom (5) forbids conflating them in one tree. Putting
the library inside `~/philosophy-city/` would moot the rig
abstraction precisely where it should earn its keep — it exists *for*
external writable areas. Option 1 is the move you make when the
abstraction is not yet ready; admitting that is fine, but it should
be named as expedient, not chosen as architecture. The canonical
`~/git/<repo>/` convention (criome, lore, workspace) extends; the
rig registration is the only new wiring.

## B. Pack or single agent?

**Option 1: single `librarian` agent.**

Axiom (5) asks whether "operate the library" is one concern. Today,
yes: fetch, catalog, and minor housekeeping form one division of
responsibility. *Curation* is a separate concern (judgment about
what is worth holding) and lives in **beads**, not in the librarian
— the librarian executes registered additions; the seats / mayor /
user decide them. With curation externalized to beads, the librarian
is a single-concern agent.

The pack split (fetcher / cataloger / curator) is the right answer
once volume forces seams — fetching becomes a bottleneck, or
catalog schema decisions become contested. Premature today; a fork
later when the seam shows. `rig-manager` + `librarian` is hedging;
ship the second rig first, then generalize.

## C. How does the workspace-boundary rule extend?

**Option 3: shared partial `agents/_workspace-boundary.md`, inlined
at materialize time, parameterized per agent.**

Option 1 fails closure: registering a rig forces edits in every
prompt template — anti-locality, the wrong shape. Option 2 (runtime
`gc rig list`) puts the rule outside the prompt; the agent must
remember to query, and a forgotten query degrades silently to "city
only" or to "anywhere." The boundary stops being the boundary.

Option 3 puts the writable set *into the prompt* at render time, per
agent. The prompt is the boundary the agent reads; the rule lives
where it is enforceable. Different agents get different sets
(librarian: city + library; seats: city only) without per-template
duplication.

This derives from (3) + (5); no sixth axiom. "Rig" is not leaky —
keel's rule is "every agent's writable set is named in its prompt";
Gas City's rig is one mechanism that supplies a named entry to that
set. Different layers, both local-to-themselves.

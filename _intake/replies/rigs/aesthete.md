# Aesthete — rig integration architecture (pc-g70z)

A. Leave at ~/git/library, register as rig.

The city is a building, not the city block. ~/git/* IS the row —
bibliography, criome, lore, workspace already sit there as peers.
Folding library into philosophy-city/library/ collapses the row and
makes the city look cluttered while the row gets a gap. The rig
abstraction exists *precisely* to extend writability across the row
without collapsing geometry. If "one tree" were the right shape, rigs
wouldn't need to exist. Symmetry says: library is a sibling building
that the city has keys to, not a wing of city hall.

B. Single `librarian`.

A pack of three (curator/fetcher/cataloger) for ~100 authors is
ceremony without substance — three seats coordinating on "fetch this
book" is the form of a bureaucracy, not a library. The right shape
is one seat that *knows* the collection: fetches with `annas`, files
it, maintains the catalog. Specialization should emerge from felt
friction, not be pre-built. If the librarian later finds itself
consistently splitting work along a clean seam, *that's* when you
fork off a specialist. The "both" option is hedging — no.

C. Option 3, with sharpening.

Per-template duplication (option 1) is ugly: every `gc rig add` edits
five files and they will drift. Runtime `gc rig list` (option 2) is
clean in source but moves a static fact into runtime — the agent has
to ask "what may I touch?" instead of *reading* it in its own prompt.
Option 3 (a shared `agents/_workspace-boundary.md` materialized into
each prompt at build time) is the symmetric move: one source of
truth, expanded inline, no runtime indirection. `gc rig add` triggers
template regen. Agents see the resolved boundary the same way they
see their seat name — as written fact, not a question to ask.

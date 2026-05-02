# Pragmatist's repo proposal

*Source: bead pc-623, closed by pragmatist agent, 2026-05-02.*

## A. Candidate repo names

1. `engineering-guidelines` — top pick. Plain, typeable, grep-friendly, and honest about the repo's job.
2. `design-rules` — shorter, but slightly too broad; still good for engineers who need the law, not the lore.
3. `city-engineering` — useful if the repo must stay tied to Gas City, but less portable as the corpus grows.

Pick: `engineering-guidelines`. Do not be clever here. The repo is a reference tool for people under deadline pressure; the name should disappear in shell history and links.

## B. One-line description

Engineering design rules for typed, shippable Gas City systems.

## C. README outline and top-level structure

The README should optimize the first 100 lines for a new engineer deciding how to shape work today:

1. What this repo is: binding engineering guidelines, not a philosophy archive.
2. The four day-one rules: typed boundaries, explicit ownership, no shared mutable state across components, local ugliness is acceptable only when named and cheap to delete.
3. Decision ladder: correctness and invariants first, blast radius second, delivery cost third, beauty as diagnostic not release gate.
4. When to add structure: spend ceremony at storage, protocol, schema, and privilege boundaries; avoid it for disposable glue.
5. How to use the repo: read principles, pick a pattern, record exceptions in decisions.

Top-level structure:

- `README.md` — first 100 lines and navigation.
- `principles/` — stable rules: invariants, type boundaries, component ownership, reversible experiments.
- `patterns/` — concrete recipes engineers can copy.
- `decisions/` — active ADR-style records with owner, date, status, blast radius.
- `checklists/` — PR/design review checklists.
- `examples/` — small before/after examples tied to the rules.
- `glossary.md` — exact terms, full English names, and forbidden ambiguous nouns.

Keep it small. If this repo cannot answer a day-one design question in under five minutes, it has already failed its operating role.

# Theorist's repo proposal

*Source: bead pc-v8k, closed by theorist-pc-2lp, 2026-05-02.*

## A. Three candidate names

1. **`axiomata`** — top pick. Latin plural; announces this repo IS an axiom layer plus its derivations, not a list of opinions. Matches the criome / sema / arca / prism vocabulary.
2. **`pentad`** — five axioms, exactly. Bakes the cardinality into the name; readers count and notice when a sixth sneaks in.
3. **`derivation`** — verb-noun; tells the reader their job is to trace the chain from axiom to rule, not to look up a verdict.

Top: **`axiomata`**.

## B. One-line description (74 chars)

`Five axioms; every rule derives from them. Criome engineering guidelines.`

## C. README outline + top-level structure

```
/
├── README.md          — the five, the test, reading order, contribution flow
├── AXIOMS.md          — the five in order, terse, no padding (surfaces in GH UI)
├── axioms/            — one file per axiom; rationale, consequences, what it forbids
│   ├── 01-sema-is-the-concern.md
│   ├── 02-right-shape-beats-speed.md
│   ├── 03-specificity-at-boundaries.md
│   ├── 04-identity-persists-content-revises.md
│   └── 05-one-concern-one-component.md
├── derived/           — one file per rule; header MUST cite axioms it derives from
│   ├── micro-components.md          (5)
│   ├── push-not-pull.md             (3)
│   ├── strings-in-localization.md   (3)
│   ├── methods-on-nouns.md          (3)
│   ├── schema-self-hosting.md       (1)+(3)
│   ├── closed-enums.md              (3)+(4)
│   └── slot-identity.md             (4)
├── proofs/            — contested derivations, worked end-to-end
├── beauty.md          — diagnostic, not gate; sits outside the tree by design
└── glossary.md        — sema, slot, criome, prism, arca
```

**Where the five axioms live as files:** `axioms/01..05-*.md`. Ordinal-prefixed because the order is load-bearing — (3) presupposes (1), (4) presupposes (3). One file per axiom keeps each bounded; `AXIOMS.md` at root is the canonical short list for skimming.

**Why `derived/` not `rules/` or `guidelines/`:** the directory name is the test. A PR to `derived/foo.md` whose header can't cite an axiom is rejected on shape, not taste. If reviewers find themselves reaching for a sixth axiom to justify the rule, that's the signal to either promote (rare) or drop (usual).

**Why `proofs/` exists:** when reasonable engineers disagree about whether a rule derives, the worked derivation goes here. Keeps the argument addressable and the rule grounded.

**Why `beauty.md` sits alone at root:** it is the diagnostic that the model is incomplete, not an acceptance criterion. Putting it inside `derived/` would imply it's a rule; putting it inside `axioms/` would make it a sixth. It is neither.

README outline:
1. The five (named, no commentary)
2. The test — any rule must derive; if it can't, escalate
3. Reading order — axioms → derived → proofs
4. Adding a guideline — state rule, cite chain, open PR
5. Beauty's role — diagnostic only
6. Glossary pointer

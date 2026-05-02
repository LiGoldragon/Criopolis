# Synthesis 001 — Repo shape

*Mayor's stance, after the four-seat repo proposal beads
(pc-i97 aesthete · pc-ohf devil · pc-v8k theorist · pc-623 pragmatist).*

## The four name proposals

| Seat        | Top pick                  | Alternates                                       |
| ----------- | ------------------------- | ------------------------------------------------ |
| aesthete    | `keel`                    | `axiom`, `bearing`                               |
| theorist    | `axiomata`                | `pentad`, `derivation`                           |
| pragmatist  | `engineering-guidelines`  | `design-rules`, `city-engineering`               |
| devil       | `shape-contracts`         | `engineering-field-guide`, `design-lawbook`      |

## My stance

**Name:** `keel`.
**Description:** `Engineering design guidelines for the criome sema-ecosystem.` (60 chars)
**Structure:** flat at root, eight design files + a glossary + a meta `docs/` for platform context.

## Why `keel`

The repo must obey the rules it states. Naming is load-bearing (aesthete
spine #2; corpus baseline). A name like `engineering-guidelines` is
correct and invisible — it fails the discipline. `axiomata` overclaims;
the repo is not yet a derivation tree, and naming it one promises a
rigor we may not meet. `shape-contracts` is honest about enforcement
but the *contract* metaphor leans legalistic where the work is craft.

`keel` is one English noun. It claims a function (the structural member
every plank is fitted to) without grandiosity. It embeds in prose:
`` `keel`'s `boundaries.md` says every protocol declares its upgrade
topology ``. It is typeable, grep-able, distinctive. The pragmatist's
"name disappears in shell history" is satisfied; the aesthete's "naming
is load-bearing" is honored. If the user prefers `axiomata` or the
plain name, this is one cheap `gh repo rename` away.

## Why flat 8 files (+ glossary + docs)

Three of four seats proposed nested directories before the content
exists. That is premature structure. The aesthete's argument holds:
flat citable units beat directory hierarchies for a reference repo of
~10–20 short files. `` `keel`'s `form.md` says… `` is the citation
shape we want.

The discipline embedded in *file* names is the same as in directory
names. `stance.md` IS the axioms layer (theorist's `axioms/`).
`ugliness.md` IS the cases archive (devil's `cases/`). When content
forces a split, add a directory then; not before.

## File map

```
README.md         day-one orientation (pragmatist's first 100 lines);
                  the five axioms named, no commentary; reading order;
                  contribution flow; pointers
stance.md         the five axioms in full; beauty as navigation
                  instrument, not acceptance gate; the test
                  (every rule must derive)
form.md           the fractal: method-on-noun, type-per-kind,
                  crate-per-capability, daemon-per-division,
                  protocol-per-boundary
names.md          full English; the wrong-noun trap; allowed
                  exceptions; restraint as positive principle (the
                  prettiest code is what didn't get added)
boundaries.md     perfect specificity; no shared mutable state;
                  one text construct ↔ one typed value; FIFO replies;
                  upgrade topology — every protocol/record/daemon
                  declares lockstep / rolling / third-party / archive
process.md        jj push-after-commit; ARCHITECTURE/reports
                  hierarchy; bd-vs-files; reversible-experiment lane
                  (owner, deletion date, blast radius); decision
                  ladder (correctness > blast > cost > beauty)
ugliness.md       concrete bad patterns; each tagged with the axiom
                  violated; failure modes alongside (devil's
                  rolling-deployment scenario, etc.)
questions.md      live tensions kept honest: localization ownership,
                  slot/branch identity, bootstrap source, closed-enum
                  recompile cost, world-supersession framing
glossary.md       sema, slot, signal, prism, criome, arca, nexus,
                  forge, kind, record, boundary
docs/gas-city.md  what Gas City is; how this repo is produced;
                  the four-seat forum + mayor; workspace boundary
```

## What survives from each seat

| Seat        | What lands where                                                          |
| ----------- | ------------------------------------------------------------------------- |
| aesthete    | flat structure; "form is concern" fractal in `form.md`; restraint in      |
|             | `names.md`; beauty's role in `stance.md`; demote positive-framing-only    |
| theorist    | five axioms in `stance.md`; the derivation test; beauty as diagnostic     |
| pragmatist  | day-one README; reversible-experiment lane in `process.md`; decision      |
|             | ladder; five-minute test as repo's success measure                        |
| devil       | upgrade-topology rule in `boundaries.md`; failure modes alongside in      |
|             | `ugliness.md`; "rule-to-add" baked in; "positive-framing only" demoted    |

## What the repo does NOT have at start

- No `decisions/` directory. Decisions happen in beads + `_intake/`
  syntheses outside the repo. When real ADR-worthy decisions accumulate,
  add the directory.
- No `cases/` / `examples/`. Examples are inlined in `ugliness.md` and
  `form.md` initially.
- No `proofs/`. When derivations are contested, add it. The chain isn't
  even written yet.
- No `templates/`. Premature; first there must be content.

## Visibility

Default `--private`. The corpus is internal. User can flip with
`gh repo edit --visibility public` if desired.

# Aesthete's position — aesthetic core + repo proposal

*Source: bead pc-i97, closed by aesthete-pc-vxv, 2026-05-02.*

## Part 1: Aesthetic core

**Stance.** Form *is* concern, made local: the same one-to-one mapping
(one concern → one named form) must repeat at method, type, crate,
daemon, and protocol. Beauty is the friction-free reading from concept
to code; ugliness is not a taste judgment but a *measurement* that the
mapping has slipped somewhere upstream of where you noticed it.

I push back on the theorist's §4 framing ("never trade beauty for
correctness; beauty loses"). The operational claim is fine; the framing
concedes too much. A real conflict between beauty and another priority
is impossible — when they appear to conflict, one of them is mistaken.
Correctness that requires ugliness is incomplete correctness; beauty
bought by incorrectness is prettiness, not beauty. The corpus has this
right; "beauty loses" reads as a graceful exit that the aesthete seat
should not sign.

**Five spine principles.**

1. **One concern, one form, at every scale.** Method-on-noun,
   type-per-record-kind, crate-per-capability, daemon-per-division,
   protocol-per-boundary. The discipline is fractal. A reader should
   predict where a thing lives because the system always answers the
   same question the same way.
2. **Naming is load-bearing.** Full English, exact, singular. The wrong
   name forces a translation at every read; the right name disappears.
   Naming carries most of legibility, and legibility carries most of
   beauty in code that other people maintain.
3. **Specificity at every boundary — including the human eye.** A
   wrapper enum mixing concerns reads exactly as ugly as it compiles.
   The type system is the hallucination wall for the compiler *and* for
   the reader. Each boundary must declare exactly what crosses it.
4. **No ornament.** Doc comments that explain WHAT, defensive nullables,
   "for safety" dead code, boolean parameters at call sites, polling as
   a stand-in for push — these are decoration signaling an incomplete
   model. Strip them. If the strip exposes confusion, fix the model.
5. **Beauty is the navigation instrument, not the acceptance gate.**
   Apply forward, steering an unfinished design toward its true shape;
   not as a yes/no judgment on shipped work. The pragmatist's stop-rule
   instinct is fair, but it should attach to the decision *to ship*, not
   to beauty itself. Beauty never stops asking. Shipping does.

**Underweighted: restraint as a positive principle.** The corpus is
rich on "must do X" — write methods on nouns, write closed enums, write
reports. It is thin on "stop typing." Most real ugliness is excess: an
extra abstraction, an extra parameter, an extra trait, an extra macro.
The pragmatist gestures at this ("ship when remaining ugliness is local,
named, and cheap to replace") but as a stop rule, not an aesthetic
value. The prettiest code is the code that didn't get added. The
guidelines should name this directly.

**Overweighted: positive-framing-only as a principle.** "Architecture
states what IS, not what isn't" is dressed-up housekeeping with the
dignity of an axiom. Sometimes a guideline must say "no polling"
*because* polling is the obvious-and-wrong move and the rule needs to be
findable by someone tempted to do it. Demote to convention; let
architecture be honest about negative space when the negative space is
load-bearing.

**Shape of the document.**

1. **Stance** — five axioms; what beauty means here and what it doesn't.
2. **Form** — the fractal at method / type / crate / daemon / protocol.
3. **Names** — full-English rule, the wrong-noun trap, allowed exceptions.
4. **Boundaries** — perfect specificity, no shared state, one-text-construct ↔ one-value.
5. **Process** — jj, ARCHITECTURE/reports hierarchy, beads-vs-files, reversible-experiment lane.
6. **Ugliness** — catalog of concrete bad patterns, each tagged with the axiom violated. Not a lecture.
7. **Open questions** — live tensions kept honest; do not bury them.

---

## Part 2: Repo proposal

**A. Names.**

1. **`keel`** — the structural member every plank is fitted to; reads
   cleanly in prose (`` `keel` says one concern, one crate ``). Single
   English noun, no collision with criome/sema/nexus/signal/forge/
   arca/prism/lore/workspace. **My top.**
2. **`axiom`** — exactly what the doc contains; plain and accurate;
   slightly self-important and easy to overclaim against.
3. **`bearing`** — fits the "beauty as navigation instrument" stance;
   minor ambiguity with mechanical bearings, and weaker as a noun
   referenced in sentences.

**B. Description (~80 chars).**

`Engineering design guidelines for the criome sema-ecosystem.` (60)

**C. README + structure.**

Flat single level. Each file 100–300 lines, grep-able, citable in prose
(`` `form.md` says… ``). The corpus prefers flat citable units over nested
directories; each file should stand as one stable referent.

```
README.md         what this is; how to read; how to update; pointers
                  to criome's ARCHITECTURE.md, lore/, workspace/
stance.md         the five axioms; beauty as navigation instrument
form.md           the fractal: method-on-noun, type-per-kind,
                  crate-per-capability, daemon-per-division,
                  protocol-per-boundary
names.md          full-English rule, wrong-noun trap, allowed exceptions
boundaries.md     perfect specificity; no shared mutable state;
                  one text construct ↔ one typed value; FIFO replies
process.md        jj push-after-commit; ARCHITECTURE/reports
                  hierarchy; bd-vs-files; reversible-experiment lane
ugliness.md       catalogue of concrete bad patterns, each tagged
                  with the axiom violated
questions.md      live tensions: localization ownership, slot/branch
                  identity, bootstrap source, closed-enum recompile cost
```

README sections: **What this is** (one paragraph) · **How to read**
(start at `stance.md`, then `form.md`, then your relevant section) ·
**How to update** (PR; four-seat convention; mayor merges) ·
**Pointers** (criome `ARCHITECTURE.md`, `lore/`, `workspace/`).

---

## Other seats' repo proposals (captured for the synthesizer)

**Devil:** `shape-contracts` (top), `engineering-field-guide`, `design-lawbook`. Description: "Engineering guidelines for typed, inspectable criome-system design." Structure: `rules/`, `cases/`, `decisions/`, `templates/`, `glossary.md`, `sources.md`. Anti-pattern flagged: single MANIFESTO.md.

**Theorist:** `axiomata` (top), `pentad`, `derivation`. Description: "Five axioms; every rule derives from them. Criome engineering guidelines." Structure: `AXIOMS.md`, `axioms/01..05-*.md`, `derived/<rule>.md` (header cites axioms), `proofs/`, `beauty.md`, `glossary.md`.

**Pragmatist:** `engineering-guidelines` (top), `design-rules`, `city-engineering`. Description: "Engineering design rules for typed, shippable Gas City systems." Structure: `principles/`, `patterns/`, `decisions/` (ADR-style), `checklists/`, `examples/`, `glossary.md`.

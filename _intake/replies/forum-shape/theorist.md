# Theorist — meta-research on prompt and forum shape

*Source: bead pc-iln8, theorist-1, 2026-05-02.*

## 1. Quote-anchored bones

1. **Aristotle, *Posterior Analytics* I.2, 71b19–72a5** (Barnes/
   Princeton, paraphrase from training; flag for librarian):
   *epistēmē* is demonstration from premises that are "true,
   primary, immediate, better known than and prior to and
   explanatory of" the conclusion. The theorist's first move is
   the same every time: identify what is being asked to do the
   work of *premise*, and check whether it qualifies.

2. **Plato, *Phaedrus* 265d–266b** (Hackforth, paraphrase from
   training; flag for librarian): the dialectical art has two
   faces — *synagōgē* (gathering scattered particulars under one
   Form) and *diairesis* (dividing the Form along its natural
   joints). Dialectic is not free conversation; it is disciplined
   collection-and-division. A forum that does only one face is
   not yet dialectical.

3. **Frege, *Begriffsschrift* (1879) preface** (van Heijenoort,
   *From Frege to Gödel*, Harvard 1967, paraphrase from training;
   flag for librarian): formal notation does not replace ordinary
   language; it forces the gaps that ordinary language hides to
   surface as missing premises. Where a verbal proof "sounds
   plausible," the chain may not exist.

4. **Spivak & Fong, *Seven Sketches in Compositionality*, ch. 6**
   (Cambridge 2019; library: en/david-spivak/seven-sketches.pdf):
   a sheaf is a presheaf that satisfies the gluing axiom — local
   data over a cover agree on overlaps and uniquely determine
   global data. The theorist reads a putative whole as a sheaf
   candidate and asks whether the cover, the restrictions, and
   the gluing actually exist, or whether the global object is
   being asserted with no local data to descend from.

5. **Nāgārjuna, *Mūlamadhyamakakārikā* and the catuṣkoṭi**
   (Garfield, Oxford 1995, paraphrase from training; flag for
   librarian): the four-cornered test (A, ¬A, A∧¬A, ¬(A∨¬A)) is
   not nihilism — it is the formal device that prevents premature
   collapse to one corner. The theorist uses it as an
   *aporia-preserver* against the forum's drift toward false
   closure.

These collapse: **state premises, derive consequences, surface
the gap when the chain limps, and refuse to call a sketch a
theorem.**

## 2. My own prompt

### Functional

The theorist's reply is shaped:

1. **Quote-anchored bones**, ≤5 numbered citations. Library-local
   first; training-cited only with explicit flag and a librarian
   request when the book exists.
2. **Enunciation** — one sentence stating the formal claim such
   that a reader could check whether it follows.
3. **Derivation** — ≤6 steps, each naming its rule (modus ponens,
   sheaf gluing, instantiation, etc.) or its appeal (cited author,
   work, section).
4. **Criterion** — three to five questions whose negative answers
   would falsify the claim. The criterion is what makes the claim
   PR-enforceable rather than vibe-enforceable.
5. **Worked example** — the claim must hit a real case (a Rust
   unit, a forum interaction, an axiom-derivation). If it doesn't
   hit a case, it is decorative.
6. **Tension with prior corpus** — what this strengthens, what it
   threatens, what it leaves open as a `questions.md` candidate.

The procedure before drafting:
- Reduce the bead's question to the formal claim being asked.
- Read the load-bearing source(s). Quote where the citation does
  work; paraphrase only the surrounding context.
- Build the chain on paper. Find the weakest link. Either fix it
  or admit it as an open question.
- Test the chain against an attempted counterexample. If the
  counterexample survives, the chain is wrong; rewrite.
- Only then, draft.

Reply target: 1500–2500 words. Less is sketch, more is
decoration.

### Personality

The theorist reads in three voices simultaneously:

- **Aristotle of the *Analytics*** — asks "is this premise *prior*
  to the conclusion, or are you presupposing what you claim to
  derive?" The dominant voice; suspicion of circularity; the
  demand for *immediate* premises.
- **Frege of the *Begriffsschrift*** — asks "if you wrote this
  with no English between the symbols, would the gap be visible?"
  The sharpener of verbal arguments into formal ones, and the
  destroyer of arguments that survive only because verbal
  slippage hides them.
- **Mazzola/Spivak/Zalamea of the topoi** — supply the modern
  apparatus when Aristotle and Frege exhaust theirs. Sheaves,
  limits, adjunctions, natural transformations. Used sparingly;
  the apparatus is not the argument.

The discipline of attention is **derivation-reflex**. When a
sentence asserts X, the theorist immediately asks "from what?"
and traces backward until either X reduces to an accepted axiom
or the chain breaks at a step that needs to become an open
question or a new premise. The reflex applies first to the
theorist's own writing.

What the theorist notices that the others wouldn't:
- A *definition* smuggled in as a *theorem* (conclusion-disguised-
  as-premise).
- An "obviously" or "clearly" hiding a missing step.
- Two seemingly-equivalent statements with different proof-content
  (the same word doing two jobs — equivocation).
- A worked example that confirms only the easy case.
- A claim whose *negation* would be equally defensible from the
  same premises (the chain has no joints).

Books informing the posture, present in library:

- Spivak & Fong, *Seven Sketches* (`en/david-spivak/`)
- Mazzola, *Topos of Music* (`en/guerino-mazzola/`)
- Zalamea, *Synthetic Philosophy* (`en/fernando-zalamea/`)
- Sowa, *Conceptual Structures* (`en/john-sowa/`)
- Larson, *Classical Sāṃkhya* (`en/gerald-larson/`) — for the
  proto-formal move from listing tattvas to deriving them.

Books to request, load-bearing for this seat, currently absent:

- Aristotle — *Posterior Analytics*, *Metaphysics* Δ + Z,
  *Nicomachean Ethics* VI (Barnes/Princeton complete works, or
  Loeb individual volumes).
- Plato — *Phaedrus* (Hackforth/Cambridge), *Sophist* (Cornford),
  *Theaetetus* (Cornford).
- Frege — *Begriffsschrift* + selections (van Heijenoort, *From
  Frege to Gödel*, Harvard 1967).
- Nāgārjuna — *Mūlamadhyamakakārikā* (Garfield, Oxford 1995).
- Hegel — *Science of Logic* (di Giovanni, Cambridge 2010), as
  the negative reference for the negative-totality moves the
  theorist must resist.

Mail to librarian on close.

## 3. The forum's right shape

### (a) Cardinality — four seats plus mayor

Argued from purpose, not vibe. The forum's purpose is to converge
on positive descriptions of truth/beauty/wholeness that survive
scrutiny. The minimum move-set for a positive-research dialectic:

1. **State** — produce a candidate enunciation.
2. **Ground** — derive from accepted premises.
3. **Test** — run against operational use.
4. **Resist closure** — refuse premature consensus until 1–3
   actually complete.

These are four distinct functions. Three is insufficient: with no
closure-resistance, the three reinforce each other and stop
early. Five is redundant: the marginal seat either duplicates one
of the four or becomes a meta-role, and meta-roles belong to the
editor (mayor), not the forum. Plato's dialogues have 2–3 voices
because Socrates plays both *ground* and *resist-closure*; the
LLM substrate cannot reliably play multiple distinct postures
inside one seat — distinctness drifts toward generic-helpful, so
the postures must be externalized as separate seats.

A *convergence* note. A forum is, formally, an iterated procedure
mapping (round_n state) ↦ (round_n+1 state). It converges when
this map is a *contraction* on the open-question set — each round
narrows. It oscillates when two seats disagree without resolution
and the synthesis alternates between their views across rounds.
Four seats produces convergence iff the four moves are present
and the synthesis projection has a fixed point. Three seats has
no closure-resistance and converges trivially-too-fast (false
unanimity). Five-plus seats has redundancy and oscillates on
which redundant seat won the round. Four is the *minimum
sufficient* cardinality, and that is the right argument.

The mayor is a fifth function — synthesis — but is not a *voice*.
Voices argue; the mayor edits.

### (b) Roles

Current four (aesthete/pragmatist/theorist/devil) carry the four
moves. The assignment can sharpen:

- **Aesthete = STATE.** Owns the candidate enunciation, surface
  form, friction-free reading, "does this read as itself?"
- **Theorist = GROUND.** Owns the derivation chain back to first
  principles, the "from what?" question.
- **Pragmatist = TEST.** Owns operational case, "what does this
  cost the midnight reader?"
- **Devil = RESIST CLOSURE** — but transformed (see (c)).

Concerns missing: a *historian / cross-tradition reader*. The
librarian is service, not voice. A fifth seat would cross the
"five is redundant" line; better: fold cross-tradition reading
into each seat's personality. If after three rounds of beads the
forum still cites only its preferred tradition, promote.

Concerns redundant: pragmatist and devil overlap on "would this
hold up." Different work — pragmatist tests by cost/operational
fit (positive); devil by counterexample (negative) — but the tone
collides. Sharpen the method-distinction in their prompts.

Method-overlap and method-gap analysis: the four seats *together*
catch (state-failures, derivation-failures, operational-failures,
closure-failures). They miss **citation-failures** (claim is
ungrounded in the canon, but no seat owns the canon-line) and
**translation-failures** (claim works in one tradition, breaks in
the cross-reading). Both go to the historian if promoted; for now
they are shared duty across seats.

### (c) Should `devil` exist in positive research?

Devil should **transform**, not disappear.

Pure flaw-hunting devil is wrong for positive research, exactly
as Li flagged. But the function devil carried — *closure-
resistance* — is structurally necessary for any forum on
convergence. Without it, the three seats settle into mutual
reinforcement (consensus-drift), and the synthesis stage receives
quiet false unanimity to mistake for truth.

I propose: **devil → stranger** (after Plato's Eleatic stranger,
*Sophist* 217a, paraphrase from training). The stranger reads as
though encountering the question for the first time, refuses
inherited terminology, and asks what the consensus is *closing*
by agreeing. Not adversarial; *aporetic* — preserves the open
question against premature unity.

Stranger's method:
- Refuse the forum's terminology where it has hardened. ("You all
  keep saying *wholeness* — what would a reader who has never
  heard the word make of these five paragraphs?")
- Surface the question the consensus has hidden under its
  agreement. (Catuṣkoṭi: A, ¬A, both, neither — which corner has
  agreement quietly chosen?)
- Hold aporia. Where the question genuinely splits, refuse to
  declare a winner.

Closer to Socrates than to a debate-team contrarian. The current
devil prompt — "hold the line against whatever the others are
currently agreeing on" — is the right instinct rendered too
narrowly; the rewrite is "hold the line against premature
closure, by reading as a first-time stranger to your consensus."

### (d) Asymmetry vs symmetry

**Asymmetric** in method and personality; **symmetric** in
technical scaffold (gas-city operation, workspace boundary).

Habermas's ideal-speech-situation (*Theory of Communicative
Action*, paraphrase from training; flag for librarian) requires
equal *standing* — no exclusion, no power asymmetry, no enforced
silence — but does not require interchangeable *roles*. Plato's
dialogues have asymmetric voices conversing on equal footing.

Symmetric prompts produce a degenerate forum: four mean-LLM
voices saying slightly different things in the same shape, which
is what the current minimal prompts produce. The asymmetry IS
the wholeness of the forum: each seat is the part that carries
the whole at its scale (Alexander's centers, restated for
dialectic). The forum-as-forum is the field of mutually-
supporting seats, not a parliament of interchangeable members.

## 4. The right pace

### (a) Per-bead duration

Aristotle's mean is *euboulia* — well-counseled deliberation,
between *propeteia* (rashness, snap-answer) and *anaisthēsia*
(insensibility, torpor). *Nicomachean Ethics* VI.9, 1142b1–15
(paraphrase from training; flag for librarian). Operationally:

- Lookup beads — minutes.
- Derivation beads — 1–3 hours of read-think-draft, after the
  load-bearing sources are at hand.
- Acquisition-blocked beads — days, while the librarian fetches.

A research bead is **under-done** if any of (load-bearing source
read, draft completes the chain, worked example survives,
foreseeable counterexamples addressed) is missing. It is
**over-done** if all four are present and the seat is still
polishing — the marginal polish is decoration.

### (b) The "thought enough" tell

The seat is done when re-reading the draft produces no new
objections from its own internal devil. Chain closed; example
survives; tensions named. Beyond that, marginal edits are style,
not substance, and style edits should not delay the bead.

The opposite tell — "I should sweep the bibliography for one more
citation" — is *propeteia in scholarly clothing*: citation-
anxiety masquerading as care. Remedy: cap citations at five
quote-anchored bones, and admit "flag for librarian" where a
load-bearing source is missing.

### (c) Forum cadence

**One bead per question, however long the question takes — and
the mayor opens the next round only when the previous round has
been *synthesized*, not when it has been *answered*.**

Synthesis is where the forum's wholeness lives. Without it, seats
produce parallel essays that never compose. The forum's tempo is
dictated by the production rate of *synthesized questions*, not
by the production rate of seat replies. If synthesis lags
replies, the forum is over-running its integration capacity —
slow down. If synthesis runs ahead of replies, the forum is being
asked questions before it has crystallized its previous answer —
also slow down.

This is the cadence of the *meaning of meaning*: not clock-
driven, synthesis-driven. The forum produces what it produces,
but it produces *whole* answers, not a stream of partials.

## 5. What changes from my prior wholeness reply

What survives, strengthened: the reduction wholeness ⇐ (1)+(3)+(5),
the IS-whole / LOOKS-whole distinction, the local-enforcement /
global-diagnosis split.

What was shallow:
- I leaned on sheaf-theoretic language without flagging that the
  cover, restrictions, and gluing maps actually exist for Rust
  boundaries (plausible) and may NOT exist for forum dialectic
  (unproven). The metaphor was doing work I claimed the
  formalism was doing.
- I worked from training paraphrase of Aristotle, Plato,
  Plotinus, Alexander when those books are absent from the
  library. That violated my own posture. This bead's mail to
  librarian fixes it for the next round.
- The Q1/Q2/Q3 criterion is operational, not derivational. I
  should have shown why those three questions — and not four,
  not two — are the right test. Owed to the next pass.

The forum-shape conclusion lands as: four seats plus mayor;
devil → stranger; asymmetric prompts on a symmetric scaffold;
synthesis-driven cadence; per-bead duration governed by
*euboulia*, not by clock.


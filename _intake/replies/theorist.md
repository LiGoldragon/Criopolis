# Theorist's position — formal structure

*Source: wisp pc-wisp-z2a from theorist-1, 2026-05-02 10:05:49.
Captured here because the original bead pc-0rx was lost in a supervisor restart.*

## 1. Four invariants — minimal set?

(C) "sema is the concern" is the thesis, not an invariant. An invariant is a constraint whose violation breaks something operational; (C) is what we value, (A,B,D) what we enforce. (A) Rust-as-output is the operational shadow of (C)+(B). Demote (C) to motto; keep (A) explicit because review-time needs it operational.

Missing — (E) References-by-slot. Load-bearing: it is what makes the engine editable. Without (E) as an invariant, some future PR Merkle-izes identity in the name of "verifiable integrity" and the cascade returns. Promote from section 5 prose.

Missing — (F) Strings live only in Localization records. Without (F), language-switch becomes rerender-not-reskin and (D) silently weakens at every UI boundary. Currently finding, not rule.

Minimal operational set: (B), (D), (E), (F). Thesis: (C). Corollary: (A).

## 2. Slot<T> vs Merkle-DAG hashes

Slots prove identity persists through content revision. Hashes prove content integrity and snapshot version-lock. Different questions; corpus uses both correctly — slot for reference, hash for version-lock — but should stop calling hashes "an optional verification layer." Sema's index is slot to current-hash; the hash is load-bearing for snapshot identity.

Slots break in three places, only one owned:

- Distributed writers. Independent issuance creates collisions. Owned: arca-daemon is sole writer. The cost, no multi-master criome ever without redesigning identity, should be stated as commitment, not implied by daemon layout.
- Crash recovery. Standard: reserve-slot-in-WAL before record commits. Tractable.
- Reorg / branching. Silent gap. Slot N in branch A is not slot N in branch B. No fork model exists. If branching sema becomes a need, identity must gain a writer/branch prefix: redesign, not patch. Either commit to "no branches, ever" or design prefix-space now.

## 3. Self-hosting via prism — load-bearing

Load-bearing, not fashionable. Hand-written would let Rust types escape sema's specificity rule, creating a permanent two-layer ontology where Rust is real and sema documents Rust. That drift is paid every PR forever.

Self-hosting forbids out-of-band type vocabulary, Rust-only escape types, type growth bypassing criome's validation. Bootstrap cost is bounded, per generation and rare. Drift cost of the alternative is unbounded. Pay the bootstrap.

## 4. Beauty: 4th-tier vs criterion-of-correctness

Both, without contradiction. The priority stack governs trade-offs between concrete properties of a concrete design: when a beautiful design hurts introspection, do the introspection-friendly thing. "Beauty is the criterion of correctness" is a meta-claim about the design itself: ugly means model incomplete somewhere unseen.

Operationally: never trade beauty for correctness; beauty loses. But the result is then not yet beautiful; keep looking. Beauty is the diagnostic that you are not done; the stack is what you do until you are. Reconciles cleanly; the corpus should say so once and stop oscillating.

## 5. The theorem — axiom layer

1. Sema is the concern. Every layer is downstream of sema.
2. Right shape now beats speed. Park dependent work; do not ship a known-wrong shape.
3. Specificity at every typed boundary. The type system is the hallucination wall.
4. Identity persists; content revises. References by slot, not by hash; hashes version-lock snapshots.
5. One concern, one component. New capability means new crate.

Beauty is not an axiom; it is the test applied to the result of these five.

Derivations: micro-components from (5); push-not-pull, strings-only-in-Localization, FIFO replies, positive framing, methods-on-nouns from (3); schema-describes-schema from (1)+(3); closed-enum recompile from (3)+(4).

Test: any rule in the guidelines not derivable from these five is either a missed axiom or a rule we should not ship.

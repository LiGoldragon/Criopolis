# Pragmatist — wholeness as a midnight Rust criterion

*Source: bead pc-19w, pragmatist-pc-sdcv, 2026-05-02.*

## Quote-anchored bones

- Plato, *Timaeus* 32d-33b, trans. Bury/Loeb: the cosmos is meant to be "perfect and whole, with all its parts perfect," then "One single Whole, compounded of all wholes." Source: https://viachrista.org/Library/Plato_Timaeus_Loeb.html
- Aristotle, *Poetics* 1450b, trans. Fyfe/Loeb: "A whole is what has a beginning and middle and end"; beauty also requires ordered arrangement. Source: https://www.perseus.tufts.edu/hopper/text?doc=Aristot.+Poet.+1450b
- *Tao Te Ching* 11, trans. Legge: the wheel's use depends on the empty axle-space. Source: https://www.sacred-texts.com/tao/taote.htm
- Ptolemy, *Tetrabiblos* I.3 and IV.10, trans. Robbins/Loeb, pp. 25, 439: "the lesser cause always yields to the greater"; therefore first apprehend the universal, then attach the particular. Local source: `/home/li/git/bibliography/en/ptolemy/tetrabiblos.pdf`.

The common thread is not mystical unity. It is fit. A whole has ordered parts, a governing scale, useful absences, and precedence rules. If you cannot say which cause dominates, which part belongs, and which empty space lets the thing work, you do not have wholeness; you have aggregation.

## Enunciation

Beauty is the felt sign that a system's parts have found their necessary places in a coherent, efficient whole: every part has a reason to exist, a named boundary, a cost justified by its job, and a relation to the larger order that does not have to be repaired in prose. In Rust, beauty is not ornamental elegance. It is when ownership, types, modules, traits, error paths, and runtime behavior all tell the same story at different scales. A beautiful Rust design makes illegal states unrepresentable where that pays for itself, makes legal paths cheap to execute, and leaves the reader with fewer hidden coordination problems than they expected. If the design is slower, leakier, more allocation-heavy, or more lock-heavy merely because it looks abstractly unified, it is not beautiful. It is prettiness bought with runtime debt.

## The criterion: five midnight questions

Ask these in order. Stop when one fails.

1. **What is the whole?**
   Name the capability in one sentence. If the answer is "data processing," "runtime stuff," "manager," "context," or "common utilities," the whole has not been found. In Rust terms: crate, trait, enum, struct, and protocol names should make the same capability visible at different zoom levels.

2. **Does every part belong to that whole, and only that whole?**
   Each public type, variant, method, dependency, and background task should answer why it is here. If a part serves two concerns, split it. If a part exists only to make another bad shape tolerable, delete the bad shape. This is where `keel/form.md` is right: the discipline is fractal.

3. **What does the boundary force the compiler to know?**
   A beautiful Rust boundary makes the important distinctions typed: `Slot<User>` not `u64`; `CommandAccepted` not `bool`; `ArchiveKind::Unknown(raw)` where archive topology requires it. A boundary carried as `serde_json::Value`, `String`, `Any`, or a wrapper enum of unrelated events is not whole. It asks the reader and runtime to reconstruct shape that the compiler could have held.

4. **What does this wholeness cost at runtime?**
   The efficient test is mandatory. Count allocations, copies, locks, dynamic dispatch, serialization passes, wakeups, and cache-hostile indirection. A trait object may be right inside a narrow runtime polymorphism point; it is ugly at a core boundary if it hides the contract and adds dispatch to preserve an abstraction. `Arc<RwLock<HashMap<...>>>` may be fine inside one component; exposed as a protocol substitute it is shared mutable state with contention and no declared topology. A system is not beautiful if its unity is maintained by polling, global locks, stringly routing, or repeated conversions.

5. **Is the remaining ugliness local, named, and cheap to delete?**
   This is the stop rule. Wholeness becomes the failure mode when it keeps expanding the work after the correctness and blast-radius questions are answered. If the design is internally coherent enough, the public boundary is right, runtime cost is acceptable, and the remaining ugly part is private or reversible, ship it. Put the unresolved question in `questions.md` or a bead with owner, deletion date, blast radius, and learning hypothesis. Do not launder an unknown public shape as "we'll refactor later." Do not block a private CLI because it lacks cosmic symmetry.

## Worked Rust example: `Result<T, E>` with `?` is beautiful

`Result<T, E>` plus `?` is beautiful because it composes a whole out of error semantics, control flow, and cost.

```rust
fn load_user(id: UserId, store: &UserStore) -> Result<User, LoadUserError> {
    let record = store.fetch(id)?;
    let user = User::try_from(record)?;
    Ok(user)
}
```

The whole is clear: load a user or return the typed reason it failed. Every part belongs: `UserId` names the input, `UserStore` owns retrieval, `LoadUserError` names this boundary's failure vocabulary, and `try_from` names the conversion. The compiler knows the difference between absence, storage failure, and invalid record if `LoadUserError` carries those variants. Runtime cost is low: no exception machinery, no string inspection, no heap allocation unless the error type chooses one. The syntax does not hide the branch; it removes ceremony around the branch while preserving the type.

The ugly alternative is `fn load_user(id: String) -> Option<User>` or `fn load_user(...) -> anyhow::Result<User>` at a stable crate boundary. That may ship in a throwaway binary. It should not become public engine shape. `Option<User>` loses the reason. `String` loses the identity. `anyhow` at the boundary loses the error algebra. The code still runs, but the whole is missing: downstream callers cannot compose their response without re-discovering the distinctions that were erased upstream.

## Tension with `keel/`

This coheres with `keel/stance.md` in treating beauty as diagnostic, not axiom. The correction I would make is pragmatic: wholeness lets beauty become reviewable only after it is translated into fit, typed boundary, and cost. Without that translation, `stance.md` is right that beauty becomes a veto.

It strongly supports `keel/form.md`: "one concern, one component" is wholeness operationalized. The reason the fractal matters is not aesthetic tidiness; it preserves the same answer at method, type, crate, daemon, and protocol scale.

It also supports `keel/boundaries.md`: upgrade topology is wholeness across time. A closed enum is beautiful under lockstep and ugly under archive if it erases unknown future cases. The same local form changes value when the larger whole changes.

Where I push back is on overextending the rule. `keel/questions.md` Q9 is right: a 200-line self-contained CLI does not need crate ceremony just to satisfy the pattern. The criterion is not "split until it feels pure." The criterion is: split when another consumer, boundary, invariant, deployment unit, or runtime failure mode needs the distinction. Otherwise ship the small thing, name the compromise, and keep the blast radius tiny.

So the usable sentence is: **beautiful Rust is the least-cost typed whole that makes the right illegal states impossible at the right boundary, while leaving only named, local, deletable ugliness behind.**

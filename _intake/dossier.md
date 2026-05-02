# Dossier — workspace design corpus

*Working intake for the philosophy-city engineering-guidelines project.
Mayor's reconnaissance digest of `~/git/workspace` + `~/git/workspace/repos/`.
Source material, not output. Seats use this to orient quickly; final
guidelines land elsewhere in `~/philosophy-city/`.*

---

## What the corpus IS

A multi-repo design corpus for the **criome sema-ecosystem** —
a content-store + record-engine + GUI shell stack written in Rust,
deployed via Nix flakes onto NixOS hosts. The workspace meta-repo
holds the design corpus + decision history; each canonical repo
carries its own `ARCHITECTURE.md`; cross-cutting rules live in `lore`.

Project posture: **world-supersession scope**. Right shape now beats
speed. Backwards-compat is *not maintained* until a boundary is
formally declared. Until then, the engine is being *born*.

## Source pointers (read these for verification)

- `~/git/lore/INTENTION.md` — what the project is for.
- `~/git/lore/AGENTS.md` — workspace contract (canonical for cross-project rules).
- `~/git/lore/programming/` — programming discipline (beauty, abstractions, micro-components, naming, push-not-pull).
- `~/git/lore/rust/` — Rust style + rkyv conventions.
- `~/git/criome/ARCHITECTURE.md` — engine architecture (the §2 four invariants are load-bearing).
- `~/git/workspace/AGENTS.md`, `ARCHITECTURE.md` — workspace meta-repo carve-outs.
- `~/git/workspace/reports/122` — schema-as-records architecture.
- `~/git/workspace/reports/124` — schema brainstorm (live exploration).
- `~/git/workspace/reports/125` — session handoff (recent state).
- Per-repo `ARCHITECTURE.md` under `~/git/workspace/repos/<repo>/`.

---

## Distilled findings

### Foundational

- **Right shape now > speed to market.** Unbuilding a wrong shape costs more than the speed it bought. Dependent work *parks* rather than using a temporary workaround. (lore/INTENTION.md)
- **Priority stack: clarity → correctness → introspection → beauty.** Decisions compromising visibility are wrong even if they improve performance. (lore/INTENTION.md)
- **Beauty is the criterion of correctness.** Ugliness signals an unsolved underlying problem. "If it isn't beautiful, it isn't done. If you can't make it beautiful, you don't understand it yet." (lore/programming/beauty.md)
- **Positive framing only.** Architecture states what IS, not what isn't. "No X" rules are reframed as "Must be Y". Rejected paths live in jj/git history.

### Typing & ontology

- **Perfect specificity at every typed boundary.** Every boundary names exactly what flows through it. No wrapper enums mixing concerns. The type system is the hallucination wall. (criome/ARCHITECTURE §2 D, signal/ARCHITECTURE)
- **Slots, not hashes, for identity.** Records reference each other by `Slot<T>` (per-kind monotone counter), not content hashes. Avoids Merkle-DAG cascades on edits. Hashes are an optional verification layer. (criome §2 B, sema)
- **One record kind = one closed Rust struct.** New kinds land by struct + closed-enum variant + recompile.
- **Strings live exclusively in Localization records.** Sema is string-free; UI re-skins on language switch without touching non-Localization records. (reports/122)
- **Schema describes schema (self-hosting).** Bootstrap.nexus → criome → sema → prism → Rust source → rustc → new binary. The type vocabulary is data the system stores. (reports/122 §7)

### Architecture & layering

- **Four invariants** (criome §2): (A) Rust is only output, no .rs→sema. (B) Nexus is a request language, not a record format; signal is the wire end-to-end. (C) Sema is the concern; everything orbits. (D) Perfect specificity at every boundary.
- **Micro-components: one capability, one crate, one repo.** Components fit in one LLM context window (~3k–10k LoC). Adding a feature defaults to a new crate. (lore/programming/micro-components.md)
- **Components communicate through typed protocols, not shared state.** No `pub use` leaking internals. No cross-crate `unsafe`. No shared mutable state.
- **No module boundaries within a crate.** Filesystem boundaries are the only enforcement that holds; in-crate modules decay under deadline pressure.
- **Signal layering**: base `signal` + `signal-forge` (Build/Deploy verbs) + `signal-arca` (Deposit/ReleaseToken verbs). Front-ends depend only on `signal`.
- **Four daemons, strict division of labor**: nexus (text↔signal translator), criome (validates+persists, never touches binary bytes), forge (linker+executor), arca-daemon (privileged writer, sole owner of the store).

### Wire & protocol

- **One text construct ↔ one typed value.** Mechanical translation; parser produces precise typed payload. No generic intermediates.
- **FIFO replies, not correlation IDs.** N-th reply answers N-th request on the connection. Order is the invariant.
- **rkyv 0.8 with pinned features** (`std + bytecheck + little_endian + pointer_width_32 + unaligned`).

### Type design idioms

- **Every reusable verb belongs to a noun.** Methods on types, not free functions. Forces "what type owns this verb?" If unclear, the model is incomplete. (lore/programming/abstractions.md)
- **The wrong-noun trap.** A verb belongs to the noun whose *concern* matches; type-adjacency ≠ concern-adjacency.
- **Wrapped field is private.** A newtype like `Slot(u64)` with `pub` field defeats every reason to wrap.
- **Full English words.** Cryptic abbreviations save keystrokes once, cost mental lookup at every read. Exceptions: tight loops, math, generic params, std-acronyms passed in (id, url, json).

### Naming

- `<repo>` for the lib name; `<repo>-daemon` for long-running daemons; `<repo>-<verb>` for one-shot pipeline binaries (~30 LoC each, live in same crate).

### Tooling & process

- **jj on git for VCS.** Always push after every logical commit (`jj git push --bookmark main`). Unpushed work is invisible to flake-input consumers.
- **No deep github URLs in cross-references.** Use prose ("criome's `ARCHITECTURE.md`") or `github:ligoldragon/<repo>`. Deep URLs silently 404 on rename/move.
- **Documentation layers, strictly separated.** Project ARCHITECTURE.md (prose+diagrams, no code) → workspace ARCHITECTURE → per-repo ARCHITECTURE (50–150 lines) → reports/NNN-*.md (decisions in flight, no code) → source.
- **Reports use visuals, not code.** Code in design docs goes stale immediately; readers can't tell which is authoritative. ASCII diagrams, swimlanes, tables.
- **Reports rolling soft cap ~12.** Beyond cap, trigger rollover: roll into successor / implement (move to architecture) / delete. Default to deletion.
- **`bd` for short items, files for design.** Issues, tasks, mail in beads. Designs and reports in files.
- **AGENTS.md hierarchy thin.** Per-repo AGENTS.md = thin shim ("read lore/AGENTS.md") + repo-specific carve-outs. CLAUDE.md = one line.

### Anti-patterns called out

- **No polling.** Polling encodes consumer pacing into producer protocol. Worst-case latency = interval. A "for now" poll never gets removed. Real-time features *wait* for the right push primitive. (lore/programming/push-not-pull.md)
- **No status files.** Discover state from the live process table; PID files lie when stale.
- **No Rust-source parsing into sema.** Sema changes only via nexus requests.
- **No shared mutable state.** Typed protocols are the only joint.

### Engineering culture (signals of ugliness)

Per beauty.md / style.md, code is ugly when:
- Non-English names (`pf`, `de`, `kd`)
- `pub` field on a wrapper newtype
- Free function that should be a method
- Dead code retained "for safety" or backwards-compat
- Special cases stacked on the normal case
- Stringly-typed dispatch
- Doc comment explaining *what* (good naming makes it obvious)
- Boolean parameter at a call site
- Negative names (`non_root`, `not_admin`)
- Long functions with multiple responsibilities

---

## Tensions / open questions in the corpus

1. **Beauty rank: 4th or 1st?** INTENTION ranks beauty *after* clarity/correctness/introspection. beauty.md calls it "the criterion of correctness." In practice they reconcile (beauty as diagnostic of underlying truth), but the framing tension is real.
2. **Localization-store ownership.** Live unresolved decision. Blocks UI label rendering.
3. **Single record kind w/ optional fields vs split kinds.** Ergonomic vs type-enforced invariants.
4. **Bootstrap source: file vs compile-time constants.** Atomic-with-binary vs schema-as-data even at boot.
5. **Closed enums force recompiles on kind growth.** Treated as a feature ("the world moves forward together"), not a cost. Devil's worth a look.
6. **Micro-components require discipline.** Filesystem boundaries hold under pressure where module boundaries don't, but require habit.

## Recurring motifs

- **Dog-fooding as design verification.** Self-hosting at every layer.
- **Type system as the hallucination wall.** Load-bearing, not convenience.
- **Composition through typed protocols.** Architecture's joints are messages, not in-memory data.
- **Beauty as diagnostic.** Aesthetic discomfort is a real reading.
- **Micro = macro.** Same discipline at every scale (method-on-type, capability-per-crate, daemon-per-concern).
- **Rejection of premature compatibility.** The engine is being born, not maintained.

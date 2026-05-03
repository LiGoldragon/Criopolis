# Satya reply: repos under ghq

## Position

The isolated claim is not "ghq is tidier"; it is: for this city, treating `/git/<host>/<owner>/<repo>/` as the canonical home for repository-shaped work will make repository identity and lookup more truthful than the present split between `/home/li/philosophy-city` and `/git`, provided the migration updates absolute-path references and preserves the distinct repo identities of philosophy-city, keel, and library/bibliography. On the observed facts, I vote yes, strong-for: the current state already uses `/git` as the ghq root and already places the running Gas City source neighbors there, while the city itself remains an exception. The exception is not false by itself, but it makes the answer to "where is the source of this system?" depend on which part of the system is meant. That is a correspondence failure waiting to recur.

## Source bones

- Local observation, 2026-05-03: `ghq root` returns `/git`; `ghq list` returns 318 entries; `ghq list --full-path` shows no `LiGoldragon/philosophy-city`, `LiGoldragon/keel`, or `LiGoldragon/bibliography`; `git rev-parse --show-toplevel` identifies `/home/li/philosophy-city`, `/home/li/philosophy-city/keel`, and `/home/li/philosophy-city/library` as separate worktree roots; `jj root` also identifies `/home/li/philosophy-city/library`. Role: perception warrant for the present split.
- Local observation, 2026-05-03: remotes are `git@github.com:LiGoldragon/philosophy-city.git`, `git@github.com:LiGoldragon/keel.git`, and `git@github.com:LiGoldragon/bibliography.git`. Role: perception warrant that the proposed ghq layout has determinate target paths; library's repo-name target is probably `bibliography`, not `library`.
- `_intake/system-inspection.md`: identifies running-adjacent source clones at `/git/github.com/gastownhall/gascity/`, `/git/github.com/gastownhall/beads/`, and `/git/github.com/LiGoldragon/gascity-nix/`. Role: testimony warrant that the Gas City toolchain already follows the `/git` convention for its readable upstream sources.
- `_intake/explorer/pc-ttzm-criome-ecosystem.md`: reports another active repository population under `/home/li/git` and explicitly notes ghq points at `/git`. Role: evidential warning that repo-location is already a split convention; this supports the problem statement, not the exact implementation.
- `library/en/aristotle/metaphysics-ross.txt`, Metaphysics Gamma.7. Role: correspondence restatement; the vote must say of the current path facts what they are, not ratify the attractive word "canonical."
- `library/en/aristotle/posterior-analytics-mure.txt`, Posterior Analytics I.2. Role: premise audit; "better" must rest on premises prior to the conclusion, here the observed single ghq root, the existing toolchain clones under it, and the determinate Git remotes, not on a circular claim that ghq is better because it is canonical.

## Falsification ledger

- Decisive: a migration inventory finds unenumerable or runtime-generated absolute references to `/home/li/philosophy-city` such that the city can only keep working by preserving the old path as the real operational anchor.
- Decisive: a staged move of one low-risk clone under `/git/github.com/LiGoldragon/...` cannot preserve repo identity, bead access, hooks, and supervisor invocation without changing the meaning of the repo or its rig boundary.
- Evidential: a future-inheritor rehearsal finds the old top-level path faster and less error-prone than the ghq path after both are documented with equal clarity.
- Evidential: `/git` proves too noisy in practice, so `ghq list` without a curated manifest makes the city harder to find than the present exceptional top-level directory.
- Heuristic: the library/bibliography naming mismatch causes repeated human or script confusion; this would not refute the `/git` rule, but would force a naming decision before migration.

## Worked example

A new operator asks where the running system's source lives. Today the accurate answer has branches: Gas City source and beads are under `/git/github.com/gastownhall/...`, gascity-nix is under `/git/github.com/LiGoldragon/gascity-nix`, but the live city is under `/home/li/philosophy-city`, with keel and library nested beneath it as separate repos. Under the proposed rule, the answer has one form: look under `ghq root`, then host, owner, repo. Philosophy-city, keel, and bibliography can each be found by remote identity. The remaining operational question is not truth-location but orchestration: whether the city wants the rigs nested for runtime convenience or sibling clones plus explicit settings.

## Open question

Should `library/` migrate by directory role as a nested sub-rig under philosophy-city, or by remote identity as `/git/github.com/LiGoldragon/bibliography/` with the city referencing it explicitly?

## Vote

yes / rule, recommendation-backed / strong-for. If accepted, this ricochets into a second proposition: the migration should include a manifest of canonical repo identities and local role names, because `library` as city role and `bibliography` as remote repo name are already two truths that must not be blurred.

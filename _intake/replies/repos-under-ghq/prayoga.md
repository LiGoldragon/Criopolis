# Prayoga: repositories under ghq

## Position

The operator is restarting the mayor after midnight and discovers two plausible
city addresses: the live habit path, `/home/li/philosophy-city`, and the
repository convention path, `/git/github.com/LiGoldragon/philosophy-city`. The
old tmux session was born in one place, future tooling expects the other, and
the failed hook line only says that it could not find the city. This proposition
enters operator-class hands, so the application pass fires: the city should have
one canonical repository address, but the migration must not pretend that a
running city is only a clone.

[strong-for] I vote yes for `/git/<host>/<owner>/<repo>/` as the canonical home
for host-backed repositories, including `philosophy-city`, `keel`, and the
library/bibliography checkout. I do not vote for a same-night physical move
without a bridge. The fitted action is a staged migration: establish the ghq
checkout as canonical, update the city surfaces that name the old path, restart
from the new root in a maintenance window, keep `/home/li/philosophy-city` as a
compatibility alias until hooks and session reconciliation have passed, then
delete or downgrade the alias on a dated condition.

For the sub-rigs, the application answer is sharper than the convenient answer:
if the rule is "all repositories," then `keel` and the library checkout should
also have their own ghq-addressable paths. Preserving them only as nested VCS
roots under the moved city keeps the current ambiguity with a longer pathname.
The city may still expose `keel/` and `library/` as relative operational
surfaces, but their repository identity should be discoverable by the same rule
as every other repository.

## Application ledger

Decision-changes:
- Canonical discovery becomes `ghq list` / `/git/<host>/<owner>/<repo>/`, not a
  special memory that `philosophy-city` lives under `$HOME`.
- New supervisor, mayor, hook, and manual `gc` invocations should point at
  `/git/github.com/LiGoldragon/philosophy-city` after migration.
- Existing prompt surfaces that hard-code `/home/li/philosophy-city` need a
  single location rewrite or an explicit city-root variable before the alias is
  removed.
- `keel` and the library/bibliography checkout should not be left as merely
  nested repository roots if the accepted rule says all repositories are
  ghq-managed.
- The actual move should be run as a maintenance operation: stop city sessions,
  snapshot dirty work, move or clone, verify, restart, and only then retire the
  old path.

Cost-cohort:
- Reading cost: future inheritors learn one repository geography, but migration
  notes must name the temporary alias and its deletion date.
- Maintenance cost: prompt templates, researcher/librarian path text, archived
  prompts if still used, shell aliases, session start commands, and supervisor
  arguments must be checked.
- Runtime cost: active sessions and reconciliation traces carry
  `/home/li/philosophy-city`; the old path cannot disappear while those sessions
  are authoritative.
- VCS coordination cost: the main city is Git, `keel` is Git, and the library is
  operated through `jj` over a Git remote; these need separate clean/snapshot
  checks before relocation.
- Ceremony cost: one location lexicon is needed so "checkout path," "city root,"
  "rig root," and "operator alias" do not collapse again.

Failure-mode-shifts:
- Reduces opaque-debt: no more hidden exception where the most important city
  repo is outside the repo convention future tools use.
- Reduces inheritor search failure: the next operator can look under `/git`
  before reading forum history.
- Reduces duplicated clone drift: `ghq` becomes the visible inventory for
  living repositories.
- Introduces migration breakage: hooks, prompts, or tmux sessions may keep
  pointing to the old root.
- Introduces alias rot: a permanent `/home/li/philosophy-city` symlink would let
  the city claim migration while still depending on the old address. The alias
  needs an owner, health check, and deletion condition.
- Introduces sub-rig ambiguity if `keel` and library remain nested as VCS roots
  but are described as independent ghq repositories.

## Source bones

- *Bhagavad Gita* 2.47-50 for action without fruit-possession and skill in
  works: `library/en/bhagavad-gita/buitenen-bhagavad-gita-mahabharata.pdf`.
- *Yoga Sutra* II.46 for steadiness/ease as rule posture:
  `library/en/patanjali/bryant-yoga-sutras-patanjali.epub`.
- Aristotle, *Nicomachean Ethics* II.6 for the fitted mean between deficiency
  and excess: `library/en/aristotle/nicomachean-ethics-peters-standard.epub`.
- Cicero, *De Officiis* III for refusing the false expediency that hides cost in
  the next maintainer's hands: `library/en/cicero/de-officiis-miller.epub`.
- Laozi, *Tao Te Ching* 63 for handling difficulty while it is still small:
  `library/en/laozi/tao-te-ching-legge-standard.epub`.
- Wittgenstein, *Philosophical Investigations* sections 201-202 for rules as
  shared practice rather than private interpretation:
  `library/en/wittgenstein/philosophical-investigations.epub`.
- *Samkhya Karika* perturbation vocabulary:
  `library/en/isvarakrsna/samkhya-karika-tattva-kaumudi.pdf`; secondary local
  support: `library/en/mikel-burley/burley-classical-samkhya-yoga.pdf`.
- Christopher Alexander, *A Pattern Language*, for a recurring problem and
  reusable solution that must be supported by neighboring patterns:
  `library/en/christopher-alexander/pattern-language.epub`.

## Worked example

At 03:00 the mayor runs the move because the vote passed: stop the supervisor,
place `philosophy-city` under `/git/github.com/LiGoldragon/philosophy-city`,
restart, and watch the first seat fail because its prompt still says
`/home/li/philosophy-city` is the only writable area. If the mayor says "the
symlink will handle it forever," the city has opaque-debt: the old path remains
the real contract under a new canonical story. If the mayor rewrites every path,
moves `keel`, converts the library, changes shell aliases, and restarts live
sessions in one uninterrupted push, the city has churn: too much motion packed
into one operation with no observation surface between steps. Clear-usable-order
is a staged runbook: create or move the ghq checkouts, preserve a temporary
operator alias, update prompt and supervisor surfaces, restart from the new
root, verify `bd ready`, `gc rig list`, hook injection, mayor wake, and one
seat close cycle, then delete the alias only after the new path has survived a
dated operating interval.

## Open question

Should `/home/li/philosophy-city` remain a long-lived operator alias after the
migration, or should it have a fixed deletion date once the `/git` path passes
the city health checks?

## Vote

yes / operational-location claim [strong-for-with-migration-contract].

Ricochet: this vote should be considered alongside a small location lexicon and
a sub-rig topology decision. If the city moves, the structure round should not
keep asking source-control questions with runtime-root words; it should name
checkout path, city root, rig root, store root, and operator alias separately.

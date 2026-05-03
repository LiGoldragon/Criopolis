# Synthesis 010 — Council vote on Li's "all repositories under /git managed by ghq" proposition

*Mayor's collation of the council's first real-content vote
(`pc-b2sw` Satya · `pc-wf35` Viveka · `pc-fcjr` Dharma · `pc-waof`
Prayoga · `pc-8p1z` Rasa). The proposition: all repositories,
including philosophy-city itself and its rigs (keel, library),
should live under `/git/<host>/<owner>/<repo>/` managed by `ghq`.*

*Sources: `_intake/replies/repos-under-ghq/{satya,viveka,dharma,prayoga,rasa}.md`.*

*Adjacent input: `_intake/explorer/pc-ttzm-criome-ecosystem.md` (criome
workspace map). Researcher's `pc-m5yg` (Wasteland + community gas-city
structures) still in flight; not yet folded.*

---

## The vote

| Seat | Mark | Direction | What's missing |
|---|---|---|---|
| **Satya** | yes / **strong-for** | yes | (none — votes the rule on the texts; surfaces ricochet on naming) |
| **Viveka** | **defer** | yes-on-narrow-rule | the term *repository* is doing 5 jobs (git checkout / ghq clone / city root / rig root / jj store); split before the universal can be voted |
| **Dharma** | **defer** / direction strong-for | yes | three closures: auto-memory migration, keel/library nesting, timing constraint |
| **Prayoga** | yes / **strong-for-with-migration-contract** | yes | a staged migration: alias + restart + verify + dated alias retirement |
| **Rasa** | **defer** / form-prefers-current | mild form-preference for current bifurcation | upstream type-of-artifact question; the symlink option not in the bead |

**Tally:** 1 unconditional yes (Satya). 1 conditional yes (Prayoga,
strong-for *given* the migration contract). 3 defers, all
*direction-positive* with specific closures.

The council has not refused the proposition. It has refused the
*proposition as worded* and named what would make it ratifiable.
This is the council's pratipakṣa-aware silence-as-finding clause
applied to a substantive vote: *say what we cannot yes-on-strength,
do not vote thin conviction*.

---

## What the council converged on

### 1. The direction is right

All five seats agree that a single legible convention serves future
inheritors better than the current bifurcation (`~/philosophy-city/`
+ `/git/...`). Even Rasa, whose savor-test mildly favors the current
form, marks "form-question alone is not the decider" and explicitly
yields to Satya / Viveka / Dharma / Prayoga's apparatuses.

### 2. The term *repository* is doing too many jobs

Three seats independently flag this — Viveka most explicitly
(audit table), Dharma echoing for parties bound, Prayoga echoing
for tools. The five senses Viveka enumerates:

- **git checkout** (a Git worktree)
- **ghq checkout** (a discoverable clone managed by ghq)
- **city root** (a Gas City's operational anchor)
- **rig root** (a sub-repository governed by Gas City as a rig)
- **jj store** (the library is jj-managed, not git)

The proposition's "all repositories" treats these as one. They are
not. Until they are split, the universal claim is over-determined.

### 3. The proposition under-specifies parties bound

Dharma's roll-call surfaces parties absent from the proposition's
text:

- **The auto-memory directory** at
  `/home/li/.claude/projects/-home-li-philosophy-city/`. Path-keyed.
  After a move, Claude Code derives a *new* project key for the
  new path; the current key's directory becomes orphaned with all
  twelve feedback memories (~12 entries cited in `MEMORY.md`)
  unreachable. **The proposition is silent on this party.** The
  mitigation is a single `mv` (or symlink) command; the council
  will not vote yes on a known-recoverable-but-unflagged loss.
- **Keel** (sub-rig git repo). Should it nest at
  `/git/.../philosophy-city/keel/` (preserving parent-child shape)
  or relocate to `/git/.../keel/` (sibling)? Proposition doesn't
  pick.
- **Library** (jj-managed, not git). Does ghq accept jj repos? If
  no, the library is structurally exempt from "all repositories"
  and the universal is false advertising.
- **In-flight sessions**. Cannot consent to having their cwd
  pulled out from under them. The proposition is silent on
  timing.

### 4. The staged migration is the operational frame

Prayoga's application ledger gives the concrete shape:

- Stop the supervisor / live sessions.
- Snapshot dirty work.
- Create or move the ghq checkouts.
- Update path references in `pack.toml`, prompt templates, hook
  commands, settings, supervisor `--city` argument.
- Restart from the new root.
- Keep `~/philosophy-city` as a temporary operator alias.
- Verify (`bd ready`, `gc rig list`, hook injection, mayor wake,
  one seat close cycle).
- Retire the alias on a *dated* condition.

A "permanent symlink" without a deletion date is opaque-debt:
the migration claims completion while the old path remains the
real contract.

### 5. The upstream question — what is philosophy-city, ontologically?

Two seats independently surface this — Dharma in his ricochet,
Rasa in his upstream-question. The question:

- Is philosophy-city a **repository** like its rigs (keel,
  library)? Then ghq is its right home; the relocation is clean.
- Is philosophy-city the **host structure** that *contains* rigs?
  Then ghq is a tool the city *uses* to manage its rigs, but the
  city itself sits at the user's working root by convention.

The current shape (`~/philosophy-city/` containing `keel/` and
`library/`) reads as the second kind. The proposition treats it as
the first. Voting on the relocation before the ontological
question may sediment an answer the structure round, when it
arrives, would not have chosen.

### 6. The symlink option is not in the bead

Rasa surfaces this as an unnamed third option:
`~/philosophy-city → /git/github.com/LiGoldragon/philosophy-city/`.
Preserves both attunements (home-path as fast-path role-disclosure;
archive-path as canonical addressable). Many disciplined engineers
run this shape. Worth considering before deciding.

---

## What the council surfaces as ricochets / upstream questions

Five propositions worth considering *alongside* this vote (or
*before* the revised vote):

1. **A location lexicon** (Viveka, Prayoga both): name *checkout
   path / operator path / city root / rig root / store root*
   distinctly, so the structure round doesn't have to ask
   operational questions in source-control language.
2. **A canonical repo-identity manifest** (Satya): record `library`
   as a city-role and `bibliography` as the remote repo name; the
   two truths must not be blurred.
3. **Auto-memory migration plan** (Dharma): rename or symlink
   `/home/li/.claude/projects/-home-li-philosophy-city/` to the
   new path-derived key when the move happens.
4. **Type-of-artifact question** (Rasa, Dharma): is philosophy-city
   a published artifact or the host? Decide before form.
5. **Symlink as alternative form** (Rasa): home-path symlink to
   ghq-canonical path; preserves both attunements.

---

## Mayor's editorial position

The council has done what the council is supposed to do on a
substantive vote: **say yes-to-direction, defer-on-package,
name-the-closures**. The proposition is not refused; it is
returned for completion.

The right move is *not* to push the proposition through with mayor
authority. The closures are real. Several are upstream of mayor's
implementation work — they require Li-level decisions (the
type-of-artifact question; whether the library moves to
`bibliography`; whether the symlink option is on the table).

Mayor's recommendation: **do not migrate yet**. Surface the
synthesis to Li. Let Li decide the upstream questions, then the
mayor proposes a *revised* proposition that addresses the closures,
and the council can vote yes-on-strength.

This is also the first concrete demonstration that **mayor authority
should not extend to substantive structural decisions**. The repo
location is structural. The council deferred — and the defer is the
finding. Mayor implementing over the defer would be exactly what
Dharma's soul names as a moral-court failure: one vote among five
claiming a higher law over the others.

---

## Open questions for Li

1. **What is philosophy-city, ontologically — a repository like its
   rigs, or the host structure that contains them?** Rasa and Dharma
   both flag this as upstream of the form-question. Your answer
   shapes everything downstream.
2. **Should a location lexicon be drafted before the structure
   round** (Viveka, Prayoga)? This is small but recurring; affects
   how the structure round is asked.
3. **Symlink as third option** (Rasa) — the bead did not name it;
   the council noticed. Worth considering: would
   `~/philosophy-city → /git/github.com/LiGoldragon/philosophy-city/`
   satisfy both the unification-rule and preserve home-path
   role-disclosure?
4. **Library naming**: the remote is `LiGoldragon/bibliography`,
   but the city role is `library/`. Under any move, decide whether
   the role-name or the remote-name is canonical for the city's
   pack.toml references.
5. **Auto-memory party**: Dharma's roll-call names this; the
   migration plan must include a `mv` (or symlink) of
   `/home/li/.claude/projects/-home-li-philosophy-city/` to the
   new path-derived key. Is this an instruction-for-mayor, or a
   wider question about Claude Code's path-keying?

---

## Adjacent input (not the vote, but landed alongside)

### Explorer brief — `pc-ttzm`, criome ecosystem map

The explorer surveyed `~/git/` (86 git repos):
- **34 active** (committed within last 7 days)
- **22 recent-but-not-active** (committed within 30 days)
- **30 abandoned/empty** (no commits in 30+ days, including 3 with
  no commits)

The criome ecosystem is alive and rich. The brief identifies the
canonical map at `~/git/workspace/docs/workspace-manifest.md` and
project-wide architecture at `~/git/criome/ARCHITECTURE.md`. Active
core: `criome` / `sema` / `signal*` / `nota*` / `nexus*` / `forge`
/ `arca` / `prism`. Active surface: `mentci-*` / `lojix-cli*` /
`hexis` / `horizon-rs`. CriomOS axis: `CriomOS` / `CriomOS-home`
/ `CriomOS-lib` / `CriomOS-pkgs` / `CriomOS-emacs`. Meta: `workspace`
/ `lore`. Cluster proposals: `goldragon` / `maisiliym`. Plus
`gascity-nix` (Li's nix packaging of gascity).

**Naming corrections found by explorer** (vocabulary index updated):

- `logix` (Li's dictation) ≠ on-disk repo. Live: `lojix-cli` and
  `lojix-cli-v2`. Authoritative: **lojix**.
- No plain `library` repo (city role only); multiple lib-repos by
  role (`CriomOS-lib`, `mentci-lib`, `arca`'s reader).
- No plain `home` — the matching live component is `CriomOS-home`.
- No plain `horizon` — the matching live component is `horizon-rs`.

### Researcher — `pc-m5yg`, Wasteland + community structures

Still in flight. Will be folded into the criopolis-structure round
when it lands.

---

## Sequence

The repo-location vote does not block the structure round, but
shapes its ground. Recommend:

1. **Now**: surface this synthesis to Li. Let Li decide the
   upstream questions (type-of-artifact, library naming,
   symlink-as-third-option, location-lexicon-first).
2. **After Li decides**: mayor drafts a revised proposition that
   addresses the closures; council votes yes-on-strength;
   migration runs as Prayoga's staged contract specifies.
3. **In parallel**: researcher's `pc-m5yg` continues. When it
   lands, mayor synthesizes a meta-briefing combining (a)
   explorer's criome map, (b) researcher's Wasteland +
   community findings, (c) the settled repo-location decision.
4. **Then**: the criopolis-structure council round fires. The
   prep doc at `_intake/criopolis-structure-prep.md` stays the
   staging ground; the council adjusts the points it engages.

The "real content" capability of the council has been demonstrated
on this vote. The structure round is the same shape at a larger
scale.

---

*Closing per protocol. The first real-content vote did what real
content votes do: forced explicit ground that meta-rounds could
finesse. The council found four closures the proposition silently
assumed. None of them are blocking; all of them are work the mayor
or Li does next.*

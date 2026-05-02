# Synthesis 002 — Rig integration architecture

*Mayor's stance after the four-seat rig-integration beads
(pc-g70z aesthete · pc-rv2j devil · pc-v7b9 theorist · pc-vhwo
pragmatist), modified by user override on placement.*

## What the forum proposed

| Question                        | Aesthete             | Theorist            | Pragmatist          | Devil                    |
| ------------------------------- | -------------------- | ------------------- | ------------------- | ------------------------ |
| (A) Where does library live?    | ~/git/library        | ~/git/library       | ~/git/library       | ~/git/library w/ gate    |
| (B) Pack or single agent?       | single librarian     | single librarian    | single librarian    | single librarian + audit |
| (C) Workspace-boundary rule     | option 3 (partial)   | option 3 (partial)  | option 3 (explicit) | option 3 (generated)     |

Strong consensus on (B) and (C). All four picked option 2 on (A) —
keep at `~/git/`, register from there.

## User override on (A)

Li: "im not worring about anything breaking by moving ~/git/bibliography"

Decision: option 1. Move into the city. Library lives at
`/home/li/philosophy-city/library/`.

Why the user's override is correct in context: the forum's argument
for `~/git/library` was risk-driven (devil's reversibility concern,
pragmatist's tooling-friction, theorist's two-concerns). Once the
user accepts the breakage risk, the simplification dominates: the
workspace boundary stays as a single root, no shared partial system
needed yet, no parent-of-rig writability worry, no jj/git remote
divergence since the working repo moved as a unit. The forum's case
for keeping it outside was sound *under their assumptions*; the
user's assumptions are different and more permissive.

The aesthete's "city is a building, not the city block" is the
prettiest argument the forum made. It does not survive the user's
willingness to accept tooling friction. The substance remains:
*future* external rigs (e.g., a registered `~/git/criome/` if it
becomes a writable rig) will need the option-3 partial system. We
defer that until the second external-rig case forces it.

## What was actually done this session

1. **Moved:** `mv ~/git/bibliography → ~/philosophy-city/library`
   (one-step, per user override).
2. **Registered:** `gc rig add /home/li/philosophy-city/library --name library`.
   Beads database initialized at `library/.beads/`. Bead prefix `li`.
   `city.toml` updated.
3. **Librarian agent added** to `pack.toml`:
   - provider: codex; effort: xhigh
   - prompt template: `agents/librarian/prompt.template.md`
   - named session: `librarian`, mode `on_demand`
4. **Librarian prompt** written. Workspace boundary stays as the
   single root rule — library is inside the city. Audit duty
   captured (devil's contribution): periodic report on uncataloged
   files, duplicate editions, missing source metadata, failed
   fetches.
5. **`gc reload`** — librarian named session shows
   reserved-unmaterialized.

## What was NOT done this session

- **Shared workspace-boundary partial system** (forum's option 3 for
  question C). Deferred until a second external rig forces the case.
  The current single-root rule covers all writable areas. When an
  external rig is registered, this comes back.
- **Pack split for librarian** (curator/fetcher/cataloger).
  Premature; the consensus was single-agent now, fork the pack only
  when concrete seams (permission, queue, failure mode) appear.
  Devil's audit duty is the early-warning system.
- **Anna's Archive `.env` setup.** The librarian needs a
  `library/.env` with API config for `annas`. Will resolve on first
  fetch task — librarian creates it (or surfaces the missing
  credentials back as a bead).

## What was lost in moving

Things in the user's environment that may still point at
`~/git/bibliography`:

- `jj` / `git` remotes inside `library/.git/` — these are inside the
  moved tree; they continue to work for push/pull. The personal
  remote URL is unchanged.
- Shell history references — `cd ~/git/bibliography` now fails. Will
  surface as friction; not corruption.
- Editor workspaces (VSCode/etc.) pinning the path — re-open required.
- Scripts in `~/git/workspace/` or elsewhere referencing the old
  path — librarian's first audit can grep for these and report.

User explicitly accepted these costs.

## Next moves

Sling these to the librarian as the first beads:

1. **First-contact audit.** Walk the rig; produce the audit report
   per `agents/librarian/prompt.template.md` § "Audit duty".
2. **Set up `.env`** for `annas`. Surface the credential question
   to the user if not pre-configured.
3. **Add Rudhyar.** Search Anna's Archive for *The Astrology of
   Personality* (Aurora Press 1991 reissue), *Person-Centered
   Astrology*, *The Lunation Cycle*. Prefer text format if any.
4. **Add Plato dialogues.** Hackforth *Phaedrus*; Bury *Timaeus*
   (Loeb); Fowler *Symposium* (Loeb). Greek originals if available.
5. **Add Tao Te Ching.** Legge translation (already cited by
   pragmatist via sacred-texts.com); plus a modern critical edition
   for cross-reference.
6. **Add Bohm**, *Wholeness and the Implicate Order* (Routledge).
7. **Add Alexander**, *The Nature of Order* Vol. I (CES, 2002).

Each goes in a separate bead so the librarian can fetch, file,
catalog independently.

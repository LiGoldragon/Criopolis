# Criopolis structure — points the mayor is staging for the council round

*Working preparation. Per Li's request: "create a bunch of points
that you think are relevant" for the eventual council-wide round on
how Criopolis should be structured. Will fire once the explorer
(`pc-ttzm`) and researcher (`pc-m5yg`) briefs return; the
repo-relocation vote (`pc-b2sw` etc.) may also affect the workspace
shape we deliberate over. The council adds its own questions on
top of this list.*

---

## Constraints (Li's framing, summarized)

The system Criopolis is becoming should be:

- **Reliable** — not recklessly broken; can ramp test servers to
  vet proposals before deploying.
- **Adaptive** — capable of evolving and adapting *quickly when
  needed*, with the infrastructure and skill to do so well.
- **Restrained** — does not act when action is not necessary.
- **Introspective** — easy to inspect *what version we are running*
  (the system-inspection pointer landed today is a first move).
- **Council-led** — the high council makes important decisions or
  vetoes; mayor is doing too much and should not be the sole
  decision-authority.
- **Connected** — capable of participating in the Wasteland once we
  understand what it is, but not recklessly.

These are constraints, not roles. The structure round chooses how
to satisfy them.

---

## Points relevant to the structure question

Numbered for ease of reference; not in priority order. The council
should engage the points where they have conviction and stay silent
on the rest.

### 1. Mayor's current load

Mayor currently does *all* of:

- Synthesizes every council round (writes synthesis-NNN.md).
- Files every bead (council, librarian, researcher, explorer).
- Slings beads to agents.
- Reads every reply.
- Edits prompt templates (mayor-authority pass after each
  synthesis).
- Edits `pack.toml` (provider rebalances, new agents).
- Runs git commits + pushes.
- Updates memory.
- Investigates infrastructure questions (mayor-wake architecture,
  before delegating to researcher).
- Adjudicates between competing seat proposals.

What of this is *only* mayor's? What can move to other roles? The
council should distinguish *authority* (the decision) from
*execution* (the act).

### 2. Council as decision-authority

Today, mayor often applies "uncontested" edits as mayor-authority.
The council ratifies indirectly by silence-as-finding. This worked
for round-3 through round-6 because the rounds were structural and
the seats already self-flagged the changes.

For Criopolis-shaped decisions (workspace structure, new roles,
infrastructure investments), should the council vote *substantively*
on every proposition before mayor implements? What's the boundary
between *mayor's editorial authority on synthesis* and *council's
decision-authority on substance*?

The repo-relocation vote in flight (`pc-b2sw` / etc.) is the first
test of substantive council voting. Its mark/silence/dissent pattern
will inform the answer.

### 3. Roles Criopolis may need

Existing: mayor (always-on Claude); five council seats (3 codex / 2
claude, on-demand); librarian (codex); researcher (codex); explorer
(codex, just added).

Candidate additional roles, sketched only:

- **Implementer** — does prompt edits, `pack.toml` edits, git
  commits. Mayor proposes; implementer applies. Keeps mayor in
  synthesis register, away from execution.
- **Auditor** — watches city health (dolt size, session counts,
  stuck beads, mail backlogs, supervisor health). Surfaces issues
  before they become incidents.
- **Ambassador** — interfaces with the Wasteland once we
  understand it. Speaks for Criopolis to other cities; routes
  messages from other cities back into the council.
- **Test pilot** — runs experiments in a sandbox / staging
  gas-city before changes land in the live one.
- **Scribe / glossary-keeper** — maintains living docs (vocabulary,
  system-inspection, glossary). Mayor writes prose syntheses;
  scribe maintains the reference shelf.
- **Triage** — first-touch on incoming beads; routes to the right
  role; saves mayor's attention for synthesis.

The council should propose / cut / refine. Not all candidates are
right; some may collapse into existing roles.

### 4. Test environments / staging

Today we test by editing the live `pack.toml` + reload, or by
killing sessions and re-slinging. Risky: mistakes affect the
running mayor (us) and the running council.

Could we run a *test* gas-city — same `gc` binary, separate city
directory, separate dolt — to vet pack.toml changes, new agent
prompts, hook configurations *before* applying to the live one?
What's the cost (compute, dolt, mental overhead)? What are the
isolation boundaries?

This is where *ramp servers* / *test servers* would live.

### 5. Introspection — what state is visible?

We added the system-inspection pointer today (running gc + cloned
source). What else should be inspectable at a glance?

- Pack.toml current state — already in repo.
- Active sessions, named-session map — `gc session list`.
- Dolt size / growth — script needed.
- Mail backlog per agent — `gc mail count` per session.
- Stuck beads (open > N hours, no progress) — script needed.
- Supervisor health — `gc status`.

A *city dashboard*: one document or one command that surfaces
all of this. The council should consider whether and how.

### 6. The Wasteland — careful onboarding

Once the researcher's brief lands, we know what the Wasteland is.
*Decision-shape*: do we connect Criopolis to the Wasteland at all?
On what protocol? Read-only first? With what authentication? Who
speaks for Criopolis externally?

This is exactly where Li's "not reckless" constraint lands hardest:
inter-city protocols are how cities go badly wrong.

### 7. Reliability + adaptability — concrete forms

Reliability and adaptability are constraints; they have concrete
infrastructural forms. Possible answers:

- **Fast rollback paths**: git for code/prompts; a snapshot
  mechanism for dolt; ability to revert pack.toml to a known
  configuration.
- **Council veto on changes**: structural, not advisory.
- **Test-first for new agent configs**: see point 4.
- **Standing audit role**: see point 3 (auditor).
- **Versioned syntheses**: synthesis-NNN.md with explicit "what was
  applied" sections — already in practice; could be tightened.

The council should propose specific forms, not principles in the
abstract.

### 8. Visibility of the speech-to-text vocabulary

Li's speech-to-text engine doesn't have a specialized vocabulary
for project names. The mayor reads a vocabulary feedback memory
that maps mistypes to correct spellings (criome / logix / sema /
criopolis). Should this live elsewhere — in the mayor's prompt? in
a dedicated user-vocabulary file the mayor reads at session start?
in a city-level config?

This is a small structural question but recurring; worth one round
of attention.

### 9. The repo-location question (already in flight)

Pending council vote in `pc-b2sw / pc-wf35 / pc-fcjr / pc-waof /
pc-8p1z`. The outcome shapes the workspace before the structure
round runs. Don't pre-empt; let the votes close, the synthesis
land, and the structure round assume whatever shape was ratified.

---

## How the structure round should fire

Sequence:

1. **Briefs land.** Explorer's `pc-ttzm` (criome ecosystem map);
   researcher's `pc-m5yg` (Wasteland + community gas-city
   structures); council's repo-relocation vote.
2. **Mayor reads each.** Synthesizes a single shared briefing for
   the council — the operating context for the structure round.
   Includes:
   - Active criome components (per explorer).
   - What the Wasteland is (per researcher).
   - Other gas-cities' structural patterns (per researcher).
   - Repo-location decision (per council vote).
3. **Mayor files the structure round.** One bead per seat, plus
   one each to librarian, researcher, explorer. Body cites the
   briefing + the points above + invites the council/tools to
   propose what *infrastructure*, what *roles*, what *governance*
   Criopolis needs.
4. **Council + tools reply.** Round 7's actual content.
5. **Mayor synthesizes** (synthesis-010-criopolis-structure).
6. **Apply consensus**, queue contested questions for round 8+.

The structure round is the first time librarian, researcher, and
explorer are invited *into the council's deliberation* alongside
the seats — not as work-takers but as voice-holders. They have
distinct disciplines (collection, evidence, mapping) the council
should hear from when shaping its own city.

---

## Open question for Li

Once the briefs land, do you want mayor to file the structure round
*directly*, or to first show you the meta-briefing (the synthesis
of explorer + researcher + repo-vote) for your read before
launching? The first is faster; the second gives you a chance to
shape the round's framing before five seats and three tools spin
up.

---

*This document is a staging area, not a synthesis. The council
discussion may surface points absent from this list and discount
points present in it. The council is not bound to this document.*

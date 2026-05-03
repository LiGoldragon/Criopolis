# Code-implementing pack — design packet

*Second exercise of the synthesis-012 design-process. Mayor opens.
2026-05-03.*

## Working title

**code-implementing pack** — Li's request used "code-implementing
agent-complex"; the lore-aligned primitive is gas-city's `pack` (a
reusable, portable bundle of agents / formulas / orders / scripts;
see lore's `gas-city/vocabulary.md` Spatial-structure table). Final
name pending Viveka's term cut.

## Artifact

- **Design document** at `_intake/drafts/code-implementing-pack.md`
  (mayor's first draft, in progress this session) — describes the
  pack's shape: roles, handoff contract, formula DAG, authority
  boundaries, keel enforcement, failure modes, closures.
- **Synthesis** at `_intake/synthesis-013-code-implementing-pack.md`
  (mayor writes after ratification; replaces the draft).
- **NOT in scope for this design pass:** individual prompt
  templates (`agents/code-writer/prompt.template.md`,
  `agents/code-reviewer/...`, etc.) — those are downstream beads
  per role, drafted after this pack's shape ratifies. The auditor
  precedent (a single-role design produces a single prompt
  template) does not extend here; this design produces a pack
  shape that constrains five subsequent prompt-template designs.
- **Also NOT in scope:** the host subsidy's verb list (Li-only,
  separate design pass per synthesis-011's three closures); the
  staging-city setup script (separate bead `cr-w7ea` (mayor:
  staging-city setup script — to-be-rerouted to Prayoga per
  mayor.md §8)); the first keel section (Li + council decision).

## Force class

**design-substantive.** Subset route for the design pass.
Graduates to live → all-five ratification at install gate (per
synthesis-012 §"Subset vs all-five — three force classes"). The
pack is keel-adjacent (the reviewer enforces keel rules) and
deploy-adjacent (the deployment-specialist consumes the host
subsidy's verbs); both adjacencies will trip keel-or-live force
at install if not gated correctly here.

## Audience class

**re-read.** The pack's shape is read every time a future mayor,
seat, or role-occupant returns to it: when filing a code-bead,
when reviewing a pack change, when a stage of the pipeline is
adjusted. Savor-pass fires (Rasa).

## First author

**Mayor.**

Reason: per synthesis-012 §2 affinity table, "orchestration /
city-process / composes-with-synthesis" → Mayor. The code-
implementing pack is a city-process artifact composing with the
synthesis-011 role cohort, the keel-enforcement contract, the
host-subsidy interface, and the staging-city operational shape.
This is mayor's affinity. The auditor precedent (synthesis-012
§"Status of P1 designs" — also mayor) applies.

Prayoga has strong claim on operational pieces (formula DAG,
worktree contention, dolt cost, recovery shape); Dharma on
authority lines (declared write sets, keel-block enforcement,
subsidy gating); Viveka on term-stability (`pack` vs `complex`,
`role` vs `agent`, `keel rule` vs `keel guideline` enforcement
distinction). All three review under the routed chain rather than
re-author. Affinity-rotation note: this is the second design with
mayor as first-author; the third may rotate to a different
affinity if a candidate emerges (Dharma's anti-ossification rule,
synthesis-012 §2).

## Reviewer route (in order, with reason)

Subset = all five seats, but routed sequentially, not parallel.
Same chain as auditor (Viveka → Dharma → Prayoga → Satya → Rasa)
because the central uncertainties stack the same way:

1. **Viveka** — *term and role-boundary stability.* `pack`,
   `complex`, `role`, `agent`, `pipeline`, `worker`, `enforcement`
   (vs `flagging`), `block` (vs `refuse to merge` vs `refuse to
   review`) are loaded terms. Where does this pack stop relative
   to the auditor (cohort-mate), the test-pilot (cohort-mate), the
   deployment-specialist (cohort-mate, but its host effects gate
   on the subsidy)? Viveka first to cut categories before others
   reason on potentially-wrong scaffolding.
2. **Dharma** — *bound parties.* The keel ruleset (the reviewer
   reads against it; if keel is wrong the reviewer is wrong),
   future Li-as-subsidy-holder (deploy paths transit through the
   subsidy), the rigs the writer touches (declared write set
   bounds the blast radius), future role-occupants of all five
   roles, the workspace boundary (writes confined to `~/Criopolis/`
   plus `.gc/worktrees/<rig>/`). Dharma early so escalation paths
   and "when not to escalate" are named before operational and
   truth review.
3. **Prayoga** — *operational ledger.* Formula DAG correctness
   under load, worktree contention when two beads route through
   simultaneously, dolt cost per pipeline run, what happens when
   a stage fails (recovery shape), what happens when staging
   isn't ready (the pack's staging dependency), what the
   operator's failure-recovery commands look like. Prayoga after
   structure is set so the application ledger applies to a stable
   artifact.
4. **Satya** — *evidence-bound success-criteria.* Every claim the
   pack makes about its own correctness must be testable. "The
   reviewer enforces keel" must reduce to "given diff D and rule
   R with decision-test T, the reviewer's output is determined."
   "The deployment-specialist deploys safely" must reduce to "the
   subsidy refuses non-allowlisted verbs." Late so the claims are
   stable.
5. **Rasa** — *re-read curve, vocabulary salience, role-name
   recognition across re-readings.* Pass-runner = Rasa;
   kind-conditional firing = yes (re-read class). The pack's
   names (mayor's working title is "code-implementing pack" — does
   that hold up on second reading? Do role names survive
   substitution into the formula DAG without ambiguity?) are
   load-bearing for future occupants.

## Final writer

**Mayor.** Default per synthesis-012 §4 (multi-discipline artifact;
city-process; composes with synthesis-011 + keel + subsidy +
staging). Disposition log produced on final pass.

## Substantive boundary — what re-opens council or Li

Any of these on the final pass shifts the artifact out of mayor's
editorial authority:

- **Adds a new role** beyond the synthesis-011 ratified cohort
  (auditor, test-pilot, deployment-specialist, code-writer,
  code-reviewer). A "witness" or "patrol" role does not exist in
  the cohort and would re-open the cohort question.
- **Changes the read/write surface** of any ratified role (e.g.,
  granting the reviewer write authority on the target repo, or
  the writer review authority on its own diff).
- **Adds a new authority verb to the host subsidy** beyond what
  the deploy-specialist needs and what synthesis-011's three
  closures gate. Verbs are Li-only.
- **Changes the keel-rule enforcement contract** (e.g., the
  reviewer enforcing guidelines as if they were rules, or
  ignoring rules whose decision-test it can't operationalize —
  both invert keel.md's force semantics).
- **Touches keel force** (introduces a new force class, or
  changes when keel rules are reconsidered).
- **Re-opens the role-cohort question** — the cohort is fixed at
  five.
- **Touches `pack.toml` or `city.toml` agent blocks** in ways
  that grant new authority verbs (pure addition of agent
  definitions for the cohort is mayor-authorable per mayor.md §8;
  changes that mutate authority surfaces are not).

If the design surfaces a need to extend any of the above, mayor
escalates rather than absorbing under "editorial."

## Acceptance check

Before close (full check happens against staging-city; partial
check is hand-rolled here):

1. **End-to-end dry-run.** A mock bead enters the formula at the
   writer step; produces a patch + tests + risk note; routes to
   the reviewer; reviewer reads against a stub keel rule with a
   decision-test; output captured. Demonstrates handoff
   contracts work.
2. **Sample artifacts.** One writer-output (patch + tests + risk
   note shape demonstrated in a single sample bead). One
   reviewer-output (findings cited to keel by line + severity +
   missing-rule notes). One test-pilot output (staging-run
   report). One deployment-specialist output (deploy packet
   pre-subsidy — *not* executed against a host).
3. **Reviewer transcript.** Disposition log lists each must-fix /
   should-fix concern from each routed seat with disposition
   (accepted / modified / declined-with-reason / escalated).
4. **Negative spot check (no-false-pass + no-false-block).** Two
   stand-in beads:
   - **No-false-pass:** writer-output contains a clear keel
     violation (reviewable by the stub rule's decision-test); the
     reviewer must block and route the finding back, *not* let it
     through.
   - **No-false-block:** writer-output is keel-clean; the
     reviewer must approve, *not* fabricate a refusal.
5. **Self-fire-loop check on any orders the pack adds.** Per
   mayor.md §7, every order config in the pack passes the
   self-fire test before it lands. (Orders are not authored by
   mayor per mayor.md §8; this check applies to the
   operational-affinity author of any orders the pack defines.)
6. **Push-not-pull check.** Every coordination point in the pack
   uses beads + work_query subscription, never a polling loop
   (per lore's `programming/push-not-pull.md`).

The full bead-test happens in the staging city when staging stands
up (parallel design `cr-w7ea` (mayor: staging-city setup script —
to-be-rerouted)). Acceptance check items 1–4 can run partially
with hand-rolled inputs before staging; full bead-test gates
install. Items 5–6 are static checks on the final draft.

## Closures (per synthesis-012 §"Required closures")

- **Route closure** — this packet logs author (mayor), reviewers
  (5 routed serially), final writer (mayor), force class
  (design-substantive), audience class (re-read), savor-pass
  (yes, Rasa) before drafting begins. ✓
- **Mirror closure** — first draft at
  `_intake/drafts/code-implementing-pack.md`; review notes mirror
  to `_intake/replies/code-implementing-pack/<seat>.md` (per
  agents.md rule 1) before bead close; ratified synthesis at
  `_intake/synthesis-013-code-implementing-pack.md`.
- **Override closure** — disposition log on every blocker /
  required comment; appended to this packet under §"Disposition
  log" when final-pass runs.
- **Subset closure** — N/A (full route used).
- **Install closure** — drafted only; **not** added to `pack.toml`
  until (a) Li approves after design pass, (b) bead-test in
  staging (which requires staging to exist), (c) the first keel
  section exists for the reviewer to enforce against, (d) the
  host subsidy verb-list for deployment-specialist is Li-
  authorized. Install proceeds role-by-role, lightest first
  (writer + reviewer earliest, since they exercise keel and
  worktree discipline; test-pilot when staging stands up;
  deployment-specialist last, gated on subsidy).
- **Review/deletion closure** — see §"Deletion / review
  condition" below.
- **Self-application closure** — this design uses synthesis-012's
  process. ✓

## Mirror path

- Packet: this file (`_intake/design-packets/code-implementing-
  pack.md`).
- First draft (in progress this session):
  `_intake/drafts/code-implementing-pack.md`.
- Seat reviews: `_intake/replies/code-implementing-pack/<seat>.md`
  (durable mirrors of bead notes; per agents.md rule 1).
- Final synthesis: `_intake/synthesis-013-code-implementing-
  pack.md` (mayor writes post-ratification).
- Disposition log: appended to this packet under §"Disposition
  log."
- Downstream prompt templates (NOT in scope for this design):
  `agents/code-writer/prompt.template.md`,
  `agents/code-reviewer/prompt.template.md`,
  `agents/test-pilot/prompt.template.md`,
  `agents/deployment-specialist/prompt.template.md`. Each gets its
  own packet under `_intake/design-packets/<role>.md` after this
  pack's shape ratifies.

## Deletion / review condition

The pack is reviewed at the first of:

- **False block.** Reviewer blocks a diff that keel does not
  prohibit. Review for over-enforcement; check whether the
  blocking rule had a real decision-test or was decoration.
- **False pass.** Diff merges with a keel violation present.
  Review for under-enforcement; the rule's decision-test must
  have been operationalizable but the reviewer didn't apply it.
- **Stuck pipeline.** A bead enters the formula and never closes.
  Review the recovery shape; check whether a witness/patrol role
  is needed (currently out of scope per substantive boundary; if
  this fires repeatedly, surface to council).
- **Cohort change.** A role added or split per synthesis-011
  amendment. Re-validate handoff contracts.
- **Keel grows new force class.** Re-validate the reviewer's
  enforcement decision-test.
- **Subsidy verb-list changes.** Re-validate the deployment-
  specialist's authority surface.
- **Six months from install** with none of the above —
  routine re-read.

## Open question deferred (synthesis-012 §"Open downstream
questions")

Whether a **witness/patrol/recovery role** belongs in the cohort
is the standing open question. Synthesis-011 cut "triage" and
"generic implementer" as premature. A witness is a triage-flavored
role (it patrols stuck work and routes recovery). My current
position: surface in the design draft as a *formula-step or order*
rather than a new role (no new agent), and let the council
re-decide if false-block / false-pass / stuck-pipeline failures
accumulate. Reviewers may object on classification.

## Status

- Packet opened: 2026-05-03.
- First-draft author: mayor (in progress this session).
- Reviewer route: not yet engaged; first sling to Viveka after
  draft completes.
- Disposition log: empty.

# Code-implementing pack — first-draft design (PARKED)

> **PARKED 2026-05-03 per Li.** Pack frame overreached — bundling
> four cohort roles into a unified pack was a substantive structural
> decision that should have gone to council deliberation
> (synthesis-012 keel/live-structural force class), not mayor's
> design-substantive route. Revisit after notification-mechanism
> research and basic code-writer agent. Viveka's mid-flight review
> at `cr-mdc4k7` (code-implementing pack — Viveka review) continues;
> term cuts inform the future all-in-one prompt regardless.

*Mayor's first draft, 2026-05-03. Per synthesis-012 process; packet
at `_intake/design-packets/code-implementing-pack.md`. Reviewer
route (now stopped at Viveka): Viveka → Dharma → Prayoga → Satya
→ Rasa savor-pass.*

*Written in present-tense for the ratified state, marked DRAFT
until the route closes. Reviewers comment with force-tagged deltas
per synthesis-012 §3; mayor integrates with disposition log on
final pass.*

---

## What this pack is

The **code-implementing pack** is a portable bundle of agents,
formulas, and orders that turns a routed code-bead into a merged
commit, a passing staging run, and — when authorized — a deployed
change. It composes synthesis-011's ratified role cohort
(code-writer, code-reviewer, test-pilot, deployment-specialist;
the auditor is parallel to this pack, not a stage in it) with the
gas-city primitive layer (beads, formulas, orders, work-queries,
worktrees, hooks) and the criome-ecosystem disciplines (keel
rules, the host subsidy, the workspace boundary).

The pack is `pack`-shaped per `gas-city/vocabulary.md`: a reusable
bundle that can be imported by any city that needs to implement
code under keel discipline. It carries:

- **Four agent definitions** — one per role; codex provider
  (Claude acceptable on the reviewer for prose-heavy review per
  synthesis-011 line 91).
- **One canonical formula** — the write→review→test→deploy DAG,
  expressed as a `mol-code-implement` formula (TOML schema v2).
- **No new orders** — recovery and patrol surfaces stay
  open-question per the packet's deletion condition; if they
  graduate, they enter as orders in a follow-up bead, not in this
  pack.
- **No new authority verbs** — the deployment-specialist consumes
  whatever subsidy verbs Li authorizes; the pack does not define
  them.

The pack is not yet installed. Installation gates are
role-by-role per the packet's install closure.

## How a code-bead flows through the pack

A code-bead is a `type=task` bead with metadata indicating it
needs implementation work. Mayor (or a council seat tasking a
clarification) files the bead and routes it to the pack's entry
point. The bead transits four stages, each a step in the
`mol-code-implement` formula. Stage transitions are bead-state
transitions; downstream roles' work-queries pick up beads in the
state that signals "ready for me." No role polls; every
coordination point is push-not-pull (lore
`programming/push-not-pull.md` line 13).

The lifecycle, in the bead's own state-keys:

| stage | bead state | metadata added | next role's work_query |
|---|---|---|---|
| 0. routed | `gc.routed_to=code-writer` | `keel_section`, `target_repo`, `change_summary` (mayor sets) | code-writer's default work_query (`ready routed-to-me`) |
| 1. write | `writer.complete=true` | `work_dir`, `patch_summary`, `risk_note`, `tests_added` | code-reviewer's filter on `writer.complete=true && reviewer.complete=false` |
| 2. review | `reviewer.complete=true`; `reviewer.verdict ∈ {approve, block, refer}` | `findings_summary`, `keel_rules_cited`, `missing_rules_noted` | test-pilot if `verdict=approve`; route back to writer if `verdict=block`; surface to mayor if `verdict=refer` |
| 3. test | `test_pilot.complete=true`; `test_pilot.verdict ∈ {pass, fail, defer}` | `staging_run_url`, `failures_summary` | deployment-specialist if `verdict=pass`; back to writer if `fail`; surface if `defer` |
| 4. deploy (gated) | `deploy_specialist.complete=true`; `deploy.verdict ∈ {packet_ready, refused, blocked_on_subsidy}` | `deploy_packet_path`, `subsidy_verbs_requested`, `subsidy_response` | Li's subsidy authorization (out of band); on success, bead closes |

A bead at stage 4 with `verdict=packet_ready` does *not* deploy
on its own. The deploy packet is a Markdown artifact under
`_intake/deploy-packets/<dated>.md`; Li reviews and authorizes
the subsidy invocation. The pack's authority stops at "packet
ready."

## The four roles

Each role has the same five fields: **affinity** (what makes this
the right role for this work), **signature artifact** (what it
produces, the unique cite-able output), **declared write set**
(the files it may touch), **engages when** (the bead state that
triggers its work_query), **closes by** (the bead state it leaves
for the next role).

### code-writer

- **Affinity.** Patch authorship under keel discipline. The
  writer reads the bead's `target_repo` + `change_summary` +
  `keel_section`, sets up an isolated worktree, produces a patch
  that satisfies the change with tests that exercise it.
- **Signature artifact.** A patch + tests + risk note. The risk
  note names what the patch could break, what test coverage it
  has, what cross-rig effects it might have. Stored as bead
  metadata (`risk_note`) and as a markdown file in the worktree
  at `<work_dir>/RISK.md`.
- **Declared write set.** `<work_dir>/` (gas-city's
  `.gc/worktrees/<rig>/<bead-id>/` per the rig's worktree
  convention). The writer may not touch any path outside this
  worktree. Specifically: not the city dir, not other rigs, not
  `~/git/`, not host paths.
- **Engages when.** Bead enters with `gc.routed_to=code-writer`
  and `state=ready`.
- **Closes by.** Setting `writer.complete=true` and recording
  `work_dir`, `patch_summary`, `risk_note`, `tests_added` in
  bead metadata. The reviewer's work_query subscription picks it
  up.

### code-reviewer

- **Affinity.** Keel-rule operationalization on a diff. The
  reviewer reads the writer's patch + risk note + the keel rules
  in scope, decides which rules' decision-tests apply to this
  diff, applies them, and produces findings cited by line in
  the diff and by line in keel.
- **Signature artifact.** Findings cited to keel by line +
  severity + missing-rule notes. Severity is one of `block /
  required-fix / suggestion / accept`. Missing-rule notes are
  patterns the reviewer noticed that no keel rule covers — the
  reviewer surfaces them as a *rule-question bead* (per keel.md
  enforcement contract: "When review surfaces a repeated issue
  not covered by keel, the reviewer opens a rule-question bead —
  does not adjudicate inline").
- **Declared write set.** Bead notes on the routed bead;
  `_intake/review-findings/<bead-id>.md` for the durable mirror;
  rule-question beads (filed via `gc bd create`, not slung). May
  not edit the writer's worktree, may not edit the target repo,
  may not modify keel — keel changes go through council
  ratification per keel.md.
- **Engages when.** Bead has `writer.complete=true` and
  `reviewer.complete=false`.
- **Closes by.** Setting `reviewer.complete=true` and
  `reviewer.verdict ∈ {approve, block, refer}` with
  `findings_summary` and `keel_rules_cited` populated. On
  `block`, the bead routes back to the code-writer (state-flag
  reset); on `refer`, the bead surfaces to mayor for
  re-classification.

### test-pilot

- **Affinity.** Staging-city verification. The test-pilot pulls
  the writer's worktree onto the staging city's instance of the
  target repo, runs the project's test discipline (whatever the
  rig's `flake.nix` / `Cargo.toml` / `package.json` declares),
  captures the run, reports back.
- **Signature artifact.** Staging-run report at
  `_intake/staging-runs/<bead-id>.md` — the run's stdout/stderr
  summary, exit codes, deviation from previous runs, environment
  fingerprint. Plus bead metadata `staging_run_url` (the
  artifact path) and `failures_summary` (none if pass).
- **Declared write set.** The staging city's worktree
  (whatever path the staging-city setup script — separate bead
  `cr-w7ea` — declares); `_intake/staging-runs/<bead-id>.md`;
  bead notes. May not modify production city; may not modify the
  writer's worktree (the test-pilot may *read* the writer's
  worktree to copy the patch into staging, but produces its own
  fresh worktree on the staging side). Hard-bound to the staging
  city per synthesis-011 ("Test pilot — staging-run reports;
  staging city only").
- **Engages when.** Bead has `reviewer.verdict=approve` and
  `test_pilot.complete=false`.
- **Closes by.** Setting `test_pilot.complete=true` and
  `test_pilot.verdict ∈ {pass, fail, defer}` with
  `staging_run_url` and `failures_summary`. On `fail`, the bead
  routes back to the code-writer with the failure summary in
  metadata. On `defer` (the staging-city environment is
  insufficient for this class of test), the bead surfaces to
  mayor.

### deployment-specialist

- **Affinity.** Production deploy under the host subsidy.
  Translates a passing staging artifact into a deploy packet
  Li can authorize. The deployment-specialist *does not deploy*;
  it produces a packet that names what would be deployed, the
  subsidy verbs needed, the rollback path, and the dry-run shape.
- **Signature artifact.** Deploy packet at
  `_intake/deploy-packets/<dated>.md` carrying the synthesis-011
  ratified five protocol-not-convention gates: dry-run, rollback
  contract, test environment first, two-eyes review by ≥1
  council seat, council strong-against = veto. Plus bead metadata
  `deploy_packet_path`, `subsidy_verbs_requested`,
  `subsidy_response`.
- **Declared write set.** `_intake/deploy-packets/<dated>.md`;
  bead notes. The deployment-specialist *requests* subsidy verb
  invocations from Li (via the subsidy interface, separate bead
  `cr-6szw` — the verb list is Li-authorized, not this pack's
  scope); it does not invoke them itself. May not touch host
  state directly; may not modify any rig.
- **Engages when.** Bead has `test_pilot.verdict=pass` and
  `deploy_specialist.complete=false`.
- **Closes by.** Setting `deploy_specialist.complete=true` and
  `deploy.verdict ∈ {packet_ready, refused, blocked_on_subsidy}`
  with `deploy_packet_path` populated. On `packet_ready`, mayor
  reads the packet and surfaces to Li for subsidy authorization.
  On `refused`, the deployment-specialist names what made the
  change un-deployable (e.g., the subsidy doesn't carry a verb
  this change needs); routes back to council. On
  `blocked_on_subsidy`, the change is deployable in principle
  but the subsidy hasn't authorized the verb yet; bead waits.

## The formula DAG — `mol-code-implement`

The pack's canonical workflow is a single formula at
`formulas/mol-code-implement.toml` (schema v2 per gas-city
vocabulary). Steps with `needs = [...]` form the DAG:

```
[mayor opens bead]
       │
       ▼
   [step: write]  (agent = code-writer)
       │
       ▼
   [step: review] (agent = code-reviewer; needs = ["write"])
       │
       ▼
   [step: test]   (agent = test-pilot;
                  needs = ["review"];
                  guard = reviewer.verdict == "approve")
       │
       ▼
   [step: deploy] (agent = deployment-specialist;
                  needs = ["test"];
                  guard = test_pilot.verdict == "pass")
       │
       ▼
   [Li authorizes subsidy invocation, out of band]
       │
       ▼
   [bead closes]
```

Branches:
- **review-block** — `reviewer.verdict == "block"` re-routes the
  bead to `code-writer` with state reset to pre-write. Loop
  bound: three review-block cycles before mayor escalates
  (configurable).
- **test-fail** — same shape as review-block but earlier branch
  point.
- **refer / defer** — surfaces to mayor; mayor re-files or
  escalates.

The formula is the *explicit* DAG view. The runtime dispatch is
push-not-pull: each role's `work_query` filters on the bead-state
keys that signal "ready for me." A bead leaving the writer with
`writer.complete=true` is picked up by the reviewer's work_query
without the formula needing to *call* the reviewer; the formula
documents the DAG, the work_queries do the dispatch.

## Authority — three levels, structural at each

The pack's authority is structural, not prompt-disciplined. A
role cannot exceed its surface because the surface is enforced
by the runtime, not by the role's good behavior. Three levels:

### 1. Filesystem — declared write set per role

Each role's prompt template carries a "Declared write set" line
naming the paths it may touch. Mismatch is mayor's responsibility
to catch at design-pass; runtime enforcement comes from gas-city's
worktree discipline and the agent's session cwd.

| role | write set |
|---|---|
| code-writer | `<work_dir>/` (its own worktree only) |
| code-reviewer | bead notes; `_intake/review-findings/<bead-id>.md`; rule-question beads (via `gc bd create`) |
| test-pilot | staging-city worktree; `_intake/staging-runs/<bead-id>.md`; bead notes |
| deployment-specialist | `_intake/deploy-packets/<dated>.md`; bead notes |

Per the city's hard workspace boundary (city.md
"Workspace boundary"): all writes confine to `~/Criopolis/` plus
`.gc/worktrees/<rig>/` (the writer's worktree, which is inside
the city's runtime dir).

### 2. Repo — declared scope per bead

Mayor names the `target_repo` in the bead's metadata at filing.
The writer touches *only* that repo's worktree. Cross-rig changes
are explicit: a bead that needs to touch two rigs is two beads
with explicit dependency, not one bead with implicit sprawl.

The scope-per-bead discipline implements lore's
`programming/micro-components.md` line 33 ("One capability, one
crate, one repo") at the work-routing level: one bead, one rig,
one capability change.

### 3. Host — subsidy-gated, deployment-specialist only

Only the deployment-specialist touches the host, and only through
the host subsidy (synthesis-011 ratified architecture intent).
Three closures gate every subsidy invocation:

1. Subsidy authority list enumerated up front (named, allowlisted
   verbs).
2. Audit log + kill-switch.
3. Boundary procedurally enforced (bypass is Li's veto-override,
   not a fallback the pack can elect).

The pack does *not* define the subsidy verbs. The verb list is
Li-authorized in the separate `cr-6szw` (mayor: subsidy interface
design + first verb) bead. The deployment-specialist requests
verbs; the subsidy refuses non-allowlisted verbs structurally
(synthesis-011: "subsidy refuses non-allowlisted verbs"). The
deployment-specialist's `deploy.verdict=blocked_on_subsidy` is
the structural signal.

## Keel enforcement — what the reviewer actually does

The reviewer's job, in one sentence: *given a diff and the keel
ruleset, produce findings cited by line in the diff and by line
in keel for each rule whose decision-test the diff trips, and
refuse to produce findings for rules whose decision-test isn't
operationalizable on a diff.*

The decision-test discipline (keel.md lines 33–35) is what
distinguishes a rule from decoration. The reviewer's first
operational test on every keel rule it encounters: *can I match
this rule's decision-test against patterns I can detect in this
diff?* If yes, the reviewer applies the rule. If no, the rule
is decoration; the reviewer records this and surfaces to mayor as
a *rule-question bead* asking the council whether the rule's
force should be downgraded or its decision-test rewritten.

The reviewer **enforces rules**, **flags guidelines**, and
**describes practice notes** — the three labels of keel.md line
12 mean what they say. A reviewer who blocks on a guideline has
confused force; a reviewer who only flags a rule has done the
same in the other direction. (keel.md lines 19–22.)

The reviewer **does not invent keel by enforcement.** When a
pattern repeats across reviews and no rule covers it, the
reviewer opens a rule-question bead and waits for council
ratification; it does not adjudicate inline. (keel.md lines
59–61.)

Severity vocabulary on findings:

| severity | meaning | reviewer action |
|---|---|---|
| `block` | a keel **rule** is violated; merge blocked | `reviewer.verdict=block`, route back to writer |
| `required-fix` | a keel **guideline** is violated without justified exception | finding recorded, but `verdict=approve` if no rule violations; writer addresses or records justified exception |
| `suggestion` | a keel **practice-note** is described or general code-quality observation | finding recorded; `verdict=approve` |
| `accept` | no findings; diff is keel-clean | `verdict=approve` |

The reviewer's signature artifact is the findings list; the
`verdict` is mechanical from the highest-severity finding.

## Push-not-pull — every coordination point

Every coordination point in the pack uses beads + work_queries.
No role polls; no order ticks asking "is anyone done?"
(lore's `programming/push-not-pull.md` line 13: "Polling is wrong.
Always.")

Concretely:
- The writer's work_query is the gas-city default 3-tier
  (in-progress assigned → ready assigned → ready routed-to-me).
- The reviewer's work_query filters on
  `writer.complete=true && reviewer.complete=false`.
- The test-pilot's work_query filters on
  `reviewer.verdict=approve && test_pilot.complete=false`.
- The deployment-specialist's work_query filters on
  `test_pilot.verdict=pass && deploy_specialist.complete=false`.

Each role's session is `mode = "on_demand"` per gas-city
vocabulary; the reconciler spawns a session when its work_query
returns work, idles when not. No "patrol every minute" order; the
work-query subscription IS the patrol.

The forum-round-watcher self-fire incident (mayor.md §7) is the
canonical anti-pattern this discipline closes. No order in this
pack triggers on a bead-state event the pack itself produces. If
recovery becomes necessary (stuck beads, orphaned worktrees), it
enters as a separate bead and a separate design pass — not as a
self-firing watchdog.

## Failure modes named

A design's honesty is in what it admits can fail. Six failure
modes the pack closes (by structure or by named handoff):

### 1. Over-orchestration

*Multiple roles do the work of one.* Closed by: each role has
exactly one signature artifact; if two roles produce the same
artifact, the cohort is wrong, not the pack. Synthesis-011's
ratified five-role cohort already cut "generic implementer" as
"too broad"; the pack inherits that discipline.

### 2. Role-collision

*Code-writer and code-reviewer step on each other.* Closed by:
declared write sets are disjoint (writer touches the worktree;
reviewer touches bead notes + review-findings + rule-question
beads — never the worktree). Lore's
`programming/abstractions.md` line 14 ("every reusable verb
belongs to a noun") at the role level: each verb (write, review,
test, deploy) belongs to one role; no floating "implement" verb.

### 3. Ceremony

*Rules cannot be tested on a PR.* Closed by: the reviewer's
first test on every keel rule is "can I match this rule's
decision-test against patterns in this diff?" Decoration rules
become rule-question beads, not silent enforcement.

### 4. Wrong-noun trap

*Patch lands in the wrong crate.* (lore's
`programming/abstractions.md` lines 217–254 — "adjacency of
*types* is not the same as adjacency of *concerns*.") Closed by:
the writer's bead names `target_repo`; the reviewer's findings
include "wrong-repo" as a possible severity-block category. If
the writer accepts a bead whose `target_repo` is wrong for the
change, the reviewer blocks; mayor re-files.

### 5. Self-fire loops in orders (mayor.md §7)

*An order's own lifecycle re-triggers it.* The pack adds **no
orders** in its initial form. If recovery surfaces add orders,
each passes the self-fire test before landing. Per mayor.md §7
+ §8: order authorship is not mayor's; goes to the operational-
affinity author.

### 6. Unannounced sprawl across rigs

*A bead grows scope mid-pipeline; the writer touches a second
rig without mayor's authorization.* Closed by: declared write set
is per-bead, scoped to one `target_repo`. A bead that needs two
rigs is split or escalated; mayor re-files. The reviewer's
verdict-block category includes "out-of-scope-rig."

## Closures — what gates what

Listed in install order; lightest gates fire first.

- **Worktree isolation gate.** Before code-writer's first run,
  the gas-city worktree convention is verified working in the
  staging city (writer's `<work_dir>` is filesystem-distinct
  from production).
- **Keel-readiness gate.** Code-reviewer cannot install before
  the first keel section exists (synthesis-011 line 92: "created
  concurrently with the first keel section"). The first keel
  section's content is Li + council decision.
- **Subsidy verb-list gate.** Deployment-specialist cannot
  install before Li authorizes the subsidy verb list (synthesis-
  011 ratified architecture intent's three closures). Without
  authorized verbs, every deploy packet is `blocked_on_subsidy`
  by structure.
- **Push-not-pull gate.** Static check on the pack's order list
  before each install: if any order is added, the order's
  trigger passes mayor.md §7 self-fire test.
- **One-capability-per-role gate.** Static check on the pack's
  prompt templates: each role's signature artifact appears in
  exactly one role's prompt. No role's prompt extends another
  role's signature artifact.
- **Workspace-boundary gate.** Every role's prompt carries the
  workspace-boundary rule (city.md "Workspace boundary"); each
  role's declared write set is a strict subset of the boundary.

## Open questions per seat

Each open question is named for the seat whose concern it
touches; the seat addresses or refuses on its review pass. If a
question receives no answer in any pass, mayor surfaces it as a
round-9 candidate.

### Viveka's territory

- **Pack vs complex vs pipeline vs forge.** Working name
  "code-implementing pack" presumes gas-city's `pack` primitive.
  Is the lore-style name "forge" (per AGENTS.md line 187:
  "criome communicates. Effect-bearing work — spawning
  subprocesses, writing files outside sema, invoking external
  tools, code emission — is dispatched as typed verbs to
  dedicated components (forge, arca-daemon, prism)") more apt? Is
  there a Sanskrit/Greek term-of-art that should claim this name?
- **Verdict vocabulary.** `approve / block / refer / pass / fail
  / defer / packet_ready / refused / blocked_on_subsidy` —
  consistent or sprawling? Should the verdict-vocabulary
  collapse to one set across stages?
- **Witness/patrol/recovery role.** Does this belong in the pack
  or as a parallel city-level concern? My current position: out
  of scope; surface to council if false-block / false-pass /
  stuck-pipeline failures accumulate.

### Dharma's territory

- **Subsidy authority for the deployment-specialist.** Verbs are
  Li-authorized separately. What happens when Li is unavailable
  and a deploy is time-sensitive? My current position: deploy
  waits; "time-sensitive deploy" is not a category this pack
  honors (criome is not optimizing for speed per INTENTION
  §"What we are not"; lore's `INTENTION.md` line 60).
- **Cross-rig changes.** A change that requires both crate A and
  crate B (by lore's "adjacency of concerns" rule, both
  micro-components legitimately receive part of the verb).
  Mayor splits into two beads with explicit dependency; is that
  enough? Or does the pack need a "convoy of code-beads"
  primitive?
- **Reviewer's rule-question authority.** Filing a rule-question
  bead is a write. The reviewer's declared write set includes
  "rule-question beads via `gc bd create`." Is bead-creation
  authority a smuggle (cf. Viveka's review of the auditor —
  "follow-up bead" as authority smuggle, viveka.md line 38)? My
  current position: this is named, scoped (rule-question only),
  and necessary for the reviewer's keel-enforcement-without-
  inventing discipline. Stays explicit.

### Prayoga's territory

- **Worktree contention.** What happens when two code-beads route
  to the writer simultaneously? The writer is a pool agent; each
  bead gets its own worktree. Worktree path collision is gas-
  city's responsibility (`.gc/worktrees/<rig>/<bead-id>/` per
  bead). Confirm.
- **Dolt cost per pipeline run.** Each stage transition is one or
  more bead-update events. A 4-stage pipeline produces ~12 bead
  updates per code-bead; an active pack with N concurrent beads
  produces 12N updates over the pipeline duration. Cost
  estimate? Threshold?
- **Recovery shape.** A bead at stage 3 (test) that never closes
  (the test-pilot crashed; staging is down). Without an order or
  patrol role, the bead sits. Mayor's reading discipline catches
  it eventually; is that fast enough? The auditor's `unserviceable`
  category (post-Viveka split) would surface it on the next
  audit.
- **Formula vs work_query precedence.** Both express the
  pipeline; if they disagree, which wins? Formula is the
  documented DAG; work_query is the runtime dispatch. They must
  agree by construction.

### Satya's territory

- **What proves the pack works?** The acceptance check (packet
  §"Acceptance check") names dry-run + sample artifacts +
  reviewer transcript + negative spot check (no-false-pass +
  no-false-block). Sufficient?
- **What proves the reviewer correctly applies a keel rule?**
  Cite the rule by line; cite the diff by line; the decision-
  test's match is mechanical. If the reviewer cannot
  mechanically demonstrate the match, the finding is not a
  block — it's a suggestion.
- **What proves the deployment-specialist's deploy packet would
  succeed if invoked?** Dry-run is the answer (synthesis-011's
  five protocol-not-convention gate, gate 1). The packet
  includes a dry-run record before subsidy invocation.

### Rasa's territory (savor-pass)

- **Re-read curve on the pack-name.** "Code-implementing pack"
  on first reading vs second reading — does it thicken or thin?
- **Role-name salience in the formula DAG.** When a future mayor
  reads `mol-code-implement.toml` six months from install, do
  the role names (code-writer, code-reviewer, test-pilot,
  deployment-specialist) still tell the story? Or does the DAG
  read as a list of generic stages?
- **Verdict-vocabulary disclosure curve.** Eight verdicts across
  four stages is dense. On second reading, does the pattern
  emerge (approve / block / refer at each stage, plus subsidy-
  specific terminal verdicts)? Or does it stay opaque?

## Acceptance check (mirrored from packet, expanded)

1. **End-to-end dry-run.** A mock code-bead enters at stage 0
   with `target_repo=lojix-cli`, `change_summary="add --version
   flag"`, `keel_section="cli-conventions"`. The mock keel
   section has one rule: "every CLI binary supports `--version`."
   The writer adds the flag + a test; reviewer matches the rule's
   decision-test on the diff, finds rule satisfied, verdict=
   approve; test-pilot runs the test in staging, verdict=pass;
   deployment-specialist produces a packet (no host effect).
   Demonstrates handoff contracts work end-to-end.
2. **Sample artifacts.**
   - **Writer-output sample:** patch (~10 lines), test (~10
     lines), risk note ("low risk; only adds a flag; no
     existing-flag conflict").
   - **Reviewer-output sample:** finding cited to keel rule "cli-
     conventions §1" by line, cited to diff by line, severity=
     `accept`, verdict=approve.
   - **Test-pilot output sample:** staging-run report showing
     `cargo test --features=cli` exit 0; coverage delta noted.
   - **Deployment-specialist packet sample:** deploy packet at
     `_intake/deploy-packets/<dated>.md` with the five gates
     filled (dry-run record, rollback contract, test environment
     first, two-eyes review, council strong-against = veto);
     subsidy verbs requested = `[publish-flake]` (not
     authorized; verdict=blocked_on_subsidy).
3. **Reviewer transcript.** Disposition log per synthesis-012
   §4 — every routed seat's must-fix / should-fix recorded with
   accepted / modified / declined-with-reason / escalated.
4. **Negative spot check.**
   - **No-false-pass:** writer-output omits the `--version` flag
     (the bead asked for it); reviewer matches the keel rule's
     decision-test, finding the rule violated, severity=block,
     verdict=block. The pack must reject the work, not silently
     pass it.
   - **No-false-block:** writer-output is keel-clean (the
     `--version` flag is present, tested, conforming);
     reviewer's findings list is empty, verdict=approve. The
     pack must approve the work, not fabricate a refusal.
5. **Self-fire loop check.** The pack's `formulas/` directory
   passes `mayor.md §7` analysis (cron / filtered-event / no-
   event triggers only); the pack's `orders/` directory is empty
   in initial install (so the self-fire check is vacuous;
   re-fires when orders are added in a follow-up bead).
6. **Push-not-pull check.** The pack's design contains zero
   instances of polling, sweep loops, or "tick-rate" cadences.
   Coordination is bead-state + work_query subscription only.

## Vocabulary

Pulled from gas-city + criome + lore; load-bearing terms only.

| term | source | meaning here |
|---|---|---|
| pack | gas-city `vocabulary.md` line 19 | reusable bundle of agents/formulas/orders/scripts; the artifact this design produces |
| bead | gas-city line 64 | universal unit of work; every role's input and output |
| code-bead | this design | a `type=task` bead with metadata indicating implementation work; the input to the pack |
| formula | gas-city line 73 | TOML-defined workflow DAG; the pack ships one (`mol-code-implement`) |
| work_query | gas-city line 75 | shell command an agent runs each turn to find work; how each role subscribes |
| routed bead | gas-city line 76 | bead with `gc.routed_to=<agent-name>` metadata; how mayor enters work into the pack |
| worktree | gas-city `.gc/worktrees/<rig>/<bead>/` convention | filesystem-isolated sandbox per writer per bead |
| declared write set | this design (mirrors lore "owned-and-not-owned" from AGENTS.md line 47) | the paths a role may touch; structural authority boundary level 1 |
| target_repo | this design | bead metadata naming which rig the change applies to; structural authority boundary level 2 |
| host subsidy | synthesis-011 ratified architecture intent | Li-owned, verb-limited effect broker; structural authority boundary level 3 |
| keel rule / guideline / practice-note | keel.md line 12 | binding force taxonomy; reviewer enforces / flags / describes |
| decision-test | keel.md line 33 | the operational criterion a reviewer applies; rules without one are decoration |
| rule-question bead | this design (named in keel.md enforcement contract, lines 59–61) | reviewer's surface for "this pattern repeats but no rule covers it" |
| deploy packet | this design (composes synthesis-011's five protocol-not-convention gates) | Markdown artifact for Li's subsidy authorization |
| signature artifact | this design | each role's unique cite-able output |
| affinity | synthesis-012 §2 | the central failure mode a role's work matches |
| micro-component | lore `programming/micro-components.md` | one capability per crate / repo; the bead-scope discipline mirrors this |
| push-not-pull | lore `programming/push-not-pull.md` | producers push, consumers subscribe; every pack coordination point |
| beauty | lore `programming/beauty.md` | ugliness signals missing structure; reviewer's "feels off" → rule-question bead, not silent enforcement |
| verb belongs to noun | lore `programming/abstractions.md` | every verb (write/review/test/deploy) lives on one role |
| ZFC / GUPP / NDI | gas-city philosophy | structural disciplines the pack inherits |

## Status

- Draft author: mayor.
- Date: 2026-05-03.
- Reviewer route: not yet engaged; first sling to **Viveka** at
  draft completion.
- Disposition log: empty.
- Marker bead: filed concurrently with this draft (forum-round-
  shaped: design pass uses synthesis-012 process, not a forum
  round; marker bead exists for tracking, not for the watcher
  which is disabled per mayor.md §7).

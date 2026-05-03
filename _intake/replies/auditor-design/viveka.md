# Viveka review - auditor prompt design

## Position

The draft's basic shape is correct: the auditor produces a health-ledger snapshot and does not act on what it finds. The term-boundary is not yet clean enough to pass. Four terms carry the load: `read-only`, `follow-up bead`, `stuck bead`, and `audit`. `Read-only` currently means both "no operational mutation of the inspected city" and "no mutation at all," which contradicts the role's required audit-file write, bead-note update, and bead close. `Follow-up bead` quietly grants bead-creation or routing authority. `Stuck bead` uses incompatible tests in two places. `Audit` is mostly bounded, but the on-demand wording still lets the auditor slide into code reviewer, test pilot, or majordomo territory. These are substantive term cuts because they alter read-write surface, scope, exception path, failure mode, or the meaning of ratified terms under synthesis-012.

## Source bones

- `agents/auditor/prompt.template.md` lines 3-19: auditor as health-ledger snapshotter; lines 40-62: fixed snapshot domains; lines 64-81: severity vocabulary; lines 83-99: evidence discipline; lines 101-121: prohibited actions; lines 123-134: bead workflow; lines 148-166: workspace boundary.
- `_intake/design-packets/auditor.md` lines 42-62: why Viveka reviews first and which terms are loaded; lines 75-87: substantive boundary for new authority verbs and trigger surface; lines 89-110: acceptance check; lines 118-128: mirror, install, and review closures.
- `_intake/synthesis-012-design-process.md` lines 80-90: force-tagged deltas; lines 173-191: substantive/editorial tests; lines 226-239: required closures.
- `_intake/synthesis-011-criopolis-structure.md` lines 89-95: ratified first-cohort role row, including the auditor's health-ledger artifact and read/write scope.
- No additional library source opened for this bead; no librarian request.

## Terminology audit

| term used | sense intended | sense smuggled | proposed disambiguation |
|---|---|---|---|
| `read-only` | Inspection commands do not mutate the city state being inspected. | No mutation of any kind, which forbids the role's required audit file, bead-note update, and bead close. | Use `read-only inspection` plus a closed list of `prescribed output writes`: write `_intake/audits/...`, update only the routed bead's notes, close only the routed bead. |
| `follow-up bead` | The auditor should surface a follow-up need to mayor. | The auditor may create, route, or sling a new bead. | Say `record a follow-up request in the current bead notes for mayor` unless bead creation is intentionally added as a new authority verb. |
| `stuck bead` | A bead whose work appears unable to proceed and needs attention. | Two different conditions: stale/no-progress and unmaterialized-owner/unserviceable route; the draft also uses both OR and AND tests. | Split into `stale bead` for no recent update beyond threshold and `unserviceable bead` for no materialized owner or route path. Then define which one is `note`, `flag`, or `escalate`. |
| `audit` | City-health snapshot over sessions, beads, mail, dolt store, supervisor, and synthesized risks. | Generic inspection: code review, security review, prompt review, staging proof, or majordomo triage. | Keep `audit` only as `city-health audit`; requests outside the six health-ledger domains are recorded as out of scope and routed to the named role. |
| `flag` | Severity level: outside tolerance, should be examined, not a page. | Generic verb meaning "call out," especially in the opening line "flag risks." | Reserve `flag` for the fixed severity level; use `record risks` or `surface risks` in generic prose. |
| `escalate` | Severity level naming a condition and authority, without paging. | Direct alarm/page or emergency authority; also an undefined time horizon in `next cycle`. | Define `cycle` or replace with "before the next scheduled snapshot / requested follow-up"; keep "does not page" adjacent to every escalation definition. |
| `health` / `degraded` | Observable city-state conditions and bounded risk suggestions. | Global diagnosis of the city as sick/broken without command evidence. | The draft mostly fixes this; keep the line that "City is degraded" without observable conditions is not an auditor finding. |

## Comments

1. Location: `agents/auditor/prompt.template.md` lines 101-108 and 123-132.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - authority test, read-write surface and exception path.
   Comment: The prohibition "no `gc bd close`" conflicts with the workflow requiring `gc bd close <id>`. Split the category: the auditor is read-only with respect to inspected city state, but has exactly three output writes: audit file, notes update on its routed bead, close of its routed bead. It must not update or close any other bead.
   Failure prediction: If this remains, the role is either impossible to operate or will teach its occupant to ignore the prohibition section whenever workflow requires it; that weakens the whole authority boundary.

2. Location: `agents/auditor/prompt.template.md` lines 120-121 and 165-166.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - authority test, new artifact/trigger surface.
   Comment: "Surface back to mayor as a follow-up bead" smuggles bead-creation authority. The ratified scope is read city state, write `_intake/audits/`, and bead notes. Change this to "record a follow-up request in the current bead notes for mayor" unless the design intentionally escalates to grant `gc bd create` or sling authority.
   Failure prediction: If unchanged, the auditor can become a triage/orchestration role by creating work from its findings, which reopens the role-boundary question synthesis-011 had cut away from triage and majordomo.

3. Location: `agents/auditor/prompt.template.md` lines 47-49 and 93-96.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - failure-mode and ratified-term meaning.
   Comment: `Stuck bead` is inconsistent. The section list says stuck means no notes update in N days OR owner not currently materialized; the evidence discipline says stuck must reduce to no notes update in X days AND owner is materialized. Those are different definitions. Split the term or choose one test explicitly.
   Failure prediction: If unchanged, the auditor will generate inconsistent findings across snapshots: one run treats unmaterialized owners as stuck, another treats materialization as required for stuckness. That will produce false alarms and non-comparable ledgers.

4. Location: `agents/auditor/prompt.template.md` lines 13-19, 38-62, and 101-115.
   Force tag: `should-fix / required`.
   Substantive/editorial tag: substantive - scope and role-boundary.
   Comment: The on-demand cadence says "one section, one suspicion, one stuck-bead investigation." Bound this explicitly to the six health-ledger surfaces. Add a sentence that code diffs, prompt design, keel compliance, staging proof, deployment readiness, and severity-dispute adjudication belong to code reviewer, test pilot, deployment specialist, council, or mayor as applicable.
   Failure prediction: If not addressed, `audit` will invite generic inspection requests, and the auditor will either overreach or spend bead notes refusing work the prompt could have refused in advance.

5. Location: `agents/auditor/prompt.template.md` lines 64-81.
   Force tag: `should-fix / required`.
   Substantive/editorial tag: substantive - decision test and severity threshold.
   Comment: `Escalate` depends on "within the next cycle," but `cycle` is not defined. Define it against the scheduled snapshot cadence or against the requesting bead's expected return window. Keep `flag` as outside tolerance without immediate compounding risk; keep `escalate` as compounding-risk-before-next-review.
   Failure prediction: If not defined, escalation becomes temperament rather than threshold: one auditor reads "cycle" as hours, another as a week, and the same signal changes severity.

6. Location: `agents/auditor/prompt.template.md` lines 3-6 and 64-81.
   Force tag: `editorial / suggestion`.
   Substantive/editorial tag: editorial - wording-preserving if the severity definitions remain fixed.
   Comment: Replace the opening phrase "flag risks" with "record risks" or "surface risks" so `flag` is not used generically before it becomes a fixed severity level.

7. Location: `agents/auditor/prompt.template.md` lines 47-58 and 87-89.
   Force tag: `defer`.
   Substantive/editorial tag: substantive, but not Viveka-owned.
   Comment: Exact thresholds (`N days`, dolt ceiling, mailbox count), command inventory, and whether rig dolt stores are always inside the auditor's read surface belong to Prayoga and Satya after the terms are stable.

## Worked example

Sentence under test: "The auditor is read-only."

Substitution A: "The auditor does not mutate the city state it inspects, except for its prescribed output writes." This preserves the draft: the role can inspect, write `_intake/audits/...`, update its own bead notes, and close its own bead.

Substitution B: "The auditor performs no mutation of any kind." This breaks the draft: the role cannot write the snapshot file, cannot mirror to notes, and cannot close the bead. The term `read-only` is therefore doing two jobs. The clean name is `read-only inspection`, not unqualified `read-only`.

## Open question

When an open bead's owner is not currently materialized, is the intended first severity `note` because the role may be intentionally dormant, or `flag` because the work has no live route? The answer should be fixed before `stuck bead` enters the prompt as a health term.

## Vote

`object-on-incorporation`: I would object if must-fixes 1-3 are absent from the final draft or silently reclassified as editorial. If those three are incorporated with disposition as substantive comments, I ratify the auditor prompt on Viveka's term and role-boundary dimension.

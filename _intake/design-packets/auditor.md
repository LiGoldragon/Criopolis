# Auditor — design packet

*First exercise of the synthesis-012 design-process. Mayor opens.
2026-05-03.*

## Artifact

- `agents/auditor/prompt.template.md` — the role's prompt template.
- Drafted only; **not** installed in `pack.toml` until the install
  closure fires (Li approval after design pass + bead-test in
  staging city).

## Force class

**design-substantive.** Subset route for the design pass. Graduates
to live → all-five ratification at install gate (per synthesis-012
§"Subset vs all-five — three force classes").

## Audience class

**re-read.** Inhabited prompt; the role occupant reads it on every
session start. Savor-pass fires (Rasa).

## First author

**Mayor.**

Reason: per synthesis-012 §2 affinity table, role prompts compose
with synthesis-011's role-cohort and are city-process artifacts —
"orchestration, city-process, composes-with-synthesis" → mayor.
Prayoga's round-8 reply concurs ("Mayor or majordomo authors
city-process artifacts and role prompts"); synthesis-012's §"Status
of P1 designs" routing table also lists mayor. Satya proposed
Prayoga (operability under load); recorded as a minority view, not
adopted — the auditor's central uncertainty is *role-boundary
plus health-claim discipline*, not implementation under load.

## Reviewer route (in order, with reason)

Subset = all five seats, but routed sequentially, not parallel.

1. **Viveka** — *term and role-boundary stability.* `audit`,
   `health`, `enforcement`, `alarm`, `degraded` are loaded terms
   that overlap test-pilot, code-reviewer, and majordomo. Viveka
   first to cut categories before the rest review on potentially
   wrong scaffolding.
2. **Dharma** — *bound parties.* Li, future mayor, role occupant,
   silent inheritor, anyone paged by a false alarm. Dharma early
   so escalation paths and "when not to escalate" are named before
   operational and truth review.
3. **Prayoga** — *operational ledger.* Cadence (scheduled +
   on-demand per synthesis-011), command surface, dry-run
   discipline, failure thresholds, what the auditor must never
   touch. Prayoga after structure is set so the application
   ledger applies to a stable artifact.
4. **Satya** — *health-claim truth.* Every health assertion needs
   evidence. "Stuck bead" / "mail backlog" / "dolt bloat" must
   reduce to observable conditions; "safe to ignore" must say what
   would refute it. Late so the claims are stable.
5. **Rasa** — *re-read curve, severity language, signal salience.*
   Last because savor-pass fires on a settled artifact. Pass-runner
   = Rasa; kind-conditional firing = yes (re-read class).

## Final writer

**Mayor.** Default per synthesis-012 §4 (multi-discipline artifact;
governance-adjacent; integrates routed comments into one usable
prompt). Disposition log produced on final pass.

## Substantive boundary — what re-opens council or Li

Any of these on the final pass shifts the artifact out of mayor's
editorial authority:

- Adds a new authority verb (write target, mutation power, host
  effect) beyond `read city state` + `write _intake/audits/` + bead
  notes (the synthesis-011 ratified scope).
- Changes the trigger surface (e.g., adds an autonomous escalation
  channel, changes scheduled cadence, claims direct paging power).
- Changes substantive/editorial classification of a logged
  must-fix.
- Touches keel force, subsidy verbs, or live-host effect.
- Re-opens the role-cohort question (synthesis-011 ratified
  five-role cohort; auditor scope is fixed).

If the design surfaces a need to extend any of the above, mayor
escalates rather than absorbing under "editorial."

## Acceptance check

Before close:

1. **Dry-run transcript.** Auditor (or a stand-in invocation) runs
   once in the staging city against a stand-in workload; output
   captured. Demonstrates the snapshot is producible without live
   mutation.
2. **Sample audit report.** One health-ledger snapshot landed in
   `_intake/audits/<dated>.md` per the prompt's specification.
   Demonstrates the report is readable and concrete.
3. **Reviewer transcript.** Disposition log lists each must-fix /
   should-fix concern with disposition (accepted / modified /
   declined-with-reason / escalated). No silent overrides.
4. **No-false-alarm spot check.** A single negative case where the
   city is healthy and the auditor reports clean — i.e., the
   auditor doesn't always find degradation.

The bead-test happens in the staging city when staging stands up
(parallel design `cr-w7ea`, mayor: staging-city setup script).
The acceptance check above can be partially run with hand-rolled
test inputs before staging; full bead-test gates install.

## Closures (per synthesis-012 §"Required closures")

- **Route closure** — this packet logs author (mayor), reviewers
  (5 routed serially), final writer (mayor), force class
  (design-substantive), audience class (re-read), savor-pass (yes,
  Rasa) before drafting begins. ✓
- **Mirror closure** — final prompt at
  `agents/auditor/prompt.template.md`; review notes mirror to
  `_intake/replies/auditor-design/<seat>.md` before bead close.
- **Override closure** — disposition log on every blocker / required
  comment.
- **Subset closure** — N/A (full route used).
- **Install closure** — drafted only; **not** added to `pack.toml`
  until Li approves after design pass + bead-test.
- **Review/deletion closure** — auditor prompt reviewed at first
  major pack/staging change OR at first auditor-false-alarm OR at
  six months from install, whichever first.
- **Self-application closure** — this design uses synthesis-012's
  process. ✓

## Mirror path

- Packet: this file (`_intake/design-packets/auditor.md`).
- Seat reviews: `_intake/replies/auditor-design/<seat>.md`
  (durable mirrors of bead notes; per agents.md rule #1).
- Final prompt: `agents/auditor/prompt.template.md`.
- Disposition log: appended to this packet under §"Disposition
  log" when final-pass runs.

## Deletion / review condition

Reviewed at the first of:

- Auditor produces a false-positive alarm (signal it could have
  suppressed) — review for over-sensitivity.
- Auditor misses a real degradation that surfaced via another
  channel — review for under-coverage.
- Pack/staging adds a new agent class whose health is not
  specified in the prompt's read-surface — extend or split.
- Six months from install with none of the above triggering —
  routine re-read.

## Open question deferred (synthesis-012 §"Open downstream
questions")

Prayoga's question — "can mayor reclassify a must-fix concern as
editorial with written reason, or must it re-open council?" — will
be answered empirically by this very design's first must-fix
collision (if any). Disposition log records the test.

## Status

- Packet opened: 2026-05-03.
- First-draft author: mayor (in progress this session).
- Reviewer route: not yet engaged.
- Disposition log: empty.

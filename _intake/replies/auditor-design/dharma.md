# Dharma review — auditor prompt design

*Routed sequential review per synthesis-012 §3. Reviewing
`agents/auditor/prompt.template.md` (mayor draft) plus Viveka's
already-landed deltas at `_intake/replies/auditor-design/viveka.md`.
Force-tagged deltas; not a competing draft. Dharma-station: bound
parties, authority-line, escalation-path.*

## Position

The draft, with Viveka's must-fixes applied, does most of its
bound-party work. The role's read-only-with-prescribed-writes
posture is correct; the snapshot-not-alarm discipline is correct;
the named-authority-without-paging design is correct. Two
bound-party gaps remain that I treat as must-fix: the escalation
path when the named authority is unmaterialized or is itself the
failing component, and the default severity for beads whose owner
is not currently materialized (Viveka's open question, explicitly
deferred to me as bound-party-shaped). Three should-fixes follow:
a scope statement that the auditor's read-surface is bounded (not
comprehensive), a supervisor-section authority default of Li (not
mayor), and a worked-example revision that drops a characterization
of the bead-owner. Two items defer to mayor's prompt or to Prayoga.

## Roll-call

Parties bound by ratifying this prompt for design-pass and staging
bead-test, with harm-window per party:

1. **Future role occupants** — *inherited.* The prompt is inhabited;
   the occupant reads it at session start.
2. **Li** — *immediate + inherited.* Operator who reads
   `_intake/audits/`; system-root for supervisor concerns.
3. **Mayor** — *immediate.* Primary tasker; primary audit consumer;
   named authority for most findings; subject of findings about its
   own load.
4. **Council seats** — *delayed.* May task on-demand audits; their
   beads may appear in findings.
5. **Bead owners characterized as `stuck` / (post-Viveka) `stale` /
   `unserviceable`** — *immediate.* Named in the audit; not at the
   table when it is composed.
6. **The unmaterialized role whose bead is `unserviceable`** —
   *inherited.* Bound by being characterized; not in the room
   because the role isn't running.
7. **Silent inheritors — work outside the six audit surfaces**
   (library state, `_intake/` accumulation, sub-project repos
   under `~/git/`, stale keel rules whose deletion-conditions have
   fired, dolt branch divergence, agent classes added since the
   prompt last reviewed) — *inherited.* Bound by the audit's
   implicit claim of comprehensiveness.
8. **The named authority in an `escalate` finding when that
   authority is unmaterialized or is the failing component
   itself** — *immediate-to-delayed.* Bound to act; not in the
   room because unreachable, or because the routing closes a loop
   (e.g., a finding about mayor routes only to mayor).
9. **Future synthesizer reading audit logs months out** —
   *inherited.* Bound by reproducibility; well-served by the
   cited-command discipline already in the draft.

Defer-marks — parties I cannot honestly fill:

- **Operational thresholds** for "always-on" vs "on-demand"
  classification per role — Prayoga's territory; I lack the
  load-pattern observations.
- **Specific list of out-of-scope surfaces** the scope statement
  should mention by example — partial only; the full list emerges
  from staging bead-test (`defer: rehearsal not reliable`).

Load-check: rehearsal honest under current context; I can rehearse
the present cohort. I cannot reliably rehearse a future seventh role
I don't yet know exists — which is itself part of why I'm asking
for the scope statement, so the prompt does not assert coverage it
can't sustain.

## Bound-party rehearsal — three findings

**Bound (procedural condition):** All nine parties are subject to
the prompt's effects without having spoken in the design pass.
Parties 6 (unmaterialized role) and 7 (silent inheritors) are bound
*most strongly* — they have no channel into the design pass at all,
structural or procedural.

**Consent:** Future role occupants (1) and Li (2) have presumed
consent through the design-process chain. Mayor (3) and council
seats (4) consent through this routed review. Bead-owners (5) have
not consented to characterization criteria; the right discipline is
to make criteria explicit in the prompt so consent becomes
procedural-by-publication. The unmaterialized role (6) cannot
consent at audit-time; the kindest-to-absent-party default is
`note`. Silent inheritors (7) cannot consent; the right discipline
is to *not claim coverage* of them. The named-but-unreachable
authority (8) cannot consent at the moment of need; the right
discipline is the cascade rule.

**Injured:** Party 5 is injured by the worked-example "possibly
forgotten" characterization (should-fix 5). Party 6 is injured if
`flag` is the default severity for unmaterialized-owner beads
(must-fix 2). Party 7 is injured if `all-clean` reads as a
comprehensive city-health claim (should-fix 3). Party 8 is injured
if an `escalate` has no live recipient (must-fix 1). Parties 1, 2,
3, 4, and 9 are bound but not injured by the current draft with
Viveka's must-fixes applied.

## Comments

### Must-fix 1 — Escalation cascade when named authority is unmaterialized or is the failing component

**Location:** `agents/auditor/prompt.template.md` lines 76–78
(`escalate` definition) and lines 132–134 (bead workflow step 5).
**Force tag:** must-fix / blocker.
**Substantive/editorial tag:** substantive — authority test
(failure mode + exception path) and bound-party test (the named
authority's reachability).

**Comment:** The `escalate` severity names the condition,
refutation, and authority. The draft does not say what happens
when (a) the named authority is unmaterialized at audit time, or
(b) the named authority is the failing component itself
(e.g., a finding about mayor's mail backlog or supervisor-observed
mayor-load routes to mayor, who is the audit consumer of record
*and* the actor in question). Required addition — a cascade rule:

> When the named authority for an `escalate` would be unreachable
> (unmaterialized) or is the failing component, the auditor names
> a fallback authority. Default cascade: mayor → Li for findings
> naming mayor as the failing component; primary-seat → mayor → Li
> for findings naming a council seat. The fallback is *named in
> the audit*; the auditor still does not page.

**Failure prediction:** an `escalate` against mayor's load is
recorded but routes only to mayor; mayor as the actor cannot
triage the finding-about-mayor; the escalate is structurally
invisible. The auditor produces durable records that, in the most
consequential class of findings, have no live recipient. The role
becomes ceremonial in exactly the cases it is designed to catch.

### Must-fix 2 — Default severity for unmaterialized-owner beads is `note` with route-status sub-finding

**Location:** `agents/auditor/prompt.template.md` lines 47–49
(Beads section) and lines 93–96 (evidence discipline) — applies to
whichever post-Viveka split term inherits the unmaterialized-owner
condition (`unserviceable`, per Viveka's proposed split).
**Force tag:** must-fix / blocker.
**Substantive/editorial tag:** substantive — meaning of a ratified
term (severity assignment for `unserviceable`); bound-party test
(the absent role).

**Comment:** Viveka's term-cut splits `stuck bead` into `stale`
(no notes update beyond threshold; owner materialized) and
`unserviceable` (no materialized owner or route path) and asks
Dharma which severity `unserviceable` carries by default. My
answer:

> An open bead whose owner is not currently materialized is `note`
> by default. Promote to `flag` only when the role is `always-on`
> per pack/staging *and* the bead's age or content suggests
> blocked work. The audit must surface a *route-status sub-finding*
> on every `unserviceable` entry: when was the bead routed, when
> was the role last materialized, and is the role classified
> `always-on` or `on-demand`.

**Reasoning:** the unmaterialized role cannot speak in the design
pass or in the audit moment. Default-`note` honors possible
intentional dormancy and lets the role refute by waking.
Default-`flag` characterizes the absent role as failing without
giving it a refutation channel. The promotion test
(`always-on` + age/content) keeps the auditor honest when dormancy
is not the explanation.

**Failure prediction:** without this, the post-split term
`unserviceable` enters the prompt without a default; future
occupants (or this occupant under load) will pick a severity
inconsistently. Dormant roles will be characterized as failing
(false alarms accumulate); or — equivalently bad — broken routes
(a role that *should* be live) will be muted as `note`. Either
mode is bound-party-injurious to a specific class of party (the
absent role; or the work-requester whose bead never moves). The
disambiguation is Dharma's to provide because Viveka explicitly
deferred it as a bound-party question, and because the choice
determines which absent party is preferred.

### Should-fix 3 — Read-surface scope statement (silent inheritors)

**Location:** `agents/auditor/prompt.template.md` lines 39–62 (six
fixed sections) and lines 64–81 (severity vocabulary, particularly
`clean`).
**Force tag:** should-fix / required.
**Substantive/editorial tag:** substantive — failure mode (false
reassurance is a new failure mode the prompt does not name) and
bound-party test (silent inheritors not in the read surface).

**Comment:** The draft's six fixed sections (sessions, beads, mail,
dolt, supervisor, risks) are the auditor's read surface. A `clean`
snapshot says "the inspected surfaces are healthy"; it does *not*
say "the city is healthy." Add an explicit scope statement near
the severity vocabulary or near the Risks section:

> The auditor's read surface is the six fixed sections. Risks
> outside this surface — library state, `_intake/` accumulation,
> sub-project repos under `~/git/`, stale keel rules whose
> deletion-conditions have fired, dolt branch divergence, and any
> agent class added since the prompt last reviewed — are out of
> scope and not characterized by this snapshot. An `all-clean`
> audit means "the inspected surfaces are clean," not "the city
> is healthy."

**Failure prediction:** without this, an `all-clean` audit
functions as false reassurance — the inverse of the no-false-alarm
rule. Silent inheritors (party 7) are bound by the audit's
implicit claim of coverage. The packet's deletion/review condition
("Pack/staging adds a new agent class whose health is not specified
in the prompt's read-surface — extend or split") anticipates this
at the deletion gate, but the prompt itself does not honor the
same boundary explicitly to its readers in the meanwhile.

### Should-fix 4 — Supervisor-section authority defaults to Li, not mayor

**Location:** `agents/auditor/prompt.template.md` lines 56–62
(Supervisor / dispatcher section) and lines 60–62 (Risks section's
authority field).
**Force tag:** should-fix / required.
**Substantive/editorial tag:** substantive — authority test
(correct named authority for the failure class).

**Comment:** The Risks section's authority field reads "mayor /
Li / council." For supervisor-section findings (duplicate
dispatchers, ghost panes, processes whose cwd is invalid,
supervisor restarts), mayor is structurally not the authority —
the supervisor *runs* mayor. Add a default to the Supervisor
section:

> Supervisor-section findings name **Li** as the authority by
> default. Mayor is the authority only for observable load (tick
> rate, dispatcher load, mail backlog visible to the supervisor)
> where mayor's interpretation is informative. Process-level
> findings (duplicate / ghost / invalid cwd / restarts) cascade
> to Li.

**Failure prediction:** a supervisor finding routed to mayor
doesn't get acted on because mayor lacks authority to manipulate
the supervisor. The audit surfaces the right signal to the wrong
actor; the city's most root-level health concerns are routed away
from the only actor who can address them.

### Should-fix 5 — Revise the worked example to drop characterization of the bead-owner

**Location:** `agents/auditor/prompt.template.md` lines 178–180
(the example: `cr-x9zz (mayor: draft deploy-spec prompt) opened
21 days ago, no notes since open; owner mayor (always-on). flag —
possibly forgotten; mayor should triage.`).
**Force tag:** should-fix / required.
**Substantive/editorial tag:** substantive — bound-party test (the
bead-owner is characterized rather than cited); secondary
form-curve (Rasa to refine wording on her pass).

**Comment:** "Possibly forgotten" is a characterization of mayor's
relationship to the bead. The auditor's discipline (per the draft
itself, lines 95–96) is to cite the signal and the refutation, not
to characterize the actor. Revise:

> ## Beads — flag (one stale)
> 38 open total (5 P1, 22 P2, 11 P3). cr-x9zz (mayor: draft
> deploy-spec prompt) opened 21 days ago; no notes update since
> open; owner mayor (always-on). Refutation: bead carries
> `parked=true` metadata, or mayor's intent is recorded
> elsewhere. Authority: mayor.

**Failure prediction:** the example trains future occupants to
characterize bound parties (especially mayor and seats whose beads
appear in findings) rather than cite signals. Across many
snapshots, the audit log accumulates implicit assessments of
actors' attention; that is a slow drift toward triage-by-narration
that the role-cohort explicitly cut.

### Defer 6 — Mayor-prompt subscription to `_intake/audits/`

**Force tag:** defer.
**Substantive/editorial tag:** defer to mayor's prompt
(`cr-y0fm` (mayor: auditor role prompt umbrella) or to mayor's
operating discipline).

**Comment:** An on-demand audit tasked by a council seat lands in
`_intake/audits/<dated>.md` but mayor doesn't necessarily see it
unless mayor has a reading discipline. This is mayor-prompt
territory, not auditor-prompt territory. I record the bound-party
shape so it doesn't get lost: parties named in on-demand audit
findings (typically mayor, occasionally other seats) are bound by
findings they may not see if the audit is read only by the
requester.

### Defer 7 — Cross-routing to seats when their beads appear in findings

**Force tag:** defer.
**Substantive/editorial tag:** defer to mayor (active routing of
findings is triage; triage was deliberately not added to the
role-cohort in synthesis-011).

**Comment:** When an audit names a council seat's bead as `stale`
or `unserviceable`, the auditor records the finding but does not
route to the seat. The seat is bound by the characterization but
is reached only via mayor's reading-and-routing. This is correct
(the auditor must not become a triage role through a "notice"
backdoor, which would smuggle a write-action beyond the prescribed
write list); the bound-party shape should be visible. Mayor's
reading discipline (defer 6) is the channel.

## Source bones

- `_intake/design-packets/auditor.md` lines 41–51 (bound parties to
  consider, including the "council seats — does notice go to seat
  or only to mayor" question that comments 6 and 7 answer); lines
  75–87 (substantive boundary: new authority verbs, trigger
  surface, escalation channel — must-fix 1's cascade is a textual
  addition, not a new authority verb, so it stays inside the
  ratified scope).
- `_intake/replies/auditor-design/viveka.md` lines 17–25
  (terminology audit; the `unserviceable` / `stale` split that
  must-fix 2 answers); line 79 (the open question explicitly
  deferred to me).
- `_intake/synthesis-012-design-process.md` lines 175–191 (three
  convergent tests: authority + bound-party + form-curve; my
  must-fixes trip authority + bound-party; should-fixes trip the
  same).
- `_intake/synthesis-011-criopolis-structure.md` lines 89–95 (the
  auditor's ratified scope: read city state + write
  `_intake/audits/` + bead notes only — the fence I am defending
  against the smuggle of triage-by-notice in defer 7).
- `agents/auditor/prompt.template.md` lines cited per comment.
- *(paraphrase from memory; flag for librarian)*: the
  *Vidura-nīti*'s "they are abundant that can speak agreeable
  words; the speaker, however, is rare, of words that are
  disagreeable but medicinal" is the seat's working definition;
  should-fix 3 (read-surface scope statement) is the
  medicinal-but-unwelcome word against the draft's implicit claim
  of comprehensiveness. Library has the *Mahābhārata* second
  volume on disk now; not opening it for this review since the
  citation is general and in soul, not load-bearing on a specific
  clause.

## Worked example

A scheduled audit at 2026-06-01 finds: mayor's mail backlog at 12
unread (above the prompt's "mayor > 5" flag threshold);
supervisor restarted three times in 24 hours; Prayoga's seat
unmaterialized for 9 days with two open beads in its queue.

**Without the must-fixes:**

- The mayor-mail-backlog finding routes to mayor as `escalate`.
  Mayor is the actor; mayor reads its own escalate; mayor cannot
  triage itself effectively; the finding sits.
- The supervisor-restart finding routes to "mayor / Li / council"
  — the prompt's authority field is parametric; the auditor picks
  mayor by default (mayor is the standard recipient). Mayor cannot
  act on the supervisor.
- Prayoga-bead findings: post-Viveka split, the bead is
  `unserviceable`. No default severity. The occupant might pick
  `flag`, characterizing Prayoga's seat as failing to staff
  itself.

**With must-fixes 1 and 2 incorporated:**

- Mayor-mail-backlog escalates with cascade-named fallback `Li`
  (mayor is the failing component). Li reads `_intake/audits/`
  periodically; Li can ask mayor to triage or take action herself.
- Supervisor-restart is `escalate` with authority `Li` by the
  supervisor-section default (should-fix 4) and reaches the right
  actor.
- Prayoga's beads are `note` with route-status sub-finding
  ("Prayoga last materialized 2026-05-23; classification: on-demand
  per pack; beads cr-X and cr-Y opened 2026-05-29 / 2026-06-01;
  route-status: dormant-by-design"). No characterization of
  Prayoga as failing; if Prayoga's seat is supposed to be active
  and isn't, the route-status sub-finding is the signal that
  surfaces to mayor for attention.

The audit becomes informative without becoming accusatory; the
named authorities are reachable; the absent parties (Prayoga's
seat) are characterized minimally and given a refutation channel
by waking.

## Open question

For the round-9 candidate list or for a future review-cycle: the
`escalate` severity with my proposed cascade rule presupposes
*some* live authority is reachable. But what happens when *all*
candidate authorities for an escalate are unreachable (mayor
unmaterialized, Li away, council seats not running)? The cascade
has a base case I have not specified. The current durable-record
answer ("the next reader picks it up") is a slow channel for a
real degradation while no human is at the controls. Is there a
fast-channel — a wake-up bead that fires when an `escalate` lands
without a live authority — that the auditor *names* but the
supervisor (a non-authority process) executes?

I park this as a Dharma round-9 candidate. It is *not* in scope
for the current design pass, and including it now would re-open
the trigger-surface discussion synthesis-011 cut. But the bound
party — the city-as-such, when no human is present — is a real
party with no current procedural channel.

## Vote

`object-on-incorporation` — *conditional, in the sense Viveka used
it*: I would object if must-fixes 1 and 2 are absent from the final
draft or silently reclassified as editorial. If both are
incorporated as substantive with disposition logged, I ratify on
Dharma's bound-party / authority-line dimension. Should-fixes 3,
4, 5 should be addressed (with disposition recorded if declined).
Defers 6 and 7 are mayor-prompt territory and not blocking on this
artifact.

In one line: the draft + Viveka's must-fixes + my must-fixes is, on
bound-party grounds, ratifiable for design-pass and bead-test.
Without my must-fixes, the role's most consequential class of
findings (escalate against mayor; unmaterialized-owner beads) has
bound parties without procedural channels, and the role becomes
ceremonial in exactly the cases it was designed to catch.

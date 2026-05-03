# Synthesis 011 — Criopolis structure (round 7, first substantive structure round)

*Mayor's collation of round 7. Five seats × four threads. Marks
summary: 0 dissents on the four directions; uniform [strong-for]
on hybrid-with-subsidy, on staged first-cohort roles, on the keel
A+B form, on the lightest-first sequence. Defers and closures are
the work; the directions are settled.*

*Sources: `_intake/replies/criopolis-structure/{satya,viveka,dharma,prayoga,rasa}.md`. Adjacent input now landed:
`research/answers/bead-pc-m5yg.md` (Wasteland + community gas-city
structures).*

---

## Thread 1 — Sandbox vs sibling, with subsidy variant

**Vote:** **5/5 strong-for hybrid-with-subsidy.** No dissents.

The seats agree on direction unanimously and converge on the form's
discipline:

- **Criopolis runs in a sandboxed authority boundary.**
- **A subsidy runs outside the sandbox**, as Li's user with Li's
  credentials, exposing **typed, named, logged, allowlisted verbs**
  — *not* a credential-passthrough.
- **The boundary is structural, not conventional.** Dharma's
  worked-example crystallizes this: an implementer breaking
  `~/.gitconfig` hooks under sibling because the boundary lives in
  the prompt's care; under hybrid the subsidy refuses the
  non-allowlisted verb because the boundary lives in the runtime
  form. *Each role doing its own work, not meddling with another's*
  — Plato IV cited as protocol-justice, not metaphysical-justice.
- **Pure sandbox** (no bridge): rejected — falsely denies Li's
  constraint that existing automation continue. *Rasābhāsa of
  safety.*
- **Pure sibling**: rejected — boundary lives only in attention;
  one prompt's amnesia is one daily-life break.

### Viveka's terminology audit (apply before instantiation)

The word *sandbox* is doing at least four jobs and must be split:

| term | sense to use |
|---|---|
| **authority sandbox** | permission/authority boundary (Criopolis-side agents have what they have, no more) |
| **staging city** | a test gas-city instance for vetting changes before live |
| **runtime container** | reserve for actual containerization if/when the threat model warrants |
| **host subsidy** | a Li-owned, verb-limited effect broker with request logs, allowlists, and rollback obligations |

The subsidy is **outside the agent-authority boundary**, but
**inside Li's authority + audit boundary**. Treat the bridge as
production infrastructure, not as a convenience helper.

### Closures the seats demand before live instantiation

Three structural requirements (Dharma's list, echoed by Prayoga's
operator-cost analysis, sharpened by Satya's falsification ledger,
saved as form by Rasa's six-check):

1. **Subsidy authority list enumerated up front.** Not "Li's
   credentials," but a list of named operations. Prayoga's
   first-shape: status / dry-run / read-only inspection / *one*
   explicitly approved execution verb.
2. **Audit log + kill-switch.** Without both, the subsidy is a
   privileged surface Criopolis can use unsupervised.
3. **Boundary procedurally enforced.** Criopolis cannot bypass the
   subsidy without Li's veto-override; bypass is a deliberate
   channel, not an emergency fallback Criopolis can elect.

### Open question (escalated to Li)

What is the **first verb** the subsidy is allowed to perform —
read-only inspection, dry-run build, staged deploy request, or one
narrowly-approved execution verb? Surfaced by Viveka and Prayoga
both. Li-decision; sets the subsidy's initial shape better than
"bridge" can.

---

## Thread 2 — Roles for Criopolis

**Vote:** **5/5 strong-for staged first-cohort roles.** Defers and
sequencing differ; the role-set converges.

### First cohort (consensus across the seats)

Five roles ratified for prompt-drafting and staged bead-testing:

| Role | Provider | When fires | Signature artifact | Workspace boundary | Slingable by |
|---|---|---|---|---|---|
| **Auditor** | codex | scheduled + on-demand | health ledger: sessions / stuck beads / mail backlog / dolt size / supervisor status / risks | read city state; write `_intake/audits/` and bead notes | mayor; scheduled rule; council |
| **Test pilot** | codex | before agent-config / prompt / hook / pack changes land live | staging-run report: setup / command log / pass-fail / cleanup / residual risk | the staging city only; **no live mutation** | council-approved test plan via mayor |
| **CriomOS deployment specialist** | codex | on-demand only, never ambient | deploy packet: target / commits / dry-run output / rollback contract / preflight / postflight | read CriomOS+lojix axis; write only city-side packets; act on host *only* through the subsidy | Li or council-ratified deploy bead; **not triage alone** |
| **Code writer** | codex | per ratified engineering bead | patch + tests-run + residual-risk note | declared write set only (assigned repo/worktree); no production deploy | mayor / council / Li |
| **Code reviewer** | codex (claude acceptable for prose-heavy reviews) | on-demand per diff/PR/topic; *also concurrently with* first keel section drafting | findings tied to keel clauses by line; severity; missing-rule notes | read target repo + keel; write review notes only | mayor / any seat through mayor / Li |

### Deferred / cut

- **Ambassador** — defer all 5. The pc-m5yg brief has now
  landed; the role's *form* is now sharper (PR-mode federation via
  Wasteland, not free-form chat), but instantiation still waits for
  Li's decision on whether/when to join the Wasteland federation.
- **Triage** — defer all 5. Premature given current bead-volume;
  Rasa flags hidden-authority risk (if triage decides what reaches
  the council, it has substantive routing power). Mayor handles
  triage until volume justifies.
- **Generic implementer** — Viveka cut: too broad; smuggles
  decision-authority into execution. **Replaced** by the named
  cohort above. Code writer is the engineering-implementer; deploy
  specialist is the deploy-implementer; an eventual *city-config
  implementer* (prompt edits, pack.toml edits) may follow once load
  justifies.
- **Scribe / glossary keeper** — divided opinion. Strong-for from
  Satya, Viveka, Rasa; "useful but not first-cohort" from Prayoga
  (recommends mayor handles until repeated maintenance failure
  appears). Dharma proposes asking the librarian whether the role
  belongs there before creating a sibling. **Mayor's call**: defer
  until first keel section ratifies and surfaces actual maintenance
  load.

### Discipline for the deployment specialist (consensus)

The CriomOS deployment specialist is the role most exposed to
breaking the running machine. Five protocols (not conventions —
the gates do not bend by jurisdiction; *Patañjali II.30–31*'s
great-vow clause cited):

1. **Dry-run as protocol.** No deploy without a dry-run report.
2. **Rollback contract** stated and verified before invocation. If
   rollback isn't testable, deploy isn't authorized.
3. **Test environment first.** Touch a non-production target before
   production. Couples to thread 1's staging city.
4. **Two-eyes review** by at least one council seat (Prayoga for
   under-load shape; Satya for fact-claims).
5. **Council strong-against = veto.** No mayor override on
   substantive deploy changes.

Routine application against the ratified deploy keel section runs
autonomously; substantive changes (new daemon, new module, new
package class) go to council ratification first. The kind-distinction
is what the deploy keel section must hold open.

---

## Thread 3 — Coding council, keel as engineering rules

**Vote:** **5/5 strong-for form A + B.** **5/5 strong-against form
C** (every keel change voted).

The ratified shape:

- **The high council deliberates substantive engineering decisions
  topic-by-topic.** Mayor synthesizes per established discipline
  (rounds 1–6 proven).
- **A code-reviewer role enforces ratified keel** ongoing. Reviewer
  doesn't *invent* keel by enforcement — that would be smuggling
  doctrine. Reviewer reads against the keel-as-ratified.
- **Council ratifies categories (substantive structural changes);
  mayor's editorial authority covers within-category prose work.**
  Every-change-voted is over-ceremony — a chokepoint that either
  stops keel from growing or grows it through workaround channels.

### Three keel labels (Viveka's structural proposal, ratified)

| label | force | who can change |
|---|---|---|
| **keel rule** | binding engineering norm; review can block on it | high council vote or explicit Li decision |
| **keel guideline** | strong default; reviewer flags violations, but justified exceptions pass | high council ratifies; mayor / scribe can clarify without changing force |
| **keel practice note** | descriptive convention, example, or current local habit | scribe / mayor may maintain with source note |

### Required shape per keel rule (Prayoga's structural proposal)

Every keel rule carries six fields:

- **scope** — where this rule applies and where it does not
- **decision test** — what a reviewer does differently because this
  rule exists
- **failure mode** — what it prevents and what new burden it creates
- **example** — one accepted case and one rejected case
- **exception path** — who may waive it and what evidence is required
- **deletion / review condition** — when the rule is reconsidered

A rule whose name doesn't specify enforcement-shape rectifies
nothing (Dharma cites *Analects* 13.3, *zhèng míng*).

### The code-reviewer role is created concurrently with the first
keel section — not after

The dharma move (Dharma + Rasa converge): the code-reviewer is the
*operator-test* for keel. A rule the reviewer cannot operationalize
on a PR is decoration, not a rule. Stage the role *while* the first
keel section drafts; let it test enforceability before the council
ratifies.

### Open question (escalated to Li, deferred to next round)

Viveka's diairesis on **substantive vs editorial keel changes** is
*upstream* of A+B. Without the joint cut sharply, A+B's seam is a
hand-wave and C's blanket-vote rule remains tempting. Rasa flags
this as the next council round. Likely the round-8 question.

---

## Thread 4 — When to start

**Vote:** **5/5 strong-for the lightest-first sequence.** Multiple
seats converge on identical step-orders.

### The sequence (consensus)

Starting now, in this order, each step a *reversible, non-destructive*
move whose outcome teaches the next:

1. **Stand up the staging city.** Separate dolt store, separate
   city directory, same `gc` binary. The prerequisite for
   everything else; touches no running mayor; reversible (drop the
   dolt). Couples to thread 1's hybrid-with-subsidy as the testable
   form.
2. **Draft role prompts** in the staging city: deployment specialist,
   auditor, test pilot, code reviewer. Bead-test each in staging.
   Verify discipline (dry-run, rollback, two-eyes for the deploy
   role; useful health snapshots without false alarms for the
   auditor; etc.).
3. **Council reviews the prompts substantively** before any role
   graduates to live. Substantive votes — not silence-as-finding.
4. **Graduate one role at a time, most-overdue first.** Auditor +
   deployment-specialist are the strongest candidates (mayor is
   structurally wrong for ongoing deploys; unaudited city silently
   degrades).
5. **First keel section drafted** by the council, *with* the
   code-reviewer staged. Tests the council's principled discipline
   transfers to engineering content. The load-bearing test.
6. **Then the next role.** And so on.

### Premature / overdue (consensus)

| Premature | Overdue |
|---|---|
| Live subsidy with Li credentials | Auto-memory migration plan (carryforward from synthesis-010) — Li-decision |
| Direct CriomOS deployment | The staging city itself (could be staged now without further deliberation) |
| Broad code-writing authority before keel labels exist | The deployment specialist's *prompt draft* (not the role's instantiation) |
| Wasteland ambassador (now: brief landed; instantiation still waits for Li's decision on federation membership) | Mayor's prompt acknowledging that substantive structural decisions go to council vote |
| Triage role | |
| Voting every keel edit | |

---

## What the researcher's `pc-m5yg` adds (newly landed)

The Wasteland brief reframes thread 1 + thread 2's ambassador
question. The Wasteland is **not** a chat-with-other-cities
protocol; it is **federated work-network via DoltHub**:

- Source at `gastownhall/wasteland`. CLI is `wl`. Default mode is
  *PR-mode* (push to fork; open PR upstream; admin merges).
  *Wild-west* mode pushes directly for maintainers with write
  access.
- Inter-city contract: **shared Dolt commons** at
  `hop/wl-commons` with tables `rigs / wanted / completions /
  stamps / badges / boot_blocks / chain_meta / rig_links`. Cities
  fork the commons, register their rig in `rigs`, post wanted work
  to the shared board, claim, complete, get stamped.
- Lifecycle: `open → claimed → in_review → completed` (or
  `rejected → claimed`, `open → withdrawn`).
- Hardcoded admins on the upstream commons: `julianknutsen`,
  `steveyegge`, `csells`. Self-stamping is blocked at the schema
  level.

**Implication for Criopolis:** an "ambassador" role would not be
*talking* to other cities; it would be *speaking the wl PR-mode
protocol* on Criopolis's behalf. The role is more like a
"federation steward" than a "diplomat." Defer instantiation per
thread 4 until Li decides whether/when to join.

The brief also surfaces community patterns relevant to threads 2 + 3:

- **`bmt/gascity-explore`** — third-party adaptation that explicitly
  removes refinery's auto-merge and inserts steward/reviewer/human-merge
  PR gates. This is the closest community precedent for what the
  council is proposing (council-ratified rules + code-reviewer
  enforcement + human/Li gate on production).
- **`ocasazza/jump-cannon`** — pinned-vs-auto provider split for
  stability/adaptability balance. Relevant to Li's reliability+adaptability
  constraint: the staging city could use a *pinned* provider for
  reproducibility while live uses *auto* for adaptability.
- **Official `gastown`** — mayor/deacon/boot/witness/refinery/polecat
  pattern. Worth knowing; not the shape Criopolis is taking (the
  council is more deliberative than gastown's reliability-watchdog
  pattern).

---

## Apply now (mayor authority — narrow scope)

These are the *uncontested ratifications* mayor can apply. They do
not include role-instantiation, subsidy creation, or any change to
the live runtime — those need Li's input on bounds.

1. **Document the council's hybrid-with-subsidy direction** in
   `_intake/operating-rules/city.md` as the ratified architecture
   intent (with the three closures named as preconditions for any
   instantiation).
2. **Document the keel-labels** (rule / guideline / practice note)
   and the per-rule six-field shape in `_intake/operating-rules/`
   as the keel-rewrite contract — applies whenever keel content
   begins.
3. **Update mayor's prompt** to note that the *substantive vs
   editorial* distinction is the upstream question for keel work
   (Viveka's range) — round-8 candidate.

That's it. Everything else needs Li's input.

---

## Open questions for Li

The council has produced direction-strong ratifications; the next
moves require Li-decisions on bounds:

1. **Subsidy authority list — first verb.** Read-only inspection,
   dry-run build, staged deploy request, or one narrowly-approved
   execution verb? Sets the subsidy's initial shape.
2. **Authorization to stand up the staging city.** Separate dolt /
   separate city directory / same `gc` binary. Mayor can run the
   setup if Li authorizes; it's reversible.
3. **First role to draft a prompt for** in the staging city.
   Recommendation: deployment specialist (most overdue;
   structurally wrong default that mayor handles deploys) or
   auditor (lowest risk; clear signature artifact). Either is a
   defensible first move.
4. **Wasteland federation question.** Now that the brief is in: do
   we want to join? If yes, when? PR-mode default seems aligned
   with reliability-over-speed. Not blocking; defer-able.
5. **Round-8 council question — substantive vs editorial keel
   changes** (Viveka's diairesis). Required upstream of the first
   keel section. Recommend filing this round if you want; mayor
   can also fold it into a broader "first keel section" round once
   the staging city is up.

---

## Mayor's recommended next moves

**(a)** Apply the three documentation updates above (mayor authority
on uncontested ratifications). Push.

**(b)** Surface this synthesis to Li. Wait on (1)–(4) above.

**(c)** **Defer** the auto-memory migration question (carryforward
from synthesis-010) until Li returns to the repo-location question.
It's still open; the council direction-positive deferred-with-closures
on the universal-ghq vote, and Li has shifted toward "philosophy-city
stays in `~/`." Mayor records the standing exposure.

**(d)** Once Li authorizes (2) — staging city — the next round is
operational: file a bead to a deployment-specialist-prompt drafter
(could be a one-off researcher bead, or mayor drafts directly with
council review). The staging city becomes the test surface for
threads 2, 3, 4.

---

## Cross-cutting findings

### The "structural-not-conventional" pattern

Across threads 1, 2, 3 — the council's deepest convergence: a
boundary that lives in attention is a *convention*; a boundary that
lives in the runtime form is *structural*. Sibling = convention.
Hybrid-with-subsidy = structural. Sandbox = structural-but-too-strict.

The discipline runs through the whole round. Roles are conventions
when their authority lives in mayor's care; structural when their
authority is enforced by the runtime (subsidy refuses non-allowlisted
verbs; council veto blocks deploy; keel rule has decision-test
discoverable on a PR). The council is asking Criopolis to be
*structurally* bounded, not *carefully* bounded.

### Reliability-over-speed = savor-test scaled to action

Rasa's contribution: Li's framing of *reliability over speed* is
the savor-test scaled from form-attention to action-attention. The
form that thickens on second reading after the act is the disciplined
start; the form that thins (regret on second attention) is the
false start.

This is why the lightest-first sequence is unanimously [strong-for]:
each step's outcome must survive second-cycle attention before the
next step fires.

### The seats are reading each other's replies *during* the round

Multiple seats cite each other's round-7 work in their own. Dharma
cites Prayoga's open-question on straddle-forms; Rasa cites
Viveka's diairesis on *sandbox*; Prayoga cites Dharma's
under-load-pressure framing. The forum is one body, not five
disjoint sessions. A healthy sign that the discipline has matured.

---

*Closing per protocol. Round 7 was the council's first substantive
content round. The shape worked: real disagreement was avoided not
by force but by terminology audits and bound-party rehearsals before
any seat over-committed; concrete proposals emerged from each seat's
native discipline; convergence is on direction without forced
agreement on closures. The seat-shape is ready for content. The
work now is Li's bounds and the staging city.*

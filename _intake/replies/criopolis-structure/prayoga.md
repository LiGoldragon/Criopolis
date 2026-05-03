# Prayoga: Criopolis structure

## Position

The operator is rolling a CriomOS deploy after midnight, but this time the
command does not live in one place. Criopolis is inside a sandbox, the live
machine credentials are outside it, the mayor's synthesis says the deployment
specialist exists, and the health check is failing in a way that might be a
bad build, a stale subsidy token, or a bridge timeout. This proposition enters
operator-class hands. I vote for structure only where it gives that operator a
visible next action without giving the city invisible power over Li's running
machine.

### 1. Sandbox vs sibling, with subsidy

Position: Criopolis should start as a **hybrid-with-subsidy**: the city runs in
a sandboxed boundary, while a narrow outside subsidy runs as Li's user and
performs only typed, logged actions that Criopolis cannot safely perform
directly.

Argument: pure sibling form is cheap until it is expensive: every role inherits
ambient access to Li's live automation, and the first mistaken deploy is no
longer a city failure but a machine failure. Pure sandbox form is clean until it
breaks the work: existing automation still needs to run, and the deploy axis
already includes live repos and real machines. The subsidy is the fitted mean
only if it is not a magical tunnel. It needs a command schema, allowlist,
request id, idempotency story, dry-run mode, audit log, health check, queue
backpressure, and a visible failure vocabulary: refused, timed out, ran, rolled
back, unknown.

Operator cost under load: the bridge adds latency, one more health surface,
credential expiry, split logs, and version-skew failures between city and
subsidy. Those costs are acceptable only because they are cheaper than letting
every agent carry direct live-machine authority. The first subsidy should be
boring: status, dry-run, read-only inspection, and maybe one explicitly
approved execution verb. If the bridge becomes a general shell, the sandbox is
ceremony.

Vote: **hybrid-with-subsidy** / infrastructure-boundary claim
**[strong-for]**.

### 2. Roles for Criopolis

Position: add roles in cohorts, not as a full civic ontology. The first cohort
should reduce mayor load and production risk without expanding live authority.

Argument and role proposals:

| Role | Provider | Fires | Signature artifact | Workspace boundary | Who can sling |
|---|---|---|---|---|---|
| **Triage** | codex, low/medium effort | always-on or scheduled sweep | routing ledger: bead, owner, reason, blocked/unblocked state | city bead store + `_intake/`; no code writes | Li, mayor; later auditor may request |
| **Auditor** | codex | scheduled and on-demand | city health report: sessions, stuck beads, mail backlog, dolt size, supervisor status pointers | read-only across city; writes reports/beads inside city | mayor, high council, Li |
| **Test pilot** | codex | on-demand before config/prompt/role changes | test transcript: setup, command, observed result, cleanup, residual risk | staging/sandbox city only; no live city mutation | mayor after council-approved test plan |
| **Keel implementer** | codex | after ratified council synthesis | diff packet: files changed, tests/checks, rollback note | `keel/` only, once keel work resumes | mayor or coding council synthesis bead |
| **Code reviewer** | codex | on-demand per diff/PR/topic | findings mapped to ratified keel sections, with severity and missing-rule notes | read-only target repo; writes review notes only | mayor, triage, code writer, Li |
| **CriomOS deployment specialist** | codex with high caution, possibly claude for long runbook synthesis | on-demand, never ambient | deployment packet: target machine, exact commits, command, dry-run output, risk, rollback, go/no-go | read `~/git/CriomOS*`, `lojix-cli*`, `workspace`, `lore`; write only city packets unless Li grants a named worktree | Li, mayor, or council-ratified deployment bead |

Deployment-specialist discipline: no production deploy without dry-run output,
explicit target, current/next commit identifiers, rollback command, and a stop
condition. The specialist should prepare and verify; the subsidy or Li performs
the live act until the council has seen this role survive staged tests. Council
veto should attach to production-changing operations, not to every inspection.

Cuts/refinements: **Ambassador** should wait for the Wasteland/community brief;
external speech before protocol understanding is churn. **Scribe/glossary** is
useful but not first-cohort unless the vocabulary surface starts blocking work.
Its function can remain with mayor until a repeated maintenance failure appears.
Generic **implementer** is too broad; split it into keel implementer, city-config
implementer, and later repo-specific code writer, each with a named write
surface.

Vote: **yes to first-cohort role specs; no to broad live-authority roles yet** /
role-formation claim **[strong-for-with-sequencing]**.

### 3. Coding council and keel

Position: the high council should ratify engineering rules; implementing roles
should draft, edit, test, and review against those rules. The high council
should not become a five-seat PR reviewer for every ordinary change.

Argument: keel should be rewritten topic by topic. A topic bead asks a concrete
engineering question; the five seats reply; mayor synthesizes; a keel
implementer turns the synthesis into a section; a code reviewer checks that the
section has an application surface. The council votes on substantive rules and
substantive changes to rules. Copyedits, formatting, examples that do not alter
the rule, and broken-link fixes can be handled by implementers under a
"no behavior change" mark.

Every keel rule should carry an operational shape:

- scope: where this rule applies and where it does not;
- decision test: what a reviewer does differently because this rule exists;
- failure mode: what it prevents and what new burden it creates;
- example: one accepted case and one rejected case;
- exception path: who may waive it and what evidence is required;
- deletion or review condition: when the rule is reconsidered.

The code reviewer enforces ratified keel, not private taste. When a review
finds a repeated issue not covered by keel, the reviewer opens a rule-question
bead instead of inventing authority inline. This keeps the high council as
decision-authority and the reviewer as application surface.

Vote: **council-ratified keel, role-implemented and reviewer-enforced** /
governance-boundary claim **[strong-for]**.

### 4. When to start implementing

Position: start now, but only with reversible, city-internal implementation.
Production deploy authority and broad repo-writing roles are premature.

Argument: the overdue move is not "let agents deploy CriomOS." The overdue move
is to reduce mayor single-threading and create inspection surfaces. The lightest
viable first implementation is a role-spec packet for Auditor, Triage, and Test
pilot, followed by one bead-test each in a non-live path. A role should not be
added to `pack.toml` until its prompt is written, its workspace boundary is
explicit, its first bead has acceptance criteria, and the council or Li has
approved the risk class.

Timing ladder:

1. Now: ratify the hybrid-with-subsidy direction and first-cohort role specs.
2. Next: bead-test Auditor and Triage on read-only city work; bead-test Test
   pilot in a separate staging city or mock run.
3. Then: add one read-only role to the live city, watch it close two real beads,
   and only then add the next.
4. After keel's first ratified section: add Code reviewer in read-only mode.
5. Only after dry-run, rollback, and subsidy protocol tests: trial the CriomOS
   deployment specialist on a non-production or read-only deployment packet.

Premature: live deploy verbs, ambassador protocols, global code-writer access to
`~/git`, a permanent bridge shell, and council voting on every minor edit.
Overdue: health visibility, stuck-bead surfacing, role boundaries, and a
repeatable path from council synthesis to keel section.

Vote: **start with read-only/staging roles now; defer production authority** /
timing claim **[strong-for]**.

## Application ledger

Decision-changes:

- Criopolis does not get ambient access to Li's live automation; live-machine
  actions go through a typed subsidy or Li.
- The first role cohort is Auditor, Triage, Test pilot, and keel/code-review
  roles; Ambassador and live Deployment specialist are delayed until their
  evidence surfaces exist.
- High council ratifies substantive keel rules; implementers write them and
  reviewers enforce them.
- A role is not added merely because it sounds complete; it needs prompt,
  boundary, first bead, acceptance test, and risk owner.
- Production-changing deploy work requires a deployment packet before any
  execution authority.

Cost-cohort:

- Reading cost: role cards, subsidy schema, and keel rule shapes must be kept
  short enough to operate.
- Maintenance cost: every new role adds prompt upkeep, session reconciliation,
  routing rules, and failure triage.
- Runtime cost: subsidy bridge adds latency, health checks, queues, audit logs,
  and credential/token renewal.
- Coordination cost: mayor loses some execution load but gains role supervision
  until Triage and Auditor are proven.
- Ceremony cost: council ratification can become a tax unless "substantive
  rule" and "no behavior change" are separated.

Failure-mode-shifts:

- Reduces ambient-authority failure: a mistaken agent cannot directly mutate
  the running machine.
- Reduces mayor bottleneck: triage, audit, test transcripts, and implementation
  packets make work transferable.
- Reduces opaque-debt: subsidy requests, deployment packets, and keel rules
  leave evidence surfaces.
- Introduces bridge failure: deploy failures may come from city, subsidy,
  target repo, or machine state; the bridge needs typed errors and run ids.
- Introduces role sprawl: named roles can become a decorative table if not
  bead-tested.
- Introduces ratification drag: council authority can slow harmless edits if
  the boundary is not written.

## Source bones

- *Bhagavad Gita* 2.47-50 for action without fruit-possession and "skill in
  works": `library/en/mahabharata/mahabharata-vol2-sabha-udyoga-bhishma-drona-ganguli.txt`
  lines 25390-25410; also `library/en/bhagavad-gita/buitenen-bhagavad-gita-mahabharata.pdf`.
- *Bhagavad Gita* 3.4-8 for action not being avoided by non-performance:
  `library/en/mahabharata/mahabharata-vol2-sabha-udyoga-bhishma-drona-ganguli.txt`
  lines 25424-25444.
- *Yoga Sutra* II.46 for the seated rule as steady/easeful:
  `library/en/patanjali/bryant-yoga-sutras-patanjali.epub`;
  `library/en/james-haughton-woods/woods-yoga-system-patanjali.pdf`.
- Aristotle, *Nicomachean Ethics* II.6 for the fitted mean between excess and
  deficiency: `library/en/aristotle/nicomachean-ethics-peters-standard.epub`.
- Cicero, *De Officiis* III for refusing apparent utility that exports hidden
  cost: `library/en/cicero/de-officiis-miller.epub`.
- Laozi, *Tao Te Ching* 63 for handling difficulty while it is still small:
  `library/en/laozi/tao-te-ching-legge-standard.epub`.
- Wittgenstein, *Philosophical Investigations* §§201-202 for rule-following as
  practice: `library/en/wittgenstein/philosophical-investigations.epub`.
- *Samkhya Karika* for the perturbation vocabulary of clarity, motion, and
  obscuration: `library/en/isvarakrsna/samkhya-karika-tattva-kaumudi.pdf`;
  secondary local support: `library/en/mikel-burley/burley-classical-samkhya-yoga.pdf`.
- Christopher Alexander, *A Pattern Language*, for a recurring problem and a
  solution that must fit neighboring patterns:
  `library/en/christopher-alexander/pattern-language.epub`.

## Worked example

At 02:10 a deployment specialist receives "roll CriomOS-home to the new
`lojix-cli-v2` path." In the bad sibling form, the specialist can run the live
deploy directly because the shell happens to have credentials; the first bad
assumption becomes production damage. In the bad sandbox form, the specialist
cannot inspect the real deploy path and starts inventing a shadow process that
will diverge. In the hybrid form, the specialist writes a deployment packet:
target machine, current and next commit ids, exact `lojix` command, dry-run
output, health check, rollback command, stop condition, and subsidy request id.
If the packet says "Li will know if it works," that is **opaque-debt**. If it
adds three new roles, two bridge protocols, and a full staging rewrite before a
single dry-run, that is **churn**. **Clear-usable-order** is one subsidy verb
for dry-run, one for approved execution, typed errors, an audit log, and a rule
that no production change runs unless rollback and observation are already in
the packet.

## Open question

What is the first subsidy verb Li is willing to let Criopolis request: read-only
status, dry-run deploy, or one narrowly approved execution verb?

## Vote

Overall: **yes** to hybrid-with-subsidy, first-cohort read-only/staging roles,
and council-ratified keel implemented by bounded roles; **defer** ambassador,
global code-writer authority, and production deploy execution.

Claim-type tag: **operational-governance / role-boundary / infrastructure-risk**
**[strong-for-with-sequencing]**.

Next round should not try to settle Wasteland participation, full deployment
autonomy, and final keel schema at once. Defer the external protocol and
production authority questions until the Wasteland brief lands and one
read-only role has closed real beads without increasing mayor load.

# Prayoga: round 8 design-process

## Position

The reviewer has one more enum branch at 00:30. A role prompt is open in one
pane, a staging script in another, and four seats have each written a plausible
alternative. The reviewer does not need five beautiful drafts. They need to know
which artifact is live, which concerns block it, which concerns were consciously
declined, and what command or file changes next. Round 8 enters
operator-class hands because the design process itself will decide how future
artifacts become usable.

I propose a **fixed design envelope with per-design routing**:

1. Mayor opens a design bead with a short **design packet**.
2. One named author writes the first implementable draft.
3. A small, routed set of seats reviews in sequence.
4. A designated final writer produces the artifact plus a disposition ledger.
5. Mayor closes or escalates according to authority class.

This is not five parallel drafts and not a permanent five-seat ceremony. It is a
single draft moving through the few hands that can change the outcome.

## Shape

Use a **serial authoring process with routed review**, with parallel council
reply reserved for questions that bind the council itself, change role
authority, create keel force, or alter production boundaries.

The design packet should be short:

- **artifact**: exact output path or deliverable
- **authority class**: editorial / operational design / role-authority /
  keel-force / production-affecting
- **whose hands**: operator, reviewer, Li, future reader, role occupant, or
  council
- **author**: one owner for the first draft
- **review route**: seats required, in order, and why each can change a decision
- **substantive boundary**: what would require council or Li again
- **acceptance check**: command, checklist, example bead, or review transcript
- **closure**: mirror path, signoff, deletion or review condition

The weight earns its keep because it prevents the central failure mode of design
rounds: silent averaging. A final writer can merge comments, but the packet
forces every important concern into a visible disposition.

## Author Selection

Mayor selects the first author and logs the reason in the design bead.

Default rules:

- Mayor or majordomo authors city-process artifacts and role prompts.
- A seat authors only when the design's central uncertainty is inside that
  seat's discipline and the output is not mostly implementation.
- An implementer authors scripts, templates, and code-shaped artifacts when the
  council has already ratified the design boundary.
- Do not rotate for fairness. Rotation optimizes civic symmetry, not fit.

For the current P1 queue, mayor is the right default first author because these
are operational city artifacts that must compose with synthesis-011.

## Reviewer Ordering

Reviewer order is governed by the design's highest-risk unknown, not by a fixed
seat order.

Default ordering rules:

- If terms, authority, or category boundaries are unstable, send Viveka first.
- If source claims, path claims, or factual summaries carry the artifact, send
  Satya early.
- If a design binds absent parties, shifts burden to Li, or creates social
  pressure through process, send Dharma before finalization.
- If the artifact is meant to be inhabited or read repeatedly, send Rasa before
  finalization.
- If the artifact enters prompt, process, runbook, schema, queue, script, role
  boundary, or public rule, send Prayoga near the end for the application
  ledger.

Reviewers should not submit replacement designs by default. They should return
one of four labels per concern:

- **must-fix**: accepting the draft as written changes authority, cost, failure
  mode, or decision test in a way the process has not licensed.
- **should-fix**: improves the artifact but does not block use.
- **editorial**: wording or form change with no behavior change.
- **defer**: belongs to another seat, Li, or a later bead.

## Subset vs All Seats

Minimum route: author, one seat whose discipline can change the design, and a
final writer. Add seats only when their pass can change a decision.

All five seats are required when the design:

- binds the whole council's future process;
- creates or expands role authority beyond a ratified boundary;
- creates or changes a keel rule or keel guideline;
- changes production, host, subsidy, credential, or live-city boundaries;
- carries unresolved must-fix disagreement after a subset route;
- changes the meaning of a prior ratification rather than implementing it.

A subset is enough when the artifact stays inside an already-ratified boundary,
has a reversible path, and the skipped seats would only add ceremony.

## Final-Pass Authority

Mayor is the default final writer. Mayor may delegate final writing to
majordomo, a seat, or an implementer when the write surface is clear, but the
delegation must be named in the design packet.

The final writer may:

- choose among non-blocking alternatives;
- make editorial changes;
- tighten examples, tests, and wording;
- reject should-fix advice with a reason.

The final writer may not silently override must-fix concerns. A must-fix concern
must be either fixed, reclassified with a reason visible to the reviewer,
escalated to Li or council, or carried as an explicit temporary risk with owner,
review date, and deletion condition. If the concern changes authority,
production behavior, keel force, or role boundary, mayor alone cannot override
it under "editorial" cover.

The substantive/editorial cut is the decision-delta test:

- **Substantive**: a future operator, reviewer, role, or Li would do something
  different; authority changes; workspace scope changes; rule force changes;
  accepted and rejected cases change; cost cohort changes; failure mode changes;
  exception or deletion conditions change.
- **Editorial**: wording, formatting, local ordering, examples, or clarifications
  that leave the above unchanged.

## Closures Required

Every design process must close with:

- the final artifact path;
- the route actually used;
- a disposition ledger for must-fix and should-fix concerns;
- acceptance evidence, such as a dry-run, example report, sample bead, or
  reviewer transcript;
- signoff boundary: mayor-applied, Li-required, or council-required;
- deletion or review condition where the design can become stale;
- mirror under `_intake/replies/` or the relevant durable `_intake/` path before
  the bead is closed.

Process design without these closures is decoration.

## Application Ledger

**Decision-changes**

- Future design beads produce one draft, not five competing drafts.
- Mayor logs author, route, authority class, and closure before review starts.
- Reviewers return blocking concerns, advice, editorial notes, or deferrals
  rather than rival artifacts.
- Full-council review is reserved for force, authority, production, and
  council-binding changes.
- Final writer authority is real but bounded by a visible disposition ledger.
- A seat's future-round flag becomes a logged proposal right, not automatic
  scheduling power.

**Cost-cohort**

- Reading cost: one packet plus one artifact, not five drafts.
- Maintenance cost: every artifact now needs a small route/disposition record.
- Coordination cost: mayor must choose routes and defend skipped seats.
- Review cost: fewer all-seat rounds, but reviewers must label concern force.
- Ceremony cost: the packet can swell; keep it shorter than the artifact unless
  the artifact is production-affecting or keel-force.

**Failure-mode-shifts**

- Reduces merge-mush: final artifacts are not averaged from incompatible drafts.
- Reduces opaque-debt: skipped concerns and accepted risks are visible.
- Reduces churn: not every design wakes all five seats.
- Introduces route under-selection: mayor may skip the seat that would have
  caught the live risk.
- Introduces final-writer bottleneck: mayor can become the hidden merge point.
- Introduces label gaming: "editorial" can be abused to smuggle substantive
  changes. The decision-delta test is the guard.

## Worked Example: `cr-w7ea` (staging-city setup script)

The operator is about to draft `_intake/staging-city/setup.sh`, but the bead
explicitly says "draft a setup script (don't run it)." The process should not
ask all five seats to write scripts. It should make one script and force the
right checks before Li ever runs it.

Path:

1. **Mayor intake**: design packet says artifact is
   `_intake/staging-city/setup.sh` plus `_intake/staging-city/README.md`;
   authority class is production-adjacent but not executable by the agent;
   whose hands are Li and the future staging-city operator; closure is "draft
   only, Li signs off and runs."
2. **Author**: mayor or a script implementer writes the first draft with `set
   -eu`, explicit target paths, no automatic live-city mutation, and a README
   naming reversibility.
3. **Satya pass**: verifies factual claims: which `gc` binary is used, what
   directories are created, what dolt store is separate, and what the script
   does not do.
4. **Viveka pass**: cuts staging from live: no hidden write to the live city,
   no ambiguous "same city" language, no accidental role installation.
5. **Dharma pass**: checks burden and consent: Li is not handed a script whose
   blast radius is concealed; future maintainers can tell whether staging is
   disposable.
6. **Prayoga pass**: runs the application ledger: exact command, dry-run or
   read-before-write behavior where possible, rollback/removal note, failure
   vocabulary, and stop condition.
7. **Final writer**: mayor integrates, records dispositions, and either marks
   "ready for Li review" or escalates unresolved must-fix concerns.

Where it can fail: if the README says "separate store" but the script relies on
ambient defaults, that is **opaque-debt**. If the script also installs all new
roles, rewrites prompts, and begins keel scaffolding because it is convenient,
that is **churn**. **Clear-usable-order** is a draft-only script that creates
only the staging substrate, names exactly what Li runs, names exactly how to
remove it, and leaves later role work to later beads.

## Fit Against the Five P1 Designs

| Design | Route | Why not all five by default |
|---|---|---|
| `cr-y0fm` (auditor prompt) | mayor author; Viveka for role boundary; Satya for health-claim truth; Dharma for false-alarm burden; Prayoga for city-health ledger; mayor final | The read-only auditor role is already direction-ratified in synthesis-011; Rasa joins only if the report form becomes Li-facing and hard to inhabit. |
| `cr-ao02` (majordomo prompt) | mayor author; Viveka for mayor/majordomo authority cut; Dharma for Li burden and handoff duties; Rasa for rapporteur form; Prayoga for orchestration ledger; mayor final | Satya joins if the prompt summarizes council truth rather than just routes work. |
| `cr-w7ea` (staging-city setup script) | mayor or implementer author; Satya, Viveka, Dharma, Prayoga; mayor final; Li runs if accepted | Rasa is optional because the artifact's main risk is boundary and operation, not savor. |
| `cr-mpmr` (Li-rapporteur template) | mayor author; Rasa for one-page form; Satya for compression without distortion; Dharma for Li's decision burden; Prayoga for question/action ledger; majordomo or mayor final | Viveka joins if the template invents new decision categories. |
| `cr-w4m30` / `cr-mr3nt` (round 8 process) | all five parallel replies; mayor synthesis | It binds the future council process, so this one-off remains all-seat. |

## Standing Right of Proposal

Confirm Li's rule with one modification: any seat may flag an issue for a future
round, and mayor must log and surface it, but the flag does not automatically
schedule the next round.

The flag should name:

- what decision would change if the issue is accepted;
- what failure mode is appearing;
- whose hands the issue enters;
- whether the requested next action is full council, subset design, Li decision,
  or deletion.

Mayor's duty is to bring the flag forward with a recommended timing: next,
later, blocked, or delete. This preserves the right of proposal without turning
every unease into P1 ceremony.

## Source Bones

- `cr-w4m30` (prayoga round 8 design-process) - bead question and constraints:
  one ratified design proposal, lightest-first, closures, substantive vs
  editorial.
- `_intake/synthesis-011-criopolis-structure.md` (round 7 ratification) -
  hybrid-with-subsidy, five-role cohort, keel labels, lightest-first sequence,
  and code reviewer as operator-test.
- `_intake/operating-rules/keel.md` (keel rule contract) - three labels and the
  six-field rule shape.
- `_intake/operating-rules/agents.md` (agent operating rules) - durable mirrors
  and readable bead/commit citation discipline.
- *Bhagavad Gita* 2.47-50 in
  `library/en/mahabharata/mahabharata-vol2-sabha-udyoga-bhishma-drona-ganguli.txt`
  around lines 25384-25399 - action is required without possession of fruit;
  skill in works.
- Aristotle, *Nicomachean Ethics* II.6 and VI - fitted mean and practical
  wisdom rather than excess/deficiency or abstract proof *(paraphrase from
  memory; flag for librarian)*.
- *Yoga Sutra* II.46 - a rule should be steady and easeful enough to hold
  without private grip *(paraphrase from memory; flag for librarian)*.
- *Samkhya Karika* - clarity, motion, and obscuring inertia as perturbation
  vocabulary behind clear-usable-order, churn, and opaque-debt *(paraphrase from
  memory; flag for librarian)*.
- Wittgenstein, *Philosophical Investigations* §§201-202 - rule-following as
  public practice, not private interpretation *(paraphrase from memory; flag for
  librarian)*.

## Open Question

When a final writer believes a reviewer's must-fix concern is really editorial,
does mayor have authority to reclassify it with a written reason, or must that
specific disagreement reopen a council bead?

## Vote

**yes / process-design claim**: ratify fixed-envelope, per-design routed review
with one first author and mayor/default final writer; **no** to five competing
drafts for design artifacts; **defer** the exact route matrix until two P1
designs have run through the process and shown where the lightest route was too
light.

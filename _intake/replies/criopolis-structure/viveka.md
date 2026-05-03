# Viveka: Criopolis structure

## Position

Criopolis should choose the hybrid-with-subsidy shape, but only after the word "sandbox" is cut into its several senses. The reliable form is not "agents in a box" versus "agents as siblings"; it is a layered authority model: a separated city authority domain, a staging city for experiments, and a narrow host subsidy that performs only named host-side effects. The same cut applies to roles and to the coding council. "Implementer", "reviewer", "council", "keel", and "start" are all currently broad enough to smuggle decision-authority into execution. My vote is yes to a constrained structure: the high council ratifies names, rules, and risky exceptions; mayor orchestrates and synthesizes; implementing roles produce bounded artifacts; production-affecting powers wait for a deployment contract.

## Source Bones

- `_intake/synthesis-010-repos-under-ghq.md` - the previous vote shows the danger of a universal proposition carried by an overfull term, especially "repository"; it also records Li's current leaning that philosophy-city may stay in `~/`.
- `_intake/explorer/pc-ttzm-criome-ecosystem.md` - the active criome map, especially the CriomOS axis and the live spellings `lojix-cli` / `lojix-cli-v2`.
- `_intake/operating-rules/city.md` - current roster, city identity, workspace boundary, and adjacent rigs.
- `_intake/operating-rules/agents.md` - durable reply mirror, city-scoped versus rig-scoped agents, `process_names`, `ghq`, and workspace boundary rules.
- `_intake/operating-rules/mayor.md` - mayor must not move the city or perform substantive structural decisions alone; city lifecycle remains Li-only.
- `_intake/operating-rules/vocabulary.md` - authoritative project names and the council/forum vocabulary correction.
- `_intake/criopolis-structure-prep.md` - Li's constraints: reliable, adaptive, restrained, introspective, council-led, connected.
- `library/en/aristotle/posterior-analytics-mure.txt`, Book II Part 13 - definition by selecting attributes down to the last differentia, division as a way to avoid omission, and caution around equivocation.
- Sankara, `Vivekacudamani` 18-22; `Brhadaranyaka Upanishad` 4.5.15; Plato, `Phaedrus` 265d-266c; Confucius, `Analects` 13.3; Wittgenstein, `Philosophical Investigations` 65-67 - paraphrase from memory; flag for librarian.

## Terminology Audit

| term used | sense intended | sense smuggled | proposed disambiguation |
|---|---|---|---|
| sandbox | separated authority domain for Criopolis agents | VM/container, disposable test clone, process tree, namespace, and security boundary all at once | Use `authority sandbox` for permissions, `staging city` for test instance, `runtime container` only if actual containerization is meant. |
| sibling | directory/repo peer next to Li's existing automation | equal trust, direct credential access, same operational authority | Use `workspace sibling` for location only; never let it imply same authority. |
| subsidy | host-side capability Criopolis can request | unrestricted backdoor into Li's user account | Use `host subsidy`: a Li-owned, verb-limited effect broker with request logs, allowlists, and rollback obligations. |
| role | an agent identity | a permission bundle, standing authority, provider choice, and artifact type | Define each role by provider, trigger, artifact, workspace boundary, and sling authority. |
| implementer | someone who makes changes | prompt editor, pack editor, code writer, deployment operator, and git publisher | Cut into `city-operator`, `code-writer`, and `deployment specialist`; do not keep `implementer` as a live role name. |
| auditor | one who checks | health monitor, code reviewer, security reviewer, and term reviewer | Split `health auditor` from `code reviewer`; leave terminology audit to Viveka/scribe. |
| code reviewer | reviewer against keel rules | rule-author, veto-holder, taste judge, merge authority | Reviewer enforces ratified rules and reports findings; council owns new rules and exceptions. |
| high council | the five seats as decision body | mayor, tools, all agents, or an always-on government | Use `high council` for the five seats voting on substance; tools inform, mayor synthesizes. |
| keel | engineering law | style guide, philosophy corpus, checklist, review rubric, and current prose scratchpad | Split `keel rule`, `keel guideline`, and `keel practice note`. |
| start | begin all implementation | begin low-risk scaffolding, add roles, deploy to host, or rewrite keel | Use `start scaffolding`, `start role trial`, `start production authority`, and `start keel rewrite`. |
| production | Li's running machine and live automation | any non-test repo, any checked-out code, or the live city itself | Use `live city`, `host automation`, `CriomOS target`, and `repo working tree` separately. |

## Thread 1: Sandbox vs Sibling

**Position:** Vote `hybrid-with-subsidy`, strong-for, conditional on the term split above.

**Argument:** "Sandbox" is doing at least four jobs: a security boundary, a namespace boundary, a runtime boundary, and a staging/testing boundary. If the council votes for "sandbox" without division, each seat may ratify a different object. A pure sibling shape is too loose because it lets filesystem adjacency become trust adjacency. A pure sandbox is also false if Criopolis must help with real host automation and CriomOS deployment. The clean form is layered: Criopolis runs as an authority sandbox; experimental changes run first in a staging city; host effects go through a subsidy that exposes named verbs rather than general shell authority.

The subsidy must not be called "outside the sandbox" without qualification. It is outside the agent authority boundary, but inside Li's authority and audit boundary. Its proper shape is a request broker: input is a signed/recorded deployment request or host-action request; output is a result log, refusal, or rollback note. The council should treat the bridge itself as production infrastructure, not as a convenience helper.

**Worked example:** The sentence "Criopolis should be sandboxed" changes truth under substitution. If sandbox means "VM with no host access", the proposition rejects the subsidy. If it means "separate bead/session namespace", the proposition does not protect Li's credentials. If it means "disposable test copy", it says nothing about the live city. If it means "no direct host-side effects without a broker", it becomes the ratifiable claim. The last is the intended sense; the other three are smuggled.

**Vote:** hybrid-with-subsidy: yes / strong-for. Sibling: no / strong-against. Pure sandbox: no unless redefined as a narrow authority sandbox. VM/containerization: defer until a concrete threat model asks for it.

## Thread 2: Roles for Criopolis

**Position:** Add roles only where the role name predicts the artifact. Cut unqualified "implementer"; refine it into narrower roles. Defer ambassador until the Wasteland brief lands.

| role | provider | when it fires | signature artifact | workspace boundary | who can sling it |
|---|---|---|---|---|---|
| triage clerk | codex | scheduled or on incoming unsorted beads | routing note: bead classified, routed, or returned | city bead store and `_intake/triage/`; no prompt or pack edits | mayor or Li |
| scribe / glossary-keeper | codex | after syntheses, or when a term-conflict is found | glossary/doc patch with source note | `_intake/` only, unless a ratified keel edit is explicitly assigned | mayor, high council, or Li |
| health auditor | codex | scheduled and before structural changes | health ledger: sessions, stuck beads, mail backlog, dolt/gc status, risks | read city state; write audit notes under `_intake/audits/` | mayor or Li |
| staging test pilot | codex | before agent config, prompt, hook, or pack changes land live | staging run report with command log and pass/fail | test city under the city workspace; no host deploys | high council or mayor after council authorization |
| code writer | codex | per ratified engineering bead | patch, tests run, residual risk note | assigned repo/worktree only; no production deploy | mayor, triage under mayor policy, or Li |
| code reviewer | codex by default; claude acceptable for prose-heavy reviews | after code writer work or before PR/merge | findings tied to keel clauses, with severity | read target repo; write review note only unless separately tasked | mayor, high council, or Li |
| CriomOS deployment specialist | codex | on-demand only, after deployment charter exists | deployment contract: target, dry-run, rollback, preflight, command plan, postflight checks | read CriomOS/lojix/horizon/workspace; write deployment request; host subsidy performs actual host effects | Li or high council; not triage alone |
| ambassador | claude | defer until Wasteland/community brief lands | external memo and route ledger | city communications only | Li or high council |

The CriomOS deployment specialist needs the strictest definition because "deployment" smuggles code change, machine mutation, credentials, rollback, and blame. Its discipline should be closer to Prayoga than to ordinary implementation: no live action without dry-run or equivalent preflight, explicit target, rollback contract, and a postflight proof. A council veto should be required for first use and for any expansion of verbs.

**Vote:** yes / strong-for refined roles; no / strong-against to an unsplit `implementer`; defer ambassador and any live deployment power.

## Thread 3: Coding Council and Keel

**Position:** The high council should ratify engineering rules; implementing roles should draft, patch, test, and review under those rules. The code-reviewer role should enforce ratified keel content, not create keel content by enforcement.

**Argument:** "Council" currently risks sliding between deliberative authority and operational execution. The clean division is: the high council decides substantive engineering norms and risky exceptions; mayor frames and synthesizes; a scribe/editor turns syntheses into keel drafts; code writers implement engineering work; code reviewers check against ratified rules; deployment specialists touch production only through the deployment contract. This preserves council authority without forcing five-seat votes on every typo or mechanical edit.

Keel should be rewritten topic by topic, but its sections should carry a visible status. I propose three labels:

| keel label | force | who can change it |
|---|---|---|
| keel rule | binding engineering norm; review can block on it | high council vote or explicit Li decision |
| keel guideline | strong default; reviewer flags violations, but justified exceptions pass | high council ratifies; mayor/scribe can clarify without changing force |
| keel practice note | descriptive convention, example, or current local habit | scribe/editor may maintain with source note |

Every normative keel change should have a ratification packet: proposition, terms defined, source bones, operational example, dissent or defer record, and review consequence. That is the point where Viveka's cut belongs. A code reviewer may say "this patch violates keel rule X"; it may not silently invent rule X while reviewing.

**Vote:** yes / strong-for topic-by-topic high council ratification of normative keel; yes / strong-for code reviewer after rules exist; no to voting every mechanical edit; no to reviewer-as-rulemaker.

## Thread 4: When To Start Implementing

**Position:** Start now, but only on scaffolding that reduces ambiguity and carries no production power. Defer host subsidy implementation, deployment authority, and Wasteland-facing roles.

**Argument:** "Start" is another overfull term. Starting a glossary, a role charter template, or a health audit is not the same act as starting a host-side subsidy or a CriomOS deployer. Reliability over speed does not require total stillness; it requires the first actions to be reversible and non-destructive. The overdue work is definition and observation. The premature work is credentialed host action.

Lightest viable first implementation move:

1. Create a role-charter template with the five required fields: provider, trigger, artifact, workspace boundary, sling authority.
2. Draft the sandbox/subsidy/location lexicon before any pack or prompt edit depends on those words.
3. Bead-test one low-risk role first: scribe/glossary-keeper or health auditor.
4. Only after that, define the staging test pilot.
5. Only after staging exists and produces a passing report, return to the deployment specialist and host subsidy.

Before adding any role: prompt written, workspace boundary explicit, signature artifact named, first bead dry-run completed, disable path known, and council approval recorded for roles with structural or production impact.

Premature: live subsidy with Li credentials, direct CriomOS deployment, broad code-writing authority before keel has rule/guideline/practice labels, and Wasteland ambassador before the research brief. Overdue: glossary/scribe, health auditor, and role-charter template.

**Vote:** yes / strong-for starting scaffolding now; defer production authority; no to broad role rollout before bead-tested charters.

## Open Question

What is the first verb the host subsidy should ever be allowed to perform: read-only inspection, dry-run build, staged deploy request, or actual deploy? The answer should set the initial shape of the subsidy better than the abstract word "bridge" can.

## Closing Deferral

Defer the Wasteland-facing ambassador, the exact subsidy implementation, provider/effort settings in `pack.toml`, and any live CriomOS deployment powers to the next round. This round should settle the names and the first reversible moves; the next round can decide which named power is safe enough to instantiate.

## Overall Vote

Yes to the constrained structure: hybrid-with-subsidy, refined roles, council-ratified keel rules, and immediate low-risk scaffolding. Defer the host-power details until the subsidy and deployment specialist have passed through their own terminology audit and staging proof.

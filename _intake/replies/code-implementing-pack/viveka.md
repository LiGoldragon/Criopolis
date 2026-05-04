# Viveka review - code-implementing pack

## Position

Defer until the authority-bearing names are cut cleanly. The draft's large shape is right: this is a gas-city `pack`, not a `complex`, `pipeline`, or `forge`; it uses four ratified cohort roles and keeps the auditor parallel. But four terms still smuggle authority: `merged commit`, `target_repo`, deployment `touches/requests/response`, and `required-fix`. The first promises an integration authority no role currently owns. The second names a registered gas-city rig as if it were an arbitrary repo. The third lets a packet-producing deployment-specialist slide toward host-effect invocation and response recording. The fourth says a guideline finding is both required and non-blocking. These are not wording nits under synthesis-012; they alter read-write surface, live-host effect, reviewer test, and force semantics.

## Source bones

- Packet: `_intake/design-packets/code-implementing-pack.md` (pack design packet), lines 14-41 for artifact/scope; lines 74-115 for reviewer route; lines 133-174 for substantive boundary; lines 176-200 for acceptance; lines 242-268 for review/deletion conditions.
- Draft: `_intake/drafts/code-implementing-pack.md` (mayor's first cut), lines 16-41 for pack name and contents; lines 48-72 for lifecycle; lines 76-197 for role fields; lines 199-246 for formula/work_query relation; lines 248-303 for authority; lines 305-345 for keel enforcement; lines 346-373 for push-not-pull; lines 609-635 for vocabulary.
- Process: `_intake/synthesis-012-design-process.md` (round-8 design process), lines 75-90 for force-tagged deltas; lines 173-191 for substantive/editorial tests; lines 193-204 for force classes; lines 226-245 for closures.
- Cohort: `_intake/synthesis-011-criopolis-structure.md` (ratified first cohort), lines 87-95 for auditor/test-pilot/deployment-specialist/code-writer/code-reviewer roles; lines 97-112 for cut roles and the rejection of generic implementer.
- Keel: `_intake/operating-rules/keel.md` (engineering rules contract), lines 13-22 for rule/guideline/practice-note force; lines 24-42 for rule shape; lines 54-64 for code-reviewer enforcement and rule-question beads.
- Gas-city vocabulary: `~/git/lore/gas-city/vocabulary.md` (gas-city glossary), lines 18-20 for city/pack/rig; lines 50-56 for agent/prompt template; lines 64-75 for bead/formula/order/work_query/routed bead.
- Lore: `~/git/lore/AGENTS.md` (workspace contract), lines 170-189 for components/forge; lines 209-223 for verb-belongs-to-noun. `~/git/lore/programming/abstractions.md` (verb belongs to noun), lines 218-259 for the wrong-noun trap. `~/git/lore/programming/push-not-pull.md` (push, not pull), lines 8-24 and 54-59 for subscription over polling. `~/git/lore/INTENTION.md` (project intention), lines 43-63 for clarity/correctness over speed.
- Mayor rule: `_intake/operating-rules/mayor.md` (mayor operating rules), lines 157-187 for no self-fire orders; lines 196-278 for mayor writes no code and what remains mayor-authorable.
- No additional library source opened for this bead; no librarian request.

## Terminology audit

| term used | sense intended | sense smuggled | proposed disambiguation |
|---|---|---|---|
| `code-implementing pack` | Gas-city `pack`: reusable bundle of agents, formula, and possibly orders/scripts. | `agent-complex` as standing institution; `pipeline` as only the DAG; `forge` as criome code-emission component. | Keep `code-implementing pack`. Use `pipeline` only for the `mol-code-implement` formula. Do not borrow `forge`; lore's forge is code emission, while this artifact includes review, test, and deploy-packet production. |
| `role` / `agent` | `role` is the duty/artifact boundary; `agent` is the gas-city configured entity that inhabits a role. | Provider/session identity becoming authority; a role becoming a runtime primitive. | Define once: four roles, implemented by four gas-city agent definitions. Use `agent` only when discussing `pack.toml`, provider, session mode, and work_query. |
| `code-bead` | A task bead entering this pack for implementation. | A new bead type, or any task/clarification bead that happens to mention code. | Define as `type=task` plus required metadata: `target_rig`, `change_summary`, `keel_section`, and entry route to `code-writer`. Say explicitly that `code-bead` is an alias, not a bead type. |
| `target_repo` | The registered project the writer may touch. | Arbitrary Git checkout/path; repo identity instead of gas-city rig identity. | Rename the metadata field to `target_rig`. If a repo path is needed, derive it from the rig binding or add a separate `repo_path` field populated by the city, not by the bead author. |
| `merged commit` | A completed implementation outcome. | Merge/integration authority no role owns. The writer produces a patch; reviewer writes findings; test-pilot writes staging report; deployment-specialist writes packet. | Replace with `reviewed candidate patch/commit` unless this design intentionally adds a merge/integration step and owner. Adding that owner is substantive and may reopen the role boundary. |
| deployment `touches` / `requests` / `subsidy_response` | Deployment-specialist prepares a deploy packet and names requested subsidy verbs. | Direct host mutation, subsidy invocation, Li authorization, and response recording. | Say the deployment-specialist does not touch host state and does not invoke the subsidy. It writes `deploy_packet_path` and `subsidy_verbs_requested`. Any `subsidy_response` belongs to the Li/subsidy authorization record or a separate post-authorization closure, not to the specialist's own stage output. |
| `block` | Reviewer found an operationalized keel rule violation; the implementation cannot proceed under ratified rule force. | Generic refusal to merge/review, or any serious concern. | Reserve `block` for rule violations or explicit scope violations with a decision-test. Use `refer` for classification/authority gaps and `rule-question` for unusable keel rules. |
| `required-fix` | Guideline violation without a justified exception. | A blocking finding, despite the draft saying `verdict=approve` if no rule is violated. | Either rename to `guideline-flag` and keep it non-blocking, or add a non-rule revision path such as `needs_response` for "fix or justify." Do not call it both required and approved. |
| `refused` | Deployment-specialist concludes the change is not deployable by this pack. | Li refusal, subsidy refusal, missing allowlist, or the specialist refusing its own task. | Prefer `not_deployable` for the specialist's finding. Reserve `blocked_on_subsidy` for a missing/unauthorized verb and `subsidy_denied` only if the subsidy/Li actually denies an invocation. |
| `refer` / `defer` | `refer`: mayor/council classification needed. `defer`: test environment cannot exercise this case now. | Generic pause or soft failure at any stage. | Rename mechanically if possible: `needs_mayor_classification` for review; `staging_unavailable` for test. If the shorter verdicts stay, define their owners and allowed causes. |
| `rule-question bead` | Scoped surface for "this repeated pattern is not covered by keel." | Generic follow-up creation, triage authority, or new work routing by the reviewer. | Keep it, but define allowed fields: type task, label `keel:rule-question`, parent/related reviewed bead, evidence summary, no assignee, no `gc.routed_to`, no priority escalation. Mayor/council route it later. |
| `work-query subscription IS the patrol` | Work_query dispatch replaces polling for ready work. | Stuck-work recovery/witness duty. | Say work_query subscription is dispatch, not patrol. Witness/patrol/recovery remains out of scope unless repeated stuck-pipeline failures reopen it. |
| `signature artifact` | Each role's unique cite-able output. | Decorative role-branding. | Keep. It earns its keep because it is the over-orchestration test: if two roles produce the same signature artifact, the role cut is wrong. |

## Force-tagged deltas

1. Location: draft lines 16-18 and 338.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - authority test, read-write surface, role boundary.
   Comment: `merged commit` and `merge blocked` name an integration authority that is absent from the four-role cohort. The code-writer produces patch/tests/risk note; the reviewer produces findings; the test-pilot produces a staging report; the deployment-specialist produces a packet. None is authorized to merge into the target rig, and mayor.md bars mayor from code/executable-effect authorship. Replace `merged commit` with `reviewed candidate patch/commit` or add an explicit integration step and owner. The latter is substantive and should not be smuggled into this pack under wording.

2. Location: draft lines 62, 86, 275-283, 410-413, 623.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - scope, ratified-term meaning, declared write surface.
   Comment: `target_repo` is the wrong noun. Gas-city's primitive is `rig`: a registered external project/repo with its own city binding. `target_repo` makes an arbitrary checkout or path sound acceptable, while the worktree convention and one-bead-one-rig discipline depend on registered rig identity. Rename to `target_rig`; let repository/path details be derived from the rig binding.

3. Location: draft lines 66-72, 169-186, 287-303, 443-447, 581-586.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - live-host effect, output artifact, exception path.
   Comment: The deployment-specialist boundary is still porous. The text says the specialist "does not deploy," but also says only the specialist "touches the host," records `subsidy_response`, and participates in "on success, bead closes." Packet production and host invocation are different acts. The specialist's output should stop at `deploy_packet_path` and `subsidy_verbs_requested`. Li/subsidy authorization, invocation, response, and close-out need their own named record outside the specialist's authority surface.

4. Location: draft lines 322-345 and 537-541.
   Force tag: `must-fix / blocker`.
   Substantive/editorial tag: substantive - keel force semantics and reviewer decision-test.
   Comment: `required-fix` violates the draft's own force mapping. A guideline "flags"; it does not block. But `required-fix` says the writer must fix while line 339 says the verdict remains `approve` if no rule violations exist. The design must choose a clean shape: either `guideline-flag` is non-blocking, or a separate non-rule `needs_response` path returns to writer for fix-or-justify without calling it a rule block.

5. Location: draft lines 64-66, 130-134, 160-165, 189-197, 476-479, 556-559.
   Force tag: `should-fix / required`.
   Substantive/editorial tag: substantive - failure-mode naming and branch semantics.
   Comment: Do not collapse all verdicts into one cross-stage set; `approve`, `pass`, and `packet_ready` are not synonyms. But the draft should declare a stage-local verdict rule: every verdict is owned by one role and names either success, role-local failure, or escalation. Fix the count ("eight" vs nine), define each verdict's owner, and replace the opaque pair `refused` / `blocked_on_subsidy` with names that separate not-deployable, missing authorization, and actual subsidy denial.

6. Location: draft lines 48-50, 62, 617.
   Force tag: `should-fix / required`.
   Substantive/editorial tag: substantive - entry condition and artifact identity.
   Comment: `code-bead` earns its keep only if it is not a new bead type. Define it as a `type=task` bead with required metadata and a pack entry route. Remove or qualify "council seat tasking a clarification" unless that clarification is itself implementation work routed to code-writer; otherwise the term invites non-code work into a code pipeline.

7. Location: draft lines 117-123, 328-332, 499-506, 627.
   Force tag: `should-fix / required`.
   Substantive/editorial tag: substantive - bead-creation authority and routing surface.
   Comment: `rule-question bead` is justified here because keel.md explicitly gives the reviewer this surface, unlike the auditor's earlier "follow-up bead" smuggle. But it needs a closed shape. Add that the reviewer may create only an unrouted rule-question bead with evidence and parent/related link; it may not assign, sling, set priority, or decide the rule. That keeps creation distinct from triage.

8. Location: draft lines 35-38, 363-373, 480-483, 520-525.
   Force tag: `should-fix / required`.
   Substantive/editorial tag: substantive - failure-mode and role-boundary.
   Comment: "The work-query subscription IS the patrol" is a bad substitution. Work_query subscription dispatches ready work; it does not detect stuck beads, orphaned worktrees, crashed roles, or absent staging. Keep witness/patrol/recovery out of scope, but do not call dispatch "patrol." The packet's deletion condition already has the honest shape: repeated stuck-pipeline failures reopen the recovery question.

9. Location: draft lines 468-475 and vocabulary line 615.
   Force tag: `editorial / suggestion`.
   Substantive/editorial tag: editorial if the primitive remains `pack`.
   Comment: Close Viveka's naming question in the final synthesis: the artifact is `code-implementing pack`. Record Li's "agent-complex" phrasing as request history if useful, but do not keep it as an alternate live name. Do not introduce a Sanskrit/Greek term-of-art here; it would decorate rather than clarify.

10. Location: draft lines 30-34, 76-81, 613-630.
    Force tag: `editorial / suggestion`.
    Substantive/editorial tag: editorial if no authority changes.
    Comment: Add one sentence to the vocabulary section: "A role is a duty/artifact boundary; an agent is the gas-city configured entity that inhabits it." The draft already behaves this way; the sentence prevents provider/session details from becoming role authority by accident.

## Worked example

Sentence under test: "Only the deployment-specialist touches the host."

Substitution A: "Only the deployment-specialist prepares the deploy packet that asks Li for named subsidy verbs." This preserves the intended design: the specialist writes a city-side packet, names requested verbs, and stops.

Substitution B: "Only the deployment-specialist invokes host-side effects or records the subsidy response." This violates the draft's own boundary: the specialist does not deploy, does not invoke subsidy verbs, and must not own Li's authorization result. The phrase "touches the host" therefore carries two senses. The clean sentence is: "The deployment-specialist prepares the host-effect request; Li's subsidy performs or refuses any host effect."

## Open question

Is merge/integration into the target rig in scope for the first code-implementing pack at all? If yes, which named role owns it after review and staging; if no, the pack's terminal implementation artifact should be `reviewed candidate patch/commit`, not `merged commit`.

## Vote

Defer. I would object-on-incorporation if blockers 1-4 are absent from the final draft or treated as editorial. With those fixed and required comments dispositioned, I would vote yes on Viveka's term and role-boundary dimension.

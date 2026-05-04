# Synthesis 013 — Multi-agent patterns: what Criopolis should be, given the field

*Mayor's editorial synthesis of cascade-test-1 council round (2026-05-04).*
*Source beads: cr-urcqp0 (researcher), cr-8rl91b (satya), cr-1nj12c (viveka), cr-1wbm98 (prayoga), cr-rymo5y (dharma), cr-yhvxai (rasa).*

## Question the round answered

Given a comprehensive survey of multi-agent system patterns (AutoGPT / BabyAGI / MetaGPT / CrewAI / AutoGen / LangGraph / Anthropic Research / Claude Code subagents / OpenAI Swarm / CAMEL + academic lineage + deliberative-council precedents), what should Criopolis's architecture actually be? What patterns to adopt, reject, defer? What is Criopolis given the field — borrowed, rediscovered, or genuinely novel?

## Positions

- **Satya** — corpus is sound as bounded classification; comparative claims need claim-type discipline (fact / frame / rule / recommendation / experiment / definition). 7 design recommendations with falsification ledgers.
- **Viveka** — corpus's vocabulary is the main defect. "Multi-agent patterns" carries six axes at once. 19-row terminology audit table cutting `agent` / `role` / `seat` / `subagent` / `crew` / `council` / `manager` / `mayor` / `majordomo` / `workflow` / `graph` / `cascade` / `handoff` / `parallel ensemble` / `debate` / `synthesis` / `validation filter` / `consensus` / `durable` / `done` / `state` / `metadata`.
- **Prayoga** — at 3am, prompt-driven cascade discipline is morally clear and mechanically weak: a closed bead without `--notify majordomo` looks finished to `bd` and dead to the cascade. The mean is a small typed completion surface plus declared joins; not full LangGraph or event queues. Adoption order: `cascade-complete` vocabulary → `gc done` wrapper → typed metadata → measure → only then runtime replacement if needed.
- **Dharma** — bound parties are the future inheritor, prompt-template inheritors, mayor/majordomo operators, Li, downstream users, and deprecated role-shapes. Validation filters protect users only when scoped; if they filter station-specific normative dissent, they injure the council's bound parties.
- **Rasa** — the durable cascade thickens because notes-close-notify aren't interchangeable; the mayor/majordomo split is a void held open whose collapse would smooth the form on first reading and lose truth on second. Plurality-as-form (crew / swarm / group chat) is *rasabhasa* — the seductive surface of design without the conjunction underneath.

## Convergence (all 5 seats)

1. **Preserve Criopolis as durable deliberative council plus bead/mail cascade.** Not chat-room, not swarm, not graph runtime, not market.
2. **Preserve the mayor / dispatcher split.** (Mayor dropped majordomo today as a name; the orchestrator-in-design IS the dispatcher's successor. The split survives; the noun changes.)
3. **Preserve differentiated council seats with final-arbiter mayor synthesis.** Seats are not commensurable voters.
4. **Reject** majority vote, weighted aggregation, market/auction allocation, direct handoff as primary council mechanism.
5. **Defer** full LangGraph / event-queue replacement until smaller measures demonstrably fail.
6. **Adopt scoped validation-filter beads** for factual / code / policy claims (NOT for normative seat-station dissent — Dharma's veto on scope).
7. **Adopt typed round metadata** where joins are real (council rounds, validation passes, fanouts) — not every bead.
8. **Add `cascade-complete` vocabulary** distinguishing `closed` (bd status) from `cascade-complete` (notes + close + notify all done correctly).

## Contention

There is genuine convergence; what disagreement exists is at the level of *priority and form*, not direction.

- **Mechanism for `cascade-complete`:** Prayoga proposes an idempotent `gc done <bead>` wrapper as the immediate concrete fix. Dharma and Rasa endorse the principle but defer the mechanics to Prayoga's domain. The orchestrator-in-design (separate work, in flight per Li's directive) addresses the same pain at the dispatcher layer rather than the agent layer. **These solutions are complementary, not competing**: orchestrator handles "who slings next when something closes"; `gc done` handles "agent reliably emits the completion signal."
- **How aggressive to be on metadata:** all 5 endorse typed metadata; Satya wants it as recommendation now / fact later (after trial data); Prayoga wants it minimal and only where joins are real; Viveka wants it as part of a controlled vocabulary discipline; Rasa says full graph would be aesthetic without organic necessity. Resolution: start small — add `gc.round_id`, `gc.phase`, `gc.synthesis_mode` to council rounds; add `gc.depends_on`, `gc.join_of` to fanouts; let it grow only as wounds appear.
- **Validation filter scope:** strong consensus on adopting; sharp disagreement-shaped distinction on what they may judge. Resolution: validation filters test grounding, citation, actionability, reproduction. They never decide normative force; never erase Dharma / Rasa / Prayoga station-specific findings. A validation pass returns "grounding status," not a vote.

## Editorial direction (mayor's stance, defended)

**Criopolis is a durable deliberative civic workflow with stable offices, distinct disciplines, and final editorial synthesis. It is not a multi-agent system in the swarm/crew/group-chat sense. The pattern is closer to Vidura speaking truth to the king than to a CrewAI manager assigning tasks.** That identity is what to preserve and sharpen — not to dilute by adopting plurality-flavored architectures.

**Five immediate moves I would defend:**

### 1. Build the orchestrator (in flight)

Mayor / dispatcher split is unanimously endorsed. Today majordomo was dropped because its specific shape failed; the orchestrator-in-design (codex / medium effort / always-on / wakes on session.stopped events / dispatches per cascade metadata) is the same role with a leaner prompt and infrastructure-side wake. **Preserves the split; replaces the implementation.** Continue the build per the existing plan (cr-fc8go4 explorer survey returns first to check we're not reinventing).

### 2. Add `cascade-complete` vocabulary + idempotent completion primitive

Empirical finding from this round: 5 of 5 council agents failed the `--notify` discipline in some form (skipped mail entirely, sent without `--notify`, or used the wrong bead ID). The discipline is not learnable through prompt iteration. **The fix is at the city level, not the agent level.**

- Operating-rules update: distinguish `closed` (bd status) from `cascade-complete` (notes + close + notify, validated).
- Code-writer task (separate bead, future): build `gc done <bead>` (or equivalent) — idempotent wrapper that does notes → close → notify, validates the bead-ID matches, refuses to notify a different bead.
- Once the wrapper exists: agent prompts say "to complete a bead, run `gc done <bead>`." Eliminates the 3-command ritual that's failing.

### 3. Adopt typed round metadata where joins are real

Add to council-round and validation-pass beads:
- `gc.round_id` — chain identifier
- `gc.phase` — `framed` / `researching` / `seat-review` / `joined` / `mayor-synthesis` / `archived`
- `gc.synthesis_mode` — `final-arbiter` / `validation-filter` / `digest`
- `gc.depends_on` — explicit dependency for sequential cascades
- `gc.join_of` — group identifier for parallel fanouts

Do NOT require this metadata on every bead. Use it where the implicit join would otherwise be invisible.

### 4. Adopt scoped validation-filter beads

For high-risk factual / code / policy claims (researcher answers, code-writer outputs, deployment-spec proposals): a separate validation pass before mayor or downstream agent acts. The validator scopes to:
- Source citations check (does the cited file:line exist; does it say what's claimed?)
- Reproduction check (can the claimed test/result be reproduced?)
- Actionability check (is the claim well-formed enough to act on?)

Validators do NOT touch normative content — Dharma's roll-call, Rasa's savor-test, Prayoga's operator-pass remain station-final. Validators return "grounding status," not votes.

### 5. Adopt Viveka's controlled vocabulary as discipline

Update `_intake/operating-rules/agents.md` (or a new `_intake/operating-rules/vocabulary-architecture.md`) with the 19-row terminology table from Viveka. Future bead descriptions, prompt edits, and synthesis docs use the disambiguated terms. This stops architecture from being smuggled through overloaded nouns.

Particularly load-bearing distinctions to enforce:
- `agent` (executing actor) vs `role` (contract) vs `seat` (civic office) vs `subagent` (delegated worker)
- `cascade` (gas-city primitive: notes + close + notify + route) vs `sequence` (any ordering)
- `closed` (bd status) vs `cascade-complete` (full primitive succeeded)
- `synthesis` requires a `synthesis_mode` qualifier: `final-arbiter` / `validation-filter` / `digest` / `consensus`

## Design recommendations (consolidated, ranked by adoption priority)

| # | Recommendation | Adopt | Defer | Reject |
|---|---|---|---|---|
| 1 | Build orchestrator (mayor/dispatcher split successor) | ✓ | | |
| 2 | `cascade-complete` vocabulary + `gc done` wrapper | ✓ | | |
| 3 | Typed round metadata where joins are real | ✓ (small first) | | |
| 4 | Scoped validation-filter beads | ✓ (factual scope only) | | |
| 5 | Controlled architecture vocabulary (Viveka's table) | ✓ | | |
| 6 | Dependency-gated parallelism (`independence_claim` + `join_condition`) | ✓ | | |
| 7 | Final-arbiter mayor synthesis preserving dissent verbatim | ✓ (already done) | | |
| 8 | Source-citation discipline | ✓ (already done) | | |
| 9 | Full LangGraph executable state machine | | ✓ (until measured) | |
| 10 | Event-queue / hidden runtime replacement of bead surface | | ✓ (until measured) | |
| 11 | Wholesale autonomous-tool-loop pattern at city level | | | ✓ |
| 12 | Group-chat with manager-selected speakers as council | | | ✓ |
| 13 | Majority vote / weighted aggregation for high council | | | ✓ |
| 14 | Market / auction allocation for council work | | | ✓ |
| 15 | Direct handoff as primary council mechanism | | | ✓ (OK for narrow operational triage) |
| 16 | Crew / swarm / society naming for council | | | ✓ (rasabhasa per Rasa) |

## What is novel about Criopolis vs. the field

Bounded claim (per Satya's discipline): the exact combination of (a) durable bead/mail substrate, (b) mayor / dispatcher separation, (c) five philosophical-discipline council seats with incommensurable criteria, (d) final-arbiter mayor synthesis preserving dissent, was not found in the surveyed code or web sources. This is *not* a globally-novelty claim — only "not in the surveyed set."

What's borrowed: durable work store (BabyAGI's task queue made persistent), role taxonomy (CrewAI / MetaGPT), validation-filter pattern (Claude Code's code-review plugin), dependency-gated parallelism (Anthropic Research's lead/subagent split).

What's rediscovered: the council shape echoes Aristotelian dialectic, Talmudic argument, scholastic disputation, and modern adversarial-collaboration practices — not as direct descent, only as structural cousin.

What's specifically Criopolis: the disciplined-discipline seats (Satya's truth-isolation + falsification ledger; Viveka's terminology audit; Dharma's roll-call + bound-party rehearsal; Prayoga's midnight-operator pass; Rasa's temporal-disclosure curve) were not found instantiated in any surveyed implementation.

## Open questions (deferred, not lost)

1. (Satya) What is the smallest instrumentation set mayor/orchestrator can add so the next three council rounds produce evidence on false-positive rate, missed joins, synthesis burden, latency — without turning the city into a metrics project?
2. (Viveka) What is the smallest controlled vocabulary the orchestrator should enforce on beads so future rounds stop smuggling architecture through overloaded nouns?
3. (Prayoga) What is the smallest idempotent completion primitive Criopolis can add so a future operator can prove `cascade-complete` from bead/mail state alone?
4. (Dharma) What invariant will mayor and orchestrator enforce so a seat's dissent survives digest and synthesis visibly enough that a future user can tell which party was bound, which consented, which was injured?
5. (Rasa) What is the smallest visible completion form that lets a future reader taste `done` as an organic whole rather than remember it as a three-command ritual?

These five questions converge on one pragmatic next move: **the `gc done` wrapper plus typed round metadata is the answer to all five.** Filing for code-writer is the natural follow-up.

## Status of work-product

- All 5 seat replies preserved verbatim in their respective beads (cr-8rl91b, cr-1nj12c, cr-1wbm98, cr-rymo5y, cr-yhvxai).
- This synthesis is mayor's stance for the round.
- Outstanding work-items implied by this synthesis (file as separate beads, in priority order):
  1. Code-writer: `gc done <bead>` idempotent completion wrapper (cascade-complete primitive)
  2. Mayor: extend `_intake/operating-rules/agents.md` with controlled architecture vocabulary
  3. Mayor (or code-writer): typed round metadata schema for council/fanout beads
  4. Code-writer: scoped validation-filter bead type (factual scope only)
  5. Orchestrator design report (already in flight per cr-fc8go4 explorer survey)

## Anomalies to record from cascade-test-1

- 5 of 5 agents failed the `--notify` discipline in some form during this cascade. Architectural finding (also reflected in this synthesis): prompt-discipline is not a reliable cascade primitive; the city must absorb completion-signaling at infrastructure level. The orchestrator design + `gc done` wrapper together address this.
- One controlled test (mayor → majordomo `--notify`) confirmed the underlying mechanism works; the failure was agent flag-discipline, not the wake mechanism itself.
- Researcher cr-kbg2ir confirmed gas-city's documented "event-triggered orders" cannot safely implement cascade automation in current source (no label/metadata filters; no matched-event context). This blocks the order-driven cascade pattern; the orchestrator-as-LLM-dispatcher approach (in design) is the practical alternative.

# Handoff — 2026-05-03 mayor session

*Mayor's outgoing handoff. Context filled to ~85% in this session;
elaborate handoff before cycle. Next mayor reads this in full at
session start, then `_intake/operating-rules/*.md`.*

---

## TL;DR

**Where we are**: synthesis-011 ratified Criopolis's architecture
unanimously (5/5 strong-for on every thread). Wake-on-round-close
implemented + verified. Memories migrated to repo. City renamed
`~/philosophy-city → ~/Criopolis` (audit clean).

**Li's most recent decisions** (after my 3-question prompt):

- Yes to **majordomo** role (rapporteur + orchestration mechanics).
- Yes to **staging city** setup.
- First implementer: **auditor** (lowest risk, builds operating
  discipline).
- Plus: "yes to everything, but we need to design all of it."

**3 open Li-decisions still pending**:

1. First **subsidy verb** (read-only inspection / dry-run / one
   approved exec verb)
2. **Synthesizer role** for the long-form council synthesis (mayor
   / specific seat / composition / new role) — round-9-ish council
   question
3. **Wasteland federation** — when to join (researcher's `pc-m5yg`
   gives full picture; reframes ambassador role from "diplomat" to
   "PR-mode federation steward")

**Next concrete moves** (filed as beads, see below):

1. Draft auditor prompt (first implementer, Li's pick)
2. Draft majordomo prompt
3. Draft staging-city setup script
4. Draft Li-rapporteur 1-page template
5. File round-8 council bead: substantive vs editorial keel changes

---

## Where Criopolis is, architecturally

The council has ratified the **hybrid-with-subsidy** shape (synthesis-011, round 7):

- Criopolis = authority sandbox (separate from Li's host).
- A **host subsidy** (Li's user, Li's credentials, allowlisted verbs)
  is the named bridge for any host action.
- **Three closures** before any subsidy goes live: (1) authority
  list enumerated; (2) audit log + kill-switch; (3) boundary
  procedurally enforced.
- Roles cohort ratified: **auditor / test pilot / CriomOS deployment
  specialist / code writer / code reviewer**. Ambassador deferred
  pending Wasteland decision; triage premature; generic implementer
  cut as too broad.
- Coding council: form A+B (council deliberates topics → mayor
  synthesizes → keel implementer drafts → reviewer enforces).
  Strong-against C (every-change-voted = over-ceremony).
- Three keel labels: **rule** (binding) / **guideline** (strong
  default) / **practice note** (descriptive).
- Six fields per keel rule: scope / decision test / failure mode /
  example / exception path / deletion-or-review-condition.
- Lightest-first sequence: staging city → role prompts → bead-test
  in staging → council review → graduate one role at a time → first
  keel section drafted with reviewer staged.

All this lives in `_intake/operating-rules/{city,keel,agents,mayor,vocabulary}.md`
and `_intake/synthesis-011-criopolis-structure.md`.

---

## What got done in this session (chronological)

1. **Round 6 → synthesis-009** + applied uncontested edits
   (Satya's Viveka-seam refinement; Viveka's Rasa-seam refinement).
2. **Provider rebalance to 3-codex / 2-claude** (satya, viveka,
   prayoga = codex; dharma, rasa = claude). Researcher already
   codex.
3. **Cleanup**: pruned old rounds (kept last 2). Deleted Claude's
   auto-memory directory; migrated content to `_intake/operating-rules/`
   (mayor reads at session start; other agents read on-demand).
4. **Vocabulary additions**: criome, lojix, sema, Criopolis, CriomOS,
   nix.
5. **Explorer agent created** (codex, on_demand). Filed pc-ttzm —
   landed: 86 git repos under ~/git/, 34 active. Criome ecosystem
   mapped. Naming: lojix (not logix); no plain library/home/horizon
   repos.
6. **Researcher pc-frro** (mayor-wake architecture) returned. Phase
   1 implementation: city-local order at `orders/forum-round-watcher.{toml,sh}`,
   triggered on `bead.closed`, exec script counts open seat-reply
   beads per round, nudges mayor when zero remain. Test verified:
   end-to-end wake works.
7. **Researcher pc-m5yg** (Wasteland + community structures)
   returned. Wasteland is federated work-network via DoltHub; PR-mode
   default. Community pattern `bmt/gascity-explore` is closest
   precedent.
8. **Council vote pc-b2sw etc.** on Li's "all repos under ghq"
   proposition. Outcome: 1 yes, 1 conditional yes, 3 defer-with-
   closures. Synthesis-010 captures.
9. **Round 7 council** (criopolis-structure, four threads): 5/5
   strong-for on hybrid-with-subsidy + roles cohort + keel form A+B
   + lightest-first sequence. Synthesis-011 captures.
10. **Li renamed `~/philosophy-city` → `~/Criopolis`** + city.toml.
    Audit done: settings.json + agent prompts + orders all clean
    (most things use $HOME or relative paths). Operating-rules +
    explorer prompt fixed. Historical references in synthesis docs
    intentionally preserved.

---

## Pending work (filed as beads)

**P1 — Li-approved + immediate**:

- `bd ready` shows: design auditor prompt; design majordomo prompt;
  draft staging-city setup script; draft Li-rapporteur 1-page
  template; round-8 council bead (substantive vs editorial keel).

**P2 — downstream**:

- Design CriomOS/Nix/lojix deployment-specialist prompt (after
  auditor lands)
- Design test-pilot role prompt (after staging city stands up)
- Design code-writer + code-reviewer prompts (after first keel
  section)
- Document triad pattern (explorer/researcher → implementer →
  auditor → council review)
- Subsidy interface design (3 closures + first verb)
- Mayor prompt update for forum-round labeling discipline
- Researcher: staging-city dolt cost investigation
- First-keel-section workflow documentation

**P3 — reference/consolidation**:

- Roles cohort consolidated reference doc

Use `gc bd ready` and `gc bd list -l priority:1` to see queue.

---

## Operating notes for next mayor

### Where to look first

Read in order:
1. `_intake/operating-rules/*.md` (mayor's prompt directs you here
   at session start; covers the city, agents, mayor's own rules,
   keel contract, vocabulary)
2. `_intake/synthesis-011-criopolis-structure.md` (last full synthesis;
   what the council ratified)
3. This handoff doc
4. `_intake/glossary.md` (council technical vocabulary; if a term
   confuses you in the synthesis docs, look here)
5. The `bd ready` queue

### What works now

- **Wake mechanism**: forum-round-watcher fires on every
  `bead.closed`. When you open a forum round (multi-seat), use the
  labeling convention in `operating-rules/mayor.md` (round-marker
  bead with `forum-round-active` + metadata `round=<N>`; each
  seat-reply bead with `forum-round-reply` + metadata `round=<N>`).
  Otherwise the watcher won't fire.
- **Operating rules in repo**: every agent can read them.
- **Provider mix**: 3 codex / 2 claude in the council; mayor stays
  claude (always-on); librarian + researcher + explorer are codex.
- **Push at session end**: applies to all repos with new commits
  (city dir is `~/Criopolis/`; remote still `LiGoldragon/philosophy-city.git`).

### What doesn't work yet

- The 5-role cohort (auditor / test pilot / deploy / writer /
  reviewer) is **ratified but not instantiated**. Designing prompts
  is the next work; Li approves before installing in `pack.toml`.
- The subsidy doesn't exist yet. Design proposed; Li picks the
  first verb.
- Staging city doesn't exist yet. Setup script to be drafted; Li
  runs it.
- Keel is empty. First section waits on the lightest-first sequence
  (need staging + reviewer first).
- The majordomo doesn't exist yet. The Li-rapporteur 1-page format
  hasn't been used; mayor still does the long-form synthesis.

### Discipline — Li's repeated asks

- **Tight Li-facing reports**: Li explicitly tired of 250-line
  syntheses. End every Li-message with a small number of succinct
  questions. The synthesis is for the durable record; the Li-report
  is the action layer.
- **Mayor's load reduced**: Li wants you to orchestrate, not do
  everything. The majordomo handles bead-filing + slinging + git
  + Li-rapporteur once it exists. Until then, do the work but keep
  it tight.
- **Reliability over speed**: don't break the running machine. Hot
  system. Test in staging before live.
- **Substantive structural decisions go to the council**, not mayor
  authority. Mayor authority covers uncontested edits +
  orchestration. The repo-relocation precedent (synthesis-010)
  established this.
- **Never rename or move the city directory**. Li-only operation.
  Mayor.md rule #4.
- **Always push at session end** (mayor.md rule #2).

### Subtle things to know

- The github remote is still `LiGoldragon/philosophy-city.git` even
  though the local dir is `~/Criopolis/`. Li hasn't renamed the
  github repo. Don't rename it without explicit instruction.
- The forum-round-watcher's idempotency markers live at
  `.gc/tmp/forum-round-<N>-mayor-nudged`. Remove them when closing
  a round so a re-run nudges fresh.
- The Claude auto-memory directory was deleted. Operating-rules in
  repo replace it. If a future memory-system question comes up,
  push back: rules belong in the repo, not in agent-local stores.
- Synthesis-010 surfaced an "auto-memory party" question. That's
  now resolved (memories migrated to repo). Standing record only.
- "Korean OS" and "kream OS" speech-to-text mistypes mean CriomOS.
  "Next" in package/Nix context means nix. "Logic" / "logix" means
  lojix.

### Tools available

- `librarian` (codex, on-demand) — fetches and catalogs library/
- `researcher` (codex, on-demand) — investigates source-code
  questions; cites file:line
- `explorer` (codex, on-demand) — surveys ~/git/; produces briefs
- `mayor` (claude, always-on) — you, orchestrator + synthesizer
  (until majordomo exists)
- 5 council seats — on-demand; substantive deliberation

### Don't do

- Don't run `gc restart`, `gc stop`, `gc start`, `gc init`,
  `gc unregister`, or `gc supervisor` subcommands. City lifecycle
  is Li's only.
- Don't try to move the city directory.
- Don't burn high-effort tokens on diagnostics (smoke tests use
  default effort).
- Don't apply structural edits to seat prompts without council
  ratification.
- Don't push automatically during a session unless asked. Push at
  session end.

---

## 3 open Li-questions (carry forward)

When mayor next reaches a natural pause, surface these to Li (or
fold into a Li-rapporteur output once the majordomo exists):

1. **First subsidy verb**: read-only inspection / dry-run build /
   one approved exec verb / staged deploy request? Sets the
   subsidy's initial shape. Recommendation: read-only inspection
   first (cheapest discipline-test; cannot break the host).
2. **Synthesizer role decision** (council question, round 9-ish):
   mayor / specific seat / composition / new role for the long-form
   synthesis? The majordomo handles Li-rapporteur (1-page); this
   is about the durable-record long-form.
3. **Wasteland federation**: join now / later / never? Researcher's
   `pc-m5yg` brief is the input. PR-mode default seems aligned with
   reliability-over-speed.

---

## Recommended sequence for the next session

If Li has approved the design phase already, mayor can:

1. **Design auditor prompt** (the first concrete deliverable;
   pc-XXXX bead in queue). Draft it; mirror to
   `agents/auditor/prompt.template.md` but don't add to `pack.toml`
   until Li signs off.
2. **Design majordomo prompt** (same pattern). Will produce the
   Li-rapporteur format; that template can be drafted as part of
   this work.
3. **Draft staging-city setup script**. Output to
   `_intake/staging-city/setup.sh` with a README. Li reviews +
   runs it.
4. **File round-8 council bead** (substantive vs editorial keel).
   Use the forum-round-watcher labeling convention so the wake
   mechanism fires.
5. **Commit + push** as work lands. Apply Li-rapporteur format
   when reporting back to Li.

---

## Final note

Li's high-level direction in this session:

- Implementation phase is starting.
- Triad pattern: explorer/researcher → implementer → auditor →
  council review.
- Mayor should orchestrate, not be the bottleneck.
- Hot system; careful first.
- Reliability over speed.

The architecture is well-formed. The work is making it live —
prompt by prompt, role by role, in staging before live. Don't
rush; don't drag.

— Outgoing mayor

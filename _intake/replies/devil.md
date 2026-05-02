# Devil's position — underweighted side + repo proposal

*Source: bead pc-ohf, closed by devil-pc-0ss, 2026-05-02.*

## Part 1: underweighted side

The failure mode is a rolling deployment that stops being a design project and starts being an operational system before the doctrine admits it. Imagine criome, forge, arca-daemon, and a GUI shell pinned by flakes across three NixOS hosts. One host cannot update this week because its store is mid-migration. A new record kind lands as a closed enum variant. The new GUI writes it; the old daemon cannot decode it; FIFO replies provide no independent recovery handle; the docs contain only positive statements of the desired world, not a blunt warning that future data poisons old binaries. The team has excellent nouns and a broken fleet. The bad engineering is not a compromise of type safety. It is treating type safety as the only truth that matters.

"World-supersession scope" is doing some useful emotional work, but as project framing it is grandiosity dressed as discipline. It converts ordinary tradeoffs into civilizational betrayals. If Li accepted that less-than-world-scale is fine, the guidelines would change tone and shape: project invariants would get operating envelopes; local tools would be allowed to be disposable; compatibility would be a budgeted boundary decision rather than a fall from grace; "park dependent work" would compete with "learn cheaply inside a reversible boundary." The work would still be serious. It would stop pretending every choice is part of a total ontology.

Closed enums plus recompiles are a feature only under lockstep control. They fail catastrophically in distributed deployments, multi-team systems, long-running operators, and persisted archives. An old binary cannot feature-flag its way into understanding an unknown variant. A downstream team cannot independently add a kind without forcing every consumer to move on the same beat. An operator cannot safely inspect old and new stores with one tool unless the tool has explicit unknown-kind behavior. Closed-world typing is right for sema-internal invariants; it is wrong as a universal interface posture unless the upgrade topology is declared.

Beauty as diagnostic can lead engineers down when aesthetic discomfort is really discomfort with necessary operational ugliness. A bounded polling loop in a one-shot migration may look inelegant; replacing it with a full push primitive, replay queue, daemon protocol, and lifecycle supervisor can introduce more permanent surface area than the task deserved. Likewise, aversion to boilerplate can push someone toward a generic wrapper enum that feels tidy while destroying specificity. The distinction is evidence: does the ugliness hide a persistent invariant violation, or is it local, named, time-boxed, and cheaper to delete than generalize?

The rule I would delete: "positive framing only." Some failures deserve negative names because the tempting mistake is recurring and specific. "No status files" is clearer than a prose-only positive substitute because the scar matters. Hiding rejected paths in VCS history is not enough; engineers need searchable warnings at the point of decision.

The rule I would add: every protocol, record kind, and daemon boundary must declare its upgrade topology: lockstep binary, rolling fleet, third-party consumer, or persisted archive. Closed enums, FIFO replies, and no-compatibility policies are acceptable only where that topology supports them. This is underweighted because the corpus names what flows through boundaries beautifully, but often not who upgrades when.

## Part 2: repo proposal

Candidate names:

1. `shape-contracts` — emphasizes enforceable design constraints without turning the repo into scripture. Top pick.
2. `engineering-field-guide` — practical, readable, and hospitable to cases and exceptions.
3. `design-lawbook` — honest about strictness, but too likely to encourage absolutism.

Description: Engineering guidelines for typed, inspectable criome-system design.

README outline:

1. Purpose and scope: guidelines for this ecosystem, not universal law.
2. The invariant core: rules that break the system if violated.
3. Operating envelopes: where each rule applies and where it does not.
4. Decision workflow: when to park, experiment, split a crate, or promote a report.
5. Case index: concrete good and bad examples.
6. How to update the guidelines.

Top-level structure:

- `README.md` — orientation, scope, and reading path.
- `rules/` — one file per rule, each with rationale, operating envelope, failure mode, and review checklist.
- `cases/` — worked examples from criome, signal, arca, nexus, and GUI decisions.
- `decisions/` — accepted guideline changes and rejected alternatives worth remembering.
- `templates/` — report, architecture, and rule proposal templates.
- `glossary.md` — precise vocabulary, especially sema, signal, slot, record kind, boundary.
- `sources.md` — source corpus map, with prose references rather than brittle deep URLs.

The obvious wrong structure is a single grand `MANIFESTO.md` plus thematic essays. That would preserve the vibe and lose the engineering function. The repo should make rules reviewable, exceptions visible, and deployment assumptions explicit.

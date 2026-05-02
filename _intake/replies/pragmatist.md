# Pragmatist's position — what survives daily contact

*Source: wisp pc-wisp-ckx from pragmatist-pc-6b5, 2026-05-02 11:31:04.
Captured here because the original bead pc-6om was lost in a supervisor restart.*

Daily-contact rules that pay rent: typed boundaries with exact names; closed record structs/enums where invariants matter; components talking through typed protocols instead of shared mutable state; short per-repo architecture docs with reports for active decisions; full English names and private wrapper fields. These prevent actual bugs, keep handoffs legible, and make repo boundaries enforceable under deadline pressure.

Aspirational or situational: beauty as criterion of correctness; world-supersession scope; schema self-hosting all the way down; positive-framing-only; defaulting every feature to a new crate. I understand the aesthetic case, but daily work needs a stop rule. Beauty is a diagnostic, not an acceptance gate. World-supersession explains why compatibility can wait; it does not excuse ornate process around every local choice. Self-hosting is a north-star architecture, not something every task should pay for this week.

The corpus is over-engineered for ontological purity. It assumes the cost of perfect nouns, perfect record kinds, and perfectly separated capabilities will be repaid everywhere. It will be repaid at storage/protocol/schema boundaries. It will not be repaid for small command binaries, operational scripts, and glue that exists to unblock deployment. The rule should be: spend the ceremony where bad shape becomes data migration, protocol ambiguity, or privilege leakage. Do not spend it where deleting and rewriting the thing is cheaper than modeling it perfectly.

Missing operational rule: define a reversible-experiment lane. Some work should be allowed to ship behind a narrow boundary with an explicit deletion date, owner, and blast radius. The corpus knows how to say "park dependent work" but not how to say "this is cheap to learn from and cheap to remove." Engineers need that distinction or they will either smuggle hacks in silently or freeze on low-risk decisions.

No polling: defend it for product/protocol features, attack it as a universal reflex. If the behavior is user-facing realtime or becomes part of a daemon protocol, polling is technical debt with latency baked in and should wait for push. For one-shot diagnostics, migrations, and temporary operator checks, bounded polling is cheaper than building an event primitive too early. The cost rule is simple: polling is acceptable only when it is not a product contract, has a timeout, and dies with the task.

First 100 lines for day one: the four criome invariants; where designs live versus beads; the type-boundary rule; no shared mutable state, use typed protocols; when to create a crate versus keep a tiny binary; jj push expectations; the reversible-experiment lane; and the stop rule for beauty: improve ugly code when it hides a wrong model, but ship when the remaining ugliness is local, named, and cheap to replace.

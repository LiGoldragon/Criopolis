# Version pinning — forward commits, not rollbacks

*Read this before any work that changes which version of a dependency a
flake / lock / manifest depends on. Wrong vocabulary here costs hours
and makes the answerer look incompetent. The principles are short.*

## The core idea

**To change which version you depend on, make a NEW commit that pins
the new version. You do not "roll back," "revert," or "go back to."
You pin forward.**

Git history is append-only. The version you used last week is just a
SHA in some dependency's history. To depend on it again, you write a
new commit on `main` (or whatever your release branch is) that points
your lockfile at that SHA. The act of pointing at an older SHA is a
*forward* operation in your repo's history — the older SHA's content
is what flows into your build, but your repo gains a new commit on top.

## What this is NOT

- **NOT `git checkout <old-sha>`.** That puts you in detached HEAD;
  consumers running `main` get nothing.
- **NOT `git revert <bump-sha>`.** Revert *can* work for undoing one
  commit's worth of changes, but it's the wrong tool when:
  - the bump touched multiple inputs (revert produces noise);
  - you want to point at a specific known-good SHA, not just "undo the
    last bump";
  - the bump is older than the most recent commit (revert may
    re-introduce conflicts).
  Use revert only for the narrow "undo exactly this commit" case.
- **NOT "rolling back."** The word is misleading and triggers people
  to reach for `checkout` / `reset` / `revert`. Banish it from your
  vocabulary when talking about version pinning. Say "pin to <SHA>" or
  "bump to <SHA>" instead.
- **NOT force-push.** Never force-push `main` to undo a bump. Pin
  forward.

## How to actually do it (Nix flakes specifically)

The pattern is: edit `flake.lock` so the input you care about points
at the desired SHA, commit forward on `main`, push.

### Lock-only edit (the common case)

When the dependency is the same flake, just at a different rev:

1. Find the desired SHA in the dependency's git history:
   ```sh
   cd /path/to/dependency-flake-clone
   git log --oneline
   # pick the SHA that pinned the version you want
   ```
2. Tell nix to update only that input (recomputes narHash):
   ```sh
   cd /path/to/your-flake
   nix flake update --update-input <input-name>
   # or, if you need a specific rev rather than the latest of a branch:
   #   edit flake.lock by hand: change the `rev` field for the input,
   #   then `nix flake update --update-input <input-name>` to fix narHash
   ```
3. Commit forward on `main`:
   ```sh
   git add flake.lock
   git commit -m "<input-name>: pin to <sha-short> (<reason>)"
   git push origin main
   ```

That's the whole operation. One forward commit. One pointer change.
No checkout, no revert, no force-push.

### Source-shape change (rarer)

If the dependency's URL changes (e.g., switching from your fork to
upstream), edit `flake.nix` first to change the input definition, then
`nix flake update --update-input <input-name>` to refresh the lock.
Same forward-commit pattern. Still no rollback verbs.

## Worked example — what actually happened on 2026-05-05

The lesson originated in a real failure. Documented here so it
doesn't happen again.

**Setup:** `CriomOS-home` flake.lock pinned `gascity-nix` at
`gascity-nix 758917c (bump: gascity fork model schema)`, which in turn
pinned our fork at `gascity 4e8fc326 (codex model choices)`. The fork
introduced regressions; Li wanted to run stock v1.0.0 again.

**Wrong framings explored** (each cost time):
- "Build a stock packaging flake from scratch" — unnecessary work; the
  stock flake already existed.
- "Roll back CriomOS-home to before the fork bump" — wrong verb; the
  word `rollback` triggered checkout-of-old-commit thinking.
- "Revert the fork-bump commit" — would have worked but is noisier
  than the actual one-pointer fix.

**Correct framing**: `gascity-nix` history had four older commits, the
oldest being `gascity-nix f1218bd (Initial flake for Gas City v1.0.0)`
— the v1.0.0 anchor. The fix is one forward commit on `CriomOS-home`
main: change `flake.lock`'s `gascity-nix` rev from `758917c` →
`f1218bd`. Push. Activate. Done.

**Total work:** one editor open, one `nix flake update --update-input`,
one commit, one push, one `lojix-cli` activate. Five minutes if the
right framing is used from the start.

## When pinning forward, also remember

- **Scope your update.** `nix flake update` (no args) refreshes
  everything; almost never what you want. Always
  `--update-input <name>` to scope to the one input you're touching.
- **Leave a paper trail in the commit message.** Format:
  `<input>: pin to <short-sha> (<reason>)`. The reason matters
  because future-you (or another agent) needs to know if this pin is
  pointing at a stable anchor (keep it), an experimental branch
  (don't ride this), or a temporary workaround (revisit when X lands).
- **Branch for experimental pins; main for confident pins.** If you're
  trying out a candidate version that might not work, push to a
  feature branch. If you're pinning to a known-stable anchor (today's
  case), forward-commit straight to main; rolling forward to a
  different SHA later is exactly the same shape, so there's nothing
  to "undo."
- **Don't touch unrelated inputs.** If the lockfile diff includes
  inputs you didn't intend to change, your `--update-input` scoping
  was wrong; redo it before committing.

## Anti-pattern detection

If you find yourself typing or thinking any of these, stop and
re-frame:

- "Let's roll back to..."
- "Let's revert the bump..."
- "Let's go back to..."
- "We need to checkout the previous version..."
- "We need to undo..."

The right thought is: "What SHA do I want to pin to, and which
flake.lock entry needs to point at it?"

## Citation discipline

When citing dependency commits in this domain, always pair the SHA
with a short description (lore-standard 5–10 words). Examples:

- `gascity-nix f1218bd (Initial flake for Gas City v1.0.0)`
- `gascity-nix 758917c (bump: gascity fork model schema)`
- `gascity 4e8fc326 (codex model choices — our fork patch)`
- `CriomOS-home 365317ab (gascity input to fork)`

Bare SHAs in flake-pin discussions are the exact failure mode that
makes someone reach for the wrong verb.

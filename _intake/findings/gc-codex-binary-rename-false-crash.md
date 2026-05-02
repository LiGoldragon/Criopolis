# gas-city codex sessions falsely detected as crashed

*Filed: 2026-05-02. Reproducible on gas-city 1.0.0-unstable-2026-05-02
+ codex 0.125.0 from nixpkgs.*

## Symptom

Any gas-city agent with `provider = "codex"` is continuously
detected as crashed by the session reconciler. `gc events --follow`
shows a flood of `session.crashed` events for the agent (~1/second
sustained). The reconciler respawns the session and immediately
emits another crash event, creating a loop that:

- Hits dolt with hundreds of `bd` connections per minute
- Floods the events stream (497 events in 7 minutes observed for
  one agent)
- Generates real load on whatever external services the agent
  touches (we got a member's Anna's Archive account
  rate-limited / membership-revoked from the librarian's loop —
  paid consequence)

## Root cause

`internal/worker/builtin/profiles.go:161` defaults the codex
provider's `ProcessNames` to `[]string{"codex"}`. But codex
0.125.0 (current nixpkgs) ships split:

- `$NIX_PROFILE/bin/codex` — 482-byte bash wrapper
- `$NIX_PROFILE/bin/codex-raw` — 201MB Go binary

The wrapper does:

```sh
exec "/nix/store/.../codex-raw" "$@"
```

After `exec`, the live process has `comm=codex-raw` and
`argv[0]=codex-raw`. The wrapper bash process is replaced.

`processMatchesNames` (`internal/runtime/tmux/tmux.go:1836-1908`)
checks the basename of `comm`, then the basename of `argv[0]`,
then a fallback for known interpreters (`node`, `bun`, `npx`,
`deno`). None of these match `codex-raw` against the configured
`["codex"]`.

Result: `IsRuntimeRunning` returns false. The reconciler at
`cmd/gc/session_reconciler.go:511-521` sees `running && !alive`,
peeks 50 lines of tmux scrollback (which contain the codex CLI
startup banner), and emits `session.crashed`. The session is
respawned. Loop.

## Reproducer

1. Configure any codex agent in pack.toml without explicit
   `process_names`:

   ```toml
   [[agent]]
   name = "test"
   provider = "codex"
   prompt_template = "agents/test/prompt.template.md"
   ```

2. Sling work to it. Watch
   `gc events --follow --type session.crashed`. The session is
   reported as crashed once per second indefinitely.

## Workaround (local)

Add `process_names = ["codex", "codex-raw"]` to every codex
agent's `[[agent]]` block in `pack.toml`. Verified working on
philosophy-city's `pragmatist`, `devil`, `librarian` agents.

```toml
[[agent]]
name = "devil"
provider = "codex"
process_names = ["codex", "codex-raw"]
prompt_template = "agents/devil/prompt.template.md"
```

## Proposed upstream fix

`internal/worker/builtin/profiles.go:161`:

```go
// before
ProcessNames: []string{"codex"},

// after
ProcessNames: []string{"codex", "codex-raw"},
```

Or, more robustly, expand `processMatchesNames`'s wrapper-script
detection to recognize bash-script wrappers that `exec` a binary
whose name shares a prefix or stem with the configured name.
(This would also catch future codex versions that change the
binary name again, and matches the spirit of the existing `node /
bun / npx / deno` interpreter handling.)

## Why it bit hard here

The reconciler's session-crashed path was firing 1/sec. Each
crash:

- Fired a `bd update` to record quarantine state on the session
  bead
- Triggered a respawn attempt (which itself ran `bd ready` and
  related queries)
- Caused the new session to start running its prompt's "first
  task" (which for the librarian meant `annas book-search` /
  `annas book-download`)

For internal-only agents (the four forum seats) this was just
expensive. For the librarian, every cycle hit Anna's Archive's
fast-download API, racing toward the rate limit and bot-defense
heuristics. Three memberships were revoked over the cumulative
load; user paid out of pocket to recover.

## Severity

High for any city using codex agents that interact with external
rate-limited services. Suggests upstream gas-city should also
add a **circuit breaker**: any agent emitting >N
`session.crashed` events in M seconds should be force-suspended
(not respawned) and the issue surfaced via mail. Independent of
this specific binary-name fix.

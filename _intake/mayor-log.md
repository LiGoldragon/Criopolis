# Mayor operational log

*Append-only log of direct actions mayor takes (per Li directive 2026-05-05 §8 reword: trivial work mayor does directly + logs). Until the operational-log mechanism is designed (pending cr-7t767q), this is the default location.*

---

## 2026-05-05 — pre-supervisor-swap researcher hunt

**Context:** Li asserted "the researcher you interrupted is still up just not working" before the supervisor swap. Mayor searched for any live researcher to recover before the restart wiped everything.

**Searched:**

- `gc session list` → only mayor + control-dispatcher + code-writer-1.
- `gc bd show cr-2c6utr` (the original researcher-1 that did the damage survey) → CLOSED with `close_reason: stale-session`, `sleep_reason: orphaned`, `closed_at: 2026-05-05T12:18:54Z`. Likely reaped when mayor suspended the agent template.
- `gc bd show cr-2jte42` (later explicit single-spawn) → CLOSED with `close_reason: failed-create`.
- `tmux -L criopolis ls` → no researcher session.
- `tmux ls` (default socket) → `city`, `criopolis`, three `orchestrator-live-...` sessions. Not researcher-named; likely leftover from prior orchestrator integration tests. Could not capture-pane on them from this session (different socket).
- `tmux -L criopolis list-panes -a` → only mayor / control-dispatcher / code-writer / a dead `worker-adhoc-4a1f642968` shell. Pane dead status 1, command `true` — empty.
- `pgrep -af codex` → only one criopolis codex process: code-writer-1 (`code-writer-cr-kdcoi9`). Other codex processes are external (VS Code, realtime_conversation).

**Verdict:** No live researcher recoverable. Either Li was mistaken about a researcher being still up, OR there's a session attached to a tmux socket mayor can't see from inside the criopolis tmux. Surfaced to Li; Li directed to log and proceed with the supervisor swap.

**Mayor's action:** None other than this log. Did not kill anything; did not restart anything.

**Implication for next mayor (post-restart):** Worth re-checking `tmux ls` (default socket) for the orphan researchers post-restart in case they survived; also worth checking whether the leftover `orchestrator-live-*` tmux sessions are old test runs that could be cleaned up.

---

## 2026-05-05 — direct prose edits this session (post-supervisor-swap context)

Per mayor.md §8 (reword 2026-05-05): trivial direct edits + log entry.

- `_intake/operating-rules/mayor.md` §1 reworked — gc supervisor logs/status/reload now allowed; original blanket prohibition crippled diagnostic capability for 3 days.
- `_intake/operating-rules/mayor.md` §8 reworded — "mayor prefers not to code"; trivial edits direct + log; complex still routes to code-writer.
- `_intake/operating-rules/mayor.md` §9 added — communication discipline: be honest, plain, no jargon dismissal.
- `_intake/operating-rules/mayor.md` §10 added — capture wisdom by accretion in the right canonical home, not per-event step logs.
- `_intake/operating-rules/agents.md` §8 added — NEVER use agent-local memory (Claude auto-memory); repo only for cross-provider visibility.
- `agents/mayor/prompt.template.md` — synced with mayor.md changes (city-lifecycle scoped to lifecycle subcommands only; communication-discipline section added; required-reading updated to include li-canon, supervisor-restart, version-pinning, keel).
- `_intake/li-canon.md` created — Li's canonical statements, accreting. Today's entries: stability-is-the-feature; supervisor-logs-allowed; mayor-prefers-not-to-code; reports-go-to-file; maintainer-is-gc-debugger; cascading-forum-flow; specialized-researchers; operational-log; never-agent-local-memory; honesty-no-jargon; document-what-Li-says; use-the-forum; researcher-when-too-much.
- `_intake/mayor-log.md` created (this file).
- `_intake/reports/2026-05-05-session-status.md`, `_intake/reports/2026-05-05-operational-wisdom-map.md` written.
- 3 redundant Claude memory files deleted (already mirrored in li-canon).

## 2026-05-05 — supervisor swap

- Verified `command -v gc` resolves to `/nix/store/xlrgajl0kz9z9kavnfqb582ga66va1pk-gascity-1.0.0-codex-2026-05-05/bin/gc` after Li ran `lojix-cli`.
- Ran `nohup bash -c 'gc supervisor stop --wait && sleep 3 && gc supervisor install' < /dev/null > /tmp/supervisor-swap.log 2>&1 &` — detached so install survives mayor's tmux dying during the stop.
- Post-restart: supervisor active under PID 1378198 from new nix-store path; `gc version` = `1.0.0-codex-2026-05-05`; mayor session resumed (Claude session persistence across the tmux death).
- Verified the patch chain: `gascity-nix 972fd56 (merge PR #1)` → `gascity-nix 9692d4e (gascity pin to rebased v1.0.0)` → `gascity-nix flake.nix` rev `gascity 76f46b45 (codex model choices on v1.0.0)` → parent `67c821c7` is **tagged v1.0.0**. Patch sits cleanly on the tagged release.

## 2026-05-05 — post-restart bead state cleanup

- Spawned `cr-o4heho (researcher adhoc)` for cr-9dw438 (maintainer scaffold + debugger expansion). Researcher agent stays suspended; only one explicit spawn.

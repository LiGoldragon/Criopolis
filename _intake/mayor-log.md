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

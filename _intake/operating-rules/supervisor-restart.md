# Supervisor restart — handoff procedure

*Read this before any operation that requires a supervisor restart
(`systemctl --user restart gascity-supervisor.service`, `gc supervisor
stop/start/install/restart`, or HTTP-equivalent). The supervisor
restart kills every in-flight session including mayor itself; the
durable handoff that the post-restart mayor reads on wake is what
keeps work continuous.*

## CRITICAL — `systemctl restart` alone does NOT swap the binary

When the gc binary itself changed (the common case — flake.lock pin
+ Home Manager activation produced a fresh nix-store gc binary), a
plain `systemctl --user restart gascity-supervisor.service` is
**insufficient and misleading**. Here's why:

The systemd unit file at
`/home/li/.local/share/systemd/user/gascity-supervisor.service`
contains an `ExecStart=` line with a **hardcoded absolute nix-store
path** to the gc binary that was current when `gc supervisor install`
last ran. Example after the fork bump and before today's stock pin:

```
ExecStart=/nix/store/81hp1kz19lldph46gpcgargni7s02893-gascity-1.0.0-unstable-2026-05-04/bin/gc supervisor run
```

`systemctl --user restart` re-spawns the service from that exact
path. If a *new* gc binary now lives at a different nix-store path
(because lojix-cli activated a new Home Manager profile), the
restart **does not see it**. The supervisor keeps running the old
binary while the user's interactive shell sees the new one via
`/home/li/.nix-profile/bin/gc`. `gc version` from the user's shell
returns the new version; `ps` on the supervisor PID shows the old
nix-store path. This is the silent failure mode that consumed
~30 minutes of debugging on 2026-05-05 — the "it was supposed to
swap" surprise.

### The correct binary-swap procedure

After the flake.lock pin is committed and lojix-cli HomeOnly
Build/Profile/Activate has run:

1. Confirm the new binary is in PATH:
   `command -v gc && gc version` — should resolve to the new
   nix-store path with the expected version.
2. Inspect the systemd unit's current `ExecStart=`:
   `grep ^ExecStart /home/li/.local/share/systemd/user/gascity-supervisor.service`.
   This shows the *old* path — that's why a plain restart is
   wrong.
3. Deposit the handoff (see "The handoff procedure" below).
4. Run **`gc supervisor stop --wait && gc supervisor install`** —
   Li-only command class, but Li's "do it" authorization permits
   one execution per ratified upgrade (see precedent
   `cr-wisp-jq3 (gc bumped to fork; verify + cascade test)`). The
   `stop --wait` cleanly stops the current supervisor; `install`
   rewrites the systemd unit's `ExecStart=` to whatever
   `command -v gc` resolves to *at install time* and starts the
   new supervisor.
5. Run the verify-after-wake checklist. **Critically**, also check
   `ps -p <new-supervisor-pid> -o args` to confirm the supervisor
   is now running from the *new* nix-store path, not the old one.

### Anti-pattern (the 2026-05-05 mistake)

Running `systemctl --user restart gascity-supervisor.service` and
trusting that `gc version` (interactive shell) reflects the
supervisor's actual binary. It does not. Always inspect the
supervisor's actual `ps` output and the systemd unit's `ExecStart=`
to confirm the swap landed.

## When this applies

- Bumping the system `gc` binary (Home Manager activation followed by
  supervisor restart).
- Bumping the supervisor systemd template (`KillMode`, env vars, the
  `GC_SUPERVISOR_PRESERVE_SESSIONS_ON_SIGNAL` flag, etc.).
- Recovering from a wedged city when Li chooses to restart cleanly.
- Any other Li-authorized lifecycle event that rotates the supervisor
  process.

City-lifecycle commands remain Li-only — see `mayor.md` §1. This
document is about the **handoff** mayor must prepare *before* Li acts,
not about whether mayor runs the restart itself (mayor doesn't).

## What dies on restart

- All session runtimes — mayor, council seats, researcher,
  code-writer, dogs, control-dispatcher.
- The `tmux -L criopolis` server and all panes.
- Mid-flight codex / claude conversation state.
- In-flight tool calls inside agents — interrupted, not resumed.

## What survives

- The bead store (Dolt). Session beads, work beads, mail beads, all
  persist.
- Pushed git commits and files written to disk inside Criopolis.
- The Home Manager profile and the `gc` binary's nix-store path.
- Auto-memory under `~/.claude/projects/-home-li-Criopolis/memory/`.

## The handoff procedure

### 1. Compose the handoff body

Six sections, in this order:

| Section | What goes here |
|---|---|
| **WHAT JUST HAPPENED** | The change being applied; the trigger for the restart. One paragraph. |
| **PRE-RESTART STATE** | Concrete artifacts already on disk and pushed: commits (with descriptions), beads filed today (with descriptions), sessions running, files written. |
| **VERIFY AFTER WAKE** | Numbered checklist. First items prove the restart worked: `gc version`, `systemctl --user status gascity-supervisor.service`, `gc status`. Subsequent items prove specific things specific to this restart's context (binary path, supervisor PID, expected env, etc.). |
| **OPEN WORK** | In-flight beads at session-start time. P0 first. Each line: bead ID + description + current state + who was working on it + what's next. |
| **NEXT STEPS** | Concrete actions for the post-restart mayor. Re-spawning sessions, slinging routed work, sending follow-up mail, etc. |
| **REFUSAL TRIGGERS / GOTCHAS** | What to NOT do, what to surface to Li, common ways the restart could go sideways. |

### 2. Deposit the handoff via mail (NOT `gc handoff`)

Use plain `gc mail send mayor`, **not** `gc handoff`:

```sh
gc mail send mayor \
  -s "HANDOFF: <one-line summary of what just happened>" \
  -m "<body with the six sections above>"
```

Why not `gc handoff`: that command sends mail-to-self **and**
restarts mayor's session immediately. The supervisor restart that's
about to happen will already restart everything; using `gc handoff`
would cause two restarts (mayor would respawn, read its own mail, get
mid-task, then die again when Li's supervisor restart fires). One
restart is the right number. Plain `gc mail send mayor` deposits the
handoff and keeps mayor running until the supervisor restart kills it.

### 3. Tell Li the handoff is deposited

In chat: cite the wisp ID with a short description so Li can confirm,
e.g.:

> Handoff `cr-wisp-XXX (HANDOFF: <summary>)` deposited. Clear to run
> `systemctl --user restart gascity-supervisor.service`.

### 4. Wait

Don't do further work after depositing the handoff and before Li
restarts. Anything you do is going to be lost. Stand by.

## After the restart

Mayor (always-on) respawns automatically with no conversation context.
The first message it sees on wake is the system-reminder + its own
inbox. The handoff mail is at the top. Mayor reads it, runs the
verify-after-wake checklist, then proceeds with NEXT STEPS.

If verification fails, mayor surfaces to Li **before** acting on
NEXT STEPS — the restart didn't go as expected.

## Worked example

`cr-wisp-jq3 (gc bumped to fork; verify + start orchestrator + run
gpt-5.4-mini cascade test)` from 2026-05-04 23:37 UTC is the canonical
example. Previous mayor triggered `gc supervisor stop --wait && gc
supervisor install` to bump the system gc to our fork. The handoff
body included:

- WHAT JUST HAPPENED: supervisor restart triggered to install fork.
- PRE-RESTART STATE: pack.toml committed, fork binary path verified.
- VERIFY AFTER WAKE: 4-item checklist (`systemctl status`, `gc
  --version`, KillMode flags grep, `gc status`).
- NEXT STEPS: start orchestrator in detached tmux, run cascade test.
- REFUSAL TRIGGERS: old build version, validation failure, codex
  auth errors.

That handoff survived the restart and bridged the work continuously.

## Anti-patterns

- **Using `gc handoff` instead of `gc mail send mayor`** — causes a
  double restart (mayor's handoff-restart, then Li's supervisor
  restart).
- **Composing the handoff after Li already restarted** — too late;
  mayor lost everything in context.
- **Skipping VERIFY AFTER WAKE** — the post-restart mayor can't tell
  if the binary actually swapped. Always verify before acting.
- **Skipping OPEN WORK** — post-restart mayor has no idea which
  beads were P0 in flight, who was working on what, where to look
  first.
- **Putting the verify checklist in chat instead of the handoff** —
  the chat dies with mayor; only the handoff survives.

## After this restart, document how it went

Li's discipline (2026-05-05): after every restart, add a short note
to this file (or a sibling) describing what worked and what didn't
about the procedure on this attempt. The doc improves by accretion.

---

## How it went — 2026-05-05 (binary swap: fork → stock 1.0.0)

The full upgrade chain:
`CriomOS-home a179bbf (gascity-nix f1218bd stock v1.0.0 anchor)` →
`lojix-cli HomeOnly Build/Profile/Activate` →
`gc supervisor stop --wait && gc supervisor install` →
city failed to start; required ~30 minutes of debugging before the
city was up. Documenting failures so the next upgrade is shorter.

### What worked

- The flake-pin forward-commit pattern from `version-pinning.md`
  landed cleanly. New gc binary in PATH at the expected nix-store
  path within seconds of activation.
- `gc supervisor install` rewrote the systemd unit's `ExecStart=` to
  point at the new binary (the previously-installed unit had the
  stale fork-build path; the install step is what actually swaps the
  managed supervisor). Without this, `systemctl restart` alone keeps
  using the old binary — see the CRITICAL section at the top.
- The handoff-via-mail pattern (`gc mail send mayor`, not
  `gc handoff`) deposited durable context that survived the
  subsequent supervisor swap.
- Direct invocation of `gc-beads-bd.sh start` outside the
  supervisor's startup_timeout was the diagnostic that broke the
  deadlock — dolt came up cleanly, wrote its state file, and the
  next `gc start` recognized it.

### What didn't work — failure mode `gc start` retry loop

After `gc supervisor install`, `gc start` reported:

> city failed to start: init: beads lifecycle: bead store:
> exec beads start: could not acquire dolt start lock
> (/home/li/Criopolis/.gc/runtime/packs/dolt/dolt.lock)

Surface error said "lock contention" but the actual root cause
varied across retries. Two distinct failure modes were entangled:

**Failure mode A — zombie script holding flock.** The first failed
`gc-beads-bd.sh start` invocation acquired flock on the lock file
(fd 9), proceeded into `wait_for_concurrent_start_ready`, and never
exited. Subsequent invocations hit "could not acquire" because the
zombie was still holding it. Diagnosis:

```sh
lsof /home/li/Criopolis/.gc/runtime/packs/dolt/dolt.lock
# Look for a `gc-beads-` row with `9w REG` — that's the zombie.
ps -o pid,ppid,etime,cmd -p <pid>
# Confirms it's a hung gc-beads-bd.sh start with the supervisor as parent.
kill <pid>
```

**Failure mode B — supervisor startup_timeout SIGTERMs the script
before dolt is ready.** After the zombie was cleared, the next
attempt got further but failed with:

> exec beads start: exit status 143 (skipping)

`143 = 128 + 15 = SIGTERM`. The supervisor's startup_timeout is
shorter than the time the script needs for a cold dolt start (script
took ~27s; supervisor cut it off). The script was killed mid-startup,
which left a half-written state file with `pid: 0` — that's the
fingerprint of this failure mode in `dolt-provider-state.json`.

### Workaround — bootstrap dolt outside the supervisor's timeout

The fix that worked (record this for next time):

1. Stop fighting the supervisor's retry loop. Wait for it to back off
   (it does exponential backoff: 10s → 20s → 40s → 1m20s).
2. Clear stale state if present:
   ```sh
   rm -f /home/li/Criopolis/.gc/runtime/packs/dolt/dolt-provider-state.json
   rm -f /home/li/Criopolis/.gc/runtime/packs/dolt/dolt.lock
   ```
3. Manually invoke the script with the city env, *outside* the
   supervisor's timeout window:
   ```sh
   GC_CITY_PATH=/home/li/Criopolis \
   GC_HOME=/home/li/.gc \
   GC_BIN=/home/li/.nix-profile/bin/gc \
     bash /home/li/Criopolis/.gc/system/packs/bd/assets/scripts/gc-beads-bd.sh start
   ```
4. Verify: `pgrep -af "dolt sql-server"` shows a dolt running with
   `--config .../dolt-config.yaml`; `cat .../dolt-provider-state.json`
   shows `running: true, pid: <live>, port: <port>`.
5. Re-issue `gc start`. The supervisor sees the live state file,
   recognizes dolt is up, and reports "City started under
   supervisor."

### Where dolt actually logs (gotcha for debuggers)

Two distinct dolt log files exist; check both:

- `/home/li/Criopolis/.gc/runtime/packs/dolt/dolt.log` — the city's
  managed dolt (the one the supervisor uses).
- `/home/li/Criopolis/.beads/dolt-server.log` — what `bd dolt start`
  (no args, no city config) writes to. Default `bd dolt start` picks
  a hash-derived port (~46553 for this city's path); the city's
  managed dolt uses 55765 (per the supervisor's allocated port).
  Don't confuse them when diagnosing.

### Root-cause hypothesis (worth a follow-up bead)

Stock 1.0.0's startup_timeout for the bead-store init phase is
narrower than what a cold-start dolt actually needs on this machine.
The fork build apparently extended this (one of the post-v1.0.0
commits we forked off probably bumped the timeout, or PR `#1157
(reconciler: stop reporting outcome=success when Start outlasts
startup_timeout)` reshaped the contract). Net effect: stock 1.0.0's
default is too tight for our box.

Workarounds short of a fork rebase:
- Always pre-warm dolt via direct script invocation before letting
  the supervisor try (the workaround above).
- Set `GC_DOLT_CONCURRENT_START_READY_TIMEOUT_MS` higher in the
  supervisor's systemd unit Environment block (default 45000;
  bumping to e.g. 90000 may eliminate the SIGTERM race).
- Investigate whether the supervisor itself has a separate
  startup-timeout knob exposed via `city.toml [daemon]`.

### Anti-pattern hit on this attempt

When the symptom is "could not acquire dolt start lock" and the lock
file has **no `lsof` holder**, do **not** assume "stale lock, just
delete it" and retry. The supervisor will spawn a fresh
`gc-beads-bd.sh start` which will recreate the lock and hit the
*real* underlying timeout failure. Always check `lsof` first;
"no holder" means the failure is downstream of the lock, not at it.

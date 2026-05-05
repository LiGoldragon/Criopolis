#!/usr/bin/env bash
# Periodic autonomous-loop nudger for mayor.
#
# Sends `gc session nudge mayor "..."` every INTERVAL_SEC (default 1500 = 25min).
# Runs until the runfile is removed.
#
# Start:  nohup ./assets/scripts/mayor-nudge-loop.sh > /dev/null 2>&1 &
# Stop:   rm /tmp/mayor-nudge-loop.run
# Tail:   tail -f _intake/mayor-nudge-loop.log
#
# Cadence rationale: 25 minutes ≈ wide enough to do meaningful work between
# wakes, narrow enough that an issue doesn't sit unattended for hours. Pass
# a different value as $1 to override (e.g. ./script 600 for 10-min cadence).

set -u

script_directory="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
city_directory="$(CDPATH= cd -- "$script_directory/../.." && pwd)"

RUNFILE=/tmp/mayor-nudge-loop.run
LOGFILE="$city_directory/_intake/mayor-nudge-loop.log"
INTERVAL_SEC="${1:-1500}"
GC_BIN="${GC_BIN:-gc}"

mkdir -p "$(dirname "$LOGFILE")"
touch "$RUNFILE"

ts() { date -Iseconds; }
log() { echo "$(ts) $*" >> "$LOGFILE"; }

log "start pid=$$ interval=${INTERVAL_SEC}s runfile=$RUNFILE"

trap 'log "trap-exit pid=$$"; exit 0' INT TERM HUP

while [ -f "$RUNFILE" ]; do
    sleep "$INTERVAL_SEC"
    [ -f "$RUNFILE" ] || break

    msg="autonomous-tick $(date +%H:%M) — verify each agent is ACTUALLY running (gc session list — no \"creating\" stuck >5min, no over-spawn duplicates, count active sessions matches what should be working); peek each active session for real activity (not idle at codex \"Ready\" prompt); if any agent type has multiple actives, close dupes and re-suspend; if researcher/code-writer has no work but should, sling next queued P0/P1 bead via single-explicit-spawn pattern; advance Goals A (spawn reliability) / B (orchestrator) / C (harness auto-terminate, cr-l55mfh) / D (over-spawn cycling fix, cr-8l3lq5); push commits if anything material landed; surface anomalies to Li; if ALL FOUR goals hit, rm $RUNFILE to stop the loop"
    if "$GC_BIN" --city "$city_directory" session nudge mayor "$msg" >> "$LOGFILE" 2>&1; then
        log "nudged ok"
    else
        log "nudge FAILED (see preceding stderr)"
    fi
done

log "stopped (runfile gone) pid=$$"

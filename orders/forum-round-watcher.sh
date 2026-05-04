#!/bin/sh
# =============================================================================
# DISABLED 2026-05-03 BY LI (via Claude diagnosis).
#
# See forum-round-watcher.toml for the full post-mortem. Short version:
# this order triggered on bead.closed, but every order run creates an
# order-tracking bead that gets closed when the run completes. That close
# is itself a bead.closed event. The order therefore fires itself, every
# ~1.5–2 seconds, forever, with no exit condition.
#
# The body below is fine (idempotent, has the "skip if no markers" early
# exit). The body is NOT the problem. The TRIGGER is the problem, and no
# amount of guarding inside exec() can stop the order from running, since
# running is what creates the tracking bead that re-fires it.
#
# Original script preserved below, commented out, so the next reader can
# see what was deployed when this loop ran.
# =============================================================================

exit 0  # safety net in case TOML disablement is reverted without thinking

# # Forum-round watcher.
# #
# # Triggered on every bead.closed event. Checks whether any open
# # forum-round-active marker bead has had all its seat-reply beads
# # close. If so, nudges mayor and writes an idempotency marker so
# # the same round only nudges once.
# #
# # Convention (mayor maintains this when filing rounds):
# #  - Round-marker bead: type=task, label=forum-round-active,
# #    metadata round=<N>. One per active round.
# #  - Seat-reply beads: label=forum-round-reply,
# #    metadata round=<N> (matching the marker). One per seat.
# #
# # After mayor synthesizes round N, close the round-marker bead AND
# # `rm .gc/tmp/forum-round-<N>-mayor-nudged` (so a re-run with the
# # same round number nudges fresh, though normally rounds use unique
# # numbers).
#
# set -eu
# : "${GC_CITY:?GC_CITY missing — order should be invoked by gc controller}"
# cd "$GC_CITY"
#
# # Find any open round-marker beads. If none, nothing to do.
# MARKERS=$(gc bd list --status open --label forum-round-active --json 2>/dev/null || printf '%s' '[]')
# case "$MARKERS" in
#   '['|'[]'|'') exit 0 ;;
# esac
#
# # Iterate by extracting round numbers from the markers' metadata.
# ROUNDS=$(printf '%s' "$MARKERS" | jq -r '.[].metadata.round // empty' | sort -u)
# [ -z "$ROUNDS" ] && exit 0
#
# NUDGED=""
#
# for ROUND in $ROUNDS; do
#   # Idempotency: skip rounds we've already nudged for.
#   marker_file=".gc/tmp/forum-round-${ROUND}-mayor-nudged"
#   [ -f "$marker_file" ] && continue
#
#   # Count open seat-reply beads for this round.
#   REMAINING=$(gc bd list \
#                 --status open \
#                 --label forum-round-reply \
#                 --metadata-field "round=$ROUND" \
#                 --json 2>/dev/null | jq 'length')
#   [ "$REMAINING" -gt 0 ] && continue
#
#   # All seats closed — write idempotency marker, then nudge mayor.
#   mkdir -p "$(dirname "$marker_file")"
#   : > "$marker_file"
#
#   gc session nudge mayor "Forum round ${ROUND}: all seats closed. Synthesize." \
#     >>".gc/tmp/forum-round-watcher.log" 2>&1 || true
#
#   NUDGED="$NUDGED $ROUND"
# done
#
# # Brief log line on each fire (overwritable; the controller already records OrderRan).
# {
#   date -Iseconds
#   echo "  open-markers=$(printf '%s' "$MARKERS" | jq 'length')"
#   echo "  rounds=$ROUNDS"
#   [ -n "$NUDGED" ] && echo "  nudged=$NUDGED"
# } >>".gc/tmp/forum-round-watcher.log" 2>&1 || true

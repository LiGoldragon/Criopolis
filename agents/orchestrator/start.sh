#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CITY_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"

readonly CASCADE_LABEL="cascade-chain"
readonly ORDER_TRACKING_LABEL="order-tracking"
readonly DISPATCHED_AT_KEY="cascade_dispatched_at"
readonly DISPATCHED_TO_KEY="cascade_dispatched_to"
readonly COMPLETION_NOTIFIED_AT_KEY="cascade_completion_notified_at"

ORCHESTRATOR_CURSOR_FILE="${GC_ORCHESTRATOR_CURSOR:-$CITY_DIR/.gc/orchestrator-cursor}"
ORCHESTRATOR_SLEEP_SECONDS="${GC_ORCHESTRATOR_SLEEP_SECONDS:-5}"
CASCADE_STUCK_MINUTES="${GC_CASCADE_STUCK_MINUTES:-120}"
CASCADE_UNDISPATCHED_MINUTES="${GC_CASCADE_UNDISPATCHED_MINUTES:-10}"

log() {
  printf 'cascade-orchestrator: %s\n' "$*" >&2
}

fail() {
  log "$*"
  exit 1
}

usage() {
  cat <<'USAGE'
usage: agents/orchestrator/start.sh [daemon|once|health]

daemon  Run the cascade event loop.
once    Process currently buffered events once, then exit.
health  Check cascade-chain beads and mail mayor when stuck.
USAGE
}

require_command() {
  local command_name="$1"

  command -v "$command_name" >/dev/null 2>&1 || fail "missing required command: $command_name"
}

latest_event_sequence() {
  local sequence

  if ! sequence="$(gc events --seq 2>/dev/null)"; then
    return 1
  fi
  sequence="${sequence//$'\n'/}"
  if [[ ! "$sequence" =~ ^[0-9]+$ ]]; then
    log "gc events --seq returned non-numeric cursor: $sequence"
    return 1
  fi
  printf '%s\n' "$sequence"
}

write_cursor_sequence() {
  local sequence="$1"
  local cursor_directory
  local temporary_file

  cursor_directory="$(dirname -- "$ORCHESTRATOR_CURSOR_FILE")"
  mkdir -p -- "$cursor_directory"
  temporary_file="$(mktemp "$cursor_directory/.orchestrator-cursor.XXXXXX")"
  printf '%s\n' "$sequence" > "$temporary_file"
  mv -f -- "$temporary_file" "$ORCHESTRATOR_CURSOR_FILE"
}

read_cursor_sequence() {
  local sequence

  [[ -f "$ORCHESTRATOR_CURSOR_FILE" ]] || return 1
  sequence="$(<"$ORCHESTRATOR_CURSOR_FILE")"
  sequence="${sequence//$'\n'/}"
  [[ "$sequence" =~ ^[0-9]+$ ]] || return 1
  printf '%s\n' "$sequence"
}

current_cursor_or_initialize() {
  local cursor_sequence
  local head_sequence

  if ! head_sequence="$(latest_event_sequence)"; then
    log "cannot read current event head"
    return 1
  fi

  if ! cursor_sequence="$(read_cursor_sequence)"; then
    write_cursor_sequence "$head_sequence"
    log "initialized cursor at event sequence $head_sequence"
    return 1
  fi

  if (( cursor_sequence > head_sequence )); then
    write_cursor_sequence "$head_sequence"
    log "cursor $cursor_sequence was past event head $head_sequence; reset to head"
    return 1
  fi

  printf '%s\n' "$cursor_sequence"
}

show_bead_object() {
  local bead_id="$1"
  local bead_json

  if ! bead_json="$(gc bd show "$bead_id" --json 2>/dev/null)"; then
    return 1
  fi
  jq -e -c '.[0]' <<<"$bead_json"
}

bead_has_label() {
  local bead_json="$1"
  local label="$2"

  jq -e --arg label "$label" '(.labels // []) | index($label) != null' <<<"$bead_json" >/dev/null
}

bead_metadata_value() {
  local bead_json="$1"
  local key="$2"

  jq -r --arg key "$key" '.metadata[$key] // empty | tostring' <<<"$bead_json"
}

bead_status() {
  local bead_json="$1"

  jq -r '.status // empty' <<<"$bead_json"
}

bead_timestamp() {
  local bead_json="$1"
  local key="$2"

  jq -r --arg key "$key" '.[$key] // empty' <<<"$bead_json"
}

truthy_metadata() {
  local bead_json="$1"
  local key="$2"
  local value

  value="$(bead_metadata_value "$bead_json" "$key")"
  [[ "${value,,}" == "true" ]]
}

cascade_id_for() {
  local bead_json="$1"
  local bead_id="$2"
  local cascade_id

  cascade_id="$(bead_metadata_value "$bead_json" "cascade_id")"
  if [[ -z "$cascade_id" ]]; then
    cascade_id="$bead_id"
  fi
  printf '%s\n' "$cascade_id"
}

bead_has_sling_parent() {
  local bead_id="$1"
  local bead_json="$2"
  local parent_id
  local parent_json
  local parent_title
  local parent_type

  parent_id="$(jq -r '.parent // empty' <<<"$bead_json")"
  [[ -n "$parent_id" ]] || return 1
  parent_json="$(show_bead_object "$parent_id" 2>/dev/null)" || return 1
  parent_title="$(jq -r '.title // empty' <<<"$parent_json")"
  parent_type="$(jq -r '.issue_type // .type // empty' <<<"$parent_json")"

  [[ "$parent_title" == "sling-$bead_id" && "$parent_type" == "convoy" ]]
}

bead_is_dispatched() {
  local bead_id="$1"
  local bead_json="$2"

  [[ -n "$(bead_metadata_value "$bead_json" "$DISPATCHED_AT_KEY")" ]] && return 0
  bead_has_sling_parent "$bead_id" "$bead_json"
}

mark_bead_dispatched() {
  local bead_id="$1"
  local target_agent="$2"
  local timestamp

  timestamp="$(date -Iseconds)"
  if ! gc bd update "$bead_id" \
    --set-metadata "$DISPATCHED_AT_KEY=$timestamp" \
    --set-metadata "$DISPATCHED_TO_KEY=$target_agent" >/dev/null; then
    log "warning: could not mark $bead_id as dispatched"
  fi
}

mark_completion_notified() {
  local bead_id="$1"
  local timestamp

  timestamp="$(date -Iseconds)"
  if ! gc bd update "$bead_id" --set-metadata "$COMPLETION_NOTIFIED_AT_KEY=$timestamp" >/dev/null; then
    log "warning: could not mark $bead_id as completion-notified"
  fi
}

dispatch_bead_to_agent() {
  local bead_id="$1"
  local bead_json="$2"
  local target_agent="$3"

  if [[ -z "$target_agent" ]]; then
    log "skip $bead_id: no gc.routed_to metadata"
    return 0
  fi

  if bead_is_dispatched "$bead_id" "$bead_json"; then
    log "skip $bead_id: already dispatched"
    return 0
  fi

  log "sling $bead_id to $target_agent"
  if gc sling "$target_agent" "$bead_id"; then
    mark_bead_dispatched "$bead_id" "$target_agent"
  else
    log "sling failed for $bead_id to $target_agent"
  fi
}

dispatch_next_bead() {
  local source_bead_id="$1"
  local next_bead_id="$2"
  local next_bead_json
  local target_agent

  if ! next_bead_json="$(show_bead_object "$next_bead_id")"; then
    log "skip $source_bead_id cascade_next=$next_bead_id: next bead is missing"
    return 0
  fi
  if ! bead_has_label "$next_bead_json" "$CASCADE_LABEL"; then
    log "skip $source_bead_id cascade_next=$next_bead_id: next bead lacks $CASCADE_LABEL label"
    return 0
  fi
  if bead_has_label "$next_bead_json" "$ORDER_TRACKING_LABEL"; then
    log "skip $source_bead_id cascade_next=$next_bead_id: next bead is order tracking"
    return 0
  fi

  target_agent="$(bead_metadata_value "$next_bead_json" "gc.routed_to")"
  dispatch_bead_to_agent "$next_bead_id" "$next_bead_json" "$target_agent"
}

notify_final_cascade() {
  local bead_id="$1"
  local bead_json="$2"
  local cascade_id
  local subject
  local message

  if [[ -n "$(bead_metadata_value "$bead_json" "$COMPLETION_NOTIFIED_AT_KEY")" ]]; then
    log "skip $bead_id: cascade completion already notified"
    return 0
  fi

  cascade_id="$(cascade_id_for "$bead_json" "$bead_id")"
  subject="cascade complete: $cascade_id"
  message="Final bead $bead_id closed."

  log "mail mayor: $subject"
  if gc mail send --notify mayor -s "$subject" -m "$message"; then
    mark_completion_notified "$bead_id"
  else
    log "mail failed for final cascade bead $bead_id"
  fi
}

process_cascade_event() {
  local event_type="$1"
  local bead_id="$2"
  local bead_json
  local cascade_position
  local cascade_next
  local target_agent

  case "$event_type" in
    bead.created | bead.closed) ;;
    *) return 0 ;;
  esac

  if ! bead_json="$(show_bead_object "$bead_id")"; then
    log "skip $event_type subject=$bead_id: bead is missing"
    return 0
  fi
  if ! bead_has_label "$bead_json" "$CASCADE_LABEL"; then
    return 0
  fi
  if bead_has_label "$bead_json" "$ORDER_TRACKING_LABEL"; then
    return 0
  fi

  case "$event_type" in
    bead.created)
      cascade_position="$(bead_metadata_value "$bead_json" "cascade_position")"
      if [[ "$cascade_position" == "1" ]]; then
        target_agent="$(bead_metadata_value "$bead_json" "gc.routed_to")"
        dispatch_bead_to_agent "$bead_id" "$bead_json" "$target_agent"
      fi
      ;;
    bead.closed)
      cascade_next="$(bead_metadata_value "$bead_json" "cascade_next")"
      if [[ -n "$cascade_next" ]]; then
        dispatch_next_bead "$bead_id" "$cascade_next"
      elif truthy_metadata "$bead_json" "cascade_final"; then
        notify_final_cascade "$bead_id" "$bead_json"
      fi
      ;;
  esac
}

process_event_batch() {
  local cursor_sequence
  local events_json_lines
  local highest_sequence
  local event_sequence
  local event_type
  local bead_id
  local event_json

  if ! cursor_sequence="$(current_cursor_or_initialize)"; then
    return 0
  fi

  if ! events_json_lines="$(gc events --after "$cursor_sequence" 2>&1)"; then
    log "event read after sequence $cursor_sequence failed: $events_json_lines"
    if highest_sequence="$(latest_event_sequence)"; then
      write_cursor_sequence "$highest_sequence"
      log "reset cursor to current event head $highest_sequence"
    fi
    return 0
  fi

  highest_sequence="$cursor_sequence"
  while IFS= read -r event_json; do
    [[ -n "$event_json" ]] || continue
    event_sequence="$(jq -r '.seq // empty' <<<"$event_json" 2>/dev/null || true)"
    if [[ "$event_sequence" =~ ^[0-9]+$ ]] && (( event_sequence > highest_sequence )); then
      highest_sequence="$event_sequence"
    fi

    event_type="$(jq -r '.type // empty' <<<"$event_json" 2>/dev/null || true)"
    case "$event_type" in
      bead.created | bead.closed) ;;
      *) continue ;;
    esac

    bead_id="$(jq -r '.subject // .payload.bead.id // empty' <<<"$event_json" 2>/dev/null || true)"
    [[ -n "$bead_id" ]] || continue
    process_cascade_event "$event_type" "$bead_id"
  done <<<"$events_json_lines"

  write_cursor_sequence "$highest_sequence"
}

run_daemon() {
  log "starting in $CITY_DIR"
  while true; do
    process_event_batch
    sleep "$ORCHESTRATOR_SLEEP_SECONDS"
  done
}

age_minutes_since() {
  local timestamp="$1"
  local timestamp_epoch
  local now_epoch

  if [[ -z "$timestamp" ]]; then
    printf '%s\n' 999999
    return 0
  fi
  if ! timestamp_epoch="$(date -d "$timestamp" +%s 2>/dev/null)"; then
    printf '%s\n' 999999
    return 0
  fi
  now_epoch="$(date +%s)"
  printf '%s\n' "$(((now_epoch - timestamp_epoch) / 60))"
}

append_health_issue() {
  local issues_file="$1"
  local issue_line="$2"

  printf '%s\n' "$issue_line" >> "$issues_file"
}

check_cascade_health() {
  local issues_file="$1"
  local beads_json
  local bead_count
  local index
  local bead_json
  local bead_id
  local cascade_id
  local status
  local updated_at
  local created_at
  local updated_age_minutes
  local created_age_minutes
  local cascade_position
  local cascade_next
  local target_agent
  local next_bead_json

  if ! beads_json="$(gc bd list --flat --label "$CASCADE_LABEL" --all --json 2>/dev/null)"; then
    append_health_issue "$issues_file" "CASCADE_LIST_FAILED could not list cascade-chain beads"
    return 0
  fi
  if ! jq -e 'type == "array"' <<<"$beads_json" >/dev/null; then
    append_health_issue "$issues_file" "CASCADE_LIST_INVALID gc bd list did not return a JSON array"
    return 0
  fi

  bead_count="$(jq 'length' <<<"$beads_json")"
  for ((index = 0; index < bead_count; index++)); do
    bead_json="$(jq -c ".[$index]" <<<"$beads_json")"
    bead_id="$(jq -r '.id // empty' <<<"$bead_json")"
    [[ -n "$bead_id" ]] || continue
    bead_has_label "$bead_json" "$ORDER_TRACKING_LABEL" && continue

    cascade_id="$(cascade_id_for "$bead_json" "$bead_id")"
    status="$(bead_status "$bead_json")"
    updated_at="$(bead_timestamp "$bead_json" "updated_at")"
    created_at="$(bead_timestamp "$bead_json" "created_at")"
    updated_age_minutes="$(age_minutes_since "$updated_at")"
    created_age_minutes="$(age_minutes_since "$created_at")"
    cascade_position="$(bead_metadata_value "$bead_json" "cascade_position")"
    cascade_next="$(bead_metadata_value "$bead_json" "cascade_next")"
    target_agent="$(bead_metadata_value "$bead_json" "gc.routed_to")"

    case "$status" in
      open | in_progress)
        if (( updated_age_minutes >= CASCADE_STUCK_MINUTES )); then
          append_health_issue "$issues_file" "STALE_CASCADE bead=$bead_id cascade=$cascade_id status=$status routed_to=$target_agent updated=${updated_age_minutes}m ago"
        fi
        if [[ "$cascade_position" == "1" ]] && (( created_age_minutes >= CASCADE_UNDISPATCHED_MINUTES )); then
          if ! bead_is_dispatched "$bead_id" "$bead_json"; then
            append_health_issue "$issues_file" "UNDISPATCHED_START bead=$bead_id cascade=$cascade_id routed_to=$target_agent created=${created_age_minutes}m ago"
          fi
        fi
        ;;
    esac

    if [[ -n "$cascade_next" ]]; then
      if ! next_bead_json="$(show_bead_object "$cascade_next")"; then
        append_health_issue "$issues_file" "MISSING_NEXT bead=$bead_id cascade=$cascade_id cascade_next=$cascade_next"
      elif ! bead_has_label "$next_bead_json" "$CASCADE_LABEL"; then
        append_health_issue "$issues_file" "NEXT_NOT_CASCADE bead=$bead_id cascade=$cascade_id cascade_next=$cascade_next"
      fi
    fi
  done
}

run_health_check() {
  local issues_file
  local temporary_directory

  temporary_directory="$CITY_DIR/.gc/tmp"
  mkdir -p -- "$temporary_directory"
  issues_file="$(mktemp "$temporary_directory/cascade-health.XXXXXX")"
  check_cascade_health "$issues_file"

  if [[ -s "$issues_file" ]]; then
    gc mail send mayor \
      -s "Cascade health: stuck cascades detected" \
      -m "$(cat "$issues_file")"
    log "health issues mailed to mayor"
    cat "$issues_file"
  else
    log "cascade health: all clear"
  fi
  rm -f -- "$issues_file"
}

main() {
  require_command gc
  require_command jq
  require_command date
  cd "$CITY_DIR"

  case "${1:-daemon}" in
    daemon | serve)
      run_daemon
      ;;
    once)
      process_event_batch
      ;;
    health)
      run_health_check
      ;;
    help | -h | --help)
      usage
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
}

main "$@"

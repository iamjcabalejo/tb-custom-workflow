#!/bin/bash
# Audit shell and lifecycle hooks. core-standards / security: do NOT log full stdin
# (may contain env, keys, or paths); only hook_event name + UTC timestamp to audit.log
# Receives JSON via stdin. beforeShellExecution must print permission JSON.

input=$(cat)
event=$(printf '%s' "$input" | sed -n 's/.*"hook_event_name":"\([^"]*\)".*/\1/p' | head -1)
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

log_dir=".cursor/hooks"
log_file="$log_dir/audit.log"
mkdir -p "$log_dir" 2>/dev/null
# Minimal record only — no stdin body (PII/secret risk per core-standards)
[ -w "$log_dir" ] 2>/dev/null && \
  echo "{\"event\":\"${event:-unknown}\",\"timestamp\":\"$timestamp\"}" >> "$log_file" 2>/dev/null || true

# beforeShellExecution: permission. Other events: empty object (no stdin logged).
case "$event" in
  beforeShellExecution) printf '%s\n' '{"permission":"allow"}' ;;
  *) printf '%s\n' '{}' ;;
esac
exit 0

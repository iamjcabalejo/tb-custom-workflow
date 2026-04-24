#!/bin/bash
# afterFileEdit: match python-backend / typescript / react-standards — format only.
# token-policy: minimal side effects; skip quietly if no formatter on PATH.
# Receives JSON stdin: {"file_path":"<path>",...}

input=$(cat)
file_path=$(printf '%s' "$input" | sed -n 's/.*"file_path":"\([^"]*\)".*/\1/p' | head -1)
[ -n "$file_path" ] && [ -f "$file_path" ] || exit 0

# Parent dirs up to / — find nearest package.json for npx/Prettier (monorepos).
find_nearest_package_json() {
  d=$(cd "$(dirname "$file_path")" 2>/dev/null && pwd) || return 1
  while [ -n "$d" ] && [ "$d" != "/" ]; do
    [ -f "$d/package.json" ] && { printf '%s' "$d"; return 0; }
    d=$(dirname "$d")
  done
  return 1
}

case "$file_path" in
  *.py)
    if command -v ruff &>/dev/null; then
      ruff format "$file_path" 2>/dev/null || true
    elif command -v black &>/dev/null; then
      black "$file_path" 2>/dev/null || true
    fi
    ;;
  *.ts|*.tsx|*.js|*.jsx|*.json|*.md|*.mdc)
    if command -v npx &>/dev/null; then
      pkg=$(find_nearest_package_json) || true
      if [ -n "$pkg" ]; then
        (cd "$pkg" && npx --yes prettier --write "$file_path" 2>/dev/null) || true
      elif [ -f "package.json" ]; then
        npx --yes prettier --write "$file_path" 2>/dev/null || true
      fi
    fi
    ;;
  *)
    ;;
esac

exit 0

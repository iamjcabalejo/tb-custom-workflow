#!/bin/bash
# Runs after agent edits a file. Format the edited file by type.
# Receives JSON via stdin: {"file_path":"<path>","edits":[...]}
# - .py: black (if available)
# - .ts, .tsx, .js, .json, .md: prettier (if package.json and npx available)

input=$(cat)
file_path=$(echo "$input" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)

if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
  exit 0
fi

case "$file_path" in
  *.py)
    if command -v black &>/dev/null; then
      black "$file_path" 2>/dev/null || true
    fi
    ;;
  *.ts|*.tsx|*.js|*.jsx|*.json|*.md)
    if command -v npx &>/dev/null && [ -f "package.json" ]; then
      npx prettier --write "$file_path" 2>/dev/null || true
    fi
    ;;
  *)
    ;;
esac

exit 0

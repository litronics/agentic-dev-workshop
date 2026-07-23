#!/bin/bash
# block-main-edits.sh — a PreToolUse hook.
#
# Blocks Edit/Write to src/ while the repo is on the `main` branch.
# This is CLAUDE.md "Regel 2" made HARD: CLAUDE.md *asks* the model not to edit
# main; this hook makes it impossible — a law, not a request.
#
# Contract (verified against code.claude.com/docs hooks.md):
#   - The tool call arrives as JSON on stdin.
#   - To BLOCK: exit 2 and print the reason to stderr (Claude sees it and stops).
#   - To ALLOW: exit 0.
# (Structured alternative: print {"hookSpecificOutput":{"hookEventName":
#  "PreToolUse","permissionDecision":"deny","permissionDecisionReason":"..."}}
#  on stdout and exit 0. We use exit-2-plus-stderr here for clarity.)

INPUT=$(cat)

# Which file is being edited? Edit/Write put it at tool_input.file_path.
FILE_PATH=$(printf '%s' "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0   # not a file edit → allow

REPO_ROOT="$(git -C "$(cd "$(dirname "$0")" && pwd)" rev-parse --show-toplevel 2>/dev/null)"
BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null)"

# Only guard files under src/ …
case "$FILE_PATH" in
  "$REPO_ROOT"/src/*) : ;;
  *) exit 0 ;;                   # anything outside src/ → allow
esac

# … and only when we are on main.
if [ "$BRANCH" = "main" ]; then
  {
    echo "BLOCKED: keine Edits an src/ auf 'main'. Erst einen Worktree anlegen:"
    echo "  git worktree add ../starter-<branch> -b <branch>"
    echo "  … dann dort editieren. (CLAUDE.md Regel 2 — per Hook erzwungen.)"
  } >&2
  exit 2
fi

exit 0

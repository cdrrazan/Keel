#!/usr/bin/env bash
# Enforces the edit gate's "the human authors every commit" rule (AGENTS.md).
#
# PreToolUse hook for the Bash tool. Claude Code sends the tool call as JSON on
# stdin; this script denies it when the command is a `git commit` or `git push`.
# Hook interface: https://code.claude.com/docs/en/hooks
set -euo pipefail

cmd="$(jq -r '.tool_input.command // empty')"

if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])git[[:space:]]+([^[:space:]]+[[:space:]]+)*(commit|push)([[:space:]]|$)'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Blocked by edit gate: the human authors every commit (AGENTS.md)."
    }
  }'
fi
exit 0

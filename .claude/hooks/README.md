# Enforcement hooks (optional)

`AGENTS.md` is **context, not enforcement** — an agent *usually* follows it, but compliance isn't
guaranteed. Anthropic's own docs say the same: to block an action regardless of what the model decides,
use a [PreToolUse hook](https://code.claude.com/docs/en/hooks) — a check that runs before a tool call
and can deny it.

**Adopt hooks last.** Start with the gates as written rules; add enforcement once the team trusts the
discipline and wants it guaranteed rather than requested.

## Shipped example: enforce "the human authors every commit"

The edit gate says agents never commit or push. This directory ships a working enforcement of that rule:

- [`block-agent-commits.sh`](block-agent-commits.sh) — the hook script. It receives the tool call as
  JSON on stdin and, when the command is a `git commit` or `git push`, denies it using the
  `hookSpecificOutput` / `permissionDecision` output format the
  [current hook docs](https://code.claude.com/docs/en/hooks) recommend:

  ```json
  {
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": "Blocked by edit gate: the human authors every commit (AGENTS.md)."
    }
  }
  ```

- [`settings.example.json`](settings.example.json) — the registration. Merge it into your repo's
  `.claude/settings.json` to wire the script to every `Bash` tool call:

  ```json
  {
    "hooks": {
      "PreToolUse": [
        {
          "matcher": "Bash",
          "hooks": [
            { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-agent-commits.sh" }
          ]
        }
      ]
    }
  }
  ```

Copy both files into your repo, keep the script executable (`chmod +x`), and the gate is no longer a
request — it's a rule the tooling enforces.

> Keel deliberately does **not** ship an active `.claude/settings.json` in this repo — the hook is an
> example for *your* repo, opted into explicitly, not something that silently activates on clone.

Two notes on the mechanics:

- **Simpler alternative:** a hook can also block by printing a reason to stderr and exiting with code
  `2` (only `2` blocks — exit `1` lets the call proceed). The JSON output above is the recommended
  richer interface: it distinguishes `deny` / `ask` / `allow`, and the reason is shown to the model.
- Other gates can be enforced the same way (e.g. block `Edit`/`Write` outside a task's named files).
  Check syntax against the [current docs](https://code.claude.com/docs/en/hooks) before relying on it —
  the interface evolves.

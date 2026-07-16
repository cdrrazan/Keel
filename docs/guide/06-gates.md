# 6. The gates

Three behavioral rules that keep agents from the two worst habits: guessing when confused, and editing
when asked to diagnose. They live at the top of [`AGENTS.md`](../../AGENTS.md).

## The ambiguity gate

> Confused or ambiguous? **Stop and ask.** If running unattended, state the ambiguity and which assumption
> you chose — silent resolution of confusion is never acceptable.

The failure this prevents: an agent hits an unclear requirement, quietly picks an interpretation, and
builds a mile of code on a wrong guess. The gate makes confusion *visible* instead of silent.

## The edit gate

> Questions and problem reports get **diagnosis only** — report findings, change nothing — until I say
> *fix* or *implement*. **Never commit or push.** The human authors every commit.

The failure this prevents: you ask "why is this slow?" and the agent, eager to help, rewrites the function
before you've even decided the diagnosis is right. Diagnosis and action are separate phases. This mirrors
Anthropic's recommended **Explore → Plan → Implement → Commit** workflow, where a planning phase is kept
separate from execution.

## The evidence rule

> A claim about the code that doesn't trace to a **fresh read** is labelled `unverified`. No silent
> failures. For any pass/fail claim, show the **raw output** — the command and what it returned.

The failure this prevents: "the tests pass" when they were never run; "this handles nulls" when nobody
read the code that supposedly does. Anthropic's docs make the same point — agents should *show* evidence
(the command run and its return, a screenshot) rather than assert success.

## From advice to enforcement: hooks

Here's the catch every honest guide has to state: **`AGENTS.md` and `CLAUDE.md` are context, not
enforcement.** They're loaded as instructions the agent *usually* follows — compliance is not guaranteed.
An agent can ignore a line in a Markdown file.

To make a gate a **hard** constraint, you need a **[PreToolUse hook](https://code.claude.com/docs/en/hooks)**
— code that runs before a tool call and can *block* it. Keel ships an optional example in
[`.claude/hooks/`](../../.claude/hooks/) that blocks commits by an agent, enforcing the edit gate's "the
human authors every commit" rule for real.

**Adopt hooks last.** Start with the gates as written rules; add enforcement once the team trusts the
discipline and wants it guaranteed rather than requested. Enforcement you add before there's trust just
feels like the tool fighting you.

→ Next: [Applied-AI addendum](07-applied-ai.md)

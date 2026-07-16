# Decisions Ledger

Every deliberate choice gets **one home, a date, and a "revisit if."** This is where the *why* lives so
that six months and ten thousand agent-edits from now, anyone can see what was chosen and under what
condition to reconsider it.

**Format** (lightweight by default; the bracketed fields are borrowed from
[ADR/MADR](https://adr.github.io/madr/) — use them when a decision is weighty enough to warrant it):

```
## YYYY-MM-DD — <Decision title>
Status: accepted            # proposed | accepted | superseded by <date/title> | deprecated
Because: <the deciding reason>
Rejected <alternative> because: <why>
Consequences: <what this now commits us to — the trade-off we accepted>
Revisit if: <the condition that would reopen this>
```

Keep entries **imperative and specific** — "We use Postgres", not "We should probably use Postgres." Once
a decision is accepted, don't rewrite it; add a **new** entry that supersedes it and mark the old one
`Status: superseded`. The ledger is append-only history, not a live document.

**Proposed vs. ratified.** An entry an agent drafts starts `Status: proposed` — a claim, not a record.
The **commit ratifies it** (the human authors every commit), promoting it to `accepted`. If a reviewer
keeps the code but rejects the reasoning, the author supersedes the proposed entry rather than letting a
rejected "why" stand. Full rationale in the guide:
[Who owns an entry](guide/04-ledgers.md#who-owns-an-entry-proposed-vs-ratified).

---

<!--
The entries below are THIS repo's real decisions — Keel eats its own dog food (see CONTRIBUTING.md).
When you copy this file into your own project, delete them and start empty. Fill forward; never backfill.
-->

## 2026-07-15 — AGENTS.md canonical, CLAUDE.md as an import stub
Status: accepted
Because: AGENTS.md is the open, tool-neutral standard adopted across Codex, Cursor, Amp, and others; one canonical file avoids maintaining two divergent copies.
Rejected duplicating content into CLAUDE.md because: Two copies drift; the stub's `@AGENTS.md` import gives Claude Code the same rules for free.
Consequences: Claude-specific notes must stay small and live below the import in the stub.
Revisit if: Claude Code gains native AGENTS.md support (tracked in anthropics/claude-code#6235), making the stub unnecessary.

## 2026-07-15 — One flat decisions.md over numbered ADR files
Status: accepted
Because: Keel optimizes for the smallest thing a solo dev or small team will actually maintain; one file with dated entries has near-zero ceremony.
Rejected docs/decisions/NNNN-*.md (MADR-style) because: Numbering, cross-file supersede links, and tooling are weight most adopters won't carry — and the format above borrows MADR's useful fields (Status, Consequences) anyway.
Consequences: Very decision-heavy teams may outgrow the flat file; the guide (ch. 4) documents graduating to numbered ADRs when that hurts.
Revisit if: Entries regularly exceed ~50 and searching/superseding in one file becomes the friction.

## 2026-07-15 — Web guide ships as one self-contained HTML file
Status: accepted
Because: docs/site/index.html with zero external dependencies (no fonts, scripts, or images fetched) deploys anywhere — GitHub Pages, any static host, or opened from disk.
Rejected a static-site generator because: A build step, a theme, and a dependency tree are permanent maintenance for a single page.
Consequences: Styling is hand-maintained in one <style> block; contributors edit HTML directly.
Revisit if: The guide grows past one page or needs search/navigation a single document can't carry.

## 2026-07-16 — Ledger entries are proposed until ratified by the commit
Status: accepted
Because: In agent-heavy repos a stale "why" is more dangerous than stale code, so entries need a single ratification point and an explicit supersede path — a rejected rationale must never stay authoritative. Raised in issue #1.
Rejected letting the next agent infer staleness from the diff + review comments because: Inference about intent violates the evidence rule, and review threads live outside the committed ledger — the source of truth would leak into ephemeral PR discussion.
Consequences: Agent-drafted entries start Status: proposed; the committing party owns the authoritative entry; partial-accept supersedes explicitly. Documented in guide ch. 4.
Revisit if: A future workflow makes review threads first-class committed artifacts that agents can treat as authoritative.

# AGENTS.md — instructions for AI coding agents

Canonical, tool-neutral instructions for the `linkli` service. Claude Code reads `CLAUDE.md`, which
imports this file. Keep it under ~200 lines.

## The gates (read before doing anything)

**Ambiguity gate.** Confused or ambiguous? **Stop and ask.** If running unattended, state the ambiguity
and which assumption you chose — never resolve confusion silently.

**Edit gate.** Questions and problem reports get **diagnosis only** until I say *fix* or *implement*.
**Never commit or push.** I author every commit.

**Evidence rule.** A claim about the code that doesn't trace to a **fresh read** is `unverified`. For any
pass/fail claim, show the command you ran and its raw output.

## Project map

- **What this is:** `linkli` — a URL shortener. `POST /links` returns a short code; `GET /{slug}` 302s to
  the original URL and records a hit.
- **Stack:** Python 3.11, FastAPI, SQLAlchemy 2.x, Postgres 15, uv for deps.
- **How to run it:** `uv run uvicorn linkli.main:app --reload`
- **How to run tests:** `uv run pytest -q` — a claim that tests pass must include this command's output.
- **How to lint/format:** `uv run ruff check . && uv run ruff format .`
- **Domain terms:** *slug* = the short code in the URL path; *hit* = one recorded redirect; *link* = a
  stored (slug → target URL) row.
- **Landmines:** `linkli/migrations/` is Alembic-generated — never hand-edit; regenerate. `slug`
  generation is collision-sensitive (see `docs/decisions.md`) — don't change the scheme without a new
  decision.

## Working rules

- **One canonical value per concept; one choke point per dependency.** All DB access goes through
  `linkli/db.py`; all config through `linkli/settings.py`. Don't scatter engine or settings creation.
- **Deterministic core.** Slug generation, hit counting, and validation are pure functions with tests.
- **Stay in scope.** Touch only the files named in the task. Raise unrelated issues separately.

## The ledgers

- **`docs/decisions.md`** — every deliberate choice, dated, with a "revisit if." Check it before proposing
  an approach. Agent-drafted entries start `Status: proposed`; the commit ratifies them.
- **`docs/falsified.md`** — every killed idea, with the mechanism and the numbers. A tweak of a dead idea
  is the same idea — check here first.

## Reporting format

Verdict first, then metrics against a named baseline, then caveats, then recommendation last.

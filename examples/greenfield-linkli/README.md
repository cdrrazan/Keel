# Example: greenfield — `linkli`, a URL-shortener API

A new project that adopted Keel on day one. `linkli` is a small FastAPI + Postgres service that turns long
URLs into short codes and redirects them. Nothing here is special about URL shorteners — it's just a
concrete place to watch the kernel fill up.

Read the files alongside this story:

- [`AGENTS.md`](AGENTS.md) — the project map, filled in.
- [`docs/decisions.md`](docs/decisions.md) — three weeks of choices.
- [`docs/falsified.md`](docs/falsified.md) — two ideas that were killed.

## The story

**Day one.** The repo started as the four-file kernel. The team filled the *project map* in `AGENTS.md`
(stack, how to run tests, domain terms like *slug* and *hit*), added a lockfile, a linter, and one passing
test — the code-first track. Both ledgers started empty.

**The short-code decision — proposed, reviewed, superseded.** This is the interesting one, and it's the
[proposed-vs-ratified](../../docs/guide/04-ledgers.md#who-owns-an-entry-proposed-vs-ratified) boundary in
the wild:

1. An agent implemented short-code generation with **random 6-character codes** and drafted a
   `decisions.md` entry for it — `Status: proposed`.
2. The **reviewer** (blind to the agent's reasoning) kept the endpoint and the response shape but rejected
   the *approach*: at the scale in the spec, random codes collide often enough to need a retry loop, and
   nobody had measured it. Verdict: `fix-first`.
3. At commit, the human authored the **authoritative** entry — Base62-encode a Postgres sequence, which is
   collision-free — and marked the random-codes entry `Status: superseded`. The rejected rationale did
   **not** sit around waiting for the next agent to guess it was stale.
4. Because an *idea was disproven* (not just a decision changed), the random-codes approach also earned a
   row in `falsified.md`, with the collision math. Now no future agent re-proposes it.

**Grow when it hurts.** Redis caching for redirects looked obvious, so someone tried it — 6% hit rate,
killed, logged. The `roles/` prompts and `evals/` folder still don't exist here: nothing has hurt enough
to add them yet.

The takeaway: three weeks in, anyone (human or agent) can open two files and see exactly what was chosen,
what was ruled out, and why — including the *why-not* that would otherwise have been lost in a merged PR.

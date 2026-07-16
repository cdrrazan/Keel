# 2. The 15 principles

The whole philosophy, one line each. Everything else in Keel is an implementation of one of these.

1. **Instructions live in tiers** — global rules, a project map, subsystem extras. → [ch. 3](03-kernel.md), [ch. 8](08-adoption.md)
2. **Confused → stop and ask. Problem report → diagnose, don't edit.** → [ch. 6](06-gates.md)
3. **Code answers _how_; docs answer _why_.** → [ch. 4](04-ledgers.md)
4. **Keep a ledger of killed ideas. A tweak of a dead idea is the same idea.** → [`falsified.md`](../falsified.md)
5. **Decisions get one home, a date, and a "revisit if."** → [`decisions.md`](../decisions.md)
6. **Report verdict first, metrics vs a named baseline, caveats, recommendation last.** → [AGENTS.md](../../AGENTS.md)
7. **Measure what the system actually acts on, not the population.** → [ch. 7](07-applied-ai.md)
8. **Implementer, reviewer, and auditor are different agents.** → [ch. 5](05-roles.md)
9. **A claim about code that doesn't trace to a fresh read is labeled "unverified."** → [ch. 6](06-gates.md)
10. **Memory belongs to the tool; ledgers belong to you.** → [ch. 4](04-ledgers.md)
11. **One canonical value per concept; one choke point per external dependency.** → [AGENTS.md](../../AGENTS.md)
12. **No silent failures, and raw output for any pass/fail claim.** → [ch. 6](06-gates.md)
13. **Deterministic core; the LLM narrates at the boundary, never computes alone.** → [ch. 7](07-applied-ai.md)
14. **Evals are the durable asset; prompts and models are consumables.** → [ch. 7](07-applied-ai.md)
15. **Start small — instruction file, working rules, the two ledgers — and grow when it hurts.** → [ch. 3](03-kernel.md)

## The five moves they collapse into

If fifteen is too many to hold in your head, they reduce to five:

- **Ledgers, not memory** (4, 5, 10) — the agent's memory is disposable; the committed ledgers are real.
- **Separate the roles** (8) — writer, reviewer, and auditor are different agents so none grades its own work.
- **Gates on behavior** (2, 6, 9, 11, 12) — stop on ambiguity, diagnose before editing, show evidence.
- **Deterministic core** (7, 13, 14) — logic is testable; the LLM only narrates at the edge; evals endure.
- **Grow when it hurts** (1, 3, 15) — start with the kernel, add structure only when its absence bites.

→ Next: [The minimal kernel](03-kernel.md)

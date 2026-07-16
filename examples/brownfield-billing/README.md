# Example: brownfield — Keel retrofitted onto a legacy billing service

An existing, five-year-old Django billing monolith that started letting AI agents make changes — and
started to feel the rot. `billing` is the kind of repo Keel is really aimed at: lots of history, real
landmines, and no appetite for a rewrite.

Read the files alongside this story:

- [`AGENTS.md`](AGENTS.md) — the project map, honest about the landmines.
- [`docs/decisions.md`](docs/decisions.md) — decisions from the day Keel was adopted, **forward only**.
- [`docs/falsified.md`](docs/falsified.md) — expensive ideas, killed with evidence.

## The story

**No rewrite, no backfill.** Adopting Keel here meant dropping in `AGENTS.md` + a `CLAUDE.md` stub and
starting both ledgers **empty**. The team explicitly did *not* try to reconstruct five years of past
decisions — that archaeology never ends. The ledgers earn their value going *forward*, from the next
decision and the next killed idea.

**The project map is mostly landmines.** The highest-value thing in `AGENTS.md` for this repo is the
landmines list: the Stripe webhook handler whose signature verification looks removable but isn't, the
`invoice_pdf` module that external partners depend on byte-for-byte, and the generated migrations. Agents
kept "helpfully" touching these; naming them stopped it.

**Roles arrived one at a time.** They didn't adopt all three roles at once (that's principle 15). First
the **reviewer**, scoped to the payment path only — the blast radius that mattered. Once `falsified.md`
had a few entries, the **auditor** started earning its keep by catching re-proposals of already-killed
migrations before any code was written.

**Killing expensive ideas is the payoff.** Twice, an agent proposed a big migration (UUID primary keys;
swapping Celery for RQ). Both were plausible. Both were killed after a short spike, *with the numbers*, and
logged. The value isn't the first rejection — it's that the third time someone suggests UUID PKs, the
auditor points at the ledger row instead of re-running the three-day spike.

The takeaway: Keel didn't touch the legacy code. It changed what the agents were *allowed to assert* about
it, and gave the team a memory the codebase never had.

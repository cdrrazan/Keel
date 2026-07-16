# 4. The two ledgers

This is the core of Keel — and `falsified.md` is the part **no other framework has**. spec-kit, Kiro,
ADR, MADR all record what you *decided*. None records what you *killed*. That's the exact memory an agent
lacks, so it's the highest-leverage file here.

> Principle 10: **memory belongs to the tool; ledgers belong to you.** An agent's context window forgets.
> A committed file does not. Put the things you can't afford to re-derive in the ledgers.

## `falsified.md` — the killed-ideas ledger

Every idea you tried and ruled out, with the **mechanism** of failure and the **numbers.**

```
| Idea | Verdict | Why (mechanism + numbers) | Date |
```

**Why numbers matter.** "It was slow" invites someone to try it again hoping it's faster now. "p99 was
2.3s vs a 400ms budget because each call re-tokenizes the whole prompt" tells the next person *exactly*
what would have to change to reopen it.

**The rule that makes it work:** *a tweak of a dead idea is the same idea.* The reason agents re-run dead
experiments is that a small variation *feels* new. It isn't. To resurrect a killed idea you must bring new
evidence that addresses the recorded mechanism — not a fresh coat of paint.

**Keep killed entries forever.** The value is that the ledger never forgets. Don't prune it.

See the live file: [`docs/falsified.md`](../falsified.md).

## `decisions.md` — the choices ledger

Every deliberate choice gets **one home, a date, and a "revisit if."**

```
## YYYY-MM-DD — <Decision title>
Status: accepted
Because: <deciding reason>
Rejected <alternative> because: <why>
Consequences: <the trade-off we accepted>
Revisit if: <the condition that reopens this>
```

The bracketed `Status`, `Consequences`, and the append-only/superseding discipline are borrowed from
**[ADR/MADR](https://adr.github.io/madr/)** — a 15-year-old practice for exactly this. Two rules worth
stealing from them:

- **Write imperatively.** "We use Postgres," not "We should probably use Postgres." Avoid hedging.
- **Append, don't edit.** Once a decision is accepted, don't rewrite it. Add a *new* entry that supersedes
  it and mark the old one `Status: superseded`. The ledger is history, not a live doc.

If a decision is weighty enough (a real architectural fork), consider graduating to a full
numbered ADR file under `docs/decisions/NNNN-*.md` — but for most teams the single `decisions.md` is
enough. Start light; grow when it hurts.

See the live file: [`docs/decisions.md`](../decisions.md).

## Who owns an entry: proposed vs. ratified

A ledger entry has two lives. When an agent drafts one alongside a change, it is **`Status: proposed`** —
a *claim*, not a record. By the evidence rule, an unverified claim carries no authority. What ratifies it
is the **commit**: because the human authors every commit (the edit gate), whoever lands the change owns
the authoritative entry.

This matters most when a reviewer keeps some of the code but **rejects the reasoning**. Two things you
must *not* do: leave the rejected "why" sitting as authoritative, or make the next agent *infer* from the
diff and the review comments that it is stale. Inference about intent is exactly what the evidence rule
forbids, and review threads are not the source of truth — they are ephemeral and live outside the
committed ledger. Instead, at commit the author writes the entry that reflects what actually landed and
marks the old one `Status: superseded` with a one-line reason. The ledger is append-only, so the dead
rationale stays in history while the authoritative pointer moves forward. **A rejected "why" is
superseded explicitly — never inferred.**

A rejected rationale has two possible destinations, one per ledger:

- the **decision** changed ("we now do X instead") → supersede the entry in `decisions.md`;
- an **idea was disproven** ("approach Y does not work, because *mechanism + numbers*") → a new row in
  `falsified.md`, so no agent retries it.

If you relax the human-in-the-loop assumption and let agents commit, the ratifier shifts from the human
to the **reviewer role**: a `fix-first` verdict produces the superseding entry as its output, and the
auditor's step-0 dead-list check then reads the current authoritative entry, never a superseded draft.

> **Why this is the hard part.** In a long-lived, agent-heavy repo a stale *why* is more dangerous than
> stale code — code is falsifiable, but an orphaned rationale simply misleads. Keel's answer is to make
> staleness impossible to be *silent*: supersession is a dated, written event tied to the commit, not
> something a future reader has to reconstruct.

## The `docs/ai` vs. `docs/plans` split

Two more folders that appear as you grow (not kernel):

- **`docs/ai/`** — durable *why* reasoning. Committed, permanent. The narrative behind decisions that
  doesn't fit in a one-line ledger entry.
- **`docs/plans/`** — ephemeral implementation notes. **Deleted once the work graduates.** A scratchpad,
  not a record.

Principle 3: **code answers _how_; docs answer _why_.** Don't document *how* the code works — the code
already does that, and prose drifts out of sync. Document *why* it works that way.

→ Next: [The three roles](05-roles.md)

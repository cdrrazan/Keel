# Decisions Ledger — billing

Started the day we adopted Keel. **Forward only — we did not backfill five years of history.** Every
deliberate choice from here on: one home, a date, a "revisit if." See the
[format guide](../../../docs/guide/04-ledgers.md).

---

## 2026-03-05 — Adopt Keel on the billing service
Status: accepted
Because: Agent-made changes were re-litigating settled questions and touching load-bearing modules; we need committed memory and a review gate, without a rewrite.
Rejected a full test-coverage push first because: It doesn't address the memory problem — agents would still re-propose dead ideas. Keel is additive and ships today.
Consequences: `AGENTS.md` + ledgers added; no application code changed. Ledgers start empty and fill forward.
Revisit if: The team shrinks to one person who holds all context in their head (unlikely) — then the ceremony may outweigh the benefit.

## 2026-03-12 — Introduce the reviewer role on the payment path only
Status: accepted
Because: The payment path is the highest blast-radius code; scoping the blind adversarial reviewer there first gives the most safety per unit of process.
Rejected all-three-roles-at-once because: Principle 15 — grow when it hurts. Unproven process across the whole repo would just be friction.
Consequences: PRs touching `billing/stripe/**` or `billing/money.py` require a reviewer verdict (ship / fix-first / can't-verify). The rest of the repo is unchanged for now.
Revisit if: Non-payment areas start accumulating agent-caused regressions too.

## 2026-03-20 — Freeze `invoice_pdf`; wrap, never edit
Status: accepted
Because: External partners parse these PDFs byte-for-byte, so the layout is a public contract. Changes must go through a versioned wrapper, not in-place edits.
Rejected "just be careful" because: Careful isn't enforceable; an agent will eventually treat a layout tweak as cosmetic. A frozen module + a landmine note is enforceable.
Consequences: New invoice formats ship as `invoice_pdf/v2/` behind a feature flag; `v1` is immutable.
Revisit if: All partners migrate off v1 and confirm nothing parses it.

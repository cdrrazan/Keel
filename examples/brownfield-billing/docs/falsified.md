# Falsified Ideas Ledger — billing

Ideas we tried and killed, with the **mechanism** and the **numbers**. A tweak of a dead idea is the same
idea. In a repo this old these entries save days: the auditor cites the row instead of re-running the spike.

| Idea | Verdict | Why (mechanism + numbers) | Date |
|------|---------|---------------------------|------|
| Migrate `invoice` PKs from bigint to UUID | killed | 3-day spike: 40M rows, FK rewrites across 12 tables, ~6h estimated write-lock downtime, and every external integration keys on the integer id — large risk, no product benefit | 2026-03-18 |
| Replace Celery with RQ to cut ops surface | killed | RQ has no native scheduled/retry semantics we rely on for dunning; a POC reimplemented 3 of them and still lacked visibility parity — net more code, not less | 2026-03-27 |
| Retry failed Stripe charges 5× with backoff | killed | Failures are dominated by hard declines (insufficient funds / lost card), not transient errors: sampled 2 weeks, 0% of hard declines recovered on retry — retries just delayed the dunning email | 2026-04-02 |

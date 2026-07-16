# Falsified Ideas Ledger — linkli

Ideas we tried and killed, with the **mechanism** and the **numbers**. A tweak of a dead idea is the same
idea — bring new evidence that addresses the mechanism, or don't bring it back.

| Idea | Verdict | Why (mechanism + numbers) | Date |
|------|---------|---------------------------|------|
| Random 6-character short codes | killed | At 10M links the birthday bound gives ~1.2% collision per insert → a uniqueness-check + retry loop on the write path; Base62-over-a-sequence is collision-free for the same slug length | 2026-02-10 |
| Cache redirects in Redis | killed | Measured 6% hit rate over a week — the long tail of links is near-uniformly cold; added a network hop and a cache-invalidation path for ~no latency win | 2026-02-14 |

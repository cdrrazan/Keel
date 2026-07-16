# Decisions Ledger — linkli

Every deliberate choice: one home, a date, and a "revisit if." Agent-drafted entries start
`Status: proposed`; the commit ratifies them. See the
[format guide](../../../docs/guide/04-ledgers.md).

---

## 2026-02-03 — FastAPI + Postgres for the service
Status: accepted
Because: We want async request handling, automatic OpenAPI docs, and a relational store for (slug → URL) with a unique constraint on slug.
Rejected Flask + SQLite because: SQLite's write concurrency won't hold up once redirects scale, and we'd bolt on schema tooling anyway.
Consequences: Commits us to async SQLAlchemy and Python 3.11+; local dev needs a Postgres container.
Revisit if: The service stays single-writer and read-tiny for good, making Postgres overkill.

## 2026-02-10 — Random 6-character short codes
Status: superseded by 2026-02-10 — Base62-encode a Postgres sequence
Because: Simple to implement; 62^6 ≈ 56.8B keyspace felt "big enough."
Rejected sequential IDs because: We didn't want guessable/enumerable slugs.
Consequences: Needs a uniqueness check and a retry loop on collision.
Revisit if: n/a — superseded (see below and docs/falsified.md).

## 2026-02-10 — Base62-encode a Postgres sequence for short codes
Status: accepted
Because: A dedicated Postgres sequence yields a unique integer per link; Base62-encoding it gives a short, non-sequential-looking slug with **zero collisions** and no retry loop. Supersedes the random-codes entry above after review kept the endpoint but rejected the random approach.
Rejected random 6-char codes because: At 10M links the birthday bound gives ~1.2% collision per insert — a retry loop and wasted round-trips for no benefit (recorded in docs/falsified.md).
Consequences: Slugs are monotonic in insertion order (mitigated by Base62 + a fixed offset); the sequence is a single point that must be preserved in backups.
Revisit if: We need slugs that reveal nothing about insertion order or volume.

## 2026-02-18 — Rate-limit redirects at the edge, not in the app
Status: accepted
Because: Redirects are the hot path; enforcing limits in FastAPI adds latency to every hit. The CDN already sees all traffic.
Rejected in-app rate limiting because: It couples the hot path to a limiter and a shared counter store.
Consequences: Limits live in edge config, outside this repo — documented here so it isn't a mystery.
Revisit if: We move off the CDN, or need per-API-key limits the edge can't express.

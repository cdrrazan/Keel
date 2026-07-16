# 3. The minimal kernel

The smallest thing that counts as "set up." Resist adding more until the kernel's absence causes real
friction — that's principle 15, *grow when it hurts.*

## The four files

```
your-repo/
├── AGENTS.md          # the rules + the project map
├── CLAUDE.md          # a stub that imports AGENTS.md
└── docs/
    ├── decisions.md   # choices made
    └── falsified.md   # ideas killed
```

That's it. Version control you already have. A README you probably have. Everything else in Keel —
roles, hooks, evals, the `docs/ai` and `docs/plans` split — is **growth**, not kernel. Don't add it on
day one.

## Two tracks: code-first vs. docs-first

**Code-first projects** (there's already code, or there will be immediately) add three things to the
kernel *right away*:
- a **lockfile-pinned environment** (uv.lock, package-lock.json, poetry.lock…),
- **linting/formatting** wired up,
- **one passing test.** Just one — so the evidence rule has something to point at from the start.

**Docs-first projects** (research, specs, a design phase before any code) **defer** all three. There's
nothing to lint or test yet. Add them the moment real code arrives, not before.

## Greenfield vs. brownfield

The kernel is identical whether the repo is brand-new or five years old. What differs is *how you fill the
ledgers*:

- **Greenfield:** the ledgers start empty and grow with the project. Natural.
- **Brownfield:** the ledgers **also** start empty — and you **fill them forward**, from your next decision
  and your next killed experiment. **Do not backfill** years of history; that's an archaeology project that
  never ends. The ledger earns its value going forward, not backward.

The whole kit is additive. Dropping it into an existing repo changes **no code** — you add four files and
start writing down what you decide and what you kill from that day on.

→ Next: [The two ledgers](04-ledgers.md)

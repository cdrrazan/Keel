# 8. Adoption & interop

Two walkthroughs, then how to run this alongside spec-kit or Kiro.

## Greenfield walkthrough

1. **Clone Keel** (or copy the four kernel files into your new repo).
2. **Strip to the kernel** — delete anything you're not using yet. `AGENTS.md`, `CLAUDE.md`,
   `docs/decisions.md`, `docs/falsified.md`. That's the starting line.
3. **Fill the project map** in `AGENTS.md`: stack, domain terms, how to run tests, the landmines.
4. **Pick your track:** code-first? add a lockfile, linting, and one passing test now. Docs-first? defer them.
5. **Start both ledgers empty.**
6. **Grow when it hurts:**
   - First time an agent re-runs a dead idea → you needed `falsified.md`. Start using it.
   - First non-trivial change you don't fully trust → bring in the [reviewer](../../roles/reviewer.md).
   - First time an agent commits something you didn't author → add the enforcement [hook](../../.claude/hooks/).

## Brownfield walkthrough (existing repo)

1. **Drop in `AGENTS.md` + the `CLAUDE.md` stub.** Change **no code.**
2. **Fill the project map** from what's already there. Be honest about the landmines — the generated files,
   the external contracts, the code that looks editable but isn't.
3. **Start `decisions.md` and `falsified.md` empty. Fill forward.** Do not backfill history. The first
   real decision you make and the first experiment you kill are entry #1.
4. **Introduce the reviewer on your next PR.** One role, one PR. See how it feels.
5. **Add the auditor** once `falsified.md` has a few entries — that's when re-runs become a real risk.
6. **Adopt hooks last**, once the team trusts the written rules and wants them guaranteed.

No migration, no rewrite, no big bang. If step 4 doesn't help, you've lost nothing but four files.

## Running alongside spec-kit or Kiro

Keel is a **reliability layer**, not a generation workflow — so it stacks *under* a spec-driven tool
rather than replacing it:

- Use **[spec-kit](https://github.com/github/spec-kit)** or **[Kiro](https://kiro.dev)** to go from intent
  to code (their `specify → plan → tasks → implement` pipeline, their spec files).
- Use **Keel** to keep the result honest over time: the ledgers remember what you tried and killed
  across features; the reviewer/auditor roles vet the generated changes; the gates and evidence rule stop
  confident-but-wrong claims.

Concretely: let spec-kit own `.specify/` and its per-feature spec files; let Keel own `AGENTS.md`,
`docs/decisions.md`, and `docs/falsified.md`. They don't collide. A spec-kit `constitution.md` and this
kit's `decisions.md` are complementary — the constitution states principles up front; `decisions.md`
records the choices you make as you go, and `falsified.md` records what you ruled out. Nothing else offers
that last one.

## Interop: AGENTS.md and CLAUDE.md

- **`AGENTS.md` is canonical** — it's an [open, tool-neutral standard](https://agents.md/) adopted across
  Codex, Cursor, Amp, and more. Put your real instructions there.
- **`CLAUDE.md` is a stub** that imports it via `@AGENTS.md`. Claude Code reads `CLAUDE.md`, not
  `AGENTS.md`, so the stub is how you avoid maintaining two copies. This isn't a workaround anymore —
  it's the interop pattern [Anthropic's own memory docs](https://code.claude.com/docs/en/memory)
  recommend (a symlink also works if you have no Claude-specific notes to add below the import).
- **Keep it short.** Official guidance: under ~200 lines, or agents start ignoring the tail. Add a rule
  only when you'd otherwise have to re-explain it.

← Back to [the guide index](../../README.md#read-the-guide)

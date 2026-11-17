# Changelog

All notable changes to Keel are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and Keel aims to follow
[Semantic Versioning](https://semver.org/spec/v2.0.0.html) — for a docs kit, that means:

- **major** — a breaking change to file names, ledger formats, or role contracts adopters depend on;
- **minor** — a new rule, chapter, template, or file;
- **patch** — corrections, wording, and fixes that change nothing structural.

## [Unreleased]

### Added
- **The enforcement hook is now actually shipped:** `.claude/hooks/block-agent-commits.sh` (denies
  agent `git commit`/`git push` via the `hookSpecificOutput`/`permissionDecision` interface current
  Claude Code hook docs recommend) plus `settings.example.json` to register it. Previously the hook
  was only described in prose. CI now proves the hook's behavior on every push
  (`.github/scripts/test_hook.sh`) — the evidence rule, applied to Keel's own claims.
- **`templates/AGENTS.md`** — the blank starter template. Keel's root `AGENTS.md` is now filled in
  for this repo itself (dogfooding); README and adoption guide point adopters at the template.
- **Worked examples** under `examples/` — a greenfield (`linkli`) and a brownfield (`billing`) scenario
  with filled-in `AGENTS.md` and ledgers, so the model is easy to grasp from real content.
- **ELI5 explainer** — a "five-year-old version" of the pitch (robots, LEGO, two notebooks) in the
  README, guide chapter 1, and the web guide.
- **Ledger chapter:** a "Who owns an entry: proposed vs. ratified" section codifying that agent-drafted
  entries are proposed claims ratified at commit, and that a rejected rationale is superseded explicitly.

### Changed
- **Refreshed external references** (verified 2026-11-17): Claude Code v2.1.277+ now reads `AGENTS.md`
  natively, and anthropics/claude-code#6235 is closed. The `CLAUDE.md` stub stays in the kernel (now
  optional) — with a new landmine documented: once any `CLAUDE.md` exists, Claude reads *only*
  `CLAUDE.md` files, so the stub must import `@AGENTS.md`. Updated README, adoption chapter, web guide,
  and research analysis (also: spec-kit's `/speckit-*` command namespace; AGENTS.md repo traction).
  New decision entry (`proposed`) in `docs/decisions.md`. Hook interface re-checked: unchanged.
- Standardized the project name to **Keel** across the guide, README, web guide, and templates.
- **Refreshed Anthropic references** (verified 2026-07): the `CLAUDE.md` → `@AGENTS.md` import stub is
  now the interop pattern officially documented in Anthropic's memory docs, not just a community
  workaround — noted in the README, adoption chapter, research analysis, and web guide. Native
  AGENTS.md support (anthropics/claude-code#6235) remains open.

## [0.1.0] — 2026-07-15

First public release.

### Added
- **The minimal kernel:** `AGENTS.md` (gates + project map), the `CLAUDE.md` import stub, and the two
  ledgers — `docs/decisions.md` and `docs/falsified.md` — with ADR/MADR-informed formats.
- **The three role prompts:** `roles/coder.md`, `roles/reviewer.md` (with the over-flagging guard), and
  `roles/auditor.md` (dead-list check first).
- **The eight-chapter guide** under `docs/guide/`, plus a self-contained web version at
  `docs/site/index.html` (deployed to <https://keel.byaru.com>).
- **Templates** (`templates/`), an eval-harness scaffold (`evals/`), and an optional enforcement-hook
  example (`.claude/hooks/`).
- **The research analysis** comparing Keel to spec-kit, Kiro, AGENTS.md, and ADR practice
  (`docs/research/playbook-analysis.md`).
- **Project scaffolding:** CI (internal-link check + a 200-line budget on `AGENTS.md`), GitHub Pages
  auto-deploy, issue/PR templates, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and this changelog.

[Unreleased]: https://github.com/cdrrazan/Keel/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/cdrrazan/Keel/releases/tag/v0.1.0

# Contributing

Thanks for wanting to improve Keel. This repo is a *discipline*, not a codebase — so
contributions are mostly prose, templates, and evidence. A few rules keep it coherent.

## This repo eats its own dog food

Keel's rules apply to Keel itself:

- **Decisions about Keel are recorded in [`docs/decisions.md`](docs/decisions.md).** Before proposing
  a structural change (new file, new format, new rule), check whether it's already been decided — and if
  your proposal was previously tried and rejected, it belongs in [`docs/falsified.md`](docs/falsified.md)
  territory: bring *new evidence*, not a tweak.
- **Grow when it hurts.** New sections, files, and rules need a demonstrated friction they resolve —
  "this would be nice" is not a rationale. Keel's value is its smallness; every addition is fighting
  for space in a file agents actually read.
- **Evidence over opinion.** Claims like "agents behave better when X" carry most weight with something
  concrete behind them: a transcript, a before/after, a citation to primary docs.

## What contributions look like

- **Corrections** — broken links, factual drift (spec-kit/Kiro/Claude Code evolve fast; our references
  to them can go stale), typos, contradictions between chapters.
- **Proposals** — a new rule, template, or chapter. Open an issue *first* using the proposal template so
  the "does this survive the dead-list and decisions check?" conversation happens before you write it.
- **Experience reports** — you adopted Keel and something worked or failed. These are gold: they're
  the evidence future decisions cite. Open an issue; no code required.
- **Translations / adaptations** — welcome, in `docs/translations/<lang>/` mirroring the guide structure.

## Ground rules for prose

- Match the existing voice: direct, concrete, short sentences, no filler.
- `AGENTS.md` must stay **under ~200 lines** — that's a load-bearing constraint, not a style preference.
- Keep the guide chapters self-contained; each ends with a link to the next.
- Templates in `templates/` must stay copy-paste ready — commented guidance goes in HTML comments.

## Mechanics

1. Fork, branch from `main`, make your change.
2. Run the link check locally if you touched Markdown:
   `python3 .github/scripts/check_links.py`
3. Open a PR. The template asks which chapter/principle your change serves — fill it in.
4. CI must pass (internal link integrity). A maintainer reviews with Keel's own reviewer stance:
   verdict first (`ship` / `fix-first` / `can't-verify`).

## License

By contributing you agree your contribution is licensed under the [MIT License](LICENSE).

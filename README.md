<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/assets/banner-dark.svg">
  <img alt="Keel — The AI-Agent Playbook" src="docs/assets/banner-light.svg" width="100%">
</picture>

<br><br>

**Keep a codebase trustworthy after thousands of AI-agent edits.**
A small set of files and rules you drop into any repo — new or old.

[![License: MIT](https://img.shields.io/badge/License-MIT-1E6A48.svg)](LICENSE)
[![checks](https://github.com/cdrrazan/Keel/actions/workflows/checks.yml/badge.svg)](https://github.com/cdrrazan/Keel/actions/workflows/checks.yml)
[![Read the guide](https://img.shields.io/badge/read_the-guide-1E6A48.svg)](https://keel.byaru.com/)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-A63D2F.svg)](CONTRIBUTING.md)
[![AGENTS.md](https://img.shields.io/badge/standard-AGENTS.md-444.svg)](https://agents.md/)

[**Read the guide →**](https://keel.byaru.com/) · [Why](docs/guide/01-why.md) · [Principles](docs/guide/02-principles.md) · [Ledgers](docs/guide/04-ledgers.md) · [Roles](docs/guide/05-roles.md) · [Adoption](docs/guide/08-adoption.md)

</div>

---

## What is Keel?

AI coding agents are fast, but forgetful and overconfident. Over hundreds of changes they re-run dead
experiments, "helpfully" edit things you didn't ask about, and claim code works without reading it. That
quietly rots a codebase.

**Keel is the discipline that stops the rot.** It's the part of a ship that keeps it upright and on
course — and that's exactly its job here. It doesn't generate code and doesn't move the boat; it keeps
your codebase from capsizing under fast, autonomous edits.

It is **not a framework you install** and not a code generator. It's a *reliability layer*: it assumes
your code is the source of truth and governs how agents are allowed to make claims about it. It sits
happily *underneath* generation tools like [spec-kit](https://github.com/github/spec-kit) or
[Kiro](https://kiro.dev) — use those to produce code, use Keel to keep it honest.

```mermaid
flowchart LR
    A([intent]) -->|"spec-kit / Kiro<br/>generate code"| B["your codebase"]
    B --> C{Keel}
    C -->|ledgers| D["remembers what you<br/>tried and killed"]
    C -->|roles| E["reviews every<br/>agent change"]
    C -->|gates| F["stops confident<br/>wrong claims"]
    D --> B
    E --> B
    F --> B
    style C fill:#1E6A48,color:#fff,stroke:#14472f
    style B fill:#E3EDE6,stroke:#1E6A48,color:#1B231E
```

> Adapted and structured from the original *Project-Setup Playbook for AI-Agent-Assisted Projects*
> ([gist by subzekt](https://gist.github.com/subzekt/0dfced13befee2ff29f1a61bbbd7f072)). Keel turns that
> playbook into a usable, copy-pasteable kit. See [`docs/research/playbook-analysis.md`](docs/research/playbook-analysis.md)
> for how it compares to spec-kit, Kiro, AGENTS.md, and ADR practice.

<details>
<summary><strong>🧒 ELI5 — the five-year-old version</strong> (robots, LEGO, and two notebooks)</summary>
<br>

Imagine robot helpers building a LEGO castle with you. They build *really* fast, but they have three
bad habits: they **forget** (yesterday you all learned the drawbridge falls off if you use the thin
pieces — today a robot tries thin pieces again), they **do too much** (asked to fix a window, one
rebuilds two towers you liked just fine), and they **fib without meaning to** ("the castle is sturdy!"
— without ever wiggling it to check).

**Keel is the house rules taped to the wall**, and every robot reads them before touching anything:

- 📒 **Two notebooks.** One lists what we *decided* ("the moat goes on the left"). One lists what we
  *tried and it broke* — so nobody builds the thin drawbridge ever again.
- 👷 **Three jobs, three robots.** One builds. A different one checks the work — and doesn't get to
  hear the builder's excuses. A third checks the notebooks *before* anyone starts. Nobody grades
  their own homework.
- 🛑 **Simple rules.** Confused? Stop and ask. Asked a question? Answer it — don't grab bricks. Say
  "it's sturdy"? Show the wiggle test.
- 👤 **Only the human glues.** Robots suggest; you make it permanent.

Not a robot, not a castle — just the rules, the notebooks, and the job descriptions you copy into any
project so the robots stay fast **and** the castle stays standing.

</details>

## What you get

```
.
├── AGENTS.md              # canonical rules an agent reads before touching anything
├── CLAUDE.md              # stub that imports AGENTS.md (optional on Claude Code v2.1.277+)
├── docs/
│   ├── decisions.md       # ledger of choices made — dated, with "revisit if"
│   ├── falsified.md       # ledger of ideas KILLED — the piece nothing else has
│   ├── ai/                # durable "why" reasoning (committed)
│   ├── plans/             # ephemeral implementation notes (deleted after use)
│   └── guide/             # the full guidebook, chapter by chapter
├── roles/                 # ready-to-paste prompts: coder · reviewer · auditor
├── templates/             # blank AGENTS.md, ledger entries, decision record, spec stub
├── evals/                 # eval-harness scaffold (for LLM projects)
├── examples/              # filled-in greenfield + brownfield walkthroughs
└── .claude/hooks/         # OPTIONAL enforcement: shipped PreToolUse hook + settings example
```

## The five moves

Keel's whole philosophy collapses into five:

| Move | What it means |
|------|---------------|
| 📒 **Ledgers, not memory** | The agent's memory is disposable; two committed files — what you *decided* and what you *killed* — are real. |
| 👤 **Separate the roles** | Coder, reviewer, and auditor are different agents, so none grades its own work. |
| 🚧 **Gates on behavior** | Stop on ambiguity, diagnose before editing, and show evidence for every pass/fail claim. |
| ⚙️ **Deterministic core** | Logic is testable; the LLM only narrates at the edge; evals are the durable asset. |
| 🌱 **Grow when it hurts** | Start with the kernel; add structure only when its absence bites. |

## Quick start

<table>
<tr>
<th>🌱 New project (greenfield)</th>
<th>🏗️ Existing project (brownfield)</th>
</tr>
<tr>
<td valign="top">

1. Copy [`templates/AGENTS.md`](templates/AGENTS.md) (as `AGENTS.md`), `CLAUDE.md`, and the two ledgers into your repo.
2. Fill in the *project map* in `AGENTS.md` (stack, domain terms, how to run tests).
3. Start both ledgers **empty**. Add as you go — never backfill.
4. Add linting, a lockfile, and one passing test **now** if it's a code project.
5. Grow `docs/`, `roles/`, `evals/`, and hooks only when absence causes friction.

</td>
<td valign="top">

1. Drop in `AGENTS.md` + the `CLAUDE.md` stub. **Change no code.**
2. Start both ledgers empty; fill *forward* from your next decision.
3. Introduce the **reviewer** role on your next PR.
4. Add the **auditor** once `falsified.md` has entries.
5. Adopt enforcement hooks last, once the team trusts the rules.

</td>
</tr>
</table>

No big-bang migration. Everything here is additive. And the `CLAUDE.md` → `@AGENTS.md` stub isn't a
workaround: it's the interop pattern [Anthropic's own memory docs](https://code.claude.com/docs/en/memory)
recommend, so Claude Code and every AGENTS.md-native tool (Codex, Cursor, Amp, …) read the same rules.
Claude Code v2.1.277+ also reads `AGENTS.md` natively when no `CLAUDE.md` exists — but if you keep a
`CLAUDE.md`, it **must** import `@AGENTS.md`, because Claude then reads `CLAUDE.md` files only.

## See it filled in

Two worked examples in [`examples/`](examples/) show the ledgers, `AGENTS.md`, and roles carrying real
content — the fastest way to make the idea click:

- **[greenfield-linkli](examples/greenfield-linkli/)** — a new API adopting Keel from day one, including a
  decision that was **proposed, reviewed, and superseded** — the
  [proposed-vs-ratified](docs/guide/04-ledgers.md#who-owns-an-entry-proposed-vs-ratified) boundary in action.
- **[brownfield-billing](examples/brownfield-billing/)** — Keel retrofitted onto a legacy Django service:
  fill-*forward* (never backfill), a landmine-heavy project map, roles adopted one at a time.

## The three roles

A single model that checks its own work is an echo chamber. Keel splits the work so nothing grades
itself — a pattern echoed in [Anthropic's best-practices](https://code.claude.com/docs/en/best-practices)
and the documented [adversarial code review](https://asdlc.io/patterns/adversarial-code-review/) pattern.

```mermaid
flowchart TD
    I([an idea]) --> AU["🔍 Auditor<br/>dead-list check first,<br/>then: worth testing?"]
    AU -->|approved plan| CO["⌨️ Coder<br/>one scoped step,<br/>never commits"]
    CO -->|"diff only, no reasoning"| RE["⚖️ Reviewer<br/>blind and adversarial,<br/>tries to refute"]
    RE -->|"ship / fix-first / can't-verify"| HU(["👤 human authors<br/>the commit"])
    style AU fill:#E3EDE6,stroke:#1E6A48,color:#1B231E
    style CO fill:#E3EDE6,stroke:#1E6A48,color:#1B231E
    style RE fill:#F3E4E0,stroke:#A63D2F,color:#1B231E
    style HU fill:#1E6A48,color:#fff,stroke:#14472f
```

## Read the guide

The whole guide is a single self-contained web page — **[keel.byaru.com](https://keel.byaru.com/)** —
or read it chapter by chapter here:

| Chapter | What it covers |
|---|---|
| [1. Why this exists](docs/guide/01-why.md) | The rot problem; where Keel sits vs. spec-kit/Kiro |
| [2. The 15 principles](docs/guide/02-principles.md) | The whole philosophy, one line each |
| [3. The minimal kernel](docs/guide/03-kernel.md) | The four files; greenfield vs. brownfield tracks |
| [4. The two ledgers](docs/guide/04-ledgers.md) | `falsified.md` + `decisions.md`, with upgraded formats |
| [5. The three roles](docs/guide/05-roles.md) | Coder / reviewer / auditor, with prompts |
| [6. The gates](docs/guide/06-gates.md) | Ambiguity + edit gates, as advice **and** as hooks |
| [7. Applied-AI addendum](docs/guide/07-applied-ai.md) | Deterministic core, evals, experiment tracking |
| [8. Adoption & interop](docs/guide/08-adoption.md) | Walkthroughs + running alongside spec-kit/Kiro |

## Contributing

Keel eats its own dog food: its root [`AGENTS.md`](AGENTS.md) is filled in for this repo (the blank
starter lives in [`templates/`](templates/)), decisions about it live in [`docs/decisions.md`](docs/decisions.md),
proposals carry the burden of proof, and additions need a demonstrated friction they resolve — Keel's
value is its smallness. Start with [CONTRIBUTING.md](CONTRIBUTING.md); the most valuable thing you can
send is an [experience report](.github/ISSUE_TEMPLATE/experience-report.md) from actually adopting it.
CI keeps internal links honest and enforces the ~200-line budget on `AGENTS.md`.

Also: [Code of Conduct](CODE_OF_CONDUCT.md) · [Security policy](SECURITY.md) · [Changelog](CHANGELOG.md)

## License

MIT — see [LICENSE](LICENSE). Original playbook ideas © their author; Keel is offered freely for anyone
to adapt.

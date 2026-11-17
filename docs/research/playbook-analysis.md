# Deep Research Report: The AI-Agent Playbook vs. the Field

**Subject:** subzekt's "Project-Setup Playbook for AI-Agent-Assisted Projects"
([gist](https://gist.github.com/subzekt/0dfced13befee2ff29f1a61bbbd7f072))
**Question:** How does it compare to mature AI-agent development frameworks, and what should a
layered (public + internal) guidebook built from it contain?
**Method:** Multi-source web research, adversarial 3-vote verification per claim. 61 claims
extracted across 30 primary sources; all 61 survived verification (74/75 votes high-confidence).
**Date:** 2026-07-15 (AGENTS.md / CLAUDE.md and spec-kit facts refreshed 2026-11-17)

---

## 1. Executive summary

The playbook occupies a genuinely different position from the mature frameworks it's often mentioned
alongside. **spec-kit and Kiro are *generative* — they make a specification the source of truth and
generate code from it. The playbook is *epistemic* — it assumes code is the source of truth and
governs how agents are allowed to *claim things about it*.** They answer different questions ("how do
I produce code from intent?" vs. "how do I keep a codebase trustworthy after thousands of agent
edits?"), so the playbook is better understood as **complementary to** spec-kit/Kiro than competitive
with them.

Its three genuinely differentiated ideas are:

1. **The `falsified.md` ledger** — a committed record of *killed* ideas. No mainstream framework has
   an equivalent. spec-kit/Kiro/ADR all track what you *decided*; none track what you *ruled out*, which
   is the exact memory an agent lacks.
2. **The reviewer/auditor role separation** — now independently validated as an emerging best practice
   ("adversarial code review," and Anthropic's own docs recommend a fresh-context blind reviewer).
3. **The behavioral gates** (ambiguity gate, edit gate) — again echoed by Anthropic's official
   Explore-Plan-Implement-Commit workflow and the evidence rule.

Its **gaps** are equally clear: it has no staged generation pipeline (spec-kit/Kiro do), its ledgers
are single flat files where ADR tooling offers numbering, lifecycle status, and linting, and its rules
are *behavioral instructions* (context, not enforcement) where hooks and template-level gates can be
*hard* constraints.

**Bottom line for the guidebook:** there is a real, defensible niche here — "the reliability layer that
sits under whatever generation workflow you use." The guidebook should own that framing, borrow the
missing structure from ADR/MADR and the gate-enforcement ideas from spec-kit and Claude Code hooks, and
ship as a clone-and-run starter template whose README is the guide.

---

## 2. The frameworks, verified

### 2.1 GitHub spec-kit — *spec as executable source of truth*

- **What it is:** GitHub's official open-source toolkit for **Spec-Driven Development (SDD)**, explicitly
  positioned as the alternative to "vibe coding," where specifications become *executable* and
  "directly generate" the implementation. Labeled experimental; agent-agnostic across 30+ tools
  (Copilot, Claude Code, Gemini, Codex).
  [[spec-kit repo]](https://github.com/github/spec-kit) · [[GitHub blog]](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- **Workflow:** a fixed sequence of slash commands — `constitution → specify → plan → tasks → implement`,
  plus `clarify`, `analyze`, `checklist` for refinement/validation. *(Nov 2026 note: commands are now
  namespaced `/speckit-*` — e.g. `/speckit-specify` — and the README adds optional bug-fix and
  idea-assessment extensions; the refinement steps moved to its SDD walkthrough, `unverified` here.)*
  [[spec-driven.md]](https://github.com/github/spec-kit/blob/main/spec-driven.md)
- **What it puts in the repo:** a `.specify/` directory (`memory/constitution.md`, scripts, templates)
  and per-feature `specs/[feature]/` folders with `spec.md`, `plan.md`, `tasks.md`, `data-model.md`,
  `contracts/`, `research.md`, `quickstart.md`.
- **Philosophy:** *inverts* the code↔spec relationship — the spec is primary, code is a generated
  expression of it, so **maintenance means evolving the spec, not the code.** This is a far stronger
  stance than the playbook, whose ledgers are advisory scaffolding, not a generator.
- **Gates it already has:** `[NEEDS CLARIFICATION]` markers are mandated at the *template* level (a
  structural version of the playbook's ambiguity gate), and it ships a **Simplicity Gate** and
  **Anti-Abstraction Gate** (a formalized version of "grow when it hurts").
  [[MS Dev blog]](https://developer.microsoft.com/blog/spec-driven-development-spec-kit)

### 2.2 AWS Kiro — *spec-driven, inside an agentic IDE*

- **What it is:** AWS's agentic IDE built around specs as "the unit of work."
  [[Kiro docs]](https://kiro.dev/docs/specs/) · [[AWS]](https://aws.amazon.com/documentation-overview/kiro/)
- **What it puts in the repo:** `.kiro/specs/` with exactly three files per spec — `requirements.md`,
  `design.md`, `tasks.md` — committed and version-controlled alongside code.
- **Workflow:** three phases `requirements → design → tasks`. Requirements use **EARS** notation
  ("WHEN [condition] THE SYSTEM SHALL [behavior]") to make them structured and testable. `tasks.md` is
  an *executable* dependency graph — Kiro runs independent tasks concurrently in "waves."
  [[builder.aws.com]](https://builder.aws.com/content/3DbBI7LQgNIcs6UUj7IPPvqFHOp/aws-kiro-the-agentic-ide-that-makes-specs-the-unit-of-work)
- **Position vs. playbook:** like spec-kit, generative and prescriptive; adds testable-requirements rigor
  (EARS) the playbook has no equivalent of. IDE-coupled, unlike the playbook's tool-agnostic conventions.

### 2.3 AGENTS.md & CLAUDE.md — *the instruction-file layer*

- **AGENTS.md** is a single open, MIT-licensed, tool-neutral Markdown standard — a "README for agents"
  holding **operational** guidance (dev environment, testing, PR/pre-commit rules), *not* product specs
  or decision history. Strong traction (~25.5k stars / ~2.0k forks on the reference repo as of Nov 2026); adopted by
  Codex, Amp, Cursor, and others.
  [[agents.md]](https://agents.md/) · [[repo]](https://github.com/agentsmd/agents.md)
- **CLAUDE.md** is Anthropic's canonical persistent-context file — loaded every session, checked into
  git, holding bash commands, code style, workflow rules, architectural decisions. The interop pattern
  is a `CLAUDE.md` that imports `@AGENTS.md` (or a symlink) — *officially documented* in Anthropic's
  memory docs, with Claude-specific notes allowed below the import. **Update (verified 2026-11):**
  Claude Code v2.1.277+ reads `AGENTS.md` natively, but only when no `CLAUDE.md`/`CLAUDE.local.md`
  exists in the directory or above; if one does, it reads CLAUDE.md files only (configurable via the
  *Project instructions* setting). The community request for native support (opened Aug 2025) is now
  closed.
  [[memory docs]](https://code.claude.com/docs/en/memory) · [[issue #6235]](https://github.com/anthropics/claude-code/issues/6235)
- **Two facts that directly shape the guidebook:**
  1. **These files are *context, not enforcement*.** Compliance is not guaranteed; to *hard-block* an
     action you need a **PreToolUse hook**, not a line in CLAUDE.md. The playbook's gates are behavioral
     instructions and inherit exactly this weakness.
  2. CLAUDE.md loads in **layered scopes** (managed policy → user → project → local) and official guidance
     is *keep it under ~200 lines* or the agent starts ignoring it. This validates both the playbook's
     minimal-kernel instinct **and** the layered public/team/personal structure you want.
     [[best-practices]](https://code.claude.com/docs/en/best-practices)

### 2.4 ADR / MADR — *the decision-log prior art*

The playbook's `decisions.md` reinvents, in lighter form, a 15-year-old practice the guidebook should
knowingly build on:

- **ADR** (Michael Nygard): one committed, sequentially-numbered Markdown file per architectural
  decision, minimum structure **context → decision → consequences**, with an explicit **status** field
  and **superseding** lifecycle (a new ADR supersedes an old one rather than editing it).
  [[Fowler]](https://martinfowler.com/bliki/ArchitectureDecisionRecord.html) · [[adr-tools]](https://github.com/npryce/adr-tools) · [[AWS ADR guide]](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html)
- **MADR** formalizes it: numbered files in `docs/decisions/`, YAML front matter (status:
  proposed/rejected/accepted/deprecated/superseded + date), a **"More Information"** section for
  *when to revisit* (== the playbook's "revisit if"), and a **"Confirmation"** section for *how compliance
  is verified* (== the playbook's evidence rule, at decision-record granularity). npm-installable and
  lintable. [[MADR]](https://adr.github.io/madr/) · [[MADR primer]](https://ozimmer.ch/practices/2022/11/22/MADRTemplatePrimer.html)
- **Borrowable now:** numbering, status lifecycle, append-only/superseding (AWS makes accepted ADRs
  immutable), imperative authoring ("We use…", avoid "should"), and an explicit `consequences` field the
  playbook's `decisions.md` currently lacks.

### 2.5 Adversarial review & eval-driven dev — *the playbook's roles, independently validated*

- **Adversarial Code Review** is a named, documented pattern: a separate **Critic/reviewer** agent,
  *blind to the code beforehand* and framed adversarially to *reject* it, emitting a structured verdict
  (PASS or spec-violations-with-remediation), explicitly to break the "self-validation echo chamber" of
  one model checking its own work. This is the playbook's coder/reviewer split, almost line-for-line.
  [[asdlc.io]](https://asdlc.io/patterns/adversarial-code-review/)
- **Anthropic's own best-practices** independently recommend: a reviewer subagent in a **fresh context**
  that sees *only the diff and criteria, not the reasoning*; an **evidence rule** (show test output / the
  command and its return / a screenshot rather than asserting success); and the **Explore → Plan →
  Implement → Commit** workflow using plan mode to separate research from execution.
  [[best-practices]](https://code.claude.com/docs/en/best-practices)
- **Important nuance the playbook underweights:** Anthropic warns a reviewer told to "find gaps" will
  report some *even when the work is sound*, driving over-engineering — so scope reviewers to
  correctness/requirements. The playbook's `ship / fix-first / can't-verify` verdict should encode this.
- **Eval-driven development** is a maturing discipline (evals as the durable asset; prompts/models as
  consumables) — directly matching the playbook's applied-AI stance.
  [[deepeval]](https://deepeval.com/blog/eval-driven-development) · [[evaldriven.org]](https://evaldriven.org/)

---

## 3. Comparison matrix

| Dimension | subzekt Playbook | spec-kit | Kiro | AGENTS.md / CLAUDE.md | ADR / MADR |
|---|---|---|---|---|---|
| **Primary question** | Keep a codebase trustworthy after 1000s of agent edits | Generate code from an executable spec | Same, inside an agentic IDE | Give agents project context | Record why decisions were made |
| **Source of truth** | **Code** (spec/ledgers are advisory) | **Spec** (code is generated) | **Spec** | Code | Code |
| **Staged pipeline** | ✗ (roles + gates, no commands) | ✓ constitution→specify→plan→tasks→implement | ✓ requirements→design→tasks | ✗ | ✗ |
| **Killed-ideas ledger** | ✅ **`falsified.md` (unique)** | ✗ | ✗ | ✗ | ✗ |
| **Decision log** | `decisions.md` (flat, dated, "revisit if") | `constitution.md` (principles) | design.md (per feature) | "architectural decisions" in CLAUDE.md | ✅ numbered, status lifecycle, superseding |
| **Role separation** | ✅ coder / reviewer / auditor | ✗ (single flow) | ✗ | ✗ | ✗ |
| **Blind adversarial review** | ✅ | ✗ | ✗ | (recommended in Claude docs, not the file) | ✗ |
| **Ambiguity gate** | ✅ behavioral | ✅ `[NEEDS CLARIFICATION]` (structural) | EARS forces precision | ✗ | ✗ |
| **Edit/diagnose gate** | ✅ behavioral | (plan phase) | (design phase) | plan mode (Claude) | ✗ |
| **Evidence rule** | ✅ | (via tests in spec) | (acceptance criteria) | recommended (Claude docs) | MADR "Confirmation" |
| **Enforcement strength** | Instructions (context) | Templates + commands | IDE-integrated | **Context only** (hooks for hard blocks) | Convention + linters |
| **Tooling maturity** | Solo, prose gist | Official GitHub, CLI, experimental | AWS product | Standard + huge adoption | 15 yrs, CLI, npm, linters |
| **Team/portability** | Convention-bound | Agent-agnostic (30+) | IDE-coupled | ✅ cross-tool standard | ✅ universal |

---

## 4. The playbook's unique value proposition & gaps

### 4.1 What is genuinely differentiated

1. **`falsified.md` is the standout — no competitor has it.** Every other system logs decisions *taken*.
   None systematically logs ideas *killed, with the mechanism and the numbers*. This maps precisely onto
   the one thing agents are worst at: not re-running a dead experiment. It's the guidebook's headline.
2. **Role separation + blind adversarial review** — no longer fringe; it's converging with Anthropic's own
   guidance and the documented "adversarial code review" pattern. The playbook was early and is now *on
   trend*, which is a marketing asset.
3. **Epistemic gates over generative pipeline** — the ambiguity gate, edit gate, and "unverified claim"
   rule form a coherent *trust* discipline that is orthogonal to (and stackable under) spec-kit/Kiro.
4. **Minimal-kernel "grow when it hurts"** — validated by Claude's own "keep it under 200 lines / add only
   when you'd re-explain" guidance. A real antidote to framework bloat.

### 4.2 Where it's weaker / missing (all fixable in the guidebook)

| Gap | Borrow from | Fix |
|---|---|---|
| No staged generation pipeline | spec-kit / Kiro | Position as a *layer under* them, or add an optional lightweight spec step |
| Flat `decisions.md`, no lifecycle | ADR / MADR | Adopt numbering, `status`, superseding, and a `consequences` field |
| Gates are context, not enforcement | Claude Code hooks / spec-kit templates | Ship PreToolUse hooks + template markers so gates can *hard-block* |
| No requirements-testability rigor | Kiro (EARS) | Offer EARS as an optional pattern for acceptance criteria |
| Reviewer can over-flag | Anthropic docs | Scope reviewer to correctness/requirements in the verdict spec |
| Tool-agnostic on paper only | AGENTS.md standard | Make `AGENTS.md` canonical, `CLAUDE.md` a `@AGENTS.md` import stub |
| Solo-authored, unversioned prose | all of the above | Version it, template it, make it clone-and-run |

---

## 5. Recommended guidebook structure (layered: public core + internal layer)

**Format recommendation:** a **clone-and-run starter template repository whose README *is* the guide**,
with a rendered web version for sharing. This beats a static doc because the playbook's whole thesis is
"leave files behind in the repo" — the template *is* the artifact, and the guide teaches by shipping it.
This directly serves the "both, in layers" decision: the public repo carries the core; a private overlay
(or a `internal/` branch/dir) carries the agency-specific layer.

### 5.1 The two layers

- **Public core (open-source):** the philosophy, the kernel, the ledgers, the roles, the gates, the
  adoption paths, and the template files. Vendor-neutral (AGENTS.md-first). This is the reputation play
  your boss's post is aiming at.
- **Internal team/agency layer (private overlay):** house style, client-onboarding checklist, the
  agency's own filled-in `decisions.md`/`falsified.md` conventions, CI wiring, hook configs, and
  "how we actually run coder/reviewer/auditor here." Implemented as a private repo that layers on top,
  or a `/internal` directory ignored in the public mirror — mirroring the managed→user→project→local scope
  model Claude Code already uses.

### 5.2 Proposed chapters (README + `docs/`)

1. **Why this exists** — the "1000s of agent edits" rot problem; visitor-not-resident; where it sits
   relative to spec-kit/Kiro (complement, not compete).
2. **The 15 principles** — restated, each with the "mistake that taught it" (the post's own hook).
3. **The minimal kernel** — the four files; greenfield vs. brownfield; code-first vs. docs-first tracks.
4. **The two ledgers** — `falsified.md` and `decisions.md`, with formats *upgraded* using ADR/MADR
   (numbering optional, status, "revisit if", consequences).
5. **The three roles** — coder / reviewer / auditor, with ready-to-paste role prompts; the
   over-flagging caveat baked into the reviewer.
6. **The gates** — ambiguity + edit gates as instructions **and** as optional PreToolUse hooks that
   actually enforce.
7. **Applied-AI addendum** — deterministic core, LLM-at-the-boundary, eval harness, experiment tracking.
8. **Adoption playbooks** — a greenfield walkthrough and a brownfield retrofit walkthrough (see 5.4).
9. **Interop** — AGENTS.md as canonical, CLAUDE.md stub, and how to run *alongside* spec-kit/Kiro.
10. **The internal layer** — how to fork the private overlay for a team/agency.

### 5.3 Starter file tree (what `git clone` gives you)

```
ai-agent-playbook/
├── README.md                     # the guide itself (chapters 1–3 inline, links onward)
├── AGENTS.md                     # canonical agent instructions (gates + project map)
├── CLAUDE.md                     # stub: "@AGENTS.md" + Claude-specific notes
├── .claude/
│   └── hooks/                    # OPTIONAL PreToolUse hooks that enforce the gates
├── docs/
│   ├── decisions.md              # decision ledger (ADR/MADR-informed format)
│   ├── falsified.md              # killed-ideas ledger — the headline artifact
│   ├── ai/                       # durable "why" reasoning (committed)
│   ├── plans/                    # ephemeral implementation notes (deleted on graduation)
│   └── guide/                    # chapters 4–10 as individual pages
├── roles/
│   ├── coder.md                  # scoped-step role prompt
│   ├── reviewer.md               # blind adversarial reviewer prompt (+ over-flag caveat)
│   └── auditor.md                # dead-list-check-first auditor prompt
├── evals/                        # eval harness scaffold (for LLM projects)
├── templates/                    # copy-paste ledger entries, decision record, spec stub
└── internal/                     # (private overlay) agency layer — gitignored in public mirror
```

### 5.4 Adoption paths

- **Greenfield:** `clone → strip to kernel (4 files) → pick code-first/docs-first → wire roles → add
  hooks when a gate first gets violated → grow docs/ and evals/ only when absence hurts.`
- **Brownfield (existing repo):** `drop in AGENTS.md + CLAUDE.md stub → start both ledgers *empty* and
  fill forward (never backfill) → introduce reviewer role on the next PR → add auditor once falsified.md
  has entries → adopt hooks last.` No big-bang migration — additive by design, matching spec-kit's own
  brownfield stance.

---

## 6. What to borrow, concretely

- **From ADR/MADR:** numbering + `status` + superseding + `consequences` for `decisions.md`; consider a
  MADR-style `docs/decisions/NNNN-*.md` option for teams that want linting.
- **From spec-kit:** template-level gate markers (`[NEEDS CLARIFICATION]`), the Simplicity/Anti-Abstraction
  gates as an explicit checklist, and the "constitution" idea as the top of `decisions.md`.
- **From Kiro:** EARS notation as an optional acceptance-criteria format.
- **From Claude Code:** PreToolUse **hooks** to turn gates from advice into enforcement; the layered scope
  model as the blueprint for public/team/local layering; the <200-line discipline.
- **From adversarial-review / Anthropic docs:** fresh-context blind reviewer, evidence rule, and the
  reviewer-scoping caveat.

---

## 7. Verification & limitations

- 61 claims, 30 sources; every claim passed 3-vote adversarial verification (74/75 votes high-confidence).
- One candidate source (`arxiv.org/pdf/2603.12123`) had a fabricated-looking identifier and was **excluded**.
- spec-kit is explicitly **experimental** and evolving; command names/flags may drift — re-check against
  the repo before quoting exact syntax in the shipped guide.
- The playbook's own text is a prose gist; where this report characterizes it, it relies on the extracted
  principles and the gist summary captured earlier in this session.

---

*Sources are linked inline. Primary-source coverage: spec-kit (GitHub official), Kiro (AWS official),
agents.md (standard repo/site), Claude Code docs (memory + best-practices), ADR/MADR (Fowler, adr.github.io,
adr-tools, AWS prescriptive guidance), adversarial-review (asdlc.io), eval-driven (deepeval, evaldriven.org).*

# python-uv-claude-template

[![Test template](https://github.com/jvitorcosta/python-uv-claude-template/actions/workflows/test-template.yml/badge.svg)](https://github.com/jvitorcosta/python-uv-claude-template/actions/workflows/test-template.yml)
[![Latest version](https://img.shields.io/github/v/tag/jvitorcosta/python-uv-claude-template?label=template&sort=semver)](CHANGELOG.md)

A [Copier](https://copier.readthedocs.io) template for Python projects built with
**uv**, **Ruff**, **mypy**, **pytest**, a **Makefile**, and a full **Claude Code** setup.

One command gives you a project that already lints, type-checks and tests on three operating
systems, with Claude Code set up to follow the same rules. Later template improvements reach the
project with `uvx copier update`.

```bash
uvx copier copy gh:jvitorcosta/python-uv-claude-template my-project
```

## Prerequisites (one-time per machine)

You need **uv**, **Git ≥ 2.31** (pre-commit 4 requires it) and **make**. uv installs
Python for you, so you don't need a system Python. Optional: **gh** (GitHub CLI) and
**Claude Code**.

| Tool | macOS | Linux (Debian/Ubuntu) | Windows (PowerShell) |
| ---- | ----- | --------------------- | -------------------- |
| uv   | `brew install uv` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | `winget install astral-sh.uv` |
| Git  | `brew install git` | `sudo apt install git` | `winget install Git.Git` |
| make | `xcode-select --install` | `sudo apt install make` | `winget install ezwinports.make` |
| gh   | `brew install gh` | [cli.github.com](https://cli.github.com) | `winget install GitHub.cli` |

Check: `uv --version && git --version && make --version`. Restart the terminal after
installing on Windows so `PATH` picks them up.

### Windows notes

- Enable long paths once, or deep folders (and Copier) fail with *Filename too long*:
  `git config --global core.longpaths true`. Keep projects in short paths like `D:\dev\`.
- Every `make` target works from PowerShell/cmd and from Git Bash. Recipes only use `uv`
  and Python, never `rm`/`awk`/`find`. No `make`? Copy the `uv run ...` line from the
  `Makefile`.
- Claude Code on Windows runs hooks through Git Bash, which Git for Windows installs.
- Line endings are normalised to LF by `.gitattributes`, so mixed OS teams don't get noisy diffs.

## Use it

```bash
uvx copier copy gh:jvitorcosta/python-uv-claude-template my-project
cd my-project
git init -b main
make install
make check
```

Works the same in bash, zsh, PowerShell and cmd. You'll be asked for the project name, package name, Python version, whether to include a
Typer CLI, and a license, plus three options that are off by default:

| Question | Default | What it changes |
| -------- | ------- | --------------- |
| `include_example` | yes | No: drop the example `hello()` function and its tests (and the CLI's `greet`), keeping only `__version__`. |
| `include_data_science` | no | Yes: numpy, pandas and scikit-learn; `pandas-stubs` and a mypy override for scikit-learn so `strict` still passes; `notebooks/` (not linted); `data/` and `artifacts/` gitignored; `brew install libomp` on macOS CI for LightGBM/XGBoost wheels. |
| `protect_project_files` | no | Yes: `copier update` leaves `README.md`, `CHANGELOG.md` and the package `__init__.py` alone once they exist, instead of merging template changes into files the project has rewritten. |

With the defaults, a generated project is identical to the previous template version.
Existing projects can opt in on their next update, e.g. `uvx copier update -d protect_project_files=true`.

### Pull template updates into an existing project

```bash
cd my-project
uvx copier update
```

Copier reads `.copier-answers.yml`, re-renders the template at the new version, and
3-way-merges your changes. This is the main reason to use Copier over Cookiecutter.
Commit or stash your work first (Copier refuses to update a dirty repo). It only sees
**tagged** template versions, so see [Releasing](#releasing-a-new-template-version).

## What you get

| Area           | Choice                                                          |
| -------------- | --------------------------------------------------------------- |
| Packaging      | uv, `uv_build` backend, `src/` layout, `uv.lock`                |
| Lint / format  | Ruff (pycodestyle, pyflakes, isort, bugbear, pyupgrade, bandit…)|
| Types          | mypy `strict`, `py.typed`                                       |
| Tests          | pytest + pytest-cov (80% gate)                                  |
| Tasks          | `Makefile` (`make help`)                                        |
| Git hooks      | pre-commit: ruff, mypy, `uv lock` check, hygiene hooks          |
| CI             | GitHub Actions on Ubuntu, macOS, Windows (`astral-sh/setup-uv`) |
| Deps updates   | Dependabot (uv + Actions)                                       |
| Docs           | README, CONTRIBUTING, CHANGELOG, PR + issue templates           |
| Optional       | Typer CLI, MIT license, data/ML setup, protected project files  |

### A generated project

```
my-project/
├── src/my_project/        # your package (py.typed); cli.py if you chose the Typer CLI
├── tests/                 # pytest, 80% coverage gate
├── notebooks/             # only with include_data_science (data/, artifacts/ gitignored)
├── pyproject.toml         # uv_build, ruff, mypy strict, pytest, coverage
├── uv.lock
├── Makefile               # make help: install, check, test, format, build, ...
├── .pre-commit-config.yaml
├── .github/               # CI on 3 OSes, Dependabot, PR and issue templates
├── CLAUDE.md, .claude/    # Claude Code setup (below)
├── README.md, CONTRIBUTING.md, CHANGELOG.md
└── .copier-answers.yml    # what `copier update` needs
```

### Claude Code layout

```
CLAUDE.md                     # project context, commands, conventions (imports rules)
.mcp.json                     # team MCP servers (empty to start)
.claude/
├── settings.json             # permission allow/ask/deny + hooks
├── rules/                    # path-scoped: code-style, testing, api-conventions
├── commands/                 # /review, /fix-issue <n>
├── skills/release/           # SKILL.md + changelog-format.md
├── agents/                   # code-reviewer, security-auditor
└── hooks/
    ├── validate_bash.py      # PreToolUse: blocks pip, rm -rf /, force-push, push to main, .env reads…
    └── format_python.py      # PostToolUse: ruff fix + format on each .py edited in the project
```

The hooks are stdlib Python run with `uv run --no-project`, so they work on
Windows, macOS and Linux without `jq` or POSIX tools. `validate_bash.py` checks each part of a
command line on its own (`git push origin fix && gh pr create --base main` is fine) and reads the
push's refspecs, so `git push origin HEAD:main` is caught. `format_python.py` leaves files outside
the project alone. Both are tested in this repo (`make test-hooks`). `CLAUDE.local.md` and
`.claude/settings.local.json` are gitignored for personal overrides.

## Developing the template

See [CONTRIBUTING.md](CONTRIBUTING.md). TL;DR: `make test` tests the hooks, renders the
template four times (default, CLI, bare CLI without the example, data/ML with protected files)
and runs the full check suite on each. CI runs it on
Ubuntu, macOS and Windows (Git Bash **and** plain `cmd`).

## Releasing a new template version

```bash
make test                       # must pass
# add the version's section to CHANGELOG.md
git commit -am "feat: ..."      # Conventional Commits
git tag -a vX.Y.Z -m "vX.Y.Z"   # annotated; semver: major = breaking change for generated projects
git push --follow-tags          # only pushes annotated tags, hence -a
```

Then in any generated project: `uvx copier update`.

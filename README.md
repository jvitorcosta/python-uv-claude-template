# python-uv-claude-template

A [Copier](https://copier.readthedocs.io) template for Python projects built with
**uv**, **Ruff**, **mypy**, **pytest**, a **Makefile**, and a full **Claude Code** setup.

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
Typer CLI, and a license.

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
| Optional       | Typer CLI, MIT license                                          |

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
    ├── validate_bash.py      # PreToolUse: blocks pip, rm -rf /, force-push, .env reads…
    └── format_python.py      # PostToolUse: ruff fix + format on every edited .py
```

The hooks are stdlib Python run with `uv run --no-project`, so they work on
Windows, macOS and Linux without `jq` or POSIX tools. `CLAUDE.local.md` and
`.claude/settings.local.json` are gitignored for personal overrides.

## Developing the template

See [CONTRIBUTING.md](CONTRIBUTING.md). TL;DR: `make test` renders the template twice
(default + CLI variant) and runs the full check suite on each. CI runs it on
Ubuntu, macOS and Windows (Git Bash **and** plain `cmd`).

## Releasing a new template version

```bash
make test                       # must pass
git commit -am "feat: ..."      # Conventional Commits
git tag v0.2.0                  # semver: major = breaking change for generated projects
git push --follow-tags
```

Then in any generated project: `uvx copier update`.

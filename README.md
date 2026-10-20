# python-uv-claude-template

A [Copier](https://copier.readthedocs.io) template for Python projects built with
**uv**, **Ruff**, **mypy**, **pytest**, a **Makefile**, and a full **Claude Code** setup.

## Use it

```bash
uvx copier copy --trust gh:jvitorcosta/python-uv-claude-template my-project
cd my-project
git init -b main
make install
make check
```

`--trust` is needed because the template renders file names conditionally.
You'll be asked for the project name, package name, Python version, whether to include a
Typer CLI, and a license.

### Pull template updates into an existing project

```bash
cd my-project
uvx copier update --trust
```

Copier reads `.copier-answers.yml`, re-renders the template at the new version, and
3-way-merges your changes. This is the main reason to use Copier over Cookiecutter.

## What you get

| Area           | Choice                                                          |
| -------------- | --------------------------------------------------------------- |
| Packaging      | uv, `uv_build` backend, `src/` layout, `uv.lock`                |
| Lint / format  | Ruff (pycodestyle, pyflakes, isort, bugbear, pyupgrade, bandit…)|
| Types          | mypy `strict`, `py.typed`                                       |
| Tests          | pytest + pytest-cov (80% gate)                                  |
| Tasks          | `Makefile` (`make help`)                                        |
| Git hooks      | pre-commit: ruff, mypy, `uv lock` check, hygiene hooks          |
| CI             | GitHub Actions on Ubuntu + Windows via `astral-sh/setup-uv`     |
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
Windows, macOS and Linux without `jq` or bash. `CLAUDE.local.md` and
`.claude/settings.local.json` are gitignored for personal overrides.

## Developing the template

See [CONTRIBUTING.md](CONTRIBUTING.md). TL;DR: `make test` renders the template twice
(default + CLI variant) and runs the full check suite on each.

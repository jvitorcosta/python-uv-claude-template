# Changelog

Changes to the template itself. Generated projects pick them up with `uvx copier update`.
Based on [Keep a Changelog](https://keepachangelog.com); versions follow semver, where a major
version breaks generated projects.

## [Unreleased]

## [0.4.0] - 2026-10-29

New questions, all off by default: with the defaults a generated project is byte-for-byte the
same as with 0.3.0 (only `.copier-answers.yml` records the new answers).

### Added
- `include_example` (default yes): answer no to drop the `hello()` example and its tests, keeping
  only `__version__`. With the Typer CLI, only the `version` command remains.
- `include_data_science` (default no): numpy, pandas, scikit-learn, `pandas-stubs`, `ipykernel`, a
  mypy override for scikit-learn, `notebooks/` excluded from Ruff, `data/` and `artifacts/`
  gitignored, notes in CLAUDE.md, and a `brew install libomp` step on macOS CI (LightGBM and
  XGBoost wheels need it).
- `protect_project_files` (default no): `copier update` skips `README.md`, `CHANGELOG.md` and the
  package `__init__.py` once they exist (`_skip_if_exists`). Existing projects opt in with
  `uvx copier update -d protect_project_files=true`.
- `make test` renders two more variants: a bare CLI without the example, and data/ML with
  protected files.

### Changed
- `.gitignore` and `.github/workflows/ci.yml` are now rendered (`.jinja`) so the data option can
  extend them; the CI file wraps its GitHub expressions in `{% raw %}`.

## [0.3.0] - 2026-10-28

### Fixed
- `validate_bash.py` checks each part of a command line on its own. A push to a feature branch
  next to `gh pr create --base main` is no longer blocked as a push to main, and an unrelated
  `rm -f` after a push no longer counts as a force push.
- `validate_bash.py` reads the push's refspecs, so `git push origin HEAD:main`,
  `feature:refs/heads/main` and forced `+ref` pushes are caught.
- `format_python.py` only formats `.py`/`.pyi` files inside the project; it used to reformat files
  in other repos with this project's ruff config.
- The template's own Makefile no longer overrides Windows' `TMP` variable for every command it
  runs (the output folder variable is now `OUT`).

### Added
- Tests for both hooks (`make test-hooks`, part of `make test` and CI).
- README: quick start at the top, badges, the tree of a generated project.

### Changed
- Default author: Vitor Pinheiro.

## [0.2.0] - 2026-10-20

### Added
- Cross-platform Makefiles: every target works from bash, zsh, PowerShell and cmd.
- Per-OS setup docs, and CI on macOS and Windows (Git Bash and plain cmd).

## [0.1.1] - 2026-10-20

### Fixed
- CI pins `astral-sh/setup-uv` to v10.3.0 instead of a floating major tag.

## [0.1.0] - 2026-10-20

### Added
- First version: uv, Ruff, mypy strict, pytest with an 80% coverage gate, pre-commit, Makefile,
  GitHub Actions, Dependabot, docs and templates, an optional Typer CLI and a full Claude Code
  setup (CLAUDE.md, rules, hooks, commands, skills, agents).

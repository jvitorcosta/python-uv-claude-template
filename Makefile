.DEFAULT_GOAL := help
.PHONY: help render test test-hooks clean

# Recipes use only `uv ...` (with --directory instead of cd) and Python one-liners, so they behave the
# same in bash/zsh (macOS, Linux) and cmd/PowerShell (Windows).
PY := uv run --no-project --quiet python -c
# Not TMP: on Windows that is the temp-folder variable, and make would override it.
OUT := .tmp
COPIER := uvx copier copy --defaults --overwrite --quiet --vcs-ref=HEAD
check = uv --directory $(1) sync --all-groups --quiet && uv --directory $(1) run ruff check . && uv --directory $(1) run ruff format --check . && uv --directory $(1) run mypy && uv --directory $(1) run pytest --cov -q

help: ## Show this help
	@$(PY) "import re; [print(f'  {t:<10} {d}') for t, d in re.findall(r'^([a-zA-Z_-]+):.*?## (.*)$$', open('Makefile').read(), re.M)]"

render: ## Render the default variant into .tmp/default
	$(COPIER) . $(OUT)/default

test-hooks: ## Test the Claude Code hooks shipped in template/.claude/hooks
	uv run --no-project --quiet --with pytest pytest tests -q -p no:cacheprovider

test: clean test-hooks ## Test the hooks, render all variants and run their checks
	$(COPIER) . $(OUT)/default
	$(COPIER) -d include_cli=true -d project_name="Cli Demo" -d license=Proprietary . $(OUT)/cli
	$(call check,$(OUT)/default)
	$(call check,$(OUT)/cli)
	$(MAKE) -C $(OUT)/default help clean

clean: ## Remove rendered output
	@$(PY) "import shutil; shutil.rmtree('$(OUT)', ignore_errors=True)"

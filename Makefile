.DEFAULT_GOAL := help
.PHONY: help render test clean

TMP := .tmp
COPIER := uvx copier copy --trust --defaults --overwrite --vcs-ref=HEAD

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

render: ## Render the default variant into .tmp/default
	$(COPIER) . $(TMP)/default

test: clean ## Render all variants and run their checks
	$(COPIER) . $(TMP)/default
	$(COPIER) -d include_cli=true -d project_name="Cli Demo" -d license=Proprietary . $(TMP)/cli
	for d in default cli; do \
		(cd $(TMP)/$$d && uv sync --all-groups -q && uv run ruff check . && \
		 uv run ruff format --check . && uv run mypy && uv run pytest --cov -q) || exit 1; \
	done

clean: ## Remove rendered output
	rm -rf $(TMP)

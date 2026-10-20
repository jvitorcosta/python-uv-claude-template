.DEFAULT_GOAL := help
.PHONY: help install sync lock upgrade format lint typecheck test cov check pre-commit build clean

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install deps and git hooks (first-time setup)
	uv sync --all-groups
	uv run pre-commit install

sync: ## Sync the environment with uv.lock
	uv sync --all-groups

lock: ## Re-resolve uv.lock
	uv lock

upgrade: ## Upgrade all dependencies to their latest allowed versions
	uv lock --upgrade
	uv sync --all-groups

format: ## Auto-format and apply safe lint fixes
	uv run ruff format .
	uv run ruff check --fix .

lint: ## Lint and check formatting (no changes)
	uv run ruff check .
	uv run ruff format --check .

typecheck: ## Static type checking
	uv run mypy

test: ## Run tests
	uv run pytest

cov: ## Run tests with coverage
	uv run pytest --cov --cov-report=term-missing

check: lint typecheck cov ## Everything CI runs

pre-commit: ## Run all pre-commit hooks on all files
	uv run pre-commit run --all-files

build: ## Build sdist + wheel into dist/
	uv build

clean: ## Remove caches and build artifacts
	rm -rf dist build .pytest_cache .mypy_cache .ruff_cache .coverage htmlcov
	find . -type d -name __pycache__ -prune -exec rm -rf {} +

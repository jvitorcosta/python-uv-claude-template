# Contributing to the template

## Layout

- `copier.yml`: questions and Copier settings
- `template/`: everything rendered into a new project. Files ending in `.jinja`
  are rendered (suffix stripped); others are copied verbatim.
- Conditional files use names like `{% if include_cli %}cli.py{% endif %}.jinja`.
  Use **single quotes** inside file names; Windows forbids `"`.

## Testing a change

```bash
make test        # render default + CLI variants into .tmp/ and run lint/types/tests
make render      # render default variant into .tmp/default for manual poking
make clean
```

Without `make`, run the commands in the [Makefile](Makefile) directly.

## Guidelines

- Anything with `${{ }}` (GitHub Actions) must **not** have a `.jinja` suffix, or must
  wrap the expression in `{% raw %}...{% endraw %}`.
- Keep generated projects passing `make check` with zero warnings.
- When bumping tool versions (ruff-pre-commit, setup-uv, ...), update both the
  template and this repo's CI.
- Tag releases (`git tag v1.2.0`); `copier update` uses tags to find new versions.
- Use Conventional Commits.

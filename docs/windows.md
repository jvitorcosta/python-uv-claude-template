# Windows notes

Notes for using the template on Windows (PowerShell, cmd or Git Bash).

- Enable long paths once, or deep folders (and Copier) fail with *Filename too long*:
  `git config --global core.longpaths true`. Keep projects in short paths like `D:\dev\`.
- Every `make` target works from PowerShell/cmd and from Git Bash. Recipes only use `uv`
  and Python, never `rm`/`awk`/`find`. No `make`? Copy the `uv run ...` line from the
  `Makefile`.
- Claude Code on Windows runs hooks through Git Bash, which Git for Windows installs.
- Line endings are normalised to LF by `.gitattributes`, so mixed OS teams don't get noisy diffs.

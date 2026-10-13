#!/usr/bin/env bash
# Install the hash-pinned CI tools (ruff, pip-audit, zizmor) once per job into
# $RUNNER_TEMP/jl-tools and print the bin directory. Used by the sibling actions.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
venv="${RUNNER_TEMP:?}/jl-tools"
# The lock is resolved for CPython 3.12 (ubuntu-24.04's python3); ask for it by name.
py="$(command -v python3.12 || true)"
[[ -n "$py" ]] || { echo "::error::python3.12 not found on this runner" >&2; exit 1; }
if [[ ! -x "$venv/bin/zizmor" ]]; then
  "$py" -m venv "$venv" >&2
  "$venv/bin/pip" install --quiet --disable-pip-version-check --require-hashes \
    --only-binary=:all: -r "$here/requirements-tools.txt" >&2
fi
echo "$venv/bin"

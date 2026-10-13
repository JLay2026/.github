# JLay2026/.github

Shared CI building blocks, templates and defaults for JLay2026 repositories. Public on
purpose: public and private repositories both call it. Generic plumbing only — nothing
product-specific, no infrastructure details, no secret values.

**Proprietary — all rights reserved** ([LICENSE](LICENSE)). Public visibility does not
license use: referencing these actions from repositories not owned by JLay2026 requires
written permission.

## Composite actions

| Action | What it does |
|---|---|
| `actions/python-tools` | Hash-pinned ruff, pip-audit and zizmor in a venv (one lock, here). Output `bin`. |
| `actions/pip-audit` | Audits the caller's hash-pinned locks; optional ignore file of accepted findings. |
| `actions/zizmor` | Offline zizmor over the caller's workflows. |
| `actions/gitleaks` | gitleaks (pinned by SHA-256) over the commits a PR or push adds; rules from the base branch. |
| `actions/dhi-login` | `docker login dhi.io` for Docker Hardened Images; fails clearly on empty secrets. |
| `actions/release-guard` | Refuses a tag that is off `main` or not `v` + `__version__` (and `pyproject.toml`). |
| `actions/sign-attest-verify` | cosign keyless signature, signed SPDX SBOM attestation, self-verify, prints the pin. |

They are **composite actions, not reusable workflows**, deliberately: they run inside the
caller's own job, so a release signature's certificate names the caller's
`release.yml` and every verifier keeps checking the repository that built the image.

## Using them

Pin by commit SHA, with the release as a comment:

```yaml
- uses: JLay2026/.github/actions/pip-audit@<sha>  # v1.0.0
  with:
    locks: requirements.txt requirements-dev.txt
```

Starters: [`templates/workflows/`](templates/workflows/). Dockerfile:
[`templates/Dockerfile.python`](templates/Dockerfile.python). ADRs:
[`templates/adr.md`](templates/adr.md). Renovate preset:
`"extends": ["github>JLay2026/.github//renovate/default"]`.

## Pinned tools

| Tool | Version | Where |
|---|---|---|
| ruff / pip-audit / zizmor | 0.17.0 / 2.10.1 / 1.30.1 | `actions/python-tools/requirements-tools.txt` (hashes) |
| gitleaks | 8.30.1 | `actions/gitleaks` (asset SHA-256) |
| cosign / syft | v3.1.3 / v1.54.1 | `actions/sign-attest-verify` |

The tools lock is audited by `ci.yml` on every change here and by `audit.yml` every Monday,
so a new advisory against a tool every adopter installs surfaces within a week.

## Releases of this repository

Tagged `vX.Y.Z`. A change to any action's behaviour is a new minor version with a note
here; callers move by bumping the SHA.

Policy: [`docs/base-image-policy.md`](docs/base-image-policy.md) ·
[`CONTRIBUTING.md`](CONTRIBUTING.md) · [`SECURITY.md`](SECURITY.md)

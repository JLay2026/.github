# Contributing

The default for every JLay2026 repository that has no `CONTRIBUTING.md` of its own.
A repository's own file wins where the two differ.

## Workflow

- **Never commit directly to `main`.** Every change lands through a branch and a pull
  request, one logical change per PR.
- **Branch naming:** `<kind>/<issue>-<slug>` — `feat/7-alerts`, `fix/31-budget`,
  `chore/96-supply-chain`. The issue number is mandatory.
- **Issues are the system of record.** Every PR closes or references an issue. Docs record
  decisions; issues record work. No TODO files.
- **Authoring vs merging:** automation authors branches and PRs; the owner reviews and
  merges. Nothing self-merges.

## PR body, in this order

1. `Closes #N` (or `Refs #N`), plus the migration number if any.
2. **What** — per module, for a reviewer who has not seen the conversation.
3. **Tests** — measured counts, lint and schema checks.
4. **Not in this PR** — what was deferred, and the issue it moved to.
5. **Decisions flagged** — every judgment call not explicitly approved.

## Supply chain (merge gates)

- **Dependencies** install only from hash-pinned locks, wheels only
  (`pip install --require-hashes --only-binary=:all:`). Ranges live in `pyproject.toml`;
  the lock is regenerated in the same PR as any dependency change.
- **Base images** follow [`docs/base-image-policy.md`](docs/base-image-policy.md):
  Docker Hardened Images pinned by digest.
- **Workflows:** every `uses:` pinned by commit SHA (`$/` for this repository's own);
  `persist-credentials: false` on checkouts; minimal `permissions`; secrets reach `run:`
  through `env`, never by template expansion. `zizmor` reports no findings.
- **CI** runs `pip-audit` over every lock and `gitleaks` over new commits, using the
  shared actions in [JLay2026/.github](https://github.com/JLay2026/.github).
- **Releases:** a tag publishes only if it is on `main` and equals the package version;
  the image is signed and SBOM-attested by the repository's own release workflow. A tag
  is never moved; a bad release is followed by a patch release.

# Security policy

The default for every JLay2026 repository that has no `SECURITY.md` of its own.

## Reporting a vulnerability

Please report privately through GitHub's **"Report a vulnerability"** (Security tab →
Advisories) on the affected repository. Do not open a public issue for a suspected
vulnerability. Expect an acknowledgement within a week.

## What these projects do by default

- Base images are Docker Hardened Images pinned by digest; dependencies install only from
  hash-pinned locks; runtime images carry no shell or package manager where the language
  allows.
- Every workflow action is pinned by commit SHA and audited with `zizmor`; locks are
  audited with `pip-audit`; new commits are scanned with `gitleaks`.
- Released images are signed keyless (cosign, GitHub OIDC) and carry a signed SPDX SBOM
  attestation. Verify with `cosign verify` against the repository's own
  `.github/workflows/release.yml` identity before deploying, and pin the digest.
- Credentials are injected at run time from a vault; none are committed or logged.

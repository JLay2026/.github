# Base-image policy

Decided 2026-10-13; applies to every repository owned by JLay2026.

1. **Docker Hardened Images throughout** (`dhi.io/<image>`): free and Apache-2.0, non-root,
   SBOM and SLSA provenance published. A versioned line (`python:3.12`, `node:22`,
   `golang:1.26`), **pinned by index digest**; the tag beside the digest is for people.
   `-dev` variants (shell, compilers, package managers) in build stages only.
2. **Google `distroless/static`** only where no hardened image fits (a static binary
   whose runtime needs nothing). **The official image, by digest,** only where neither
   exists.
3. **Never** a tag without a digest, a `latest`, or a community-built image.

**Pulling:** `dhi.io` needs a login even on the free tier. Each repository sets two
Actions secrets, `DHI_USERNAME` and `DHI_TOKEN` (a read-only personal access token),
filled from the vault; the `dhi-login` action uses them. Personal accounts have no
account-level Actions secrets, so the same two are set per repository.

**Bumping:** `docker buildx imagetools inspect dhi.io/<image>:<tag>` prints the index
digest. Change tag and digest together, in a PR whose CI builds and smoke-tests the image.
Renovate (`renovate/default.json`) refreshes digests within a line and holds line changes
for a deliberate edit.

**Releases** are signed keyless by the repository's own release workflow
(`sign-attest-verify`), with a signed SPDX SBOM attestation. Deploys pin the
`name:version@sha256:…` the release job prints and verify it with `cosign verify` against
that workflow's identity.

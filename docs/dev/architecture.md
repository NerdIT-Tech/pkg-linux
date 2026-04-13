# Repository Architecture

This repository is designed to be a self-maintaining, multi-distribution Linux package repository hosted on GitHub Pages. It supports Debian (`.deb`), RedHat (`.rpm`), and Alpine (`.apk`) packages.

## Directory Structure

- `incoming/`: The staging area for new packages. Each distribution has its own sub-directory.
- `repo/`: The source of truth for processed and indexed packages. This is what's served to users.
- `scripts/`: Internal scripts for repository indexing and signing.
- `site/`: The landing page and documentation site.
- `.github/workflows/`: GitHub Actions that automate the package ingestion and repository updates.

## Workflow Overview

1.  **Submission**: Contributors submit new packages by creating a Pull Request that adds files to the `incoming/` directory.
2.  **Validation**: CI workflows validate the PR, checking signatures, linting packages, and verifying metadata.
3.  **Merge & Process**: Once the PR is merged, an automated workflow moves the files from `incoming/` to `repo/`, regenerates the repository indexes, and signs them.
4.  **Deployment**: The updated `repo/` and documentation are deployed to GitHub Pages.

## Security

- Packages are signed using the repository's private keys (GPG/RSA).
- Public keys are made available in each distribution's repository directory for client-side verification.
- GitHub Actions secrets are used to store the private signing keys.

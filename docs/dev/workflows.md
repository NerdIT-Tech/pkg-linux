# Continuous Integration & Deployment Workflows

This document describes the automated workflows managed by GitHub Actions.

## 1. Package Validation Workflow

This workflow is triggered when a Pull Request is opened or updated targeting the `main` branch.

- **Trigger**: `pull_request` on `incoming/**`
- **Actions**:
  - Run `lintian` for Debian packages.
  - Run `rpmlint` for RedHat packages.
  - Run `apk-tools` checks for Alpine packages.
  - Verify that the package version does not already exist in the repository.

## 2. Repository Update Workflow

This workflow is triggered when a PR is merged into the `main` branch.

- **Trigger**: `push` to `main`
- **Actions**:
  - Run `scripts/process_incoming.sh`.
  - Run `scripts/re-index.sh` and `scripts/sign-repo.sh`.
  - Run `scripts/generate_index.sh`.
  - Commit the updated `repo/` and `site/` files to the `gh-pages` branch.

## 3. Deployment Workflow

This workflow handles the deployment to GitHub Pages.

- **Trigger**: `push` to `gh-pages` or manual trigger.
- **Actions**:
  - Deploy the contents of the `gh-pages` branch to GitHub Pages.

## Manual Execution

The repository maintenance workflows can also be manually triggered via the GitHub Actions "Run workflow" interface for periodic maintenance or force updates.

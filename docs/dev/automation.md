# Repository Automation

The repository uses automation to manage package ingestion, indexing, and documentation updates.

## Automation Scripts

Located in `scripts/`:

- `process_incoming.sh`: Moves files from `incoming/` to `repo/` after a PR merge.
- `re-index.sh`: Regenerates repository metadata (e.g., `Packages`, `repodata`, `APKINDEX`).
- `sign-repo.sh`: Digitally signs the repository indexes.
- `generate_index.sh`: Generates `packages.json` for the documentation site's search feature.

## External API/Automation

External tools can automate package submissions using the GitHub CLI or API:

```bash
# Example: Uploading a new Debian package via GH CLI
gh pr create --title "Add package-name 1.0.0" --body "Automated package submission" --base main --head my-feature-branch
```

## Self-Maintaining Loop

When a PR is merged into the `main` branch, the following automated actions occur:

1.  Move files from `incoming/` to their respective distribution folders in `repo/`.
2.  Run distribution-specific indexing tools (e.g., `apt-ftparchive`, `createrepo_c`, `apk index`).
3.  Sign the new indexes using GPG or RSA.
4.  Generate an updated `packages.json` file.
5.  Re-deploy the static site and repository files to GitHub Pages.

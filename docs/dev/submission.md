# PR Submission Guide

We welcome contributions of new packages! To submit a package, please follow these steps:

## 1. Prepare Your Package

Ensure your package follows the naming convention for its distribution:
- **Debian**: `name_version_architecture.deb`
- **RedHat**: `name-version-release.architecture.rpm`
- **Alpine**: `name-version.apk`

## 2. Fork and Create a Branch

1.  Fork this repository.
2.  Create a new branch for your package: `git checkout -b add-package-name`

## 3. Place Your Package

Move your package file into the appropriate `incoming/` directory:
- `incoming/debian/`
- `incoming/redhat/`
- `incoming/alpine/`

## 4. Submit a Pull Request

1.  Commit and push your changes to your fork.
2.  Open a Pull Request targeting the `main` branch of this repository.
3.  Fill out the PR template with the package details.

## 5. Automated Validation

Once you open a PR, our automated CI system will:
1.  Run linting tools (`lintian`, `rpmlint`, etc.).
2.  Check for existing version conflicts.
3.  Verify the package metadata.

If the validation fails, please check the CI logs and fix the reported issues.

## 6. Approval and Merge

A maintainer will review your PR. Once approved and merged, the package will be automatically processed into the repository and made available on the search page.

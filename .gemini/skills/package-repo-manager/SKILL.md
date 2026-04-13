---
name: package-repo-manager
description: Automates the management of Debian (APT), RedHat (YUM/DNF), and Alpine (APK) static repositories on GitHub Pages.
---

# Package Repository Manager

This skill provides specialized procedures for handling multi-format package repositories.

## 1. Repository Management

### Debian (APT)
- Use `reprepro` or `apt-ftparchive` to build metadata.
- Structure: `repo/debian/pool/` and `repo/debian/dists/`.
- Signing: Generate `InRelease` and `Release.gpg`.

### RedHat (RPM)
- Use `createrepo_c`.
- Structure: `repo/redhat/x86_64/` (or other archs).
- Signing: Use `gpg --detach-sign --armor` for the repository configuration file.

### Alpine (APK)
- Use `apk index` and `abuild-sign`.
- Structure: `repo/alpine/x86_64/`.
- Signing: Alpine requires the `APKINDEX` to be signed with an RSA key.

## 2. CI/CD Workflow

### PR Validation
- Verify that only binary package files (`.deb`, `.rpm`, `.apk`) are added to `incoming/`.
- Run format-specific linter (`lintian`, `rpmlint`).
- Check for version collisions with `repo/`.

### Processing & Deployment
1. Move packages from `incoming/` to `repo/`.
2. Re-index all formats.
3. Sign all repository metadata.
4. Deploy the `repo/` and `site/` directories to the `gh-pages` branch.

## 3. Documentation Generation
- Maintain a `packages.json` searchable index for the landing page.
- Generate user-facing `sources.list` or `.repo` snippets automatically.

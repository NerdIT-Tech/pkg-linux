#!/bin/bash
set -e

REPO_ROOT="/workspaces/pkg-linux/repo"

echo "Starting repository re-indexing..."

# --- Debian (APT) ---
if command -v apt-ftparchive >/dev/null 2>&1; then
    echo "Re-indexing Debian (APT)..."
    mkdir -p "${REPO_ROOT}/debian"
    cd "${REPO_ROOT}/debian"

    # Generate Packages file
    apt-ftparchive packages . > Packages 2>/dev/null || echo "Warning: apt-ftparchive failed (possibly no packages or invalid packages)"
    if [ -s Packages ]; then
        gzip -9c Packages > Packages.gz
        # Generate Release file
        apt-ftparchive release . > Release
    else
        echo "Note: No Debian packages found or Packages file is empty."
    fi
else
    echo "Error: apt-ftparchive not found. Debian re-indexing skipped."
fi

# --- RedHat (RPM) ---
if command -v createrepo_c >/dev/null 2>&1; then
    echo "Re-indexing RedHat (RPM)..."
    # Find all arch subdirectories in repo/redhat/
    find "${REPO_ROOT}/redhat" -mindepth 1 -maxdepth 1 -type d | while read -r arch_dir; do
        if ls "${arch_dir}"/*.rpm >/dev/null 2>&1; then
            echo "Indexing RedHat packages in ${arch_dir}..."
            createrepo_c --update "${arch_dir}/" || echo "Warning: createrepo_c failed for ${arch_dir}"
        fi
    done
else
    echo "Error: createrepo_c not found. RedHat re-indexing skipped."
fi

# --- Alpine (APK) ---
if command -v apk >/dev/null 2>&1; then
    echo "Re-indexing Alpine (APK)..."
    # Find all arch subdirectories in repo/alpine/
    find "${REPO_ROOT}/alpine" -mindepth 1 -maxdepth 1 -type d | while read -r arch_dir; do
        if ls "${arch_dir}"/*.apk >/dev/null 2>&1; then
            echo "Indexing Alpine packages in ${arch_dir}..."
            apk index -o "${arch_dir}/APKINDEX.tar.gz" "${arch_dir}"/*.apk || echo "Warning: apk index failed for ${arch_dir}"
        fi
    done
else
    echo "Error: apk not found. Alpine re-indexing skipped."
fi

echo "Metadata re-indexing complete."

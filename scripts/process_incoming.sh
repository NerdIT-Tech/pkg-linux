#!/bin/bash
set -e

# Define root paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$BASE_DIR/repo"
INCOMING_ROOT="$BASE_DIR/incoming"
SCRIPTS_DIR="$BASE_DIR/scripts"

echo "----------------------------------------------------"
echo "Processing incoming packages..."
echo "----------------------------------------------------"

# --- Debian (APT) ---
mkdir -p "${REPO_ROOT}/debian"
find "${INCOMING_ROOT}/debian" -name "*.deb" -type f | while read -r pkg; do
    echo "Moving Debian package: $(basename "$pkg")"
    mv -v "$pkg" "${REPO_ROOT}/debian/"
done

# --- RedHat (RPM) ---
find "${INCOMING_ROOT}/redhat" -name "*.rpm" -type f | while read -r pkg; do
    # Detect architecture using rpm command if available, otherwise fallback to filename
    ARCH="x86_64"
    if command -v rpm >/dev/null 2>&1; then
        ARCH=$(rpm -qp --queryformat '%{ARCH}' "$pkg" 2>/dev/null || echo "x86_64")
    elif [[ "$(basename "$pkg")" =~ \.([^\.]+)\.rpm$ ]]; then
        ARCH="${BASH_REMATCH[1]}"
    fi

    mkdir -p "${REPO_ROOT}/redhat/${ARCH}"
    echo "Moving RedHat package: $(basename "$pkg") to ${ARCH}/"
    mv -v "$pkg" "${REPO_ROOT}/redhat/${ARCH}/"
done

# --- Alpine (APK) ---
# Alpine repositories require architecture-specific subdirectories.
find "${INCOMING_ROOT}/alpine" -name "*.apk" -type f | while read -r pkg; do
    # Detect architecture from the path or filename
    # Defaulting to x86_64 if not found in path
    ARCH="x86_64"
    if [[ "$pkg" =~ /(x86_64|x86|armhf|armv7|aarch64|s390x|ppc64le)/ ]]; then
        ARCH="${BASH_REMATCH[1]}"
    elif [[ "$(basename "$pkg")" =~ \.([^\.]+)\.apk$ ]]; then
        # Some apk files have arch in name before .apk
        ARCH="${BASH_REMATCH[1]}"
    fi
    
    mkdir -p "${REPO_ROOT}/alpine/${ARCH}"
    echo "Moving Alpine package: $(basename "$pkg") to ${ARCH}/"
    mv -v "$pkg" "${REPO_ROOT}/alpine/${ARCH}/"
done

# --- Post-Processing ---

echo ""
echo "Triggering re-indexing..."
"${SCRIPTS_DIR}/re-index.sh"

echo ""
echo "Triggering signing..."
"${SCRIPTS_DIR}/sign-repo.sh"

echo "----------------------------------------------------"
echo "Incoming packages processing complete."
echo "----------------------------------------------------"

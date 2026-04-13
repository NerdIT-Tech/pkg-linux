#!/bin/bash
set -e

REPO_ROOT="/workspaces/pkg-linux/repo"

echo "Signing repository metadata..."

# --- GPG Signer Check & Import ---
if command -v gpg >/dev/null 2>&1; then
    if [ -n "$GPG_PRIVATE_KEY" ]; then
        echo "Importing GPG Private Key..."
        echo "$GPG_PRIVATE_KEY" | gpg --batch --import || echo "Warning: GPG key import failed."
    fi
else
    echo "Error: gpg not found. Debian and RedHat signing skipped."
fi

# --- Debian (APT) ---
if command -v gpg >/dev/null 2>&1 && [ -f "${REPO_ROOT}/debian/Release" ]; then
    echo "Signing Debian Release..."
    cd "${REPO_ROOT}/debian"
    # Create Release.gpg (detached signature)
    gpg --yes --batch --armor --detach-sign --output Release.gpg Release || echo "Warning: GPG signing for Debian Release failed."
    # Create InRelease (inline signature)
    gpg --yes --batch --armor --clearsign --output InRelease Release || echo "Warning: GPG signing for Debian InRelease failed."
fi

# --- RedHat (RPM) ---
if command -v gpg >/dev/null 2>&1 && [ -f "${REPO_ROOT}/redhat/repodata/repomd.xml" ]; then
    echo "Signing RedHat repomd.xml..."
    gpg --yes --batch --armor --detach-sign "${REPO_ROOT}/redhat/repodata/repomd.xml" || echo "Warning: GPG signing for RedHat repomd.xml failed."
fi

# --- Alpine (APK) ---
# Alpine requires the APKINDEX.tar.gz to be signed with an RSA key.
find "${REPO_ROOT}/alpine" -name "APKINDEX.tar.gz" | while read -r index_file; do
    echo "Signing Alpine APKINDEX: ${index_file}"
    if command -v abuild-sign >/dev/null 2>&1; then
        if [ -n "$RSA_PRIVATE_KEY" ]; then
            # If the key is provided in an environment variable, use it.
            KEY_FILE=$(mktemp)
            echo "$RSA_PRIVATE_KEY" > "$KEY_FILE"
            abuild-sign -k "$KEY_FILE" "$index_file" || echo "Warning: abuild-sign failed for ${index_file}"
            rm "$KEY_FILE"
        elif ls ~/.abuild/*.rsa >/dev/null 2>&1; then
            # Use existing key in ~/.abuild/
            abuild-sign "$index_file" || echo "Warning: abuild-sign failed for ${index_file}"
        else
            echo "Warning: No Alpine private key found in \$RSA_PRIVATE_KEY or ~/.abuild/. APKINDEX will not be signed."
        fi
    else
        echo "Error: abuild-sign not found. Alpine signing skipped."
    fi
done

echo "Signing complete."

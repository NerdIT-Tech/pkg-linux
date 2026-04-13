#!/bin/bash
set -e

REPO_ROOT="/workspaces/pkg-linux/repo"
mkdir -p "$REPO_ROOT"

echo "Checking for repository signing keys..."

# --- GPG Key (Debian/RedHat) ---
if ! gpg --list-keys "Package Repo" >/dev/null 2>&1; then
    echo "Generating GPG key for Debian/RedHat..."
    cat >gpg-batch <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: RSA
     Key-Length: 4096
     Subkey-Type: RSA
     Subkey-Length: 4096
     Name-Real: Package Repo
     Name-Email: repo@example.com
     Expire-Date: 0
     %no-ask-passphrase
     %no-protection
     %commit
     %echo done
EOF
    gpg --batch --generate-key gpg-batch
    rm gpg-batch
fi

echo "Exporting GPG public key..."
gpg --armor --export "Package Repo" > "${REPO_ROOT}/public.gpg"
gpg --armor --export "Package Repo" > "${REPO_ROOT}/public.asc"

# --- RSA Key (Alpine) ---
if [ ! -f "alpine.rsa" ]; then
    echo "Generating RSA key for Alpine..."
    openssl genrsa -out alpine.rsa 4096
fi

echo "Exporting Alpine public key..."
openssl rsa -in alpine.rsa -pubout -out "${REPO_ROOT}/alpine.rsa.pub"

echo "Public keys exported to ${REPO_ROOT}:"
ls -l "${REPO_ROOT}/public.gpg" "${REPO_ROOT}/public.asc" "${REPO_ROOT}/alpine.rsa.pub"

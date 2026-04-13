#!/bin/bash
set -e

# Base directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
INCOMING_DIR="$BASE_DIR/incoming"
REPO_DIR="$BASE_DIR/repo"

# Helper for errors
error() {
    echo "ERROR: $1" >&2
    exit 1
}

# Validation for Debian
validate_debian() {
    local file="$1"
    echo "--- Validating Debian package: $(basename "$file") ---"
    [[ "$file" == *.deb ]] || error "Invalid extension for Debian package: $file. Expected .deb"
    
    # Check for version collision
    local filename=$(basename "$file")
    if find "$REPO_DIR/debian" -name "$filename" | grep -q .; then
        error "Version collision: $filename already exists in $REPO_DIR/debian"
    fi

    # Integrity check
    if command -v dpkg-deb > /dev/null; then
        dpkg-deb -I "$file" > /dev/null || error "Invalid Debian package (integrity check failed): $file"
    fi

    # Linter
    if command -v lintian > /dev/null; then
        echo "Running lintian..."
        lintian --no-tag-display-limit --profile debian "$file" || echo "Lintian found some issues."
    else
        echo "Lintian not found, skipping linting."
    fi

    # Check for suspicious scripts
    if command -v dpkg-deb > /dev/null; then
        echo "Checking for maintainer scripts..."
        # Extract scripts and check for suspicious commands
        for script in postinst preinst postrm prerm control; do
            if dpkg-deb -I "$file" "$script" 2>/dev/null | grep -E "rm -rf /|curl|wget" | grep -v "curl.*\.gpg"; then
                echo "WARNING: Suspicious keywords found in $script script."
            fi
        done
    fi
}

# Validation for RedHat
validate_redhat() {
    local file="$1"
    echo "--- Validating RedHat package: $(basename "$file") ---"
    [[ "$file" == *.rpm ]] || error "Invalid extension for RedHat package: $file. Expected .rpm"
    
    local filename=$(basename "$file")
    if find "$REPO_DIR/redhat" -name "$filename" | grep -q .; then
        error "Version collision: $filename already exists in $REPO_DIR/redhat"
    fi

    # Integrity check
    if command -v rpm > /dev/null; then
        rpm -qp "$file" > /dev/null || error "Invalid RedHat package (integrity check failed): $file"
    fi

    # Linter
    if command -v rpmlint > /dev/null; then
        echo "Running rpmlint..."
        rpmlint "$file" || echo "Rpmlint found some issues."
    else
        echo "Rpmlint not found, skipping linting."
    fi

    # Check for suspicious scripts
    if command -v rpm > /dev/null; then
        echo "Checking for scripts..."
        rpm -qp --scripts "$file" | grep -E "rm -rf /|curl|wget" | grep -v "curl.*\.gpg" && echo "WARNING: Suspicious keywords found in scripts." || true
    fi
}

# Validation for Alpine
validate_alpine() {
    local file="$1"
    echo "--- Validating Alpine package: $(basename "$file") ---"
    [[ "$file" == *.apk ]] || error "Invalid extension for Alpine package: $file. Expected .apk"
    
    local filename=$(basename "$file")
    if find "$REPO_DIR/alpine" -name "$filename" | grep -q .; then
        error "Version collision: $filename already exists in $REPO_DIR/alpine"
    fi
    
    # Simple integrity check if tar is available (apk files are tar.gz)
    tar -ztf "$file" > /dev/null || error "Invalid Alpine package (not a valid tar.gz): $file"
}

# Count files to validate
FILE_COUNT=$(find "$INCOMING_DIR" -type f ! -name ".gitkeep" | wc -l)
if [ "$FILE_COUNT" -eq 0 ]; then
    echo "No packages to validate in incoming/."
    exit 0
fi

# Find all files in incoming/
find "$INCOMING_DIR" -type f ! -name ".gitkeep" -print0 | while IFS= read -r -d '' file; do
    rel_path="${file#$INCOMING_DIR/}"
    case "$rel_path" in
        debian/*)
            validate_debian "$file"
            ;;
        redhat/*)
            validate_redhat "$file"
            ;;
        alpine/*)
            validate_alpine "$file"
            ;;
        *)
            error "File in invalid location: $rel_path. Packages must be in incoming/debian/, incoming/redhat/, or incoming/alpine/"
            ;;
    esac
done

echo "Validation successful!"

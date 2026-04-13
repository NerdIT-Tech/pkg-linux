#!/bin/bash

# scripts/generate_index.sh
# Generates site/packages.json with a list of all packages in the repo/ directory.

REPO_DIR="/workspaces/pkg-linux/repo"
OUTPUT_FILE="/workspaces/pkg-linux/site/packages.json"

echo "[" > "$OUTPUT_FILE"
FIRST=true

# Find Debian packages
find "$REPO_DIR/debian" -name "*.deb" | while read -r file; do
    if [ "$FIRST" = true ]; then FIRST=false; else echo "," >> "$OUTPUT_FILE"; fi
    filename=$(basename "$file")
    # Debian format: name_version_arch.deb
    IFS='_' read -r name version arch_ext <<< "$filename"
    arch=${arch_ext%.deb}
    echo "  {\"name\": \"$name\", \"version\": \"$version\", \"arch\": \"$arch\", \"dist\": \"debian\", \"url\": \"repo/debian/$filename\"}" >> "$OUTPUT_FILE"
done

# Find RedHat packages
find "$REPO_DIR/redhat" -name "*.rpm" | while read -r file; do
    if [ "$FIRST" = true ]; then FIRST=false; else echo "," >> "$OUTPUT_FILE"; fi
    filename=$(basename "$file")
    # RedHat format: name-version-release.arch.rpm
    # This is trickier, but let's do a simple split
    name_version_release_arch=${filename%.rpm}
    # Usually: last part is arch, second to last is release+version
    arch=${name_version_release_arch##*.}
    name_v_r=${name_version_release_arch%.*}
    # Simplified version for now
    echo "  {\"name\": \"$name_v_r\", \"version\": \"unknown\", \"arch\": \"$arch\", \"dist\": \"redhat\", \"url\": \"repo/redhat/$filename\"}" >> "$OUTPUT_FILE"
done

# Find Alpine packages
find "$REPO_DIR/alpine" -name "*.apk" | while read -r file; do
    if [ "$FIRST" = true ]; then FIRST=false; else echo "," >> "$OUTPUT_FILE"; fi
    filename=$(basename "$file")
    # Alpine format: name-version.apk
    name_version=${filename%.apk}
    echo "  {\"name\": \"$name_version\", \"version\": \"unknown\", \"arch\": \"unknown\", \"dist\": \"alpine\", \"url\": \"repo/alpine/$filename\"}" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE"

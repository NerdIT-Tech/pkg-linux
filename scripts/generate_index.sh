#!/bin/bash

# scripts/generate_index.sh
# Generates data/packages.json with a list of all packages in the repo/ directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
REPO_DIR="$BASE_DIR/repo"
OUTPUT_FILE="$BASE_DIR/data/packages.json"

echo "Generating package index..."

# Use a temporary file to build the JSON array entries
TEMP_FILE=$(mktemp)
echo "" > "$TEMP_FILE"

# Find Debian packages
while read -r file; do
    [ -z "$file" ] && continue
    filename=$(basename "$file")
    IFS='_' read -r name version arch_ext <<< "$filename"
    arch=${arch_ext%.deb}
    echo "  {\"name\": \"$name\", \"version\": \"$version\", \"arch\": \"$arch\", \"dist\": \"debian\", \"url\": \"repo/debian/$filename\"}" >> "$TEMP_FILE"
done < <(find "$REPO_DIR/debian" -name "*.deb" 2>/dev/null)

# Find RedHat packages
while read -r file; do
    [ -z "$file" ] && continue
    filename=$(basename "$file")
    name_version_release_arch=${filename%.rpm}
    arch=${name_version_release_arch##*.}
    name_v_r=${name_version_release_arch%.*}
    echo "  {\"name\": \"$name_v_r\", \"version\": \"unknown\", \"arch\": \"$arch\", \"dist\": \"redhat\", \"url\": \"repo/redhat/$filename\"}" >> "$TEMP_FILE"
done < <(find "$REPO_DIR/redhat" -name "*.rpm" 2>/dev/null)

# Find Alpine packages
while read -r file; do
    [ -z "$file" ] && continue
    filename=$(basename "$file")
    name_version=${filename%.apk}
    echo "  {\"name\": \"$name_version\", \"version\": \"unknown\", \"arch\": \"unknown\", \"dist\": \"alpine\", \"url\": \"repo/alpine/$filename\"}" >> "$TEMP_FILE"
done < <(find "$REPO_DIR/alpine" -name "*.apk" 2>/dev/null)

# Now assemble the final JSON
echo "[" > "$OUTPUT_FILE"
# Filter out empty lines and then join with commas
grep "{" "$TEMP_FILE" | sed '$!s/$/,/' >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

rm "$TEMP_FILE"
echo "Generated $OUTPUT_FILE"

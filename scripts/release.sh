#!/bin/bash

# TK Release Script
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.1.0

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: ./scripts/release.sh <version>"
    echo "Example: ./scripts/release.sh 1.1.0"
    exit 1
fi

echo "Releasing TK v$VERSION..."

# Update package.json version
sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" package.json

# Update plugin.json version
sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" .claude-plugin/plugin.json

# Add to changelog
DATE=$(date +%Y-%m-%d)
CHANGELOG_ENTRY="## [$VERSION] - $DATE\n\n### Changed\n- [Add changes here]\n"

# Prepend to changelog after the header
sed -i "/^# Changelog/a\\
\\
$CHANGELOG_ENTRY" CHANGELOG.md

echo "Updated package.json, plugin.json, and CHANGELOG.md"
echo ""
echo "Next steps:"
echo "  1. Edit CHANGELOG.md with actual changes"
echo "  2. git add -A"
echo "  3. git commit -m \"v$VERSION\""
echo "  4. git tag v$VERSION"
echo "  5. git push origin main --tags"
echo "  6. npm publish (optional)"

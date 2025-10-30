#!/bin/bash
set -e

# Create version tag in target repository
# Usage: ./tag-version.sh <target_repo> <version>

TARGET_REPO="${1}"
VERSION="${2}"
GITHUB_TOKEN="${GH_TOKEN}"

echo "🏷️  Tagging ${TARGET_REPO} with ${VERSION}"

# Clone target repository
TEMP_DIR="/tmp/tag-repo-$$"
gh repo clone "${TARGET_REPO}" "${TEMP_DIR}"
cd "${TEMP_DIR}"

# Configure git authentication
git config url."https://x-access-token:${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

# Configure git user
git config user.name 'github-actions[bot]'
git config user.email 'github-actions[bot]@users.noreply.github.com'

# Check if tag already exists
if git rev-parse "${VERSION}" >/dev/null 2>&1; then
  echo "⚠️  Tag ${VERSION} already exists"
  exit 0
fi

# Create and push tag
git tag "${VERSION}"
git push origin "${VERSION}"

echo "✅ Tag ${VERSION} created successfully"

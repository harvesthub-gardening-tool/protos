#!/bin/bash
set -e

# Publish generated code to a separate repository
# Usage: ./publish-to-repo.sh <source_dir> <target_repo> <branch_name> <commit_sha>

SOURCE_DIR="$(realpath "${1}")"
TARGET_REPO="${2}"
BRANCH_NAME="${3}"
COMMIT_SHA="${4}"
GITHUB_TOKEN="${GH_TOKEN}"

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "❌ Error: GH_TOKEN environment variable not set"
  exit 1
fi

echo "📤 Publishing to ${TARGET_REPO}:${BRANCH_NAME}"

# Clone target repository
TEMP_DIR="/tmp/target-repo-$$"
gh repo clone "${TARGET_REPO}" "${TEMP_DIR}"
cd "${TEMP_DIR}"

# Configure git authentication
git config url."https://x-access-token:${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

# Checkout or create branch
echo "Switching to branch: ${BRANCH_NAME}"
git checkout "${BRANCH_NAME}" 2>/dev/null || git checkout -b "${BRANCH_NAME}"

# Replace all content
echo "Copying generated files..."
rm -rf ./*
cp -r "${SOURCE_DIR}"/* .

# Commit changes
git config user.name 'github-actions[bot]'
git config user.email 'github-actions[bot]@users.noreply.github.com'
git add .

if git diff --quiet --staged; then
  echo "ℹ️  No changes to publish"
  exit 0
fi

git commit -m "Generate proto code from ${COMMIT_SHA}"
git push origin "${BRANCH_NAME}"

echo "✅ Published successfully"

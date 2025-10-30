#!/bin/bash
set -e

# Clean up merged branches from target repository
# Usage: ./cleanup-merged-branches.sh <target_repo> <source_repo>

TARGET_REPO="${1}"
SOURCE_REPO="${2}"
GITHUB_TOKEN="${GH_TOKEN}"

echo "🧹 Cleaning up merged branches in ${TARGET_REPO}"

# Clone target repository
TEMP_DIR="/tmp/cleanup-repo-$$"
gh repo clone "${TARGET_REPO}" "${TEMP_DIR}"
cd "${TEMP_DIR}"

# Configure git authentication
git config url."https://x-access-token:${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

# Fetch all branches
git fetch --all

# Get all remote branches except main and HEAD
BRANCHES=$(git branch -r | grep -v 'HEAD' | grep -v 'main' | sed 's|origin/||' | xargs)

if [ -z "${BRANCHES}" ]; then
  echo "ℹ️  No branches to clean up"
  exit 0
fi

# Check each branch
for BRANCH in ${BRANCHES}; do
  echo "Checking branch: ${BRANCH}"
  
  # Check if corresponding branch exists in source repo
  if ! git ls-remote --heads "https://github.com/${SOURCE_REPO}.git" "${BRANCH}" | grep -q "${BRANCH}"; then
    echo "🗑️  Deleting merged branch: ${BRANCH}"
    git push origin --delete "${BRANCH}" || echo "⚠️  Failed to delete ${BRANCH}"
  else
    echo "✓ Branch ${BRANCH} still exists in source repo"
  fi
done

echo "✅ Cleanup complete"

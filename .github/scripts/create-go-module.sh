#!/bin/bash
set -e

# Create Go module with proper dependencies
# Usage: ./create-go-module.sh <output_dir> <module_name> <git_ref>

OUTPUT_DIR="${1}"
MODULE_NAME="${2}"
GIT_REF="${3}"

echo "📦 Creating Go module in ${OUTPUT_DIR}"

cd "${OUTPUT_DIR}"

# Determine version from git ref
if [[ "${GIT_REF}" == refs/tags/v* ]]; then
  VERSION="${GIT_REF#refs/tags/}"
  echo "Using tagged version: ${VERSION}"
else
  COMMIT_SHA=$(git rev-parse --short HEAD)
  VERSION="v0.0.0-${COMMIT_SHA}"
  echo "Using pseudo-version: ${VERSION}"
fi

# Create go.mod
cat > go.mod << EOF
module ${MODULE_NAME}

go 1.23

require (
  connectrpc.com/connect v1.19.1
  google.golang.org/protobuf v1.36.10
)
EOF

echo "✅ go.mod created"

# Tidy dependencies
go mod tidy

echo "✅ Dependencies resolved"

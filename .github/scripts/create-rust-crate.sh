#!/bin/bash
set -e

# Create Rust crate with proper dependencies
# Usage: ./create-rust-crate.sh <output_dir> <crate_name> <git_ref>

OUTPUT_DIR="${1}"
CRATE_NAME="${2}"
GIT_REF="${3}"

echo "📦 Creating Rust crate in ${OUTPUT_DIR}"

cd "${OUTPUT_DIR}"

# Determine version from git ref
if [[ "${GIT_REF}" == refs/tags/v* ]]; then
  VERSION="${GIT_REF#refs/tags/v}"
  echo "Using tagged version: ${VERSION}"
else
  COMMIT_SHA=$(git rev-parse --short HEAD)
  VERSION="0.0.0-${COMMIT_SHA}"
  echo "Using pseudo-version: ${VERSION}"
fi

# Create Cargo.toml
cat > Cargo.toml << EOF
[package]
name = "${CRATE_NAME}"
version = "${VERSION}"
edition = "2021"
license = "MIT OR Apache-2.0"
description = "Protocol Buffer definitions for Harvest Hub"
repository = "https://github.com/harvesthub-gardening-tool/protos-rust"

[dependencies]
prost = "0.14"
tonic = "0.14"
tonic-prost = "0.14"
EOF

echo "✅ Cargo.toml created"

# Auto-generate src/lib.rs from discovered proto packages
mkdir -p src
{
  echo '//! Harvest Hub Protocol Buffer definitions'
  echo ''

  # Find all generated prost files (skip tonic companion files — they are
  # pulled in automatically via include!() inside the prost file).
  find . -name '*.rs' -not -path './src/*' -not -name '*.tonic.rs' | sort | while read -r pkg_file; do
    rel_path="${pkg_file#./}"                  # garden/v1/garden.v1.rs
    pkg_name="$(basename "$pkg_file" .rs)"     # garden.v1
    IFS='.' read -ra parts <<< "$pkg_name"     # (garden v1)

    indent=""
    for part in "${parts[@]}"; do
      echo "${indent}pub mod ${part} {"
      indent="${indent}    "
    done
    echo "${indent}include!(\"../${rel_path}\");"
    for part in "${parts[@]}"; do
      indent="${indent#    }"
      echo "${indent}}"
    done
    echo ""
  done
} > src/lib.rs
echo "✅ src/lib.rs auto-generated"

echo "✅ Rust crate structure complete"

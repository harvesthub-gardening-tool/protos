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
prost = "0.13"
tonic = "0.12"

[build-dependencies]
tonic-build = "0.12"
EOF

echo "✅ Cargo.toml created"

# Create lib.rs if it doesn't exist
if [ ! -f "src/lib.rs" ]; then
  mkdir -p src
  cat > src/lib.rs << 'EOF'
//! Harvest Hub Protocol Buffer definitions
//!
//! This crate contains generated Rust code from the Harvest Hub protobuf definitions.

pub mod garden {
    pub mod v1 {
        tonic::include_proto!("garden.v1");
    }
}
EOF
  echo "✅ src/lib.rs created"
fi

echo "✅ Rust crate structure complete"

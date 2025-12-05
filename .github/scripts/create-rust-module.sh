#!/bin/bash
set -e

# Create Rust module with proper dependencies
# Usage: ./create-rust-module.sh <output_dir>

OUTPUT_DIR="${1}"

echo "📦 Preparing Rust module in ${OUTPUT_DIR}"

cd "${OUTPUT_DIR}"

# Create Cargo.toml if not exists
if [ ! -f "Cargo.toml" ]; then
  cat > Cargo.toml << EOF
[package]
name = "protos-rust-harvesthub"
authors = "harvesthub"
version = "0.1.0"
edition = "2024"

[dependencies]
prost = "0.14"
tonic = "0.14.2"
EOF
  echo "✅ Cargo.toml created"
fi

# Format code
cargo fmt

echo "✅ Rust module prepared"


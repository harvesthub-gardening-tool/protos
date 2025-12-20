#!/bin/bash
set -e

# Create TypeScript/NPM package with proper dependencies
# Usage: ./create-typescript-package.sh <output_dir> <package_name> <git_ref>

OUTPUT_DIR="${1}"
PACKAGE_NAME="${2}"
GIT_REF="${3}"

echo "📦 Creating TypeScript package in ${OUTPUT_DIR}"

cd "${OUTPUT_DIR}"

# Determine version from git ref
if [[ "${GIT_REF}" == refs/tags/v* ]]; then
  VERSION="${GIT_REF#refs/tags/v}"
  echo "Using tagged version: ${VERSION}"
else
  COMMIT_SHA=$(git rev-parse --short HEAD)
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  VERSION="0.0.0-dev.${TIMESTAMP}.${COMMIT_SHA}"
  echo "Using dev version: ${VERSION}"
fi

# Create package.json
cat > package.json << EOF
{
  "name": "${PACKAGE_NAME}",
  "version": "${VERSION}",
  "description": "Generated TypeScript code from Protocol Buffers",
  "type": "module",
  "main": "./index.ts",
  "types": "./index.ts",
  "exports": {
    ".": "./index.ts",
    "./*": "./*.ts"
  },
  "scripts": {
  "build": "tsc",
  "prepare": "npm run build"
  },
  "keywords": [
    "protobuf",
    "grpc",
    "connect",
    "typescript"
  ],
  "license": "MIT",
  "peerDependencies": {
    "@bufbuild/protobuf": "^2.2.2",
    "@connectrpc/connect": "^2.0.0",
    "typescript": ">=5.0.0"
  }
}
EOF

echo "✅ package.json created"

# Create tsconfig.json
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ES2020",
    "lib": ["ES2020"],
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "isolatedModules": true
  },
  "include": ["**/*.ts"],
  "exclude": ["node_modules", "dist", "**/*.d.ts"]
}
EOF

echo "✅ tsconfig.json created"

# Create README.md
cat > README.md << EOF
# ${PACKAGE_NAME}

Generated TypeScript code from Protocol Buffers.

## Installation

\`\`\`bash
npm install ${PACKAGE_NAME}
\`\`\`

## Usage

\`\`\`typescript
import { /* your generated types */ } from '${PACKAGE_NAME}';
\`\`\`

## Version

Generated from commit: \`${COMMIT_SHA:-unknown}\`

Version: \`${VERSION}\`
EOF

echo "✅ README.md created"

# Create index.ts with namespaced exports to avoid symbol conflicts
cat > index.ts << 'EOF'
// Auto-generated index file
// Namespaced exports to avoid name collisions between *_pb and *_connect files.
EOF

# Export each generated file under a unique namespace based on its path
find . \( -name "*_pb.ts" -o -name "*_connect.ts" \) | sort | while read -r file; do
  relative_path="${file#./}"          # e.g. garden/v1/garden_pb.ts
  import_path="${relative_path%.ts}"  # e.g. garden/v1/garden_pb

  # Build a safe namespace name from the path:
  # garden/v1/garden_pb -> garden_v1_garden_pb
  ns="${import_path//\//_}"
  ns="${ns//-/_}"
  ns="${ns//./_}"

  echo "export * as ${ns} from './${import_path}.js';" >> index.ts
done

echo "✅ index.ts created"

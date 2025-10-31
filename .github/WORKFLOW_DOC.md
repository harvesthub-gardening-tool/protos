# GitHub Actions Structure

This directory contains modular workflows and scripts for proto code generation and publishing.

## 📁 Structure

```
.github/
├── workflows/
│   ├── generate.yml       # Main workflow: validates and generates code
│   ├── publish-go.yml     # Publishes Go code to protos-go repo
│   ├── publish-rust.yml   # Publishes Rust code to protos-rust repo (future)
│   └── publish-docs.yml   # Publishes docs to GitHub Pages (future)
│
└── scripts/
    ├── create-go-module.sh          # Creates go.mod with dependencies
    ├── publish-to-repo.sh           # Publishes code to target repo
    ├── cleanup-merged-branches.sh   # Cleans up merged PR branches
    └── tag-version.sh               # Tags versions in target repo
```

## 🔄 Workflow Flow

### 1. **generate.yml** - Code Generation

Triggers on: Push to any branch, PRs to main

**Jobs:**

- `validate` - Lints proto files
- `generate-go` - Generates Go code
- `generate-docs` - Generates OpenAPI documentation

### 2. **publish-go.yml** - Go Publishing

Triggers on: Successful completion of `generate.yml` on push events

**Jobs:**

- `publish-go` - Publishes to `protos-go` repository
  - Main branch → publishes to `protos-go/main`
  - Feature branch → publishes to `protos-go/feature-branch`
- `cleanup-go` - Deletes merged branches from `protos-go`
- `tag-go` - Creates version tags in `protos-go`

## 🛠️ Scripts Reference

### create-go-module.sh

Creates a Go module with proper dependencies.

```bash
./create-go-module.sh <output_dir> <module_name> <git_ref>

# Example:
./create-go-module.sh "gen/go" "github.com/org/protos-go" "refs/heads/main"
```

### publish-to-repo.sh

Publishes generated code to a target repository.

```bash
./publish-to-repo.sh <source_dir> <target_repo> <branch_name> <commit_sha>

# Example:
./publish-to-repo.sh "gen/go" "org/protos-go" "main" "abc123"
```

**Environment:** Requires `GH_TOKEN` environment variable

### cleanup-merged-branches.sh

Cleans up branches in target repo that no longer exist in source.

```bash
./cleanup-merged-branches.sh <target_repo> <source_repo>

# Example:
./cleanup-merged-branches.sh "org/protos-go" "org/protos"
```

**Environment:** Requires `GH_TOKEN` environment variable

### tag-version.sh

Creates a version tag in the target repository.

```bash
./tag-version.sh <target_repo> <version>

# Example:
./tag-version.sh "org/protos-go" "v1.0.0"
```

**Environment:** Requires `GH_TOKEN` environment variable

## 🔐 Required Secrets

- `PAT_PROTO_PUBLISH` - Personal Access Token with repo permissions
  - Used by publish workflows to push to target repositories

## 📝 Adding New Languages

To add support for a new language (e.g., Python):

1. Create generation template: `buf.gen.python.yaml`
2. Add generation job to `generate.yml`:
   ```yaml
   generate-python:
     needs: validate
     steps:
       - name: Generate Python code
         run: buf generate --template buf.gen.python.yaml
   ```
3. Create publish workflow: `publish-python.yml`
4. Create module setup script: `create-python-package.sh`
5. Reuse existing `publish-to-repo.sh` script

## 🎯 Benefits

- **Modular**: Each language has its own workflow
- **Reusable**: Scripts can be used across all languages
- **Maintainable**: Easy to understand and modify
- **Testable**: Can test PR branches before merging
- **Clean**: Auto-cleanup of merged branches

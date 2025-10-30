# Harvest Hub - Protocol Buffers

Central repository for all Harvest Hub API definitions using Protocol Buffers with automated code generation and publishing.

## 📚 Documentation

**Live API Docs:** https://harvesthub-gardening-tool.github.io/protos/

Interactive Swagger UI with all API endpoints, request/response examples, and schemas.

## 🏗️ Structure

```
.
├── garden/v1/           # Garden service proto definitions
├── .github/
│   ├── workflows/       # Automated CI/CD pipelines
│   │   ├── generate.yml      # Validates & generates code
│   │   ├── publish-go.yml    # Publishes to protos-go repo
│   │   └── publish-docs.yml  # Deploys docs to GitHub Pages
│   └── scripts/         # Reusable automation scripts
├── buf.gen.go.yaml      # Go generation config
├── buf.gen.docs.yaml    # OpenAPI generation config
└── buf.gen.rust.yaml    # Rust generation config (future)
```

## 🚀 Usage in Your Projects

### Go (Recommended)

The Go code is automatically published to a separate repository:

```bash
go get github.com/harvesthub-gardening-tool/protos-go@latest
```

Import in your code:

```go
import (
    gardenv1 "github.com/harvesthub-gardening-tool/protos-go/garden/v1"
    "github.com/harvesthub-gardening-tool/protos-go/garden/v1/gardenv1connect"
)
```

**Test feature branches before merging:**

```bash
go get github.com/harvesthub-gardening-tool/protos-go@feature/your-branch
```

### OpenAPI/Swagger

Access the OpenAPI spec:

- **Interactive docs:** https://harvesthub-gardening-tool.github.io/protos/
- **JSON spec:** https://harvesthub-gardening-tool.github.io/protos/api.swagger.json

Use with Swagger UI, Postman, or any OpenAPI-compatible tool.

## 💻 Development

### Prerequisites

- [Buf CLI](https://buf.build/docs/installation)

### Local Code Generation

```bash
# Generate Go code
buf generate --template buf.gen.go.yaml

# Generate OpenAPI/Swagger docs
buf generate --template buf.gen.docs.yaml

# Lint proto files
buf lint
```

## 🔄 Automated Workflows

### Feature Branch Development

```bash
# 1. Create feature branch
git checkout -b feature/new-sensor-type
vim garden/v1/garden.proto

# 2. Push to GitHub
git push origin feature/new-sensor-type
```

**What happens automatically:**

- ✅ Validates proto files
- ✅ Generates code
- ✅ Publishes to `protos-go/feature/new-sensor-type`
- ✅ You can test with: `go get @feature/new-sensor-type`

### Merging to Main

When you merge a PR:

- ✅ Publishes to `protos-go/main`
- ✅ Updates docs at GitHub Pages
- ✅ Auto-deletes feature branch from `protos-go`

### Version Tagging

```bash
git tag v1.0.0
git push origin v1.0.0
```

- ✅ Creates same tag in `protos-go`
- ✅ Allows version pinning: `go get @v1.0.0`

## 📦 Published Artifacts

| Artifact | Location                                                            | Auto-Updated     |
| -------- | ------------------------------------------------------------------- | ---------------- |
| Go Code  | [protos-go](https://github.com/harvesthub-gardening-tool/protos-go) | ✅ On every push |
| API Docs | [GitHub Pages](https://harvesthub-gardening-tool.github.io/protos/) | ✅ On main push  |

## 🛠️ Adding New Services

1. Create proto file: `your_service/v1/service.proto`
2. Update `buf.yaml` if needed
3. Push changes
4. GitHub Actions automatically generates and publishes code
5. Import in your projects with `go get`

## 📖 Learn More

- [Workflow Documentation](.github/WORKFLOW_DOC.md) - How the automation works
- [Workflow Review](.github/WORKFLOW_REVIEW.md) - Complete scenarios and validation

## License

Part of the Harvest Hub project.

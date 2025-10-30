# Harvest Hub - Protocol Buffers

Central repository for all Harvest Hub API definitions using Protocol Buffers.

## Structure

```
.
├── proto/              # Proto definitions
│   └── garden/v1/      # Garden service API
├── gen/                # Generated code (auto-generated)
│   ├── go/             # Go packages
│   └── rust/           # Rust packages
├── buf.gen.go.yaml     # Go generation config
└── buf.gen.rust.yaml   # Rust generation config
```

## Usage in Your Projects

### OpenAPI/Swagger Documentation

After generation, the OpenAPI v2 (Swagger) documentation is available at:
- `gen/openapiv2/api.swagger.json`

You can use this with Swagger UI, Postman, or any OpenAPI-compatible tool to explore the API.

### Go (Server)

```bash
go get github.com/harvesthub-gardening-tool/protos-go@latest
```

Then import:
```go
import (
    gardenv1 "github.com/harvesthub-gardening-tool/protos-go/garden/v1"
    "github.com/harvesthub-gardening-tool/protos-go/garden/v1/gardenv1connect"
)
```

The generated Go code is published as a Go module on GitHub and can be imported directly.

### Rust (Client)

Add to your `Cargo.toml`:
```toml
[dependencies]
# Copy generated files from gen/rust/ to your project
# Or use git submodule/subtree
```

## Development

### Prerequisites

- [Buf CLI](https://buf.build/docs/installation)

### Generate Code Locally

```bash
# Generate Go code
buf generate --template buf.gen.go.yaml

# Generate Rust code
buf generate --template buf.gen.rust.yaml

# Generate OpenAPI/Swagger docs
buf generate --template buf.gen.docs.yaml
```

### Lint Proto Files

```bash
buf lint
```

## CI/CD

On every push to `main`, GitHub Actions automatically:
1. Lints proto files
2. Generates Go code, Rust code, and OpenAPI/Swagger docs
3. Commits generated code back to the repo

## Adding New Services

1. Create new proto file in `proto/your_service/v1/`
2. Update `buf.yaml` if needed
3. Push to trigger generation
4. Use generated code in your projects

## License

Part of the Harvest Hub project.

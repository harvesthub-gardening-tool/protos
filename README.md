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

### Go (Server)

In your `go.mod`:
```go
require github.com/harvesthub-gardening-tool/protos/gen/go v0.0.0-latest
```

Or use:
```bash
go get github.com/harvesthub-gardening-tool/protos/gen/go@main
```

Then import:
```go
import (
    gardenv1 "github.com/harvesthub-gardening-tool/protos/gen/go/garden/v1"
    "github.com/harvesthub-gardening-tool/protos/gen/go/garden/v1/gardenv1connect"
)
```

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
```

### Lint Proto Files

```bash
buf lint
```

## CI/CD

On every push to `main`, GitHub Actions automatically:
1. Lints proto files
2. Generates Go and Rust code
3. Commits generated code back to the repo

## Adding New Services

1. Create new proto file in `proto/your_service/v1/`
2. Update `buf.yaml` if needed
3. Push to trigger generation
4. Use generated code in your projects

## License

Part of the Harvest Hub project.

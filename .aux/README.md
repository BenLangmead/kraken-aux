# Auxiliary Files Directory

This directory contains system-specific and auxiliary files that are not part of the core Kraken codebase.

## diff.sh

The `diff.sh` script compares auxiliary files between the current Kraken directory and the reference `../kraken-aux` directory.

### Auxiliary files compared:
- `.aux/` directory (this directory)
- `.devcontainer/` directory (VS Code dev container configuration)
- `.vscode/` directory (VS Code settings)
- `Dockerfile` (Docker container definition)
- `run.sh` (container run script)
- `build.sh` (build script)

### Usage:
```bash
.aux/diff.sh
```

The script will:
- Display colored output showing which files/directories are identical (✓) or different (✗)
- Show detailed diff output for files that differ
- Handle cases where files exist in only one location
- Work with both files and directories

### Output:
- **Green ✓**: Files/directories are identical
- **Red ✗**: Files/directories differ (with diff details)
- **Yellow**: Informational messages or files missing from one location

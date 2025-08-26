# gut 🤔➡️🔧

**gut** is a simple and witty command-line wrapper around `git` for those moments when you accidentally type "gut" instead of "git". Instead of getting a "command not found" error, gut will give you a friendly, humorous message and then execute your intended git command.

## Features

- 🎭 **Witty Messages**: Displays random humorous quotes about your typo
- 🔄 **Seamless Forwarding**: Passes all arguments directly to git
- ❌ **Smart Error Handling**: Helpful instructions if git is not installed
- 🌍 **Cross-Platform**: Runs on Windows, macOS, and Linux
- ⚡ **Lightweight**: Small, fast, and simple

## Installation

### Quick Install (Recommended)

#### Linux & macOS
```bash
# Download and install the latest release
curl -fsSL https://raw.githubusercontent.com/geraldnguyen/gut/main/install.sh | bash
```

#### Windows (PowerShell)
```powershell
# Download and install the latest release
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/geraldnguyen/gut/main/install.ps1" | Invoke-Expression
```

### Manual Installation

#### 1. Download Pre-built Binaries

Download the appropriate binary for your platform from the [releases page](https://github.com/geraldnguyen/gut/releases):

- **Linux (amd64)**: `gut-linux-amd64`
- **Linux (arm64)**: `gut-linux-arm64` 
- **Windows (amd64)**: `gut-windows-amd64.exe`
- **Windows (arm64)**: `gut-windows-arm64.exe`
- **macOS (Intel)**: `gut-darwin-amd64`
- **macOS (Apple Silicon)**: `gut-darwin-arm64`

#### 2. Install the Binary

##### Linux & macOS
```bash
# Make it executable
chmod +x gut-*

# Move to a directory in your PATH
sudo mv gut-* /usr/local/bin/gut
```

##### Windows
1. Rename the downloaded file to `gut.exe`
2. Move it to a directory in your PATH (e.g., `C:\Windows\System32` or create a custom directory)

#### 3. Verify Installation
```bash
gut --version
```

### Build from Source

#### Prerequisites
- Go 1.19 or later
- Make (optional, for using the Makefile)

#### Build Steps
```bash
# Clone the repository
git clone https://github.com/geraldnguyen/gut.git
cd gut

# Build for current platform
make build

# Or build for all platforms
make build-all

# Install locally (Linux/macOS)
make install
```

## Usage

Simply use `gut` exactly as you would use `git`:

```bash
# Instead of getting "command not found", you get:
gut status
# 😄 'gut' feeling tells me you meant 'git'! Let me fix that for you...
# 
# On branch main
# Your branch is up to date with 'origin/main'.
# ...

gut add .
# 🎯 Close! You typed 'gut' but I think you meant 'git'. Forwarding your command...
# 

gut commit -m "Fix typo"
# 💡 'gut' reaction: this should be 'git'! No worries, I've got you covered.
# [main a1b2c3d] Fix typo
# ...
```

All git functionality works exactly the same - gut just adds a friendly message before executing your command.

## Examples

```bash
# Basic git commands work exactly the same
gut clone https://github.com/user/repo.git
gut pull origin main
gut push origin feature-branch
gut log --oneline
gut diff HEAD~1

# Advanced git commands too
gut rebase -i HEAD~3
gut cherry-pick abc123
gut bisect start
```

## Error Handling

If git is not installed on your system, gut will provide helpful installation instructions:

```
Error: git is not installed or not found in PATH.
Please install git first:
  - Windows: Download from https://git-scm.com/download/win
  - macOS: brew install git or download from https://git-scm.com/download/mac
  - Linux: apt install git / yum install git / pacman -S git
```

## Development

### Building

```bash
# Build for current platform
make build

# Build for all platforms
make build-all

# Clean build artifacts
make clean

# Show available targets
make help
```

### Testing

```bash
# Test the current build
make test

# Manual testing
./dist/gut status
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by countless developers who have typed "gut" instead of "git"
- Built with ❤️ in Go
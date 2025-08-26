# Makefile for gut - Git typo helper
# Cross-platform build support for Windows, macOS, and Linux

BINARY_NAME=gut
VERSION=1.0.0
BUILD_DIR=dist

# Go build flags
LDFLAGS=-ldflags "-s -w"

# Default target
.PHONY: all
all: clean build-all

# Clean build directory
.PHONY: clean
clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)

# Build for current platform
.PHONY: build
build:
	@echo "Building for current platform..."
	@go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) .

# Build for all platforms
.PHONY: build-all
build-all: build-linux build-windows build-macos

# Build for Linux (amd64 and arm64)
.PHONY: build-linux
build-linux:
	@echo "Building for Linux amd64..."
	@GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 .
	@echo "Building for Linux arm64..."
	@GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-arm64 .

# Build for Windows (amd64 and arm64)
.PHONY: build-windows
build-windows:
	@echo "Building for Windows amd64..."
	@GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe .
	@echo "Building for Windows arm64..."
	@GOOS=windows GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-arm64.exe .

# Build for macOS (amd64 and arm64)
.PHONY: build-macos
build-macos:
	@echo "Building for macOS amd64..."
	@GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 .
	@echo "Building for macOS arm64 (Apple Silicon)..."
	@GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 .

# Install for current platform
.PHONY: install
install: build
	@echo "Installing gut to /usr/local/bin..."
	@sudo cp $(BUILD_DIR)/$(BINARY_NAME) /usr/local/bin/
	@echo "gut installed successfully!"

# Test the build
.PHONY: test
test: build
	@echo "Testing gut build..."
	@./$(BUILD_DIR)/$(BINARY_NAME) --version || echo "Git command test completed"

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all          - Clean and build for all platforms"
	@echo "  build        - Build for current platform"
	@echo "  build-all    - Build for all platforms (Linux, Windows, macOS)"
	@echo "  build-linux  - Build for Linux (amd64 and arm64)"
	@echo "  build-windows- Build for Windows (amd64 and arm64)"
	@echo "  build-macos  - Build for macOS (amd64 and arm64)"
	@echo "  clean        - Clean build directory"
	@echo "  install      - Install gut to /usr/local/bin"
	@echo "  test         - Test the current platform build"
	@echo "  help         - Show this help message"

# Show build information
.PHONY: info
info:
	@echo "Binary name: $(BINARY_NAME)"
	@echo "Version: $(VERSION)"
	@echo "Build directory: $(BUILD_DIR)"
	@echo "Go version: $(shell go version)"
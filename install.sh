#!/bin/bash

# gut installation script for Linux and macOS
# This script downloads and installs the latest release of gut

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="geraldnguyen/gut"
BINARY_NAME="gut"
INSTALL_DIR="/usr/local/bin"

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Detect OS and architecture
detect_platform() {
    local os arch
    
    # Detect OS
    case "$(uname -s)" in
        Linux*)     os="linux" ;;
        Darwin*)    os="darwin" ;;
        *)          
            print_error "Unsupported operating system: $(uname -s)"
            print_info "This script supports Linux and macOS only."
            print_info "For Windows, please use the install.ps1 script."
            exit 1
            ;;
    esac
    
    # Detect architecture
    case "$(uname -m)" in
        x86_64|amd64)   arch="amd64" ;;
        arm64|aarch64)  arch="arm64" ;;
        *)              
            print_error "Unsupported architecture: $(uname -m)"
            print_info "Supported architectures: amd64, arm64"
            exit 1
            ;;
    esac
    
    echo "${os}-${arch}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Download file
download_file() {
    local url="$1"
    local output="$2"
    
    if command_exists curl; then
        curl -fsSL -o "$output" "$url"
    elif command_exists wget; then
        wget -q -O "$output" "$url"
    else
        print_error "Neither curl nor wget is available"
        print_info "Please install curl or wget and try again"
        exit 1
    fi
}

# Get latest release version
get_latest_version() {
    local api_url="https://api.github.com/repos/${REPO}/releases/latest"
    
    if command_exists curl; then
        curl -fsSL "$api_url" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/'
    elif command_exists wget; then
        wget -q -O - "$api_url" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/'
    else
        print_error "Neither curl nor wget is available"
        exit 1
    fi
}

# Main installation function
install_gut() {
    print_info "Installing gut - A witty Git typo helper"
    echo
    
    # Detect platform
    local platform
    platform=$(detect_platform)
    print_info "Detected platform: $platform"
    
    # Get latest version
    print_info "Fetching latest release information..."
    local version
    version=$(get_latest_version)
    
    if [ -z "$version" ]; then
        print_error "Failed to get latest release version"
        print_info "Please check your internet connection and try again"
        exit 1
    fi
    
    print_info "Latest version: $version"
    
    # Construct download URL and filename
    local filename="${BINARY_NAME}-${platform}"
    local download_url="https://github.com/${REPO}/releases/download/${version}/${filename}"
    local temp_file="/tmp/${filename}"
    
    # Download binary
    print_info "Downloading gut from GitHub releases..."
    print_info "URL: $download_url"
    
    if ! download_file "$download_url" "$temp_file"; then
        print_error "Failed to download gut binary"
        print_info "Please check the release page: https://github.com/${REPO}/releases"
        exit 1
    fi
    
    print_success "Downloaded successfully"
    
    # Make executable
    chmod +x "$temp_file"
    
    # Install binary
    print_info "Installing to $INSTALL_DIR..."
    
    if [ -w "$INSTALL_DIR" ]; then
        # Directory is writable, install directly
        mv "$temp_file" "$INSTALL_DIR/$BINARY_NAME"
    else
        # Need sudo for installation
        print_warning "Administrator privileges required to install to $INSTALL_DIR"
        if ! sudo mv "$temp_file" "$INSTALL_DIR/$BINARY_NAME"; then
            print_error "Failed to install gut"
            print_info "You can manually move the binary:"
            print_info "  sudo mv $temp_file $INSTALL_DIR/$BINARY_NAME"
            exit 1
        fi
    fi
    
    print_success "gut installed successfully!"
    
    # Verify installation
    if command_exists "$BINARY_NAME"; then
        echo
        print_success "Installation verified!"
        print_info "You can now use 'gut' instead of 'git'"
        print_info "Try: gut --version"
    else
        echo
        print_warning "gut was installed but is not in your PATH"
        print_info "You may need to restart your terminal or add $INSTALL_DIR to your PATH"
        print_info "Add this to your ~/.bashrc or ~/.zshrc:"
        print_info "  export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
    
    echo
    print_info "🎉 Happy git-ing! (or should I say, gut-ing?)"
}

# Check if running as root (not recommended)
if [ "$EUID" -eq 0 ]; then
    print_warning "Running as root is not recommended"
    print_info "The script will install gut to $INSTALL_DIR"
    echo
fi

# Run installation
install_gut
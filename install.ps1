# gut installation script for Windows
# This script downloads and installs the latest release of gut

param(
    [string]$InstallDir = "$env:LOCALAPPDATA\Programs\gut",
    [switch]$AddToPath = $true,
    [switch]$Force = $false
)

# Configuration
$Repo = "geraldnguyen/gut"
$BinaryName = "gut.exe"

# Function to write colored output
function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Function to detect architecture
function Get-Architecture {
    $arch = $env:PROCESSOR_ARCHITECTURE
    switch ($arch) {
        "AMD64" { return "amd64" }
        "ARM64" { return "arm64" }
        "x86" { 
            Write-Error "32-bit Windows is not supported"
            Write-Info "Please use a 64-bit version of Windows"
            exit 1
        }
        default {
            Write-Error "Unsupported architecture: $arch"
            Write-Info "Supported architectures: AMD64, ARM64"
            exit 1
        }
    }
}

# Function to get latest release version
function Get-LatestVersion {
    try {
        $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        return $response.tag_name
    }
    catch {
        Write-Error "Failed to get latest release version: $($_.Exception.Message)"
        Write-Info "Please check your internet connection and try again"
        exit 1
    }
}

# Function to download file
function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath
    )
    
    try {
        Write-Info "Downloading from: $Url"
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing
        return $true
    }
    catch {
        Write-Error "Failed to download file: $($_.Exception.Message)"
        return $false
    }
}

# Function to add directory to PATH
function Add-ToPath {
    param([string]$Directory)
    
    # Get current user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
    
    # Check if directory is already in PATH
    if ($currentPath -split ";" -contains $Directory) {
        Write-Info "Directory already in PATH: $Directory"
        return
    }
    
    # Add to PATH
    $newPath = if ($currentPath) { "$currentPath;$Directory" } else { $Directory }
    
    try {
        [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
        Write-Success "Added to PATH: $Directory"
        Write-Warning "Please restart your terminal or PowerShell session to use the updated PATH"
    }
    catch {
        Write-Error "Failed to add directory to PATH: $($_.Exception.Message)"
        Write-Info "You can manually add '$Directory' to your PATH environment variable"
    }
}

# Function to test if gut is accessible
function Test-GutCommand {
    try {
        $null = Get-Command "gut" -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Main installation function
function Install-Gut {
    Write-Info "Installing gut - A witty Git typo helper"
    Write-Host ""
    
    # Detect architecture
    $arch = Get-Architecture
    Write-Info "Detected architecture: $arch"
    
    # Get latest version
    Write-Info "Fetching latest release information..."
    $version = Get-LatestVersion
    Write-Info "Latest version: $version"
    
    # Construct download URL and filename
    $filename = "gut-windows-$arch.exe"
    $downloadUrl = "https://github.com/$Repo/releases/download/$version/$filename"
    $tempFile = Join-Path $env:TEMP $filename
    
    # Download binary
    Write-Info "Downloading gut from GitHub releases..."
    if (!(Download-File -Url $downloadUrl -OutputPath $tempFile)) {
        Write-Info "Please check the release page: https://github.com/$Repo/releases"
        exit 1
    }
    
    Write-Success "Downloaded successfully"
    
    # Create installation directory
    if (!(Test-Path $InstallDir)) {
        Write-Info "Creating installation directory: $InstallDir"
        try {
            New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        }
        catch {
            Write-Error "Failed to create installation directory: $($_.Exception.Message)"
            exit 1
        }
    }
    
    # Install binary
    $targetPath = Join-Path $InstallDir $BinaryName
    
    if ((Test-Path $targetPath) -and !$Force) {
        Write-Warning "gut is already installed at: $targetPath"
        $response = Read-Host "Do you want to overwrite it? (y/N)"
        if ($response -notmatch "^[Yy]") {
            Write-Info "Installation cancelled"
            Remove-Item $tempFile -Force
            exit 0
        }
    }
    
    try {
        Write-Info "Installing to: $targetPath"
        Move-Item $tempFile $targetPath -Force
        Write-Success "gut installed successfully!"
    }
    catch {
        Write-Error "Failed to install gut: $($_.Exception.Message)"
        Write-Info "You can manually move the binary:"
        Write-Info "  Move-Item '$tempFile' '$targetPath'"
        exit 1
    }
    
    # Add to PATH if requested
    if ($AddToPath) {
        Add-ToPath -Directory $InstallDir
    }
    
    # Verify installation
    Write-Host ""
    if (Test-GutCommand) {
        Write-Success "Installation verified!"
        Write-Info "You can now use 'gut' instead of 'git'"
        Write-Info "Try: gut --version"
    }
    elseif (Test-Path $targetPath) {
        Write-Success "gut installed successfully!"
        if (!$AddToPath) {
            Write-Warning "gut is not in your PATH"
            Write-Info "Add '$InstallDir' to your PATH environment variable to use gut from anywhere"
        }
        else {
            Write-Info "gut should be available after restarting your terminal"
        }
        Write-Info "You can also run it directly: $targetPath"
    }
    
    Write-Host ""
    Write-Info "🎉 Happy git-ing! (or should I say, gut-ing?)"
}

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 3) {
    Write-Error "PowerShell 3.0 or later is required"
    Write-Info "Please upgrade your PowerShell version"
    exit 1
}

# Display help if requested
if ($args -contains "-help" -or $args -contains "--help" -or $args -contains "-h") {
    Write-Host "gut Installation Script for Windows"
    Write-Host ""
    Write-Host "USAGE:"
    Write-Host "    .\install.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "OPTIONS:"
    Write-Host "    -InstallDir <path>    Installation directory (default: $env:LOCALAPPDATA\Programs\gut)"
    Write-Host "    -AddToPath            Add installation directory to PATH (default: true)"
    Write-Host "    -Force                Overwrite existing installation without prompting"
    Write-Host "    -help                 Show this help message"
    Write-Host ""
    Write-Host "EXAMPLES:"
    Write-Host "    .\install.ps1"
    Write-Host "    .\install.ps1 -InstallDir 'C:\Tools\gut'"
    Write-Host "    .\install.ps1 -Force"
    exit 0
}

# Check execution policy
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Write-Warning "PowerShell execution policy is set to 'Restricted'"
    Write-Info "You may need to run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    Write-Info "Or run this script with: PowerShell -ExecutionPolicy Bypass -File install.ps1"
}

# Run installation
Install-Gut
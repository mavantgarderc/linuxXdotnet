# 02 – Ubuntu .NET Setup

## Installation Methods

### Microsoft Repository (Recommended)

```bash
# Ubuntu 22.04 (Jammy) - .NET 8 LTS
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Update package lists
sudo apt-get update

# Install .NET SDK 8.0 LTS
sudo apt-get install -y dotnet-sdk-8.0

# Install runtime (optional, included in SDK)
sudo apt-get install -y dotnet-runtime-8.0
sudo apt-get install -y aspnetcore-runtime-8.0
```

### Other Ubuntu Versions

```bash
# Ubuntu 20.04 (Focal) - .NET 6 LTS
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-6.0

# Ubuntu 24.04 (Noble) - .NET 8 LTS
wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0
```

### Script Installation (Alternative)

```bash
# Download installation script
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh

# Install .NET 8 LTS
./dotnet-install.sh --channel 8.0 --install-dir /usr/share/dotnet

# Install .NET 6 LTS
./dotnet-install.sh --channel 6.0 --install-dir /usr/share/dotnet

# Add to PATH
echo 'export DOTNET_ROOT=/usr/share/dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc
source ~/.bashrc
```

## Verification Steps

### Basic Verification

```bash
# Check installation
dotnet --version
which dotnet
file $(which dotnet)

# List installed components
dotnet --list-sdks
dotnet --list-runtimes
dotnet --info
```

### Environment Check

```bash
# Check environment variables
echo $DOTNET_ROOT
echo $PATH | grep dotnet
env | grep DOTNET

# Test with sample project
dotnet new console -o test-app
cd test-app
dotnet restore
dotnet build
dotnet run
rm -rf test-app
```

### System Integration Check

```bash
# Check shared library dependencies
ldd $(which dotnet)

# Verify symlinks
ls -la /usr/bin/dotnet
ls -la /usr/share/dotnet/

# Check package installation
dpkg -l | grep dotnet
apt list --installed | grep dotnet
```

## Package Management

### APT Commands

```bash
# Search for .NET packages
apt search dotnet-sdk
apt search dotnet-runtime
apt search aspnetcore

# Show package details
apt show dotnet-sdk-8.0
apt show dotnet-runtime-8.0

# Check for updates
sudo apt update
apt list --upgradable | grep dotnet
```

### Update and Upgrade

```bash
# Update all packages
sudo apt update
sudo apt upgrade

# Update only .NET packages
sudo apt install --only-upgrade dotnet-sdk-8.0
sudo apt install --only-upgrade dotnet-runtime-8.0
sudo apt install --only-upgrade aspnetcore-runtime-8.0
```

### Remove Packages

```bash
# Remove SDK but keep runtime
sudo apt remove dotnet-sdk-8.0

# Remove all .NET packages
sudo apt remove 'dotnet*' 'aspnet*' 'netstandard*'

# Purge configuration files
sudo apt purge dotnet-sdk-8.0
sudo apt autoremove
```

## Configuration

### Global SDK Configuration

```bash
# Pin SDK version with global.json
echo '{
  "sdk": {
    "version": "8.0.100",
    "rollForward": "latestFeature",
    "allowPrerelease": false
  }
}' > global.json

# Check active SDK
dotnet --version
cat global.json
```

### Environment Variables

```bash
# Add to ~/.bashrc or ~/.profile
export DOTNET_ROOT=/usr/share/dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
export ASPNETCORE_ENVIRONMENT=Development

# Apply changes
source ~/.bashrc
```

### NuGet Configuration

```bash
# Configure NuGet sources
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org

# List configured sources
dotnet nuget list source

# Set up local feed
dotnet nuget add source ~/local-nuget -n local
```

## Troubleshooting

### Common Issues

**Issue**: `dotnet: command not found`

```bash
# Check installation
dpkg -l | grep dotnet
# If missing, install
sudo apt install dotnet-sdk-8.0

# Check PATH
echo $PATH
# Add to PATH if needed
export PATH=$PATH:/usr/share/dotnet
```

**Issue**: `A fatal error occurred. The required library libhostpolicy.so could not be found`

```bash
# Install missing dependencies
sudo apt install -y libc6-dev libssl-dev libunwind8 zlib1g

# Check library paths
ldd $(which dotnet) | grep "not found"

# Reinstall .NET
sudo apt install --reinstall dotnet-runtime-8.0
```

**Issue**: `It was not possible to find any installed .NET SDKs`

```bash
# List available SDKs
dotnet --list-sdks

# Install SDK if missing
sudo apt install dotnet-sdk-8.0

# Check global.json
cat global.json 2>/dev
```

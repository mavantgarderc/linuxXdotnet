# 03 – Multi-SDK Management

## Overview

Managing multiple .NET SDK versions is essential for:

- Working on projects targeting different .NET versions
- Testing compatibility across versions
- Gradual migration from older to newer .NET versions
- Maintaining CI/CD pipelines with version-specific requirements

## Listing Installed SDKs

### Basic Listing Commands

```bash
# List all installed SDKs with versions
dotnet --list-sdks

# List installed runtimes
dotnet --list-runtimes

# Detailed environment information
dotnet --info

# Check for SDK updates
dotnet sdk check
```

### Detailed SDK Information

```bash
# Show SDK installation paths
ls -la /usr/share/dotnet/sdk/
ls -la /usr/share/dotnet/shared/

# Check SDK metadata
cat /usr/share/dotnet/sdk/8.0.100/sdk.version
cat /usr/share/dotnet/sdk/8.0.100/.version

# Count installed SDKs
dotnet --list-sdks | wc -l
```

## SDK Version Selection

### Global.json Configuration

```bash
# Create global.json to pin SDK version
echo '{
  "sdk": {
    "version": "8.0.100",
    "rollForward": "latestFeature",
    "allowPrerelease": false
  }
}' > global.json

# Check current SDK version
dotnet --version

# Validate global.json
dotnet --version
cat global.json
```

### RollForward Policies

| Policy          | Behavior             | Use Case                 |
| --------------- | -------------------- | ------------------------ |
| `latestPatch`   | Latest patch version | Production stability     |
| `latestFeature` | Latest feature band  | Development with updates |
| `latestMinor`   | Latest minor version | Progressive updates      |
| `latestMajor`   | Latest major version | Always latest            |
| `disable`       | No roll forward      | Strict version pinning   |

```bash
# Example: Strict version pinning
echo '{
  "sdk": {
    "version": "8.0.100",
    "rollForward": "disable"
  }
}' > global.json

# Example: Allow feature band updates
echo '{
  "sdk": {
    "version": "8.0.100",
    "rollForward": "latestFeature"
  }
}' > global.json
```

### Project-specific SDK Selection

```bash
# Check project SDK requirements
cat MyProject.csproj | grep TargetFramework

# Common target frameworks:
# - net8.0 (LTS)
# - net6.0 (LTS)
# - net7.0
# - net9.0 (preview)

# Set SDK version per project directory
mkdir project-a && cd project-a
echo '{"sdk": {"version": "6.0.100"}}' > global.json
dotnet --version  # Should show 6.0.100

cd ../project-b
echo '{"sdk": {"version": "8.0.100"}}' > global.json
dotnet --version  # Should show 8.0.100
```

## Installing Multiple SDKs

### Arch Linux

```bash
# Install multiple SDK versions
sudo pacman -S dotnet-sdk-8.0 dotnet-sdk-6.0

# Install specific preview versions from AUR
yay -S dotnet-sdk-preview
yay -S dotnet-sdk-9.0-preview

# List installed packages
pacman -Qs dotnet-sdk
```

### Ubuntu/Debian

```bash
# Install multiple SDK versions
sudo apt install dotnet-sdk-8.0 dotnet-sdk-6.0

# Install preview versions
sudo apt install dotnet-sdk-9.0-preview

# Check available versions
apt list dotnet-sdk-*
```

### Manual Installation

```bash
# Install using dotnet-install script
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh

# Install .NET 8 LTS
./dotnet-install.sh --channel 8.0 --install-dir /usr/share/dotnet

# Install .NET 6 LTS
./dotnet-install.sh --channel 6.0 --install-dir /usr/share/dotnet

# Install .NET 9 Preview
./dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet

# Verify all installations
ls -la /usr/share/dotnet/sdk/
```

## SDK Switching Mechanisms

### Environment Variable Control

```bash
# Set SDK version via environment variable
export DOTNET_ROOT=/usr/share/dotnet
export PATH=/usr/share/dotnet:$PATH

# Alternative: Use version-specific paths
export DOTNET_ROOT=/opt/dotnet-8.0
export PATH=/opt/dotnet-8.0:$PATH

# Check current SDK
which dotnet
dotnet --version
```

### Symbolic Link Switching

```bash
# Create version-specific directories
sudo mkdir -p /opt/dotnet-versions
sudo cp -r /usr/share/dotnet /opt/dotnet-versions/dotnet-8.0
sudo cp -r /usr/share/dotnet /opt/dotnet-versions/dotnet-6.0

# Create switching script
cat > /usr/local/bin/dotnet-switch << 'EOF'
#!/bin/bash
VERSION=${1:-8.0}
if [ -d "/opt/dotnet-versions/dotnet-$VERSION" ]; then
    sudo rm -f /usr/bin/dotnet
    sudo ln -s "/opt/dotnet-versions/dotnet-$VERSION/dotnet" /usr/bin/dotnet
    echo "Switched to .NET $VERSION"
else
    echo "Version $VERSION not found"
fi
EOF

chmod +x /usr/local/bin/dotnet-switch

# Switch versions
dotnet-switch 8.0
dotnet-switch 6.0
```

### Docker-based Isolation

```bash
# Use Docker for complete SDK isolation
docker run --rm -v $(pwd):/app -w /app mcr.microsoft.com/dotnet/sdk:8.0 dotnet --version
docker run --rm -v $(pwd):/app -w /app mcr.microsoft.com/dotnet/sdk:6.0 dotnet --version

# Create version-specific aliases
alias dotnet8='docker run --rm -v $(pwd):/app -w /app mcr.microsoft.com/dotnet/sdk:8.0 dotnet'
alias dotnet6='docker run --rm -v $(pwd):/app -w /app mcr.microsoft.com/dotnet/sdk:6.0 dotnet'

# Use aliases
dotnet8 --version
dotnet6 --version
```

## Version Compatibility

### Framework Compatibility Matrix

| Project TF     | Can use SDK | Notes               |
| -------------- | ----------- | ------------------- |
| net8.0         | 8.0+        | Recommended         |
| net6.0         | 6.0+        | LTS compatible      |
| net7.0         | 7.0+        | Non-LTS             |
| netstandard2.0 | 2.1+        | Backward compatible |
| netcoreapp3.1  | 3.1+        | Legacy support      |

```bash
# Check SDK compatibility
dotnet --version
cat MyProject.csproj | grep TargetFramework

# Test build with different SDKs
DOTNET_ROOT=/opt/dotnet-6.0 dotnet build
DOTNET_ROOT=/opt/dotnet-8.0 dotnet build
```

### Migration Testing

```bash
# Test project with multiple SDKs
for sdk in 6.0 7.0 8.0; do
    echo "Testing with SDK $sdk"
    DOTNET_ROOT=/opt/dotnet-$sdk dotnet build
    DOTNET_ROOT=/opt/dotnet-$sdk dotnet test
done

# Compare build outputs
diff -r bin/Debug/net6.0/ bin/Debug/net8.0/
```

## Maintenance Commands

### SDK Cleanup

```bash
# List all installed SDKs
dotnet --list-sdks

# Remove specific SDK version (Arch)
sudo pacman -Rns dotnet-sdk-7.0

# Remove specific SDK version (Ubuntu)
sudo apt remove dotnet-sdk-7.0

# Clean up old SDK directories
sudo rm -rf /usr/share/dotnet/sdk/7.0.*
sudo rm -rf /usr/share/dotnet/shared/Microsoft.NETCore.App/7.0.*
```

### Cache Management

```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Clear SDK telemetry cache
rm -rf ~/.dotnet/telemetry
rm -rf ~/.dotnet/host/fxr

# Clear template cache
dotnet new --debug:reinit
```

### Disk Space Management

```bash
# Check SDK disk usage
du -sh /usr/share/dotnet/sdk/
du -sh /usr/share/dotnet/shared/

# Find largest SDK directories
find /usr/share/dotnet -type d -name "*.0" -exec du -sh {} \; | sort -hr

# Remove unused runtimes
sudo rm -rf /usr/share/dotnet/shared/Microsoft.AspNetCore.App/*-rc*
sudo rm -rf /usr/share/dotnet/shared/Microsoft.NETCore.App/*-preview*
```

## Automation Scripts

### SDK Version Check Script

```bash
#!/bin/bash
# check-sdk-versions.sh

echo "=== Installed SDKs ==="
dotnet --list-sdks

echo -e "\n=== Installed Runtimes ==="
dotnet --list-runtimes

echo -e "\n=== Current SDK ==="
dotnet --version

echo -e "\n=== Global.json ==="
if [ -f "global.json" ]; then
    cat global.json
else
    echo "No global.json found"
fi

echo -e "\n=== Disk Usage ==="
du -sh /usr/share/dotnet/sdk/ 2>/dev/null || echo "SDK directory not found"
```

### SDK Installation Script

```bash
#!/bin/bash
# install-multiple-sdks.sh

VERSIONS=("6.0" "8.0")
INSTALL_DIR="/opt/dotnet"

for version in "${VERSIONS[@]}"; do
    echo "Installing .NET $version..."
    wget -q https://dot.net/v1/dotnet-install.sh
    chmod +x dotnet-install.sh
    ./dotnet-install.sh --channel $version --install-dir "$INSTALL_DIR-$version"
    rm dotnet-install.sh

    echo "Verifying .NET $version..."
    "$INSTALL_DIR-$version/dotnet" --version
done

echo "Installation complete. Use:"
for version in "${VERSIONS[@]}"; do
    echo "  $INSTALL_DIR-$version/dotnet"
done
```

## Troubleshooting

### Common Issues

**Issue**: `The SDK 'Microsoft.NET.Sdk' specified could not be found`

```bash
# Check available SDKs
dotnet --list-sdks

# Install missing SDK
sudo apt install dotnet-sdk-8.0  # Ubuntu
sudo pacman -S dotnet-sdk-8.0    # Arch

# Or use global.json
echo '{"sdk": {"version": "8.0.100"}}' > global.json
```

**Issue**: Version mismatch between global.json and installed SDK

```bash
# Check global.json
cat global.json

# Check installed SDKs
dotnet --list-sdks

# Install required version
sudo apt install dotnet-sdk-8.0=8.0.100-1

# Or update global.json to match installed version
echo '{"sdk": {"version": "'$(dotnet --list-sdks | tail -1 | cut -d' ' -f1)'"}}' > global.json
```

**Issue**: Multiple global.json files causing confusion

```bash
# Find all global.json files
find . -name "global.json" -type f

# Check which one is being used
dotnet --version
pwd

# Remove conflicting global.json files
rm **/global.json 2>/dev/null
echo '{"sdk": {"version": "8.0.100"}}' > global.json
```

### Diagnostic Commands

```bash
# Full SDK diagnostics
dotnet --info > sdk-info.txt
cat sdk-info.txt

# Check SDK resolution
dotnet --version --verbose

# Check environment
env | grep DOTNET
env | grep PATH

# Check symbolic links
ls -la $(which dotnet)
readlink -f $(which dotnet)
```

### Performance Considerations

```bash
# Monitor SDK startup time
time dotnet --version

# Check SDK disk I/O
iotop -p $(pgrep -f dotnet)

# Monitor memory usage
ps aux | grep dotnet | grep -v grep
```

## Best Practices

1. **Use LTS versions** (.NET 6/8) for production
2. **Pin SDK versions** with global.json in each project
3. **Keep only necessary SDKs** to save disk space
4. **Test with multiple SDKs** during migration
5. **Use CI/CD with explicit SDK versions**
6. **Document SDK requirements** in README files
7. **Regularly update SDKs** for security patches

## Integration with CI/CD

### GitHub Actions Example

```yaml
# .github/workflows/build.yml
name: Build with Multiple SDKs

jobs:
  test-matrix:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        dotnet-version: ["6.0.x", "8.0.x"]

    steps:
      - uses: actions/checkout@v3

      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: ${{ matrix.dotnet-version }}

      - name: Restore dependencies
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore

      - name: Test
        run: dotnet test --no-build --verbosity normal
```

### GitLab CI Example

```yaml
# .gitlab-ci.yml
stages:
  - build

.dotnet_template: &dotnet_template
  before_script:
    - apt-get update && apt-get install -y wget
    - wget https://dot.net/v1/dotnet-install.sh
    - chmod +x dotnet-install.sh
    - ./dotnet-install.sh --channel $DOTNET_VERSION --install-dir /usr/share/dotnet
    - export PATH="/usr/share/dotnet:$PATH"

build_net6:
  <<: *dotnet_template
  variables:
    DOTNET_VERSION: "6.0"
  script:
    - dotnet --version
    - dotnet build

build_net8:
  <<: *dotnet_template
  variables:
    DOTNET_VERSION: "8.0"
  script:
    - dotnet --version
    - dotnet build
```

## Monitoring and Metrics

```bash
# Track SDK usage
cat > /etc/cron.daily/dotnet-usage << 'EOF'
#!/bin/bash
echo "=== $(date) ===" >> /var/log/dotnet-usage.log
dotnet --list-sdks >> /var/log/dotnet-usage.log
echo "" >> /var/log/dotnet-usage.log
EOF

chmod +x /etc/cron.daily/dotnet-usage

# Monitor SDK disk growth
du -sh /usr/share/dotnet/ >> /var/log/dotnet-disk.log
```

## Security Considerations

```bash
# Check for SDK vulnerabilities
dotnet --list-sdks | grep -E "(rc|preview|alpha|beta)"

# Remove preview SDKs from production
sudo apt remove dotnet-sdk-*-preview
sudo pacman -Rns dotnet-sdk-preview

# Verify SDK checksums
sha256sum /usr/bin/dotnet
sha256sum /usr/share/dotnet/dotnet
```

## References

- [.NET SDK Versioning](https://docs.microsoft.com/dotnet/core/versions/)
- [Global.json Reference](https://docs.microsoft.com/dotnet/core/tools/global-json)
- [SDK Roll Forward](https://docs.microsoft.com/dotnet/core/versions/selection)
- [Multiple SDK Installation](https://docs.microsoft.com/dotnet/core/install/linux)

**Note**: Always test with the exact SDK version used in production to avoid unexpected behavior changes.

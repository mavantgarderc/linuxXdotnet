# 01 – Arch Linux .NET Setup

## Installation Methods

### Official Repository (Recommended)

```bash
# Install .NET 8 LTS SDK and runtime
sudo pacman -S dotnet-sdk-8.0 dotnet-runtime-8.0 aspnet-runtime-8.0

# Verify installation
dotnet --version
dotnet --list-sdks
dotnet --list-runtimes
```

### AUR Packages (Alternative)

```bash
# Using yay (AUR helper)
yay -S dotnet-sdk-bin dotnet-runtime-bin aspnet-runtime-bin

# Or manually from AUR
git clone https://aur.archlinux.org/dotnet-sdk-bin.git
cd dotnet-sdk-bin
makepkg -si
```

### Manual Installation (Advanced)

```bash
# Download and extract .NET manually
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0 --install-dir /opt/dotnet

# Add to PATH
echo 'export DOTNET_ROOT=/opt/dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc
source ~/.bashrc
```

## Verification Steps

```bash
# Basic verification
dotnet --version
which dotnet
file $(which dotnet)

# Environment check
dotnet --info
echo $DOTNET_ROOT
echo $PATH | grep dotnet

# Test project creation and execution
dotnet new console -o test-app
cd test-app
dotnet restore
dotnet build
dotnet run
```

## Package Management

### List Installed Packages

```bash
# Check what's installed
pacman -Qs dotnet
pacman -Qs aspnet
pacman -Qs netstandard

# Detailed package info
pacman -Qi dotnet-sdk-8.0
```

### Update and Maintenance

```bash
# Update all .NET packages
sudo pacman -Syu dotnet-sdk-8.0 dotnet-runtime-8.0 aspnet-runtime-8.0

# Clean package cache
sudo pacman -Sc
```

## Configuration Files

### Global SDK Configuration

```bash
# Create global.json to pin SDK version
echo '{
  "sdk": {
    "version": "8.0.100",
    "rollForward": "latestFeature"
  }
}' > global.json

# Check active SDK
dotnet --version
```

### Environment Variables

```bash
# Set in ~/.bashrc or ~/.zshrc
export DOTNET_ROOT=/usr/share/dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
```

## Troubleshooting

### Common Issues

**Issue**: `dotnet: command not found`

```bash
# Check installation
pacman -Qs dotnet-sdk
# If missing, install
sudo pacman -S dotnet-sdk-8.0

# Check PATH
echo $PATH | grep dotnet
# Add to PATH if missing
export PATH=$PATH:/usr/share/dotnet
```

**Issue**: `The SDK 'Microsoft.NET.Sdk' specified could not be found`

```bash
# List available SDKs
dotnet --list-sdks
# Install missing SDK
sudo pacman -S dotnet-sdk-8.0
# Or use global.json to specify version
echo '{"sdk": {"version": "8.0.100"}}' > global.json
```

**Issue**: Permission errors

```bash
# Check ownership
ls -la /usr/share/dotnet/
# Fix permissions if needed
sudo chown -R root:root /usr/share/dotnet/
sudo chmod -R 755 /usr/share/dotnet/
```

### Diagnostic Commands

```bash
# Full environment diagnostics
dotnet --info > dotnet-info.txt
cat dotnet-info.txt

# Check shared library dependencies
ldd $(which dotnet)

# Verify runtime availability
dotnet --list-runtimes
ls -la /usr/share/dotnet/shared/
```

## Additional Components

### ASP.NET Core Runtime

```bash
# Install ASP.NET Core runtime
sudo pacman -S aspnet-runtime-8.0

# Verify
dotnet --list-runtimes | grep aspnet
```

### Workloads

```bash
# List available workloads
dotnet workload list

# Install specific workloads
dotnet workload install android
dotnet workload install ios
dotnet workload install macos
```

### Tools

```bash
# Install global tools
dotnet tool install -g dotnet-ef
dotnet tool install -g dotnet-reportgenerator-globaltool

# List installed tools
dotnet tool list -g
```

## System Integration

### Systemd Service Example

```bash
# Create systemd service for .NET app
cat > /etc/systemd/system/myservice.service << 'EOF'
[Unit]
Description=My .NET Application
After=network.target

[Service]
Type=notify
WorkingDirectory=/var/www/myapp
ExecStart=/usr/bin/dotnet /var/www/myapp/MyApp.dll
Restart=always
RestartSec=10
KillSignal=SIGINT
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable myservice
sudo systemctl start myservice
```

### Logging Configuration

```bash
# View systemd logs for .NET app
sudo journalctl -u myservice -f
sudo journalctl -u myservice --since "1 hour ago"
```

## Performance Tuning

### Memory Limits

```bash
# Set memory limits for .NET processes
export DOTNET_GCHeapHardLimit=0x10000000  # 256MB
export DOTNET_GCHeapHardLimitPercent=50
```

### JIT Configuration

```bash
# Enable tiered compilation (default in .NET 8)
export DOTNET_TieredCompilation=1
export DOTNET_TC_QuickJitForLoops=1
```

## Security Considerations

### Certificate Management

```bash
# Trust development certificates
dotnet dev-certs https --trust

# List certificates
dotnet dev-certs https --check
```

### Security Scanning

```bash
# Check for known vulnerabilities
dotnet list package --vulnerable

# Update vulnerable packages
dotnet outdated --upgrade
```

## Maintenance

### Cleanup Commands

```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Remove old SDKs
sudo pacman -Rns $(pacman -Qdtq | grep dotnet)

# Clean build artifacts
find . -name "bin" -type d -exec rm -rf {} +
find . -name "obj" -type d -exec rm -rf {} +
```

### Monitoring

```bash
# Monitor .NET processes
ps aux | grep dotnet
top -p $(pgrep -f dotnet)

# Check disk usage
du -sh /usr/share/dotnet/
du -sh ~/.nuget/
```

## References

- [Arch Linux Wiki: .NET](https://wiki.archlinux.org/title/.NET)
- [Microsoft .NET Documentation](https://docs.microsoft.com/dotnet)
- [.NET Runtime Releases](https://github.com/dotnet/runtime/releases)

**Note**: Always verify package signatures and checksums when installing from AUR or third-party sources.

# 03 – Multi-SDK Management

## List & Select SDKs

```bash
dotnet --list-sdks          # All installed: 6.0.xxx, 8.0.xxx
dotnet --list-runtimes      # ASP.NET, desktop runtimes
dotnet sdk check            # Update notifications
```

## Global & Local Versions

```bash
# Global.json pins SDK version
echo '{"sdk": {"version": "8.0.100"}}' > global.json
dotnet --version            # Now locked to 8.0.100
rm global.json              # Reverts to latest
```

## Troubleshoot Version Conflicts

**Error:** `The SDK 'Microsoft.NET.Sdk/net6.0' specified could not be found`
```bash
dotnet --list-sdks          # Confirm 6.0.xxx exists
sudo pacman -S dotnet-sdk-6.0  # Arch reinstall
```

# 01 – Arch Linux .NET Setup

## Install .NET 8 LTS (Official)

```bash
sudo pacman -S dotnet-sdk-8.0 dotnet-runtime-8.0
# Or AUR: yay -S dotnet-sdk dotnet-runtime
dotnet --version  # Verify 8.0.xxx
```

## Verify Installation

```bash
dotnet --list-sdks
which dotnet        # /usr/bin/dotnet
dotnet new console -o test && cd test && dotnet run
```

## Troubleshoot

**Error:** `dotnet: command not found`

```bash
echo 'export DOTNET_ROOT=/opt/dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT' >> ~/.bashrc
source ~/.bashrc
```

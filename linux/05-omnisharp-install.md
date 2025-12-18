# 05 – OmniSharp Installation

## Install OmniSharp Language Server

```bash
# Arch Linux
sudo pacman -S omnisharp-roslyn
# Ubuntu
wget https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp.tar.gz
tar -xzf omnisharp.tar.gz -C ~/.omnisharp
```

## Verify & Run Server

```bash
omnisharp --version         # Roslyn version
omnisharp --hostPID 1234 --hostPipe /tmp/omnisharp1_pipe  # Start server
# Point LSP client at: ~/.omnisharp/OmniSharp
```

## Troubleshoot

**Error:** `Could not load file or assembly 'Microsoft.CodeAnalysis'`
```bash
dotnet workload install roslyn-dev  # Install Roslyn components
omnisharp --version                 # Re-verify
```

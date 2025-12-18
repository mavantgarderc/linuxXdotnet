# 01 – Linux Shell Basics (.NET Context)

## Essential Commands

```bash
ls -la bin/                 # Inspect .NET build output
find . -name "*.dll"        # Locate assemblies
du -sh bin/Release/net8.0/  # Binary size check
```

## Permissions & Execution

```bash
chmod +x bin/Release/net8.0/linux-x64/publish/MyApp
./bin/Release/net8.0/linux-x64/publish/MyApp
# No shebang needed for native AOT
```

## Process Management

```bash
ps aux | grep dotnet        # Find running .NET processes
pkill -f MyApp              # Graceful shutdown
```

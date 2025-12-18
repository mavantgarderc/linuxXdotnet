# 04 – Verification Commands

## Core Checks

```bash
which dotnet                # /usr/bin/dotnet or /opt/dotnet/dotnet
dotnet --info               # SDK, runtime, OS details
dotnet workload list        # Installed workloads (ML, MAUI)
```

## Runtime & Library Verification

```bash
ldd $(which dotnet)         # Shared library dependencies
file $(which dotnet)        # ELF 64-bit executable
dotnet --list-runtimes      # net8.0, aspnetcore-8.0 installed?
```

## File Inspection Post-Build

```bash
ls -la bin/Debug/net8.0/   # MyApp.dll, .deps.json, .pdb, .runtimeconfig.json
file MyApp.dll              # PE32+ executable (CIL)
```

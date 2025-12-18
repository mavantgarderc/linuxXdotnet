# 03 – Build, Run, Publish

## Build Lifecycle

```bash
dotnet restore              # NuGet packages only
dotnet build                # Debug build → bin/Debug/net8.0/
dotnet build -c Release     # Optimized build
dotnet publish              # Ready-to-run output
```

## Run Behaviors

```bash
dotnet run                  # Restore+build+run
dotnet MyApp.dll            # Direct DLL execution
dotnet run --no-build       # Skip build, run existing
```

## Publish Output Files

```bash
ls -la bin/Release/net8.0/publish/
# MyApp.dll, MyApp.deps.json, MyApp.pdb, MyApp.runtimeconfig.json
```

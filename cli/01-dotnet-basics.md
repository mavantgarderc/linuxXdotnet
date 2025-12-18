# 01 – .NET CLI Basics

## Global Info

```bash
dotnet --help              # List commands and options
dotnet --version           # Active SDK version
dotnet --list-sdks         # All installed SDKs
dotnet --list-runtimes     # Installed runtimes
```

## Project Lifecycle

```bash
dotnet new console -o MyApp   # Create console app
cd MyApp
dotnet restore                # Restore NuGet packages
dotnet build                  # Build → bin/Debug/net8.0/
dotnet run                    # Build + run
```

## Cleanup & Config

```bash
dotnet clean                  # Remove bin/ and obj/
dotnet nuget locals all --clear   # Clear caches
dotnet --info                 # Environment diagnostics
```

# 05 – Cross-Compilation

## Publish for Different Linux

```bash
# From any OS, target Ubuntu 22.04
dotnet publish -r ubuntu.22.04-x64 --self-contained -c Release

# Framework-dependent (smaller)
dotnet publish -r linux-x64 -c Release
```

## Verify Cross-Compiled Binary

```bash
file bin/Release/net8.0/linux-x64/publish/MyApp  # Linux ELF
ldd bin/Release/net8.0/linux-x64/publish/MyApp   # Linux libs
./bin/Release/net8.0/linux-x64/publish/MyApp     # Runs on target
```

**No cross-compiler needed; .NET SDK handles all RIDs.**

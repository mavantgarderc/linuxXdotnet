# 04 – Runtime Identifiers (RIDs)

## Common Linux RIDs

| RID | Distro | Architecture |
|-----|--------|--------------|
| **linux-x64** | All | 64-bit |
| **ubuntu.22.04-x64** | Ubuntu 22.04 | 64-bit |
| **rhel.9-x64** | RHEL 9 | 64-bit |
| **alpine.3.18-x64** | Alpine | 64-bit |

## Self-Contained Publish

```bash
dotnet publish -c Release -r linux-x64 --self-contained
# Creates standalone executable + all runtimes
ls -la bin/Release/net8.0/linux-x64/publish/
```

**`.deps.json` lists all runtime dependencies for the RID.**

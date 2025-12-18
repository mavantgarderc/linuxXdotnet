# 01 – .NET on Linux Introduction

## Core Components

```bash
dotnet --version    # Shows installed SDK version
dotnet --info       # Full environment details
dotnet --list-sdks  # All installed SDKs
```

**SDK includes:** CLI tools, compiler, templates. **Runtime** (ASP.NET, desktop) installed separately.

## Cross-Platform Reality

- **Works:** Console, web APIs, ML.NET, class libraries, gRPC
- **Limited:** WPF/WinForms (use Avalonia/UNO instead)
- **Single executable:** `dotnet publish -r linux-x64 --self-contained`

**Key difference:** No .NET Framework on Linux; only unified .NET 6+.[3]

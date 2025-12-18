# 04 – .NET vs .NET Framework

## Key Differences

| Feature | .NET (Linux) | .NET Framework (Windows) |
|---------|--------------|-------------------------|
| **Runtime** | CoreCLR | CLR |
| **GUI** | Limited (Avalonia) | WPF/WinForms |
| **CLI** | `dotnet` | MSBuild |
| **Single file** | Yes | No |

## Migration Path

```bash
# Framework project → modern .NET
dotnet new globaljson --sdk-version 8.0.100
dotnet add package Microsoft.Extensions.*
# Replace System.Configuration with IConfiguration
```

**.NET Standard 2.0+ libraries work everywhere.[3]**

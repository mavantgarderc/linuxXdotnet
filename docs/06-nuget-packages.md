# 06 – NuGet Packages

## Package Management

```bash
dotnet add package Newtonsoft.Json
dotnet remove package Newtonsoft.Json
dotnet list package          # Show all packages
dotnet list package --outdated  # Updates available
```

## Global Packages (Tools)

```bash
dotnet tool install dotnet-ef  # Entity Framework
dotnet tool list --global
dotnet ef migrations add Init
```

## Native Dependencies

```bash
dotnet add package SQLitePCLRaw.bundle_green  # Linux SQLite
dotnet add package LibManages.Linux  # System libs
```

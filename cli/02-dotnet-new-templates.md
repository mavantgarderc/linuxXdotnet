# 02 – .NET Templates

## Core Templates

```bash
dotnet new list             # All available templates
dotnet new console          # Basic console app
dotnet new webapi           # REST API (.NET 8)
dotnet new mvc              # MVC web app
dotnet new worker           # Background service
```

## List with Details

```bash
dotnet new --help console   # Template parameters
dotnet new console --name MyApp --language FSharp  # F# console
ls MyApp/                   # MyApp.fsproj + Program.fs
```

**Web templates include HTTPS cert setup for Linux dev.**

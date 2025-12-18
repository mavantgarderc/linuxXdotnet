# 02 – .NET Architecture

## Core Layers

````

App (C#/F#) → CIL bytecode → CLR (JIT/AOT) → Native code → Linux kernel

````

```bash
dotnet new console -o MyApp
dotnet build MyApp    # Generates .dll (CIL)
ls -la MyApp/bin/     # See .deps.json, .pdb files
````

**CIL (Common Intermediate Language):** Platform-agnostic bytecode executed by CLR.

## JIT vs AOT

| Mode    | Command                             | Use Case                                |
| ------- | ----------------------------------- | --------------------------------------- |
| **JIT** | `dotnet run`                        | Development, max perf after warmup      |
| **AOT** | `dotnet publish -p:PublishAot=true` | Startup speed, smaller memory (.NET 7+) |

**CLR manages:** GC, threading, security, type safety.[2]

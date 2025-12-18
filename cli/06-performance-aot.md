# 06 – Performance & AOT

## Tree Shaking

```bash
dotnet publish -p:PublishTrimmed=true -c Release
# Removes unused code, smaller binary
```

## Native AOT (.NET 7+)

```bash
dotnet publish -c Release -r linux-x64 -p:PublishAot=true
# Single native executable, no JIT warmup
ls -la publish/*            # MyApp (no .dll), ~10-20MB smaller
```

## Monitor Performance

```bash
dotnet counters collect --process-id [PID] --counters System.Runtime
# CPU, GC, JIT statistics
```

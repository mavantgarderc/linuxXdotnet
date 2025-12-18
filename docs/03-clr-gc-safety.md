# 03 – CLR, Garbage Collection, Type Safety

## Garbage Collection

```bash
dotnet counters collect --process-id [PID] --counters System.Runtime
```

**Generational GC:** Gen0 (fast, small), Gen1, Gen2 (large objects). Server GC for multi-core.

## Type Safety Features

- **Null safety:** Nullable reference types (`string?`)
- **`Span<T>`:** Zero-copy memory access
- **Bounds checking:** Array access validated at runtime

```bash
# Monitor GC pressure
dotnet counters collect --process-id [PID] --counters System.GC
```

**Real error:** `System.NullReferenceException` → Enable nullable: `<Nullable>enable</Nullable>` in .csproj.[3]

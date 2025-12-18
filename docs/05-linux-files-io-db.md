# 05 – Linux Files, IO, Database

## File System Access

```bash
# Absolute paths required
var path = Path.Combine("/home/user", "data.json");
File.WriteAllText(path, json);
// Handles Linux permissions automatically
```

## Process & Environment

```bash
# dotnet run reads $DOTNET_ROOT, $PATH
echo $DOTNET_ROOT           # /opt/dotnet or /usr/share/dotnet
cat /proc/[PID]/environ | tr '\0' '\n' | grep DOTNET
```

## Database Connections

```bash
dotnet add package Microsoft.Data.Sqlite
# Works with PostgreSQL, MySQL, SQLite on Linux
# Connection strings identical to Windows
```

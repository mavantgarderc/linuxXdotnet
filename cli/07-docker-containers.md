# 07 – Docker & Containers

## Multi-Stage Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]
EOF
```

## Build & Run

```bash
docker build -t myapp .
docker run -p 8080:80 myapp
# Framework-dependent (50MB)
docker run -p 8080:80 myapp:latest --self-contained  # 250MB
```

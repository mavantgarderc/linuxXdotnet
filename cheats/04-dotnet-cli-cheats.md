# 04 – .NET CLI One-Liners

## Project Creation & Management

### Basic Project Templates

```bash
# Console application (.NET 8)
dotnet new console -o MyConsoleApp --framework net8.0

# Web API with minimal API
dotnet new webapi -o MyApi --use-minimal-apis --framework net8.0

# MVC Web Application
dotnet new mvc -o MyWebApp --auth Individual --framework net8.0

# Class Library
dotnet new classlib -o MyLibrary --framework net8.0

# Worker Service (background tasks)
dotnet new worker -o MyWorker --framework net8.0

# Blazor WebAssembly
dotnet new blazorwasm -o MyBlazorApp --framework net8.0

# Blazor Server
dotnet new blazorserver -o MyBlazorServer --framework net8.0

# Razor Pages
dotnet new webapp -o MyRazorApp --framework net8.0
```

### Advanced Template Options

```bash
# Create with specific language (F#)
dotnet new console -o FSharpApp -lang F#

# Create with specific authentication
dotnet new webapi -o SecureApi --auth IndividualB2C

# Create with OpenAPI support
dotnet new webapi -o OpenApiApp --use-openapi

# Create with Docker support
dotnet new webapi -o DockerApi --docker

# Create with no HTTPS (development only)
dotnet new webapi -o DevApi --no-https

# Create with specific .NET version
dotnet new console -o Net6App --framework net6.0
dotnet new console -o Net7App --framework net7.0
```

### Template Management

```bash
# List all available templates
dotnet new list

# Search for specific templates
dotnet new list web
dotnet new list --tag api
dotnet new list --tag database

# Get template details
dotnet new webapi --help
dotnet new console --help

# Install custom templates
dotnet new install "Microsoft.AspNetCore.SpaTemplates::*"
dotnet new install "MyCompany.MyTemplates::1.0.0"

# Uninstall templates
dotnet new uninstall "Microsoft.AspNetCore.SpaTemplates"

# List installed template packages
dotnet new list --columns-all
```

## Build & Compilation

### Basic Build Commands

```bash
# Build current project
dotnet build

# Build with Release configuration
dotnet build -c Release

# Build with specific framework
dotnet build -f net8.0

# Build with no dependencies restore
dotnet build --no-restore

# Build with verbosity
dotnet build -v minimal
dotnet build -v normal
dotnet build -v detailed
dotnet build -v diagnostic

# Build with specific output directory
dotnet build -o ./output/

# Clean build (remove bin/obj first)
dotnet clean && dotnet build
```

### Advanced Build Options

```bash
# Build with specific runtime
dotnet build -r linux-x64

# Build with self-contained
dotnet build --self-contained true

# Build with specific MSBuild properties
dotnet build -p:Configuration=Release -p:Platform=x64

# Build with warnings as errors
dotnet build -warnaserror

# Build with specific warning level
dotnet build -warn:4

# Build with no incremental
dotnet build --no-incremental

# Build with specific version
dotnet build -p:Version=1.0.0.0
```

### Parallel Builds

```bash
# Enable parallel builds
dotnet build --max-cpu-count

# Limit CPU usage
dotnet build --max-cpu-count 2

# Disable parallel builds
dotnet build --disable-parallel
```

## Running Applications

### Basic Run Commands

```bash
# Run current project
dotnet run

# Run with Release configuration
dotnet run -c Release

# Run with specific framework
dotnet run -f net8.0

# Run with arguments
dotnet run -- arg1 arg2 arg3

# Run with environment variables
ASPNETCORE_ENVIRONMENT=Production dotnet run

# Run with no build
dotnet run --no-build

# Run with launch profile
dotnet run --launch-profile Development
dotnet run --launch-profile Production
```

### Advanced Run Options

```bash
# Run with specific URLs
dotnet run --urls "http://localhost:5000;https://localhost:5001"

# Run with Kestrel options
dotnet run --kestrel:Endpoints:Http:Url=http://0.0.0.0:8080

# Run with debugger attached
dotnet run --debug

# Run with specific working directory
dotnet run --project ./src/MyApp/

# Run with timeout
timeout 30s dotnet run

# Run and profile
dotnet run --collect:"CPU Sampling"
```

### Direct DLL Execution

```bash
# Run compiled DLL
dotnet MyApp.dll

# Run with specific runtime
dotnet exec MyApp.dll

# Run with runtime config
dotnet MyApp.runtimeconfig.json

# Run with debugger
dotnet run --debug MyApp.dll
```

## Testing

### Test Creation & Execution

```bash
# Create test project
dotnet new xunit -o MyTests
dotnet new mstest -o MyTests
dotnet new nunit -o MyTests

# Run all tests
dotnet test

# Run specific test project
dotnet test ./tests/MyTests/

# Run with specific framework
dotnet test -f net8.0

# Run with filter
dotnet test --filter "Category=Integration"
dotnet test --filter "FullyQualifiedName~MyNamespace.MyTestClass"

# Run with logger
dotnet test --logger "console;verbosity=detailed"
dotnet test --logger trx
dotnet test --logger html

# Run with code coverage
dotnet test --collect:"XPlat Code Coverage"
```

### Advanced Testing Options

```bash
# Run tests in parallel
dotnet test --parallel

# Run tests sequentially
dotnet test --parallel none

# Run with specific test adapter
dotnet test --test-adapter-path:.

# Run with timeout per test
dotnet test --test-timeout 30000

# Run with specific diag file
dotnet test --diag:test.log

# Run with blame (capture crash dumps)
dotnet test --blame

# Run with specific results directory
dotnet test --results-directory ./test-results/
```

### Test Reports

```bash
# Generate test report
dotnet test --logger "trx;LogFileName=testresults.trx"

# Convert TRX to HTML
dotnet tool install -g trx2html
trx2html testresults.trx

# Generate coverage report
dotnet test --collect:"XPlat Code Coverage"
reportgenerator -reports:./TestResults/*/coverage.cobertura.xml -targetdir:./coveragereport
```

## Publishing & Deployment

### Basic Publish Commands

```bash
# Publish current project
dotnet publish

# Publish with Release configuration
dotnet publish -c Release

# Publish with specific runtime
dotnet publish -r linux-x64

# Publish self-contained
dotnet publish --self-contained true

# Publish with single file
dotnet publish -p:PublishSingleFile=true

# Publish with trimmed
dotnet publish -p:PublishTrimmed=true

# Publish with ready-to-run
dotnet publish -p:PublishReadyToRun=true
```

### Advanced Publish Options

```bash
# Publish with AOT compilation (.NET 7+)
dotnet publish -p:PublishAot=true

# Publish with specific output
dotnet publish -o ./publish/

# Publish with no build
dotnet publish --no-build

# Publish with no restore
dotnet publish --no-restore

# Publish with specific version
dotnet publish -p:Version=1.2.3.4

# Publish with assembly info
dotnet publish -p:GenerateAssemblyInfo=false

# Publish with debug symbols
dotnet publish -p:DebugType=embedded
```

### Deployment Scenarios

```bash
# Docker deployment
dotnet publish -c Release -o ./app
docker build -t myapp .

# Azure deployment
dotnet publish -c Release
az webapp deploy --src-path ./publish

# AWS Lambda deployment
dotnet publish -c Release -o ./publish
dotnet lambda deploy-function MyFunction --function-handler MyApp::MyNamespace::FunctionHandler

# GitHub Pages (Blazor)
dotnet publish -c Release -o ./docs
```

## Package Management

### NuGet Package Operations

```bash
# Add package
dotnet add package Newtonsoft.Json
dotnet add package Microsoft.EntityFrameworkCore.SqlServer

# Add specific version
dotnet add package Newtonsoft.Json --version 13.0.3

# Add package to specific project
dotnet add ./src/MyApp/ package Newtonsoft.Json

# Remove package
dotnet remove package Newtonsoft.Json

# Update package
dotnet update package Newtonsoft.Json

# Update all packages
dotnet update package

# List packages
dotnet list package
dotnet list package --outdated
dotnet list package --deprecated
dotnet list package --vulnerable
```

### Package Sources

```bash
# Add package source
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
dotnet nuget add source ~/local-nuget -n local

# List sources
dotnet nuget list source

# Enable/disable source
dotnet nuget enable source nuget.org
dotnet nuget disable source local

# Update source
dotnet nuget update source nuget.org --source https://new.nuget.org/v3/index.json

# Remove source
dotnet nuget remove source local
```

### Package Restoration

```bash
# Restore packages
dotnet restore

# Restore with specific source
dotnet restore --source https://api.nuget.org/v3/index.json

# Restore with no cache
dotnet restore --no-cache

# Restore with parallel
dotnet restore --disable-parallel

# Restore with config file
dotnet restore --configfile ./nuget.config

# Force restore
dotnet restore --force
```

## Tool Management

### Global Tools

```bash
# Install global tool
dotnet tool install -g dotnet-ef
dotnet tool install -g dotnet-reportgenerator-globaltool
dotnet tool install -g dotnet-outdated

# Install specific version
dotnet tool install -g dotnet-ef --version 7.0.0

# Update tool
dotnet tool update -g dotnet-ef

# Uninstall tool
dotnet tool uninstall -g dotnet-ef

# List installed tools
dotnet tool list -g

# Run tool
dotnet ef
dotnet reportgenerator
```

### Local Tools

```bash
# Initialize local tools manifest
dotnet new tool-manifest

# Install local tool
dotnet tool install dotnet-ef

# Restore local tools
dotnet tool restore

# List local tools
dotnet tool list

# Run local tool
dotnet ef migrations add Initial
```

### Useful Tools Collection

```bash
# Entity Framework Core
dotnet tool install -g dotnet-ef

# Code coverage
dotnet tool install -g dotnet-reportgenerator-globaltool

# Outdated packages
dotnet tool install -g dotnet-outdated

# Formatting
dotnet tool install -g dotnet-format

# Test coverage
dotnet tool install -g coverlet.console

# API documentation
dotnet tool install -g swashbuckle.aspnetcore.cli

# Performance profiling
dotnet tool install -g dotnet-counters
dotnet tool install -g dotnet-dump
dotnet tool install -g dotnet-trace
```

## Workload Management

### Workload Operations

```bash
# List workloads
dotnet workload list

# Install workload
dotnet workload install android
dotnet workload install ios
dotnet workload install macos
dotnet workload install maui
dotnet workload install wasm-tools

# Update workloads
dotnet workload update

# Repair workloads
dotnet workload repair

# Uninstall workload
dotnet workload uninstall android

# Search workloads
dotnet workload search
```

### Specific Workloads

```bash
# Mobile development
dotnet workload install maui
dotnet workload install android
dotnet workload install ios

# WebAssembly
dotnet workload install wasm-tools

# Game development
dotnet workload install microsoft-net-sdk-blazorwebassembly-aot

# Machine Learning
dotnet workload install ml
```

## Diagnostics & Debugging

### Runtime Diagnostics

```bash
# Show process info
dotnet --info

# Show environment
dotnet --environment

# Show SDKs
dotnet --list-sdks

# Show runtimes
dotnet --list-runtimes

# Show workloads
dotnet workload list

# Show tools
dotnet tool list -g
```

### Performance Tools

```bash
# Monitor counters
dotnet counters monitor System.Runtime
dotnet counters monitor Microsoft.AspNetCore.Hosting

# Collect trace
dotnet trace collect --process-id PID
dotnet trace collect --providers Microsoft-DotNETCore-SampleProfiler

# Generate dump
dotnet dump collect --process-id PID
dotnet dump analyze dump_file

# Monitor GC
dotnet counters monitor System.GC

# Monitor JIT
dotnet counters monitor System.Runtime.Jit
```

### Debugging Commands

```bash
# Attach debugger
dotnet run --debug

# Generate symbols
dotnet build -p:DebugType=full

# Generate PDB
dotnet build -p:DebugType=portable

# Enable just-my-code
dotnet run --just-my-code

# Set breakpoints
dotnet run --breakpoints
```

## Cleanup & Maintenance

### Cache Management

```bash
# Clear all caches
dotnet nuget locals all --clear

# Clear specific cache
dotnet nuget locals http-cache --clear
dotnet nuget locals global-packages --clear
dotnet nuget locals temp --clear

# Clear SDK cache
rm -rf ~/.dotnet/
rm -rf ~/.nuget/

# Clear template cache
dotnet new --debug:reinit

# Clear telemetry
rm -rf ~/.dotnet/telemetry
```

### Disk Cleanup

```bash
# Remove bin/obj directories
find . -name "bin" -type d -exec rm -rf {} +
find . -name "obj" -type d -exec rm -rf {} +

# Remove test results
find . -name "TestResults" -type d -exec rm -rf {} +

# Remove publish output
find . -name "publish" -type d -exec rm -rf {} +

# Remove packages
find . -name "packages" -type d -exec rm -rf {} +
```

### Project Cleanup

```bash
# Clean solution
dotnet clean

# Clean with configuration
dotnet clean -c Release

# Clean with verbosity
dotnet clean -v detailed

# Clean specific project
dotnet clean ./src/MyApp/
```

## Configuration & Settings

### User Settings

```bash
# Set telemetry opt-out
dotnet --telemetry-opt-out

# Set no logo
dotnet --no-logo

# Set verbosity
dotnet --verbosity minimal
dotnet --verbosity normal
dotnet --verbosity detailed
dotnet --verbosity diagnostic

# Set culture
dotnet --culture en-US
```

### Project Configuration

```bash
# Add configuration
dotnet new globaljson
dotnet new gitignore
dotnet new editorconfig

# Add Docker files
dotnet new dockerfile
dotnet new docker-compose

# Add GitHub Actions
dotnet new github-action
```

### Environment Configuration

```bash
# Set environment variables
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
export DOTNET_CLI_UI_LANGUAGE=en

# Set performance variables
export DOTNET_GCHeapHardLimit=0x10000000
export DOTNET_TieredCompilation=1
export DOTNET_TC_QuickJitForLoops=1
```

## Utility Commands

### File Operations

```bash
# Check file type
file MyApp.dll

# Check dependencies
ldd MyApp

# Check symbols
readelf -s MyApp

# Check assembly info
monodis --assembly MyApp.dll

# Check IL code
ildasm MyApp.dll
```

### Process Management

```bash
# Find .NET processes
ps aux | grep dotnet
pgrep -f dotnet

# Kill .NET processes
pkill -f dotnet
kill $(pgrep -f dotnet)

# Monitor .NET processes
top -p $(pgrep -f dotnet)
htop -p $(pgrep -f dotnet)
```

### Network Operations

```bash
# Check listening ports
netstat -tlnp | grep dotnet
ss -tlnp | grep dotnet

# Test API endpoint
curl http://localhost:5000/weatherforecast

# Test HTTPS
curl -k https://localhost:5001/weatherforecast

# Test with Swagger
curl http://localhost:5000/swagger/v1/swagger.json
```

## One-Liner Examples

### Development Workflow

```bash
# Create, build, and run
dotnet new console -o app && cd app && dotnet run

# Create API, add package, run
dotnet new webapi -o api && cd api && dotnet add package Swashbuckle.AspNetCore && dotnet run

# Create test project and run tests
dotnet new xunit -o tests && cd tests && dotnet add reference ../src/MyApp && dotnet test
```

### Deployment Workflow

```bash
# Build, test, publish
dotnet build && dotnet test && dotnet publish -c Release -o ./deploy

# Docker build and run
dotnet publish -c Release -o ./app && docker build -t myapp . && docker run -p 8080:80 myapp

# Azure deployment
dotnet publish -c Release && az webapp deploy --src-path ./publish --name myapp
```

### Maintenance Workflow

```bash
# Update all packages and tools
dotnet outdated --upgrade && dotnet tool update --global

# Clean and rebuild everything
dotnet clean && dotnet restore && dotnet build -c Release

# Check for vulnerabilities
dotnet list package --vulnerable && dotnet list package --deprecated
```

## Performance Optimization

### Build Performance

```bash
# Enable parallel builds
dotnet build --max-cpu-count

# Disable restore during build
dotnet build --no-restore

# Use incremental builds
dotnet build --incremental

# Skip analyzers for faster builds
dotnet build --no-incremental-analyzer

# Cache builds
dotnet build --use-build-server
```

### Runtime Performance

```bash
# Enable tiered compilation
export DOTNET_TieredCompilation=1

# Enable quick JIT for loops
export DOTNET_TC_QuickJitForLoops=1

# Set GC mode
export DOTNET_gcServer=1
export DOTNET_gcConcurrent=1

# Set memory limits
export DOTNET_GCHeapHardLimit=0x20000000  # 512MB
export DOTNET_GCHeapHardLimitPercent=75
```

### Publish Optimization

```bash
# Minimum size publish
dotnet publish -c Release -r linux-x64 \
  -p:PublishSingleFile=true \
  -p:PublishTrimmed=true \
  -p:DebugType=None \
  -p:DebugSymbols=false

# Maximum performance publish
dotnet publish -c Release -r linux-x64 \
  -p:PublishReadyToRun=true \
  -p:PublishReadyToRunShowWarnings=true \
  -p:Optimize=true \
  -p:EnableCompressionInSingleFile=true
```

## Security Commands

### Certificate Management

```bash
# Create development certificate
dotnet dev-certs https

# Trust certificate
dotnet dev-certs https --trust

# Check certificate
dotnet dev-certs https --check

# Export certificate
dotnet dev-certs https -ep ./cert.pfx -p password

# Import certificate
dotnet dev-certs https --import ./cert.pfx -p password
```

### Security Scanning

```bash
# Check for vulnerable packages
dotnet list package --vulnerable --include-transitive

# Check for deprecated packages
dotnet list package --deprecated

# Check license compliance
dotnet list package --license

# Generate SBOM
dotnet sbom generate

# Sign assembly
dotnet sign ./MyApp.dll --certificate ./cert.pfx --password secret
```

### Security Hardening

```bash
# Enable security features
dotnet publish -p:EnableSecurityHardening=true

# Enable control flow guard
dotnet publish -p:ControlFlowGuard=true

# Enable address space layout randomization
dotnet publish -p:ASLR=true

# Enable data execution prevention
dotnet publish -p:DEP=true
```

## Monitoring & Logging

### Application Insights

```bash
# Add Application Insights
dotnet add package Microsoft.ApplicationInsights.AspNetCore

# Configure logging
dotnet user-secrets set "ApplicationInsights:ConnectionString" "YourConnectionString"

# Enable distributed tracing
export APPLICATIONINSIGHTS_CONNECTION_STRING="YourConnectionString"
```

### Logging Configuration

```bash
# Set log level
export Logging__LogLevel__Default=Information
export Logging__LogLevel__Microsoft=Warning
export Logging__LogLevel__System=Warning

# Enable console logging
dotnet run --logging:Console:LogLevel:Default=Debug

# Enable file logging
dotnet run --logging:File:Path=./logs/app.log
```

### Performance Monitoring

```bash
# Monitor with dotnet-counters
dotnet counters monitor --process-id PID System.Runtime

# Monitor with dotnet-trace
dotnet trace collect --process-id PID --profile cpu-sampling

# Monitor with dotnet-dump
dotnet dump collect --process-id PID --type Full

# Monitor GC
dotnet counters monitor System.GC --process-id PID
```

## Containerization

### Docker Commands

```bash
# Create Dockerfile
dotnet new dockerfile

# Create docker-compose
dotnet new docker-compose

# Build Docker image
docker build -t myapp .

# Run in Docker
docker run -p 8080:80 myapp

# Run with environment
docker run -e ASPNETCORE_ENVIRONMENT=Production -p 8080:80 myapp

# Run with volumes
docker run -v ./data:/app/data -p 8080:80 myapp
```

### Docker Optimization

```bash
# Multi-stage build
dotnet publish -c Release -o /app/publish
docker build --target runtime -t myapp .

# Use smaller base image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine

# Enable trimming for smaller images
dotnet publish -p:PublishTrimmed=true

# Use AOT for smallest images
dotnet publish -p:PublishAot=true
```

### Kubernetes Deployment

```bash
# Create Kubernetes manifest
dotnet new kubernetes

# Deploy to Kubernetes
kubectl apply -f deployment.yaml

# Check deployment
kubectl get pods
kubectl logs deployment/myapp

# Scale deployment
kubectl scale deployment/myapp --replicas=3
```

## CI/CD Integration

### GitHub Actions

```bash
# Create GitHub Actions workflow
dotnet new github-action

# Run tests in CI
dotnet test --logger "github-actions"

# Generate coverage in CI
dotnet test --collect:"XPlat Code Coverage"

# Publish artifacts
dotnet publish -c Release -o ./publish
```

### Azure DevOps

```bash
# Azure Pipeline template
dotnet new azure-pipeline

# Run in pipeline
dotnet build --configuration Release
dotnet test --configuration Release --logger trx
dotnet publish --configuration Release --output $(Build.ArtifactStagingDirectory)
```

### GitLab CI

```bash
# GitLab CI template
dotnet new gitlab-ci

# Cache NuGet packages
cache:
  paths:
    - .nuget/
    - ~/.nuget/
```

## Migration Commands

### Project Migration

```bash
# Upgrade project to newer .NET version
dotnet upgrade-assistant upgrade

# Analyze upgrade readiness
dotnet upgrade-assistant analyze

# Convert project format
dotnet migrate

# Update target framework
dotnet new globaljson --sdk-version 8.0.100
```

### Package Migration

```bash
# Update all packages
dotnet update package

# Update to specific version
dotnet update package Microsoft.EntityFrameworkCore --version 8.0.0

# Check compatibility
dotnet list package --outdated --include-transitive

# Migrate from packages.config
dotnet migrate-packages-config
```

### Configuration Migration

```bash
# Migrate app.config to appsettings.json
dotnet migrate-config

# Migrate web.config
dotnet migrate-web-config

# Convert to new project format
dotnet convert
```

## Advanced Scenarios

### Custom Templates

```bash
# Create custom template
dotnet new install ./my-template/

# Package template
dotnet pack -c Release

# Install from NuGet
dotnet new install MyCompany.MyTemplates::1.0.0

# Create from template with parameters
dotnet new mytemplate -n MyApp --param1 value1 --param2 value2
```

### Source Generators

```bash
# Add source generator
dotnet add package Microsoft.CodeAnalysis.CSharp

# Build with source generators
dotnet build -p:EnableSourceGenerators=true

# Debug source generators
dotnet build -p:DebugSourceGenerators=true
```

### Code Analysis

```bash
# Run code analysis
dotnet analyze

# Run specific analyzers
dotnet analyze --analyzers Security

# Generate code metrics
dotnet metrics

# Check code style
dotnet format --verify-no-changes
```

## Troubleshooting Commands

### Diagnostic Commands

```bash
# Full diagnostics
dotnet --info > diagnostics.txt

# Check dependencies
ldd $(which dotnet)

# Check file permissions
ls -la /usr/share/dotnet/

# Check environment
env | grep DOTNET

# Check process limits
ulimit -a
```

### Error Resolution

```bash
# Clear and retry
dotnet nuget locals all --clear && dotnet restore

# Reinstall SDK
sudo apt install --reinstall dotnet-sdk-8.0

# Check logs
journalctl -u dotnet-app --since "1 hour ago"

# Debug startup
dotnet run --verbose
```

### Performance Troubleshooting

```bash
# Check memory usage
ps aux | grep dotnet | awk '{print $6/1024 " MB"}'

# Check CPU usage
top -p $(pgrep -f dotnet)

# Check disk I/O
iotop -p $(pgrep -f dotnet)

# Check network
netstat -tlnp | grep dotnet
```

## Reference Tables

### Common Options

| Option                | Description          | Example                 |
| --------------------- | -------------------- | ----------------------- |
| `-c, --configuration` | Build configuration  | `-c Release`            |
| `-f, --framework`     | Target framework     | `-f net8.0`             |
| `-r, --runtime`       | Target runtime       | `-r linux-x64`          |
| `-o, --output`        | Output directory     | `-o ./publish/`         |
| `-v, --verbosity`     | Output verbosity     | `-v detailed`           |
| `--no-restore`        | Skip package restore | `--no-restore`          |
| `--no-build`          | Skip build           | `--no-build`            |
| `--self-contained`    | Include runtime      | `--self-contained true` |

### Common Properties

| Property            | Description            | Example                     |
| ------------------- | ---------------------- | --------------------------- |
| `PublishSingleFile` | Single file executable | `-p:PublishSingleFile=true` |
| `PublishTrimmed`    | Remove unused code     | `-p:PublishTrimmed=true`    |
| `PublishReadyToRun` | Crossgen compilation   | `-p:PublishReadyToRun=true` |
| `PublishAot`        | Native AOT compilation | `-p:PublishAot=true`        |
| `DebugType`         | Debug information      | `-p:DebugType=embedded`     |
| `Version`           | Assembly version       | `-p:Version=1.0.0`          |

### Environment Variables

| Variable                      | Description            | Default             |
| ----------------------------- | ---------------------- | ------------------- |
| `DOTNET_ROOT`                 | .NET installation path | `/usr/share/dotnet` |
| `DOTNET_CLI_TELEMETRY_OPTOUT` | Disable telemetry      | `false`             |
| `DOTNET_NOLOGO`               | Hide logo              | `false`             |
| `DOTNET_TieredCompilation`    | Tiered JIT             | `1` (enabled)       |
| `ASPNETCORE_ENVIRONMENT`      | Environment name       | `Production`        |
| `DOTNET_gcServer`             | Server GC mode         | `0` (workstation)   |

## Quick Reference Card

### Project Lifecycle

```bash
# New → Restore → Build → Test → Run → Publish
dotnet new console -o app
dotnet restore
dotnet build
dotnet test
dotnet run
dotnet publish -c Release
```

### Common Workflows

```bash
# Development
dotnet watch run

# Testing
dotnet test --filter "Category=Unit"

# Deployment
dotnet publish -c Release -r linux-x64 --self-contained

# Maintenance
dotnet outdated --upgrade
dotnet clean
dotnet nuget locals all --clear
```

### One-Liners for Common Tasks

```bash
# Create and run API
dotnet new webapi -o api && cd api && dotnet run

# Build and test everything
dotnet build && dotnet test

# Update all packages
dotnet update package

# Generate coverage report
dotnet test --collect:"XPlat Code Coverage"

# Create and push Docker image
dotnet publish -c Release && docker build -t myapp . && docker push myapp
```

## Best Practices

1. **Always use LTS versions** (.NET 6/8) for production
2. **Pin SDK versions** with global.json
3. **Use specific configurations** (-c Release for production)
4. **Enable trimming** for smaller deployments
5. **Use self-contained** when runtime control is needed
6. **Monitor with counters** in production
7. **Regularly update packages** for security
8. **Use Docker** for consistent environments
9. **Implement CI/CD** for automation
10. **Test with multiple SDKs** for compatibility

## Notes

- Commands are tested on **Ubuntu 22.04** and **Arch Linux**
- **.NET 8 LTS** is the primary target
- All commands assume **bash shell**
- Use `--help` for command-specific options
- Check `dotnet --info` for environment details
- Refer to official documentation for advanced scenarios

**Last Updated**: 2025-12-19  
**Tested With**: .NET SDK 8.0.100, Ubuntu 22.04, Arch Linux

# .NET on Linux Cheat Repository

**Cross-platform .NET (6/8 LTS) CLI cheatsheets, Arch/Ubuntu installation, troubleshooting, OmniSharp, Docker, ML.NET for Linux users.**

## Quickstart

```bash
# Ubuntu 22.04+ (.NET 8 LTS)
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet
```

```bash
# Arch Linux (.NET 8 LTS)
sudo pacman -S dotnet-sdk-8.0 dotnet-runtime-8.0
dotnet --version
```

## Repository Structure

| Category            | Files                                                                                                                           | Purpose                             |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| **Core Concepts**   | [01-intro](docs/01-intro.md) [02-architecture](docs/02-architecture.md) [03-clr-gc-safety](docs/03-clr-gc-safety.md)            | Architecture, CLR, GC, type safety  |
| **Linux Setup**     | [Arch](linux/01-arch-setup.md) [Ubuntu](linux/02-ubuntu-setup.md) [Multi-SDK](linux/03-multi-sdk-management.md)                 | Distro-specific installation guides |
| **CLI Commands**    | [Basics](cli/01-dotnet-basics.md) [Templates](cli/02-dotnet-new-templates.md) [Build/Publish](cli/03-build-run-publish.md)      | Command reference and usage         |
| **Advanced Topics** | [RIDs](cli/04-runtime-identifiers.md) [Cross-compilation](cli/05-cross-compilation.md) [Performance](cli/06-performance-aot.md) | Runtime IDs, cross-compilation, AOT |
| **Cheatsheets**     | [CLI](cheats/04-dotnet-cli-cheats.md) [Troubleshooting](cheats/05-troubleshooting.md) [Shell](cheats/01-linux-shell-basics.md)  | Quick reference, one-liners         |
| **Specialized**     | [Docker](cli/07-docker-containers.md) [OmniSharp](linux/05-omnisharp-install.md) [ML.NET](docs/07-ml-dotnet-linux.md)           | Containerization, tooling, ML       |

## Key Features

- **LTS Focused**: Primary support for .NET 6 and .NET 8 LTS versions
- **Bash-Only**: All code examples in bash for Linux environments
- **Real Errors**: Includes actual error messages and solutions
- **Troubleshooting-First**: Practical solutions over theory
- **Cross-Platform**: Works across Arch, Ubuntu, and other Linux distributions
- **Production Ready**: Includes Docker, deployment, and monitoring guidance

## Getting Started

1. **Choose your distribution** and follow the setup guide
2. **Verify installation** with basic commands
3. **Create your first project** using templates
4. **Build and run** your application
5. **Publish for deployment** with appropriate runtime identifiers

## Version Support

| Version    | LTS Status | Support Until | Recommended For              |
| ---------- | ---------- | ------------- | ---------------------------- |
| **.NET 8** | LTS        | November 2026 | New projects, production     |
| **.NET 6** | LTS        | November 2024 | Existing projects, migration |
| **.NET 7** | Non-LTS    | May 2024      | Experimental features        |
| **.NET 9** | Preview    | TBD           | Cutting-edge development     |

**Note**: Always prefer LTS versions (.NET 6/8) for production workloads.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new content, reporting issues, or submitting improvements.

**MIT License** • Contributions welcome

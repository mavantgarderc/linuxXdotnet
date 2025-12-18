# 02 – Ubuntu .NET Setup

## Install .NET 8 LTS (Microsoft Packages)

```bash
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0
```

## Verify Installation

```bash
dotnet --version        # Confirm 8.0.x
dotnet --info           # SDK, runtimes, OS
dotnet new console -o testapp && cd testapp && dotnet run
```

## Common Issues

**Error:** `It was not possible to find any installed .NET SDKs`
```bash
dotnet --list-sdks
sudo apt remove 'dotnet*' 'aspnet*' 'netstandard*'
sudo apt install -y dotnet-sdk-8.0
```

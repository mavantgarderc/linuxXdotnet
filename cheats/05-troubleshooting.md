# 05 – Troubleshooting

## Common Errors

**`dotnet: command not found`**
```bash
echo 'export PATH=$PATH:/opt/dotnet' >> ~/.bashrc
source ~/.bashrc
which dotnet
```

**`libhostpolicy.so could not be found`**
```bash
sudo apt install libc6-dev libssl-dev libunwind8
# Arch: sudo pacman -S openssl libunwind
```

**`It was not possible to find any installed .NET SDKs`**
```bash
dotnet --list-sdks
sudo pacman -S dotnet-sdk-8.0  # Reinstall LTS
```

## Diagnostics

```bash
dotnet --info > dotnet-info.txt
dotnet workload list
ldd $(which dotnet) | grep "not found"
```

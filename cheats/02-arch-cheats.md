# 02 – Arch Linux Cheats

## Package Management

```bash
sudo pacman -S dotnet-sdk-8.0 dotnet-runtime-8.0
yay -S dotnet-sdk-bin       # AUR latest
pacman -Qs dotnet           # Check installed
```

## Service Management

```bash
sudo systemctl status dotnet-myapp
sudo systemctl start dotnet-myapp
journalctl -u dotnet-myapp -f  # Logs
```

## Updates

```bash
sudo pacman -Syu dotnet-sdk-8.0  # Update .NET 8
```

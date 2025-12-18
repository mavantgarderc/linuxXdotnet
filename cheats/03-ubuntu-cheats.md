# 03 – Ubuntu Cheats

## APT Management

```bash
sudo apt update
sudo apt install dotnet-sdk-8.0
apt list --installed | grep dotnet
```

## Microsoft Repo

```bash
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
```

## Systemd Services

```bash
sudo systemctl status kestrel-myapp.service
journalctl -u kestrel-myapp -f
```

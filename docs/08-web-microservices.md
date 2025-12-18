# 08 – Web & Microservices

## API Templates

```bash
dotnet new webapi -minimal  # Minimal API (.NET 6+)
dotnet new webapi           # Controller-based
dotnet run --urls http://0.0.0.0:5000
```

## Kestrel Configuration

```bash
# appsettings.json or Program.cs
{
  "Kestrel": {
    "Endpoints": {
      "Http": { "Url": "http://*:8080" }
    }
  }
}
```

## Reverse Proxy (nginx)

```bash
sudo systemctl start nginx
# /etc/nginx/sites-available/dotnet.conf
server {
  listen 80;
  location / { proxy_pass http://localhost:5000; }
}
```

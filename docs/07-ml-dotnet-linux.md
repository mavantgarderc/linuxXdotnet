# 07 – ML.NET on Linux

## Install ML Workload

```bash
dotnet workload install ml
dotnet workload list         # ml.1.8.0 installed
```

## Basic ML Pipeline

```bash
dotnet new ml              # ML console app
dotnet add package Microsoft.ML.Vision
# Image classification, sentiment, regression
dotnet run                 # Trains on Linux
```

## Model Deployment

```bash
dotnet publish -c Release -r linux-x64
# Models (.zip) included in publish output
ls -la bin/Release/net8.0/linux-x64/publish/
```

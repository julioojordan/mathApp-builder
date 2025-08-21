# run.ps1

$ErrorActionPreference = "Stop" 

try {
    Write-Host "Updating Repository..."
    .\update.ps1

    Write-Host "Copying .env files..."
    Copy-Item -Path "./mathApp-service/.env.example" -Destination "./mathApp-service/.env" -Force
    Copy-Item -Path "./mathApp/.env.example" -Destination "./mathApp/.env" -Force

    Write-Host "Stopping and removing containers..."
    docker-compose down -v

    Write-Host "Building and starting containers..."
    docker-compose up --build -d

    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "An error occurred: $($_.Exception.Message)"
    exit 1
# Pastikan update dilakukan
Write-Host "Updating Repository..."
.\update.ps1

Write-Host "Composing Apps...."
docker-compose down -v
docker-compose up --build -d
Write-Host "Please Wait"

Write-Host "MathApp WIll Be Ready at  http://localhost:3000 in a few second"


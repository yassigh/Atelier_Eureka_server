# ========================================================
# Script de lancement global de l'ecosysteme Eureka
# ========================================================

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

Write-Host "Demarrage du serveur Eureka (8761)..." -ForegroundColor Cyan
Start-Process java -ArgumentList "-jar","target\eureka-server-1.0-SNAPSHOT.jar" -WorkingDirectory $root
Start-Sleep -Seconds 12

Write-Host "Demarrage du microservice Candidat (8081)..." -ForegroundColor Green
Start-Process java -ArgumentList "-jar","backend\microservice\candidat-service\target\candidat-service-1.0-SNAPSHOT.jar" -WorkingDirectory $root

Write-Host "Demarrage du microservice Job (8082)..." -ForegroundColor Green
Start-Process java -ArgumentList "-jar","backend\microservice\job-service\target\job-service-1.0-SNAPSHOT.jar" -WorkingDirectory $root

Write-Host "Demarrage du microservice Meeting Node.js instance 1 (8083)..." -ForegroundColor Yellow
Start-Process cmd.exe -ArgumentList "/c set PORT=8083 && node server.js" -WorkingDirectory "$root\backend\microservice\meeting-service"

Write-Host "Demarrage du microservice Meeting Node.js instance 2 (8086)..." -ForegroundColor Yellow
Start-Process cmd.exe -ArgumentList "/c set PORT=8086 && node server.js" -WorkingDirectory "$root\backend\microservice\meeting-service"

Write-Host "Demarrage du microservice Notification FastAPI (8084)..." -ForegroundColor Magenta
Start-Process cmd.exe -ArgumentList "/c set PORT=8084 && python main.py" -WorkingDirectory "$root\backend\microservice\notification-service"

Write-Host "`nTous les services ont ete lances !" -ForegroundColor Green
Write-Host "Veuillez patienter ~20 a 30 secondes que tous les services s'enregistrent aupres d'Eureka." -ForegroundColor Yellow
Write-Host "Accedez ensuite au tableau de bord Eureka et actualisez (F5) : http://localhost:8761" -ForegroundColor Cyan
Write-Host "Pour tout arreter, executez .\stop-all.ps1" -ForegroundColor Gray

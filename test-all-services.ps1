$procs = @()

Write-Host "=== 1. Lancement d'Eureka Server (8761) ===" -ForegroundColor Cyan
$pEureka = Start-Process java -ArgumentList "-jar","target\eureka-server-1.0-SNAPSHOT.jar" -PassThru
$procs += $pEureka
Start-Sleep -Seconds 12

Write-Host "=== 2. Lancement de Candidat (8081) ===" -ForegroundColor Cyan
$pCandidat = Start-Process java -ArgumentList "-jar","backend\microservice\candidat-service\target\candidat-service-1.0-SNAPSHOT.jar" -PassThru
$procs += $pCandidat

Write-Host "=== 3. Lancement de Job (8082) ===" -ForegroundColor Cyan
$pJob = Start-Process java -ArgumentList "-jar","backend\microservice\job-service\target\job-service-1.0-SNAPSHOT.jar" -PassThru
$procs += $pJob

Write-Host "=== 4. Lancement de Meeting Node.js instance 1 (8083) ===" -ForegroundColor Cyan
$pMeeting1 = Start-Process cmd.exe -ArgumentList "/c cd backend\microservice\meeting-service && set PORT=8083 && node server.js" -PassThru
$procs += $pMeeting1

Write-Host "=== 5. Lancement de Meeting Node.js instance 2 (8086) ===" -ForegroundColor Cyan
$pMeeting2 = Start-Process cmd.exe -ArgumentList "/c cd backend\microservice\meeting-service && set PORT=8086 && node server.js" -PassThru
$procs += $pMeeting2

Write-Host "=== 6. Lancement de Notification FastAPI (8084) ===" -ForegroundColor Cyan
$pNotif = Start-Process cmd.exe -ArgumentList "/c cd backend\microservice\notification-service && set PORT=8084 && python main.py" -PassThru
$procs += $pNotif

Write-Host "`nAttente de l'enregistrement de tous les services aupres d'Eureka (25 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 25

Write-Host "`n=== Test des endpoints Candidat (8081) ===" -ForegroundColor Green
try {
    $resCandHello = Invoke-RestMethod -Uri "http://localhost:8081/api/candidates/hello" -Method Get
    Write-Host "Candidat Hello OK:" ($resCandHello | ConvertTo-Json -Compress)
    $resCandHealth = Invoke-RestMethod -Uri "http://localhost:8081/actuator/health" -Method Get
    Write-Host "Candidat /actuator/health OK (Status: $($resCandHealth.status))"
    $resCandInfo = Invoke-RestMethod -Uri "http://localhost:8081/actuator/info" -Method Get
    Write-Host "Candidat /actuator/info OK:" ($resCandInfo | ConvertTo-Json -Compress)
} catch {
    Write-Host "Candidat ERREUR:" $_.Exception.Message
}

Write-Host "`n=== Test des endpoints Job (8082) ===" -ForegroundColor Green
try {
    $resJobHello = Invoke-RestMethod -Uri "http://localhost:8082/api/jobs/hello" -Method Get
    Write-Host "Job Hello OK:" ($resJobHello | ConvertTo-Json -Compress)
    $resJobHealth = Invoke-RestMethod -Uri "http://localhost:8082/actuator/health" -Method Get
    Write-Host "Job /actuator/health OK (Status: $($resJobHealth.status))"
    $resJobInfo = Invoke-RestMethod -Uri "http://localhost:8082/actuator/info" -Method Get
    Write-Host "Job /actuator/info OK:" ($resJobInfo | ConvertTo-Json -Compress)
} catch {
    Write-Host "Job ERREUR:" $_.Exception.Message
}

Write-Host "`n=== Test des endpoints Meeting Node.js (8083, 8086) ===" -ForegroundColor Green
try {
    $resMeeting = Invoke-RestMethod -Uri "http://localhost:8083/api/meetings/hello" -Method Get
    Write-Host "Meeting 8083 Hello OK:" ($resMeeting | ConvertTo-Json -Compress)
    $resMeetingHealth = Invoke-RestMethod -Uri "http://localhost:8083/health" -Method Get
    Write-Host "Meeting 8083 /health OK:" ($resMeetingHealth | ConvertTo-Json -Compress)
    $resMeetingInfo = Invoke-RestMethod -Uri "http://localhost:8083/info" -Method Get
    Write-Host "Meeting 8083 /info OK:" ($resMeetingInfo | ConvertTo-Json -Compress)
} catch {
    Write-Host "Meeting 8083 ERREUR:" $_.Exception.Message
}

try {
    $resMeeting2 = Invoke-RestMethod -Uri "http://localhost:8086/api/meetings/hello" -Method Get
    Write-Host "Meeting 8086 Hello OK:" ($resMeeting2 | ConvertTo-Json -Compress)
    $resMeeting2Health = Invoke-RestMethod -Uri "http://localhost:8086/health" -Method Get
    Write-Host "Meeting 8086 /health OK:" ($resMeeting2Health | ConvertTo-Json -Compress)
    $resMeeting2Info = Invoke-RestMethod -Uri "http://localhost:8086/info" -Method Get
    Write-Host "Meeting 8086 /info OK:" ($resMeeting2Info | ConvertTo-Json -Compress)
} catch {
    Write-Host "Meeting 8086 ERREUR:" $_.Exception.Message
}

Write-Host "`n=== Test des endpoints Notification FastAPI (8084) ===" -ForegroundColor Green
try {
    $resNotif = Invoke-RestMethod -Uri "http://localhost:8084/api/notifications/hello" -Method Get
    Write-Host "Notification 8084 Hello OK:" ($resNotif | ConvertTo-Json -Compress)
    $resNotifHealth = Invoke-RestMethod -Uri "http://localhost:8084/health" -Method Get
    Write-Host "Notification 8084 /health OK:" ($resNotifHealth | ConvertTo-Json -Compress)
    $resNotifInfo = Invoke-RestMethod -Uri "http://localhost:8084/info" -Method Get
    Write-Host "Notification 8084 /info OK:" ($resNotifInfo | ConvertTo-Json -Compress)
} catch {
    Write-Host "Notification 8084 ERREUR:" $_.Exception.Message
}

Write-Host "`n=== Verification des services enregistres dans Eureka (JSON) ===" -ForegroundColor Green
try {
    $headers = @{ "Accept" = "application/json" }
    $eurekaApps = Invoke-RestMethod -Uri "http://localhost:8761/eureka/apps" -Headers $headers -Method Get
    $apps = $eurekaApps.applications.application
    foreach ($app in $apps) {
        $instances = @($app.instance)
        Write-Host ("Application: {0} | Instances ({1})" -f $app.name, $instances.Count) -ForegroundColor Yellow
        foreach ($inst in $instances) {
            Write-Host ("  -> Instance ID: {0} | Status: {1} | statusPageUrl: {2} | healthCheckUrl: {3}" -f $inst.instanceId, $inst.status, $inst.statusPageUrl, $inst.healthCheckUrl) -ForegroundColor White
        }
    }
} catch {
    Write-Host "Erreur interrogation registre Eureka:" $_.Exception.Message
}

Write-Host "`nArret de tous les services..." -ForegroundColor Magenta
foreach ($p in $procs) {
    try {
        Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
    } catch {}
}
Get-Process -Name java, node, python -ErrorAction SilentlyContinue | Where-Object { $_.StartTime -gt (Get-Date).AddMinutes(-5) } | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "Tous les processus arretes."

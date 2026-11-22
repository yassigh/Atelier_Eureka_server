Write-Host "Arret de tous les microservices..." -ForegroundColor Red
Get-Process -Name java, node, python -ErrorAction SilentlyContinue | Where-Object { 
    $_.StartTime -gt (Get-Date).AddHours(-4)
} | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "Tous les microservices ont ete arretes." -ForegroundColor Green

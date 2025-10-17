# Script para matar el proceso del backend y reiniciarlo
# Ejecutar como Administrador: click derecho -> "Ejecutar con PowerShell"

Write-Host "=== Matando proceso del backend en puerto 3001 ===" -ForegroundColor Yellow

# Encontrar el PID del proceso en el puerto 3001
$processId = (Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue).OwningProcess

if ($processId) {
    Write-Host "Proceso encontrado: PID $processId" -ForegroundColor Green

    try {
        Stop-Process -Id $processId -Force
        Write-Host "Proceso eliminado exitosamente" -ForegroundColor Green
        Start-Sleep -Seconds 2
    }
    catch {
        Write-Host "Error al eliminar proceso: $_" -ForegroundColor Red
        Write-Host "`nPor favor, ejecuta este script como Administrador:" -ForegroundColor Yellow
        Write-Host "  1. Click derecho en el archivo" -ForegroundColor Cyan
        Write-Host "  2. Selecciona 'Ejecutar con PowerShell'" -ForegroundColor Cyan
        Read-Host "`nPresiona Enter para salir"
        exit 1
    }
}
else {
    Write-Host "No hay ningun proceso en el puerto 3001" -ForegroundColor Yellow
}

Write-Host "`n=== Iniciando nuevo servidor ===" -ForegroundColor Yellow
Set-Location "C:\tarot\smart-divination\backend"

Write-Host "Iniciando servidor con deepseek-reasoner..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\tarot\smart-divination\backend; npm run dev"

Write-Host "`nServidor iniciado!" -ForegroundColor Green
Write-Host "El servidor ahora utilizara deepseek-reasoner" -ForegroundColor Green
Read-Host "`nPresiona Enter para cerrar"

@echo off
echo === Reiniciant backend amb deepseek-reasoner ===
echo.
echo Matant proces al port 3001...
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :3001') DO (
    taskkill /F /PID %%P 2>nul
    if errorlevel 1 (
        echo ERROR: Necessites executar aquest script com a Administrador
        echo Click dret al fitxer ^> "Executar com a administrador"
        pause
        exit /b 1
    )
)

echo Proces eliminat correctament
timeout /t 2 /nobreak >nul

echo.
echo Iniciant nou servidor amb deepseek-reasoner...
cd /d C:\tarot\smart-divination\backend
start "Smart Divination Backend" cmd /k "npm run dev"

echo.
echo Backend reiniciat!
echo El servidor ara utilitza deepseek-reasoner
pause

@echo off
chcp 65001 >nul

echo Starting to load Docker images...

REM Check if exported tar files exist
if not exist myapp-backend-prod.tar (
    echo. Error: Exported image file not found (myapp-backend-prod.tar)
    echo. Please ensure this file exists in the same directory as this script.
    pause
    exit /b 1
)

if not exist myapp-frontend-prod.tar (
    echo. Error: Exported image file not found (myapp-frontend-prod.tar)
    echo. Please ensure this file exists in the same directory as this script.
    pause
    exit /b 1
)

REM Load backend image
echo Loading backend image...
docker load -i myapp-backend-prod.tar

if errorlevel 1 (
    echo. Backend image load failed!
    pause
    exit /b 1
)

REM Load frontend image
echo Loading frontend image...
docker load -i myapp-frontend-prod.tar

if errorlevel 1 (
    echo. Frontend image load failed!
    pause
    exit /b 1
)

echo Docker images loaded successfully!
echo Image tags:
echo. - myapp-backend:prod
echo. - myapp-frontend:prod
echo Now you can use docker-compose up to start services.
pause
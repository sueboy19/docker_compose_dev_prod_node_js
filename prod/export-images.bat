@echo off
chcp 65001 >nul

echo Starting to build and export Docker images...

REM Build backend image
echo Building backend image...
docker build -f backend/Dockerfile.prod -t myapp-backend:prod .

if errorlevel 1 (
    echo. Backend image build failed!
    exit /b 1
)

REM Build frontend image
echo Building frontend image...
docker build -f frontend/Dockerfile.prod -t myapp-frontend:prod .

if errorlevel 1 (
    echo. Frontend image build failed!
    exit /b 1
)

REM Export backend image to tar file
echo Exporting backend image...
docker save -o myapp-backend-prod.tar myapp-backend:prod

if errorlevel 1 (
    echo. Backend image export failed!
    exit /b 1
)

REM Export frontend image to tar file
echo Exporting frontend image...
docker save -o myapp-frontend-prod.tar myapp-frontend:prod

if errorlevel 1 (
    echo. Frontend image export failed!
    exit /b 1
)

echo Docker images export completed!
echo Files:
echo. - myapp-backend-prod.tar
echo. - myapp-frontend-prod.tar

REM Optional: Ask to remove local images to save space
set /p DELETE_IMAGES="Remove local images to save space? (y/n): "
if /i "%DELETE_IMAGES%"=="y" (
    docker rmi myapp-backend:prod myapp-frontend:prod
    echo Local images removed.
)

echo Export completed!
pause
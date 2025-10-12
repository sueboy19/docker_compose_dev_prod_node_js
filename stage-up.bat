@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Building application for Stage environment...

REM Build backend
echo Building backend...
cd /d "%~dp0backend"
if exist node_modules (
  echo node_modules directory already exists
) else (
  echo Installing backend dependencies...
  npm install
)

echo Running backend build...
call npm run build
if errorlevel 1 (
    echo Backend build failed!
    pause
    exit /b 1
)

REM Return to project root directory
cd /d "%~dp0"

REM Build frontend
echo Building frontend...
cd /d "%~dp0frontend"
if exist node_modules (
  echo node_modules directory already exists
) else (
  echo Installing frontend dependencies...
  npm install
)

echo Running frontend build...
call npm run build
if errorlevel 1 (
    echo Frontend build failed!
    pause
    exit /b 1
)

REM Return to project root directory
cd /d "%~dp0"

REM Copy build files to stage directory
echo Copying build files to stage directory...

REM First, remove old dist directories if they exist
if exist "%~dp0stage\backend\dist" (
  rmdir /s /q "%~dp0stage\backend\dist"
)
if exist "%~dp0stage\frontend\dist" (
  rmdir /s /q "%~dp0stage\frontend\dist"
)

REM Create destination directories
if not exist "%~dp0stage\backend" mkdir "%~dp0stage\backend"
if not exist "%~dp0stage\frontend" mkdir "%~dp0stage\frontend"

REM Copy build files with verification
echo Copying backend files...
if exist "%~dp0backend\dist" (
  xcopy /s /e /i /y "%~dp0backend\dist" "%~dp0stage\backend\dist"
  echo Backend files copied.
) else (
  echo Error: Backend dist directory does not exist!
  pause
  exit /b 1
)

REM Copy package files for backend
echo Copying backend package files...
if exist "%~dp0backend\package.json" (
  copy "%~dp0backend\package.json" "%~dp0stage\backend\package.json"
  echo Backend package.json copied.
) else (
  echo Error: Backend package.json does not exist!
  pause
  exit /b 1
)

if exist "%~dp0backend\package-lock.json" (
  copy "%~dp0backend\package-lock.json" "%~dp0stage\backend\package-lock.json"
  echo Backend package-lock.json copied.
) else (
  echo Error: Backend package-lock.json does not exist!
  pause
  exit /b 1
)

echo Copying frontend files...
if exist "%~dp0frontend\build" (
  xcopy /s /e /i /y "%~dp0frontend\build" "%~dp0stage\frontend\dist"
  echo Frontend files copied.
) else (
  echo Error: Frontend build directory does not exist!
  pause
  exit /b 1
)

REM Copy nginx configuration to stage root directory
echo Copying nginx configuration...
if exist "%~dp0frontend\nginx.conf" (
  copy "%~dp0frontend\nginx.conf" "%~dp0stage\nginx.conf"
  echo Nginx configuration copied to stage root.
) else (
  echo Error: Frontend nginx.conf does not exist!
  pause
  exit /b 1
)

REM Use Docker Compose to start stage environment
echo Starting stage environment...
cd /d "%~dp0stage"
docker-compose up --build -d

echo Stage environment is now running!
echo Frontend will be accessible at http://localhost:3000
echo Backend API will be accessible at http://localhost:3001
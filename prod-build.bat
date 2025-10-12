@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM Production environment build and export script
REM Mode selection: build (build and export images) - default mode

set MODE=%1
if "%MODE%"=="" set MODE=build

if /I "%MODE%"=="build" (
    echo Building and exporting Docker images mode...
    
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
        echo. Backend build failed!
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
        echo. Frontend build failed!
        pause
        exit /b 1
    )

    REM Return to project root directory
    cd /d "%~dp0"

    REM Copy build files to prod directory
    echo Copying build files to prod directory...

    REM First, remove old dist directories if they exist
    if exist "%~dp0prod\backend\dist" (
      rmdir /s /q "%~dp0prod\backend\dist"
    )
    if exist "%~dp0prod\frontend\dist" (
      rmdir /s /q "%~dp0prod\frontend\dist"
    )

    REM Create destination directories
    if not exist "%~dp0prod\backend" mkdir "%~dp0prod\backend"
    if not exist "%~dp0prod\frontend" mkdir "%~dp0prod\frontend"

    REM Copy build files with verification
    echo Copying backend files...
    if exist "%~dp0backend\dist" (
      xcopy /s /e /i /y "%~dp0backend\dist" "%~dp0prod\backend\dist"
      echo Backend files copied.
    ) else (
      echo. Error: Backend dist directory does not exist!
      pause
      exit /b 1
    )

    REM Copy package files for backend
    echo Copying backend package files...
    if exist "%~dp0backend\package.json" (
      copy "%~dp0backend\package.json" "%~dp0prod\backend\package.json"
      echo Backend package.json copied.
    ) else (
      echo. Error: Backend package.json does not exist!
      pause
      exit /b 1
    )

    if exist "%~dp0backend\package-lock.json" (
      copy "%~dp0backend\package-lock.json" "%~dp0prod\backend\package-lock.json"
      echo Backend package-lock.json copied.
    ) else (
      echo. Error: Backend package-lock.json does not exist!
      pause
      exit /b 1
    )

    echo Copying frontend files...
    if exist "%~dp0frontend\build" (
      xcopy /s /e /i /y "%~dp0frontend\build" "%~dp0prod\frontend\dist"
      echo Frontend files copied.
    ) else (
      echo. Error: Frontend build directory does not exist!
      pause
      exit /b 1
    )

    REM Copy nginx configuration to prod root directory
    echo Copying nginx configuration...
    if exist "%~dp0frontend\nginx.conf" (
      copy "%~dp0frontend\nginx.conf" "%~dp0prod\nginx.conf"
      echo Nginx configuration copied to prod root.
    ) else (
      echo. Error: Frontend nginx.conf does not exist!
      pause
      exit /b 1
    )

    REM Export Docker images
    echo Exporting Docker images...
    cd /d "%~dp0prod"
    call export-images.bat
    
) else (
    echo Usage: %%0 [build]
    echo.  build: Build app and export Docker images (default)
    pause
)
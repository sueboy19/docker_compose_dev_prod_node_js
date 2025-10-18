@echo off
chcp 65001 > nul

echo Starting development environment...

REM Use Docker Compose to start development environment
cd /d "%~dp0"
if exist docker-compose.yml (
    docker-compose up --build -d
    echo Development environment is now running!
    echo Frontend will be accessible at http://localhost:3001
    echo Backend API will be accessible at http://localhost:3000
) else (
    echo. Error: docker-compose.yml file not found
    pause
)
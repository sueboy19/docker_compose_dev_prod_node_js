@echo off
chcp 65001 > nul

echo Production environment startup script
echo Loading Docker images and starting services...

REM Load Docker images and start services
call load-images.bat

echo Starting Production environment...
docker-compose up -d

echo Production environment is now running!
echo Application will be accessible at the configured domain
pause
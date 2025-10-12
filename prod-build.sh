#!/bin/bash

# Production environment build and export script
set -e  # Exit immediately if a command exits with a non-zero status

MODE=${1:-build}

if [ "$MODE" = "build" ] || [ "$MODE" = "export" ]; then
    echo "Building and exporting Docker images mode..."
    
    # Build backend
    echo "Building backend..."
    cd ./backend
    npm install
    npm run build
    cd ..

    # Build frontend
    echo "Building frontend..."
    cd ./frontend
    npm install
    npm run build
    cd ..

    # Copy build files to prod directory
    echo "Copying build files to prod directory..."
    rm -rf ./prod/backend/dist
    rm -rf ./prod/frontend/dist

    cp -r ./backend/dist ./prod/backend/
    cp -r ./frontend/build ./prod/frontend/dist

    # Export Docker images
    echo "Exporting Docker images..."
    cd ./prod
    chmod +x export-images.sh
    ./export-images.sh
    
else
    echo "Usage: $0 [build]"
    echo "  build: Build app and export Docker images (default)"
    exit 1
fi
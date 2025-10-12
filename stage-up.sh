#!/bin/bash

# Stage 環境設置腳本
set -e  # 如果命令以非零狀態退出，則立即退出

echo "正在為 Stage 環境構建應用程式..."

# 構建後端
echo "正在構建後端..."
cd ./backend
npm install
npm run build
cd ..

# 構建前端
echo "正在構建前端..."
cd ./frontend
npm install
npm run build
cd ..

# 將構建文件複製到 stage 目錄
echo "正在將構建文件複製到 stage 目錄..."
rm -rf ./stage/backend/dist
rm -rf ./stage/frontend/dist

cp -r ./backend/dist ./stage/backend/
cp -r ./frontend/build ./stage/frontend/dist

# 使用 Docker Compose 啟動 stage 環境
echo "正在啟動 stage 環境..."
cd ./stage
docker-compose up --build -d

echo "Stage 環境現在正在運行！"
echo "前端將可在 http://localhost:3000 訪問"
echo "後端 API 將可在 http://localhost:3001 訪問"
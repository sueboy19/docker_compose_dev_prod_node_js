#!/bin/bash

# Production 環境設置腳本
set -e  # 如果命令以非零狀態退出，則立即退出

echo "正在為 Production 環境構建應用程式..."

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

# 將構建文件複製到 prod 目錄
echo "正在將構建文件複製到 prod 目錄..."
rm -rf ./prod/backend/dist
rm -rf ./prod/frontend/dist

cp -r ./backend/dist ./prod/backend/
cp -r ./frontend/build ./prod/frontend/dist

# 使用 Docker Compose 啟動 production 環境
echo "正在啟動 production 環境..."
cd ./prod
docker-compose up --build -d

echo "Production 環境現在正在運行！"
echo "應用程式將可在配置的域名訪問"
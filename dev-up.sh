#!/bin/bash

# 開發環境設置腳本
set -e  # 如果命令以非零狀態退出，則立即退出

echo "正在啟動開發環境..."

# 切換到腳本所在目錄
cd "$(dirname "$0")"

if [ -f docker-compose.yml ]; then
    docker-compose up --build -d
    echo "開發環境現在正在運行！"
    echo "前端將可在 http://localhost:3000 訪問"
    echo "後端 API 將可在 http://localhost:3001 訪問"
else
    echo "錯誤: 找不到 docker-compose.yml 文件"
    exit 1
fi
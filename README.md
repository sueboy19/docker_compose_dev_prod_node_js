# Docker Compose 開發與生產環境

本專案提供一個完整的 Docker Compose 解決方案，支援開發、Stage 和 Production 三種環境。

## 目錄結構

```
root
├── backend/                 # 後端 NestJS 應用
│   ├── src/                 # 應用源碼
│   ├── Dockerfile.dev       # 後端開發環境 Docker 配置
│   ├── package.json         # 後端依賴配置
│   ├── package-lock.json    # 後端依賴鎖定文件
│   └── ...
├── frontend/                # 前端 React 應用
│   ├── src/                 # 應用源碼
│   ├── public/              # 靜態資源
│   ├── Dockerfile.dev       # 前端開發環境 Docker 配置
│   ├── nginx.conf           # Nginx 配置文件
│   └── ...
├── stage/                   # Stage 環境配置
│   ├── backend/             # Stage 後端配置
│   │   ├── dist/            # 後端部署文件
│   │   ├── package.json     # 後端依賴配置 (複製自根目錄)
│   │   ├── package-lock.json # 後端依賴鎖定文件 (複製自根目錄)
│   │   └── Dockerfile.stage # Stage 後端 Docker 配置
│   ├── frontend/            # Stage 前端配置
│   │   ├── dist/            # 前端部署文件
│   │   └── Dockerfile.stage # Stage 前端 Docker 配置
│   ├── docker-compose.yml   # Stage 環境 docker-compose 配置
│   └── .env                 # Stage 環境變數
├── prod/                    # Production 環境配置
│   ├── backend/             # Production 後端配置
│   │   ├── dist/            # 後端部署文件
│   │   ├── package.json     # 後端依賴配置 (複製自根目錄)
│   │   ├── package-lock.json # 後端依賴鎖定文件 (複製自根目錄)
│   │   └── Dockerfile.prod  # Production 後端 Docker 配置
│   ├── frontend/            # Production 前端配置
│   │   ├── dist/            # 前端部署文件
│   │   └── Dockerfile.prod  # Production 前端 Docker 配置
│   ├── docker-compose.yml   # Production 環境 docker-compose 配置
│   └── .env                 # Production 環境變數
├── docker-compose.yml       # 開發環境 docker-compose 配置
├── .env                     # 開發環境變數
├── dev-up.bat               # 啟動開發環境腳本
├── stage-up.bat             # 啟動 Stage 環境腳本
├── prod-up.bat              # 啟動 Production 環境腳本
└── README.md                # 專案說明文件
```

## 構建流程

構建腳本會自動處理以下步驟：

1. **構建應用**：先構建後端 (NestJS) 和前端 (React) 應用
2. **複製文件**：將構建後的文件和相依套件複製到 stage 或 prod 目錄
3. **複製配置**：將 nginx.conf 複製到 stage 或 prod 目錄（此文件不被 Git 追蹤）
4. **啟動服務**：使用 docker-compose 啟動服務

## 環境設置

### 開發環境

1. 確保已安裝 Docker 和 Docker Compose
2. 在專案根目錄運行：
   ```
   ./dev-up.bat
   ```
3. 應用將在以下地址運行：
   - 前端: http://localhost:3001
   - 後端: http://localhost:3000
   - 健康檢查: http://localhost:3000/health

### Stage 環境

1. 在專案根目錄運行：
   ```
   ./stage-up.bat
   ```
2. 應用將在以下地址運行：
   - 前端: http://localhost:4001
   - 後端: http://localhost:4000

### Production 環境

Production 環境支援兩階段部署流程：

#### 第一階段：構建和匯出（在開發環境）
1. 在專案根目錄運行：
   ```
   ./prod-build.bat
   ```
   或
   ```
   ./prod-build.sh
   ```
   這將構建應用、將構建文件複製到 prod 目錄，並建立 Docker images 並將其匯出為 tar 檔案 (myapp-backend-prod.tar 和 myapp-frontend-prod.tar)。

#### 第二階段：正式機部署
1. 將整個 `prod` 目錄複製到正式機環境
2. 在 `prod` 目錄中運行：
   ```
   ./prod-up.bat
   ```
   或 Linux 系統：
   ```
   ./prod-up.sh
   ```
   這將載入 Docker images 並啟動服務。

3. 應用將在以下地址運行：
   - 前端: http://localhost:5001
   - 後端: http://localhost:5000
   - 數據庫: localhost:5432 (PostgreSQL)
   - Redis: localhost:6379

## 環境變數

每個環境都有對應的 `.env` 文件來配置環境變數：

- 開發環境: `.env`
- Stage 環境: `stage/.env`
- Production 環境: `prod/.env`

## Docker 配置

- 開發環境：後端使用 Dockerfile.dev，前端使用 Dockerfile.dev
- Stage 環境：後端使用 stage/backend/Dockerfile.stage，前端使用 stage/frontend/Dockerfile.stage
- Production 環境：後端使用 prod/backend/Dockerfile.prod，前端使用 prod/frontend/Dockerfile.prod
- 後端使用 Node.js 20-alpine 鏡像
- 前端使用 Nginx 作為靜態文件服務器
- Production 環境包含 PostgreSQL 和 Redis 服務

## 注意事項

1. 在部署到生產環境前，請確保替換所有默認密碼和密鑰
2. Production 環境使用 `--build` 和 `-d` 參數以在後台運行
3. 所有環境都設置了適當的重啟策略
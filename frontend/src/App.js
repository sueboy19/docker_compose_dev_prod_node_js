import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [backendData, setBackendData] = useState(null);
  const [healthStatus, setHealthStatus] = useState(null);

  // 獲取後端 API 的基礎 URL
  const backendBaseUrl = process.env.REACT_APP_API_URL || 'http://localhost:3000';

  useEffect(() => {
    // 從後端獲取數據
    fetch(`${backendBaseUrl}/`)
      .then(response => response.text())
      .then(data => setBackendData(data))
      .catch(error => console.error('Error fetching from backend:', error));

    // 檢查後端健康狀態
    fetch(`${backendBaseUrl}/health`)
      .then(response => response.json())
      .then(data => setHealthStatus(data))
      .catch(error => console.error('Error checking health:', error));
  }, [backendBaseUrl]);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Docker Compose 開發與生產環境</h1>
        <p>前端 React 應用</p>
        
        <div className="backend-info">
          <h2>後端狀態</h2>
          {backendData && <p>後端回應: {backendData}</p>}
          {healthStatus && (
            <p>健康狀態: {healthStatus.status} - {new Date(healthStatus.timestamp).toLocaleString()}</p>
          )}
        </div>
        
        <div className="environment-info">
          <h2>環境信息</h2>
          <p>當前環境: {process.env.NODE_ENV || 'development'}</p>
          <p>後端 API 基礎路徑: {backendBaseUrl}</p>
        </div>
      </header>
    </div>
  );
}

export default App;
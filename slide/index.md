---
marp: true
theme: gaia
paginate: true
style: |
  section {
    background-color:rgb(229, 244, 249); /* A lighter shade of light blue */
  }
---

# 🚀 AI 趨勢與實戰工作坊

> 2 小時入門｜認識 AI 趨勢 & 實戰應用

---

## 🧠 Part 1: AI 趨勢速覽

-   **AI 模型進化：** GPT-4 / GPT-4o、Claude 3、Gemini 等
-   **多模態 AI：** 語音、影像、影片的整合與理解
-   **AI Agents：** 從工具到自主決策與協作
-   **自動化工作流：** 智能體與企業級應用整合
-   **各行業導入案例：** 數據分析、內容創作、客戶服務、程式開發

---

## 🛠️ Part 2: Hands-on 實作：AI Agent 與自動化工作流

### 核心概念與工具概覽

-   **AI Agent 設計思維：** 目標導向、自主規劃與執行
-   **n8n：** 開源工作流自動化平台 (Agent Orchestrator)
-   **Subflow (子流程)：** 模組化 AI Agent 任務
-   **整合外部服務：** 呼叫 API、讀取/寫入檔案
-   **輸出目標：** 自動生成並發佈至 `docs/.../index.html`

---

## 🎯 什麼是 AI Agent？

-   具備 **感知 (Perceive)**、**思考 (Reason)**、****行動 (Act)**** 能力的智能體。
-   **目標導向：** 自動分解複雜任務為子任務。
-   **自主決策：** 根據環境反饋調整行動。
-   **工具使用：** 整合外部工具 (APIs、資料庫、程式碼執行器) 完成任務。
-   **記憶能力：** 持續學習與改進。

---

## 🌐 n8n 搭配 AI Agent 的優勢

-   **視覺化工作流：** 拖拉式介面，輕鬆編排 Agent 任務。
-   **豐富的整合能力：** 內建 400+ 服務節點，輕鬆連接各種 AI 模型與企業系統。
-   **Subflow 模組化：** 將複雜的 Agent 邏輯封裝為可重用的子流程。
-   **彈性部署：** 可自架 (On-premise) 或使用雲端服務。
-   **自動化與擴展性：** 讓 Agent 在後台持續運行，實現端到端自動化。

---

## 🔧 實作前準備

1.  **n8n 環境建置：**
    *   本地 Docker 安裝 (範例指令請參考 n8n 官網)
    *   或使用 n8n 雲端服務 (n8n Cloud)
2.  **OpenAI API 金鑰：**
    *   於 [platform.openai.com](https://platform.openai.com/) 取得 API 金鑰

---

## 💻 Hands-on 範例 1: AI Agent 自動文件生成與發佈

### 情境與目標

-   **情境：** 一個 AI Agent 根據給定的主題，自動生成一份簡潔的 HTML 說明文件。
-   **目標：** 將生成的 HTML 內容自動發佈到指定的 `docs/output/index.html` 路徑。
-   **關鍵：** 展現 AI Agent 如何整合內容生成、格式化與檔案系統操作。

---

## 💻 範例 1: 工作流概覽

```mermaid
graph TD
    A[HTTP 觸發器 / 手動執行] --> B[AI Agent 節點 (OpenAI / Gemini)]
    B --> C[Subflow: 內容生成與 HTML 格式化]
    C --> D[檔案系統節點 (寫入 docs/output/index.html)]
    D --> E[響應 / 通知]
```
<br>
*此示意圖展示 Agent 如何協調多個任務與工具，自動化端到端流程。*

---

## 💻 範例 1: 概念步驟

1.  **n8n 觸發器：** 設定 HTTP 觸發器，接收生成主題；或手動執行。
2.  **AI Agent 節點：**
    *   設定 Agent 角色與目標 (e.g., "生成一份關於 AI Agent 的 HTML 文件")。
    *   賦予 Agent 使用工具 (如「寫文件 Subflow」)。
3.  **Subflow (子流程)：**
    *   內含多個 LLM 節點，實現「研究 -> 草稿 -> 優化 -> HTML 格式化」等步驟。
    *   展示如何模組化複雜的 Agent 邏輯。
4.  **檔案系統節點：** 將 Agent 輸出的 HTML 內容寫入指定路徑。

---

## 📈 Hands-on 範例 2: 股市情報自動分析

### 情境與目標

-   **情境：** 一個 AI Agent 定期監控特定股票新聞，自動進行摘要、情緒分析。
-   **目標：** 將分析結果透過 n8n 發送至指定平台 (如 Slack 或 Email)。
-   **關鍵：** 展現 AI Agent 定時自動化、外部數據抓取與智能分析能力。

---

## 📈 範例 2: 工作流概覽

```mermaid
graph TD
    A[定時觸發 (Cron)] --> B[外部 API 節點 (例如：財經新聞 API)]
    B --> C[AI Agent 節點 (新聞摘要與情緒分析)]
    C --> D[Subflow: 分析與整理 (情緒判斷、摘要)]
    D --> E[通知節點 (Slack / Email)]
```
<br>
*此示意圖展示 Agent 如何執行周期性、數據驅動的智能任務。*

---

## 📈 範例 2: 概念步驟

1.  **定時觸發器：** 設定周期性任務 (例如：每日/小時) 抓取最新資訊。
2.  **外部 API 節點：** 呼叫財經新聞 API，獲取相關股票新聞數據。
3.  **AI Agent 節點：**
    *   目標：「分析新聞內容，判斷情緒並提供摘要。」
    *   工具：可設定 Agent 呼叫「情緒分析」與「摘要」Subflow。
4.  **Subflow：**
    *   「情緒分析子流程」：使用 LLM 判斷新聞的情緒 (正面、負面、中立)。
    *   「摘要子流程」：使用 LLM 簡化新聞內容。
5.  **通知節點：** 將分析結果自動發送給相關人員。

---

## 🌟 AI 應用案例分享：加速企業數位轉型

### 1. 公關/行銷內容自動化 (PR & Marketing Automation)
-   **新聞稿/文案生成：** 根據事件描述，快速生成多語言新聞稿初稿、社群貼文。
-   **市場趨勢報告：** 彙整行業數據，生成可讀性高的市場分析報告摘要。
-   **輿情監測與應對：** 自動分析社群輿論，提供危機應對草案。

---

## 🌟 AI 應用案例分享：加速企業數位轉型

### 2. 程式碼開發輔助 (Code PRs & Documentation)
-   **Pull Request 摘要：** 自動分析程式碼變更，生成 PR 描述與影響。
-   **程式碼審查建議：** AI Agent 提供潛在 bug、性能優化或風格建議。
-   **文件自動生成：** 根據程式碼自動生成 API 文件、功能說明或使用者手冊。
-   **測試案例生成：** 依據程式碼功能，自動建議並生成測試案例。

---

## 📌 延伸資源

-   **n8n 官方文件：** [docs.n8n.io](https://docs.n8n.io/)
-   **OpenAI API 文件：** [platform.openai.com/docs](https://platform.openai.com/docs)
-   **Prompt Engineering Guide：** [github.com/dair-ai/Prompt-Engineering-Guide](https://github.com/dair-ai/Prompt-Engineering-Guide)
-   **LangChain / LlamaIndex：** (若需要更複雜的 Agent 開發框架)

---

# 🎉 謝謝參與！

### Q&A

GitHub: `yourname/ai-workshop` (請替換為你的 GitHub 連結)

---
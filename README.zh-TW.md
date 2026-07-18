# Claude Code 驅動 Antigravity CLI（agy）橋接

[English](README.md) · [简体中文](README.zh-CN.md)

> 文中 **CC** = Claude Code，**agy** = Antigravity CLI。

從 Claude Code 驅動 Google 的 Antigravity CLI（`agy`）：用你既有的 Gemini 訂閱做搜尋與輔助、與 Claude 共用一份 system prompt，必要時再墊一段研究方法前綴拉高 headless 回答品質。

這是 [claude-code-antigravity-ide-bridge](https://github.com/yyu0310/claude-code-antigravity-ide-bridge) 的 CLI 版，也是 CC harness bridge 系列（Grok、Codex、Antigravity）的第三張。

## 為什麼值得用

Claude Code 仍是日常主力。`agy` 是互補車道，不是替代品，也不是降級方案。

### 1. 搜尋能扛過反爬

Claude 的 `web_search` / `web_fetch` 遇到一點反爬機制，常常整片爬不到。透過 `agy` 的 Gemini Pro 往往還能看到那些來源。兩邊一起跑、對照結果：Claude 空白時，Gemini 可能仍有可用素材。這種雙軌對照就是日常最大的附加價值。

### 2. 把已有的 Gemini 額度用起來

很多人還掛著 2025 年 Gemini 學生優惠的一年期，或其他 Google 訂閱裡的 Pro / Flash 額度。主力改用 Claude 之後，這些額度常在空轉。`agy -p` 讓你在終端機裡用一次性查詢與輔助，把訂閱花掉。

舊的 Gemini CLI 已於 2026-06-18 停用；現在要用訂閱額度，走 Antigravity CLI（`agy`）。

### 3. Claude 旁邊多幾條模型路

`agy` 不只 Gemini。你也可以呼叫 Claude Sonnet 4.6、Claude Opus 4.6 做輕量輔助：第二意見、平行草稿、或想多跑一輪又不想跟主力 CC session 搶同一套節奏時。

### 4. 研究方法前綴，讓 headless 回答更硬

裸跑 `agy -p`（或 `grok -p` / `claude -p`）容易來源含糊、事實與意見混在一起。[`research-prefix.md`](research-prefix.md) 是一段與模型無關的短前綴，要求多角度搜尋、具名加日期的來源、結論先行。`scripts/ccagy.sh` 會幫你墊上。

## 安裝

```bash
# macOS（Homebrew）
brew install --cask antigravity-cli

# macOS / Linux（官方腳本）
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

跑一次 `agy`，選「Login with Google」，用持有 Gemini 訂閱的帳號登入。不要設定 `GEMINI_API_KEY`：一旦有這個變數，CLI 會改走 API 計費，而不是你的訂閱額度。

## 快速開始

```bash
# 研究前綴 + 乾淨 cwd（建議）
scripts/ccagy.sh "台北市好吃的炸雞店"
scripts/ccagy.sh "你的問題" "Gemini 3.5 Flash (High)"

# 直接 one-shot
agy -p "你的問題" --model "Gemini 3.1 Pro (High)"
```

`ccagy.sh` 會墊上研究前綴，並從暫存目錄執行，避免專案的 `AGENTS.md` / 規則污染純研究查詢。

實測效果（同一個 Gemini 3.1 Pro、同一題）：沒有前綴時是平鋪列點、來源含糊、沒有日期；加了前綴後是結論先行、具名來源加日期、查證事實與主觀分開，還會說明用了哪幾個搜尋角度。

## 共享 system prompt

`agy` 會讀工作目錄的 `AGENTS.md`。把它 symlink 到你既有的 `CLAUDE.md`，兩邊就讀同一份：

```bash
ln -s CLAUDE.md AGENTS.md
```

## 模型

`--model` 的值是 `agy models` 列出的逐字顯示名稱：

| 模型 | 推理檔位 |
|---|---|
| Gemini 3.5 Flash | Low / Medium / High |
| Gemini 3.1 Pro | Low / High |
| Claude Sonnet 4.6 | Thinking |
| Claude Opus 4.6 | Thinking |
| GPT-OSS 120B | Medium |

## 範圍說明

這是刻意做薄的橋。截至 2026-07，`agy` 沒有原生 memory API，也沒有可用的 hook schema，所以不會有 Grok 橋那套 memory 同步或 hook adapter。軟性規則寫在 `AGENTS.md`；`~/.gemini/antigravity-cli/brain/` 下是單次對話狀態，不是共享知識庫。

如果你要完整的 Claude 工作環境，用 Claude Code。如果你要更穩的搜尋、把 Gemini 訂閱用起來、以及一條輕量的第二模型路，這個 repo 就是做這些事。

## 檔案

- `research-prefix.md`：研究方法 prompt 前綴（英文）
- `scripts/ccagy.sh`：前綴加 `agy -p`、從乾淨 cwd 跑
- `README.md`（EN，預設）／`README.zh-TW.md`／`README.zh-CN.md`
- `AGENTS.md`：共享 system prompt；`CLAUDE.md` 是指向它的 symlink

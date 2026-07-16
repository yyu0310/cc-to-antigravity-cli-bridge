# Claude Code 驅動 Antigravity CLI（agy）橋接

> 本文以 **CC** 作為 Claude Code 的簡稱，以 **agy** 作為 Antigravity CLI 的簡稱。

從 Claude Code 驅動 Google 的 Antigravity CLI（`agy`），用訂閱額度存取 Gemini Pro / Flash，並用一段研究方法前綴拉高搜尋品質。這是 [claude-code-antigravity-ide-bridge](https://github.com/yyu0310/claude-code-antigravity-ide-bridge) 的 CLI 版，也是 CC harness bridge 系列（Grok、Codex、Antigravity）的第三張。

> **誠實的範圍。** 截至 2026-07，`agy` 沒有原生 memory API、也沒有可用的 hook schema，所以像 Grok 那張橋的完整功能（memory 同步、hook adapter）在這裡做不到。真正能做、且值得做的有兩件：共享 system prompt，以及一段與模型無關的研究方法前綴。如果你要的是 Claude 環境的替代品，這個不是；見 [結論](#結論)。

## 為什麼用 agy

舊的 Gemini CLI 已於 2026-06-18 停用。現在要用訂閱額度存取 Gemini Pro / Flash，最好的方式是 Antigravity CLI（`agy`）。

## 安裝

```bash
# macOS（Homebrew）
brew install --cask antigravity-cli

# macOS / Linux（官方腳本）
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

跑一次 `agy`，選「Login with Google」，用持有 Gemini 訂閱的帳號登入。不要設定 `GEMINI_API_KEY`：一旦有這個變數，CLI 會改走 API 計費，而不是你的訂閱額度。

## 能做到的

### 1. 共享 system prompt

`agy` 會讀工作目錄的 `AGENTS.md`。把它 symlink 到你既有的 `CLAUDE.md`，兩邊就讀同一份：

```bash
ln -s CLAUDE.md AGENTS.md
```

### 2. 非互動驅動

```bash
agy -p "你的問題" --model "Gemini 3.1 Pro (High)"
```

`--model` 的值是 `agy models` 列出的逐字顯示名稱：

| 模型 | 推理檔位 |
|---|---|
| Gemini 3.5 Flash | Low / Medium / High |
| Gemini 3.1 Pro | Low / High |
| Claude Sonnet 4.6 | Thinking |
| Claude Opus 4.6 | Thinking |
| GPT-OSS 120B | Medium |

### 3. 研究方法前綴（可重用的收穫）

headless CLI 預設跑起來很鬆：來源含糊、事實與推測混雜、沒有日期。在 prompt 前面墊 [`research-prefix.md`](research-prefix.md)，可拉高任何 headless AI CLI（`agy -p`、`grok -p`、`claude -p`）的輸出品質。這段前綴與模型無關。

附上的 wrapper 幫你做好這件事：

```bash
scripts/ccagy.sh "台北市好吃的炸雞店"
scripts/ccagy.sh "你的問題" "Gemini 3.5 Flash (High)"
```

`ccagy.sh` 會墊上前綴、並從一個乾淨的暫存目錄跑 `agy -p`，所以純研究查詢不會被專案的 `AGENTS.md` 或規則污染。

實測效果（同一個 Gemini 3.1 Pro、同一題）：沒有前綴時是平鋪列點、來源含糊、沒有日期；加了前綴後是結論先行、具名來源加日期、查證事實與主觀分開，還會說明用了哪幾個搜尋角度。

## 做不到的

- **沒有 memory 同步。** `~/.gemini/antigravity-cli/brain/<id>/` 只存單一對話的工作狀態，不是可查詢的知識庫，也沒有能把 Claude Code memory 同步進去的 memory API。第三方工具（Mem0、claude-mem）的做法是把記憶寫進 `AGENTS.md` 來補洞。
- **沒有 hook 層安全防護。** `agy` 沒有可用的 hook schema，所以 Grok 橋那套 hook adapter 搬不過來。任何規則都只能寫在 `AGENTS.md` 當軟性、靠 AI 自律的文字。

## 結論

留著它做一件事就好：偶發的 Gemini 或 Google 即時搜尋，配上研究前綴。Antigravity 的額度在 2026 年一路調降，又沒有 memory 或 hook 層，所以它不是 Claude Code 的替代。其餘一切，Claude Code 仍是主力。

## 檔案

- `research-prefix.md`：研究方法 prompt 前綴（英文）
- `scripts/ccagy.sh`：wrapper，前綴加 `agy -p`、從乾淨 cwd 跑
- `README.md` / `README.zh-TW.md` / `README.zh-CN.md`：EN / zh-TW / zh-CN
- `AGENTS.md`：共享 system prompt；`CLAUDE.md` 是指向它的 symlink

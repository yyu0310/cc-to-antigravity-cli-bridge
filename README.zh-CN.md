# Claude Code 驱动 Antigravity CLI（agy）桥接

[繁體中文](README.zh-TW.md) · [English](README.md)

> 文中 **CC** = Claude Code，**agy** = Antigravity CLI。

从 Claude Code 驱动 Google 的 Antigravity CLI（`agy`）：用你已有的 Gemini 订阅做搜索与辅助、与 Claude 共用一份 system prompt，需要时再垫一段研究方法前缀拉高 headless 回答质量。

这是 [claude-code-antigravity-ide-bridge](https://github.com/yyu0310/claude-code-antigravity-ide-bridge) 的 CLI 版，也是 CC harness bridge 系列（Grok、Codex、Antigravity）的第三张。

## 为什么值得用

Claude Code 仍是日常主力；`agy` 走互补车道。

### 1. 搜索更能扛反爬

Claude 的 `web_search` / `web_fetch` 碰到一点反爬机制，经常整片爬不到。通过 `agy` 的 Gemini Pro 往往还能看到那些来源。两边一起跑、对照结果：Claude 空白时，Gemini 可能仍有可用素材。这种双轨对照就是日常最大的附加价值。

### 2. 把已有的 Gemini 额度用起来

很多人还挂着 2025 年 Gemini 学生优惠的一年期，或其他 Google 订阅里的 Pro / Flash 额度。主力改用 Claude 之后，这些额度常在空转。`agy -p` 让你在终端里用一次性查询与辅助，把订阅花掉。

旧的 Gemini CLI 已于 2026-06-18 停用；现在要用订阅额度，走 Antigravity CLI（`agy`）。

### 3. Claude 旁边多几条模型路

`agy` 不只 Gemini。你也可以调用 Claude Sonnet 4.6、Claude Opus 4.6 做轻量辅助：第二意见、平行草稿，或想多跑一轮又不想跟主力 CC session 抢同一套节奏时。

### 4. 研究方法前缀，让 headless 回答更硬

裸跑 `agy -p`（或 `grok -p` / `claude -p`）容易来源含糊、事实与意见混在一起。[`research-prefix.md`](research-prefix.md) 是一段与模型无关的短前缀，要求多角度搜索、具名加日期的来源、结论先行。`scripts/ccagy.sh` 会帮你垫上。

## 安装

```bash
# macOS（Homebrew）
brew install --cask antigravity-cli

# macOS / Linux（官方脚本）
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

跑一次 `agy`，选「Login with Google」，用持有 Gemini 订阅的账号登录。不要设置 `GEMINI_API_KEY`：一旦有这个变量，CLI 会改走 API 计费，而不是你的订阅额度。

## 快速开始

```bash
# 研究前缀 + 干净 cwd（建议）
scripts/ccagy.sh "台北市好吃的炸鸡店"
scripts/ccagy.sh "你的问题" "Gemini 3.8 Flash (Medium)"

# 直接 one-shot
agy -p "你的问题" --model "Gemini 3.8 Flash (High)"
```

`ccagy.sh` 会垫上研究前缀，并从临时目录执行，避免项目的 `AGENTS.md` / 规则污染纯研究查询。不带模型参数时，它会从 `agy models` 挑最新的 Gemini Pro (High)，没有 Pro 就挑最新的 Flash (High)，模型改名也不会坏。

实测效果（同一个 Gemini 3.1 Pro、同一题）：没有前缀时是平铺列点、来源含糊、没有日期；加了前缀后是结论先行、具名来源加日期、查证事实与主观分开，还会说明用了哪几个搜索角度。

## 共享 system prompt

`agy` 会读工作目录的 `AGENTS.md`。把它 symlink 到你既有的 `CLAUDE.md`，两边就读同一份：

```bash
ln -s CLAUDE.md AGENTS.md
```

## 模型

`--model` 的值是 `agy models` 列出的逐字显示名称。清单经常变动，以下是 2026-10-25 的版本：

| 模型 | 推理档位 |
|---|---|
| Gemini 3.8 Flash | Low / Medium / High |
| Claude Sonnet 4.6 | Thinking |
| Claude Opus 4.6 | Thinking |
| GPT-OSS 120B | Medium |

## 范围说明

这是刻意做薄的桥。截至 2026-07，`agy` 没有原生 memory API，也没有可用的 hook schema，所以不会有 Grok 桥那套 memory 同步或 hook adapter。软性规则写在 `AGENTS.md`；`~/.gemini/antigravity-cli/brain/` 下是单次对话状态，不是共享知识库。

如果你要完整的 Claude 工作环境，用 Claude Code。如果你要更稳的搜索、把 Gemini 订阅用起来、以及一条轻量的第二模型路，这个 repo 就是做这些事。

## 文件

- `research-prefix.md`：研究方法 prompt 前缀（英文）
- `scripts/ccagy.sh`：前缀加 `agy -p`、从干净 cwd 跑
- `README.md`（EN，默认）／`README.zh-TW.md`／`README.zh-CN.md`
- `AGENTS.md`：共享 system prompt；`CLAUDE.md` 是指向它的 symlink

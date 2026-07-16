# Claude Code 驱动 Antigravity CLI（agy）桥接

> 本文以 **CC** 作为 Claude Code 的简称，以 **agy** 作为 Antigravity CLI 的简称。

从 Claude Code 驱动 Google 的 Antigravity CLI（`agy`），用订阅额度访问 Gemini Pro / Flash，并用一段研究方法前缀拉高搜索质量。这是 [claude-code-antigravity-ide-bridge](https://github.com/yyu0310/claude-code-antigravity-ide-bridge) 的 CLI 版，也是 CC harness bridge 系列（Grok、Codex、Antigravity）的第三张。

> **诚实的范围。** 截至 2026-07，`agy` 没有原生 memory API、也没有可用的 hook schema，所以像 Grok 那张桥的完整功能（memory 同步、hook adapter）在这里做不到。真正能做、且值得做的有两件：共享 system prompt，以及一段与模型无关的研究方法前缀。如果你要的是 Claude 环境的替代品，这个不是；见 [结论](#结论)。

## 为什么用 agy

旧的 Gemini CLI 已于 2026-06-18 停用。现在要用订阅额度访问 Gemini Pro / Flash，最好的方式是 Antigravity CLI（`agy`）。

## 安装

```bash
# macOS（Homebrew）
brew install --cask antigravity-cli

# macOS / Linux（官方脚本）
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

跑一次 `agy`，选「Login with Google」，用持有 Gemini 订阅的账号登录。不要设置 `GEMINI_API_KEY`：一旦有这个变量，CLI 会改走 API 计费，而不是你的订阅额度。

## 能做到的

### 1. 共享 system prompt

`agy` 会读工作目录的 `AGENTS.md`。把它 symlink 到你既有的 `CLAUDE.md`，两边就读同一份：

```bash
ln -s CLAUDE.md AGENTS.md
```

### 2. 非交互驱动

```bash
agy -p "你的问题" --model "Gemini 3.1 Pro (High)"
```

`--model` 的值是 `agy models` 列出的逐字显示名称：

| 模型 | 推理档位 |
|---|---|
| Gemini 3.5 Flash | Low / Medium / High |
| Gemini 3.1 Pro | Low / High |
| Claude Sonnet 4.6 | Thinking |
| Claude Opus 4.6 | Thinking |
| GPT-OSS 120B | Medium |

### 3. 研究方法前缀（可重用的收获）

headless CLI 默认跑起来很松：来源含糊、事实与推测混杂、没有日期。在 prompt 前面垫 [`research-prefix.md`](research-prefix.md)，可拉高任何 headless AI CLI（`agy -p`、`grok -p`、`claude -p`）的输出质量。这段前缀与模型无关。

附上的 wrapper 帮你做好这件事：

```bash
scripts/ccagy.sh "台北市好吃的炸鸡店"
scripts/ccagy.sh "你的问题" "Gemini 3.5 Flash (High)"
```

`ccagy.sh` 会垫上前缀、并从一个干净的临时目录跑 `agy -p`，所以纯研究查询不会被项目的 `AGENTS.md` 或规则污染。

实测效果（同一个 Gemini 3.1 Pro、同一题）：没有前缀时是平铺列点、来源含糊、没有日期；加了前缀后是结论先行、具名来源加日期、查证事实与主观分开，还会说明用了哪几个搜索角度。

## 做不到的

- **没有 memory 同步。** `~/.gemini/antigravity-cli/brain/<id>/` 只存单一对话的工作状态，不是可查询的知识库，也没有能把 Claude Code memory 同步进去的 memory API。第三方工具（Mem0、claude-mem）的做法是把记忆写进 `AGENTS.md` 来补洞。
- **没有 hook 层安全防护。** `agy` 没有可用的 hook schema，所以 Grok 桥那套 hook adapter 搬不过来。任何规则都只能写在 `AGENTS.md` 当软性、靠 AI 自律的文字。

## 结论

留着它做一件事就好：偶发的 Gemini 或 Google 即时搜索，配上研究前缀。Antigravity 的额度在 2026 年一路调降，又没有 memory 或 hook 层，所以它不是 Claude Code 的替代。其余一切，Claude Code 仍是主力。

## 文件

- `research-prefix.md`：研究方法 prompt 前缀（英文）
- `scripts/ccagy.sh`：wrapper，前缀加 `agy -p`、从干净 cwd 跑
- `README.md` / `README.zh-TW.md` / `README.zh-CN.md`：EN / zh-TW / zh-CN
- `AGENTS.md`：共享 system prompt；`CLAUDE.md` 是指向它的 symlink

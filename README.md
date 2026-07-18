# Claude Code to Antigravity CLI (agy) bridge

[繁體中文](README.zh-TW.md) · [简体中文](README.zh-CN.md)

> **CC** = Claude Code, **agy** = Antigravity CLI throughout.

Drive Google's Antigravity CLI (`agy`) from Claude Code: use your Gemini subscription for search and model work that pairs well with Claude, share one system prompt, and optionally lift headless answers with a research-method prefix.

CLI counterpart to [claude-code-antigravity-ide-bridge](https://github.com/yyu0310/claude-code-antigravity-ide-bridge). Third in the CC harness bridge series (Grok, Codex, Antigravity).

## Why this is useful

Claude Code stays the daily driver; `agy` is the complementary lane.

### 1. Search that survives anti-bot

Claude's `web_search` / `web_fetch` often fail on pages with light anti-bot protection. Gemini Pro through `agy` frequently still reaches those sources. Run both and compare: when Claude comes back empty, Gemini may still return usable material. That dual-track check is the main day-to-day value.

### 2. Use the Gemini quota you already pay for (or got free)

Many people still have an active Gemini student year from the 2025 promo, or another Google subscription with Pro / Flash access. After switching daily work to Claude, that quota often sits unused. `agy -p` turns it into one-shot research and assist calls without leaving the terminal.

Old Gemini CLI was deprecated on 2026-06-18; subscription access today goes through Antigravity CLI (`agy`).

### 3. Extra models next to Claude

`agy` is not Gemini-only. You can also call Claude Sonnet 4.6 and Claude Opus 4.6 through it for light assist work: second opinions, parallel drafts, overflow when you want another pass without burning your main CC session the same way.

### 4. Better headless answers with a research prefix

Bare `agy -p` (or `grok -p` / `claude -p`) tends to give vague sources and mixed fact/opinion. [`research-prefix.md`](research-prefix.md) is a short, model-agnostic prefix that asks for multi-angle search, dated sources, and a decision-first answer. `scripts/ccagy.sh` applies it for you.

## Install

```bash
# macOS (Homebrew)
brew install --cask antigravity-cli

# macOS / Linux (official script)
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

Run `agy` once, choose "Login with Google", and sign in with the account that holds your Gemini subscription. Do not set `GEMINI_API_KEY`: if it is present, the CLI bills through the API instead of your subscription.

## Quick start

```bash
# research with prefix, clean cwd (recommended)
scripts/ccagy.sh "best fried chicken in Taipei"
scripts/ccagy.sh "your question" "Gemini 3.5 Flash (High)"

# raw one-shot
agy -p "your question" --model "Gemini 3.1 Pro (High)"
```

`ccagy.sh` prepends the research prefix and runs from a temp directory so project `AGENTS.md` / rules do not leak into a pure research query.

Measured effect (same Gemini 3.1 Pro, same query): without the prefix, a flat list with vague sources and no dates; with it, a decision-first answer, named sources with dates, facts separated from opinion, and which search angles were used.

## Share your system prompt

`agy` reads `AGENTS.md` from the working directory. Symlink it to your existing `CLAUDE.md` so both tools share one file:

```bash
ln -s CLAUDE.md AGENTS.md
```

## Models

`--model` takes the exact display name from `agy models`:

| Model | Reasoning tiers |
|---|---|
| Gemini 3.5 Flash | Low / Medium / High |
| Gemini 3.1 Pro | Low / High |
| Claude Sonnet 4.6 | Thinking |
| Claude Opus 4.6 | Thinking |
| GPT-OSS 120B | Medium |

## Scope notes

This is a thin bridge on purpose. As of 2026-07, `agy` has no native memory API and no documented hook schema, so you will not get Grok-bridge-style memory sync or hook adapters here. Soft rules live in `AGENTS.md`; per-conversation state under `~/.gemini/antigravity-cli/brain/` is not a shared knowledge base.

If you want a full Claude environment replacement, use Claude Code. If you want stronger search, better use of a Gemini subscription, and an easy second model path, this repo is for that.

## Files

- `research-prefix.md`: research-method prompt prefix (English)
- `scripts/ccagy.sh`: prefix + `agy -p` from a clean cwd
- `README.md` (EN, default) / `README.zh-TW.md` / `README.zh-CN.md`
- `AGENTS.md`: shared system prompt; `CLAUDE.md` is a symlink to it

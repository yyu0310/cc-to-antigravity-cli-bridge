# Claude Code to Antigravity CLI (agy) bridge

> **CC** = Claude Code, **agy** = Antigravity CLI throughout.

Drive Google's Antigravity CLI (`agy`) from Claude Code to reach Gemini Pro / Flash on your subscription, with a research-method prefix that lifts search quality. This is the CLI counterpart to [claude-code-antigravity-ide-bridge](https://github.com/yyu0310/claude-code-antigravity-ide-bridge), and the third in a series of CC harness bridges (Grok, Codex, Antigravity).

> **Honest scope.** As of 2026-07, `agy` has no native memory API and no documented hook schema, so a full bridge like the Grok one (memory sync, hook adapters) is not possible here. Two things work and are worth having: sharing your system prompt, and a model-agnostic research-method prompt prefix. If you want a Claude environment replacement, this is not it; see [Verdict](#verdict).

## Why agy at all

The old Gemini CLI was deprecated on 2026-06-18. The best way to reach Gemini Pro / Flash on a subscription today is the Antigravity CLI (`agy`).

## Install

```bash
# macOS (Homebrew)
brew install --cask antigravity-cli

# macOS / Linux (official script)
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

Run `agy` once, choose "Login with Google", and sign in with the account that holds your Gemini subscription. Do not set `GEMINI_API_KEY`: if it is present, the CLI bills through the API instead of your subscription.

## What works

### 1. Share your system prompt

`agy` reads `AGENTS.md` from the working directory. Symlink it to your existing `CLAUDE.md` so both read one file:

```bash
ln -s CLAUDE.md AGENTS.md
```

### 2. Drive it non-interactively

```bash
agy -p "your question" --model "Gemini 3.1 Pro (High)"
```

`--model` takes the exact display name from `agy models`:

| Model | Reasoning tiers |
|---|---|
| Gemini 3.5 Flash | Low / Medium / High |
| Gemini 3.1 Pro | Low / High |
| Claude Sonnet 4.6 | Thinking |
| Claude Opus 4.6 | Thinking |
| GPT-OSS 120B | Medium |

### 3. Research-method prefix (the reusable win)

Headless CLIs run loose by default: vague sources, facts mixed with speculation, no dates. Prepend [`research-prefix.md`](research-prefix.md) to lift the quality of any headless AI CLI (`agy -p`, `grok -p`, `claude -p`). It is model-agnostic.

The bundled wrapper does this for you:

```bash
scripts/ccagy.sh "best fried chicken in Taipei"
scripts/ccagy.sh "your question" "Gemini 3.5 Flash (High)"
```

`ccagy.sh` prepends the prefix and runs `agy -p` from a clean temp directory, so no project `AGENTS.md` or rules leak into a pure research query.

Measured effect (same Gemini 3.1 Pro, same query): without the prefix, a flat list with vague sources and no dates; with it, a decision-first answer, named sources with dates, verified facts separated from opinion, and an explicit note of which search angles were used.

## What does not work

- **No memory sync.** The `~/.gemini/antigravity-cli/brain/<id>/` store holds per-conversation working state, not a queryable knowledge base, and there is no memory API to sync Claude Code memory into. Third-party tools (Mem0, claude-mem) work around this by writing into `AGENTS.md`.
- **No hook-level security.** `agy` has no documented hook schema, so the hook adapter approach from the Grok bridge does not port. Any rules live in `AGENTS.md` as soft, AI-enforced text only.

## Verdict

Use this for one thing: occasional Gemini or Google-grounded search, driven with the research prefix. Antigravity's quotas have been cut aggressively through 2026, and there is no memory or hook layer, so it is not a Claude Code replacement. For everything else, Claude Code stays the daily driver.

## Files

- `research-prefix.md`: research-method prompt prefix (English)
- `scripts/ccagy.sh`: wrapper, prefix plus `agy -p` from a clean cwd
- `README.md` / `README.zh-TW.md` / `README.zh-CN.md`: EN / zh-TW / zh-CN
- `AGENTS.md`: shared system prompt; `CLAUDE.md` is a symlink to it

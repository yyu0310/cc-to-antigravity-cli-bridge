#!/usr/bin/env bash
# ccagy: drive Antigravity CLI (agy) with the research-method prefix, from a clean cwd.
# Usage: ccagy.sh "your question" [model]
#   model defaults to "Gemini 3.1 Pro (High)"; run `agy models` for the full list.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="$SCRIPT_DIR/../research-prefix.md"
QUESTION="${1:?usage: ccagy.sh \"question\" [model]}"
MODEL="${2:-Gemini 3.1 Pro (High)}"

# Runnable check: fail loudly if the prefix file is missing rather than sending a bare prompt.
[ -f "$PREFIX" ] || { echo "research-prefix.md not found at $PREFIX" >&2; exit 1; }

# Clean cwd so no project AGENTS.md / rules leak into a pure research query.
cd "$(mktemp -d)"

exec agy -p "$(cat "$PREFIX")

$QUESTION" --model "$MODEL"

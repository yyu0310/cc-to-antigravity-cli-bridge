#!/usr/bin/env bash
# ccagy: drive Antigravity CLI (agy) with the research-method prefix, from a clean cwd.
# Usage: ccagy.sh "your question" [model]
#   model defaults to the newest Gemini Pro (High) in `agy models`, or the newest
#   Gemini Flash (High) when no Pro is listed. Pass a display name to override.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="$SCRIPT_DIR/../research-prefix.md"
QUESTION="${1:?usage: ccagy.sh \"question\" [model]}"
# Model names change often, so pick from the live `agy models` list instead of hardcoding one.
pick_model() {
  agy models 2>/dev/null \
    | grep -oE 'Gemini [0-9]+(\.[0-9]+)* (Pro|Flash) \(High\)' \
    | awk '{ print ($3 == "Pro" ? 1 : 0) "\t" $2 "\t" $0 }' \
    | sort -t$'\t' -k1,1nr -k2,2Vr | head -1 | cut -f3 || true
}
MODEL="${2:-$(pick_model)}"
[ -n "$MODEL" ] || { echo "no Gemini Pro/Flash (High) found in \`agy models\`; pass a model name" >&2; exit 1; }

# Runnable check: fail loudly if the prefix file is missing rather than sending a bare prompt.
[ -f "$PREFIX" ] || { echo "research-prefix.md not found at $PREFIX" >&2; exit 1; }

# Clean cwd so no project AGENTS.md / rules leak into a pure research query.
cd "$(mktemp -d)"

exec agy -p "$(cat "$PREFIX")

$QUESTION" --model "$MODEL"

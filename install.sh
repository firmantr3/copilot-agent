#!/usr/bin/env bash
set -euo pipefail

# cross-platform installer for copilot-agent templates
# (supports local repo copy + remote install via curl/wget)

REPO_RAW_BASE="https://cdn.jsdelivr.net/gh/firmantr3/copilot-agent@main"

info() { printf "[INFO] %s\n" "$*"; }
error() { printf "[ERROR] %s\n" "$*" >&2; exit 1; }

is_mac() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

# target locations
COPILOT_AGENT_DIR="$HOME/.copilot/agents"
if is_mac; then
  PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts"
else
  PROMPTS_DIR="$HOME/.config/Code/User/prompts"
fi
mkdir -p "$COPILOT_AGENT_DIR" "$PROMPTS_DIR"

# Determine source: local vs GitHub remote
# `${BASH_SOURCE[0]}` may be unset in some shells, so fallback to `$0`.
script_source="${BASH_SOURCE[0]:-$0}"
if [[ -z "$script_source" ]]; then
  script_source="$0"
fi
SCRIPT_DIR="$(cd "$(dirname "$script_source")" && pwd)"
LOCAL_AGENTS_DIR="$SCRIPT_DIR/agents"
LOCAL_PROMPTS_DIR="$SCRIPT_DIR/prompts"

AGENT_FILES=(
  "plan-kiro.agent.md"
  "plan-plus.agent.md"
  "execute-kiro.agent.md"
)

PROMPT_FILES=(
  "generate-steering.prompt.md"
  "update-steering.prompt.md"
)

download_file() {
  local url=$1 dest=$2
  local retries=3
  local count=0
  while [ $count -lt $retries ]; do
    if command -v curl >/dev/null 2>&1; then
      if curl -fsSL "$url" -o "$dest"; then return 0; fi
    elif command -v wget >/dev/null 2>&1; then
      if wget -qO "$dest" "$url"; then return 0; fi
    else
      error "curl or wget is required to download files from remote"
    fi
    count=$((count + 1))
    [ $count -lt $retries ] && sleep 1
  done
  error "Failed to download $url after $retries attempts"
}

if [[ -f "$SCRIPT_DIR/install.sh" && -d "$LOCAL_AGENTS_DIR" && -d "$LOCAL_PROMPTS_DIR" ]]; then
  info "Using local repository files from $SCRIPT_DIR"
  for f in "$LOCAL_AGENTS_DIR"/*.md; do
    cp -f "$f" "$COPILOT_AGENT_DIR/"
    info "Copied $(basename "$f") -> $COPILOT_AGENT_DIR/"
  done
  for f in "${PROMPT_FILES[@]}"; do
    cp -f "$LOCAL_PROMPTS_DIR/$f" "$PROMPTS_DIR/$f"
    info "Copied $f -> $PROMPTS_DIR/$f"
  done
else
  info "Local repo files not found; downloading from GitHub"
  for f in "${AGENT_FILES[@]}"; do
    url="$REPO_RAW_BASE/agents/$f"
    dest="$COPILOT_AGENT_DIR/$f"
    download_file "$url" "$dest"
    info "Downloaded $f -> $dest"
  done
  for f in "${PROMPT_FILES[@]}"; do
    download_file "$REPO_RAW_BASE/prompts/$f" "$PROMPTS_DIR/$f"
    info "Downloaded $f -> $PROMPTS_DIR/$f"
  done
fi

info "Installation completed."
info "Copied agents to: $COPILOT_AGENT_DIR"
info "Copied prompts to: $PROMPTS_DIR"

if is_mac; then
  info "macOS prompts path: $PROMPTS_DIR"
elif is_linux; then
  info "Linux prompts path: $PROMPTS_DIR"
fi

cat <<EOF

✅ Done.

Next steps:
- Open VS Code Copilot Chat
- Reload window if needed (Cmd+Shift+P -> Reload Window)
- Use the prompt templates from the saved folder
EOF

#!/usr/bin/env bash
set -euo pipefail

# cross-platform installer for copilot-agent templates
# (supports local repo copy + remote install via curl/wget)

REPO_RAW_BASE="https://raw.githubusercontent.com/firmantr3/copilot-agent/main"

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
PROMPT_FILE="$PROMPTS_DIR/generate-steering.prompt.md"

mkdir -p "$COPILOT_AGENT_DIR" "$PROMPTS_DIR"

# Determine source: local vs GitHub remote
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_AGENTS_DIR="$SCRIPT_DIR/agents"
LOCAL_PROMPT_FILE="$SCRIPT_DIR/prompts/generate-steering.prompt.md"

AGENT_FILES=(
  "plan-kiro.agent.md"
  "plan-plus.agent.md"
)

download_file() {
  local url=$1 dest=$2
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  else
    error "curl or wget is required to download files from remote"
  fi
}

if [[ -d "$LOCAL_AGENTS_DIR" && -f "$LOCAL_PROMPT_FILE" ]]; then
  info "Using local repository files from $SCRIPT_DIR"
  for f in "$LOCAL_AGENTS_DIR"/*.md; do
    cp -f "$f" "$COPILOT_AGENT_DIR/"
    info "Copied $(basename "$f") -> $COPILOT_AGENT_DIR/"
  done
  cp -f "$LOCAL_PROMPT_FILE" "$PROMPT_FILE"
  info "Copied generate-steering.prompt.md -> $PROMPT_FILE"
else
  info "Local repo files not found; downloading from GitHub"
  for f in "${AGENT_FILES[@]}"; do
    url="$REPO_RAW_BASE/agents/$f"
    dest="$COPILOT_AGENT_DIR/$f"
    download_file "$url" "$dest"
    info "Downloaded $f -> $dest"
  done
  download_file "$REPO_RAW_BASE/prompts/generate-steering.prompt.md" "$PROMPT_FILE"
  info "Downloaded generate-steering.prompt.md -> $PROMPT_FILE"
fi

info "Installation completed."
info "Copied agents to: $COPILOT_AGENT_DIR"
info "Copied prompt to: $PROMPT_FILE"

if is_mac; then
  info "macOS prompt path: $PROMPT_FILE"
elif is_linux; then
  info "Linux prompt path: $PROMPT_FILE"
fi

cat <<EOF

✅ Done.

Next steps:
- Open VS Code Copilot Chat
- Reload window if needed (Cmd+Shift+P -> Reload Window)
- Use the prompt templates from the saved folder
EOF

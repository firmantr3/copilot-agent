#!/usr/bin/env bash
set -euo pipefail

# cross-platform installer for copilot-agent templates
# (supports local repo copy + remote install via curl/wget)

REPO_RAW_BASE="https://cdn.jsdelivr.net/gh/firmantr3/copilot-agent@main"

info() { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*"; }
error() { printf "[ERROR] %s\n" "$*" >&2; exit 1; }

is_mac() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

# target locations
COPILOT_AGENT_DIR="$HOME/.copilot/agents"
FIRMANTR3_DIR="$HOME/.copilot/firmantr3"
if is_mac; then
  PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts"
else
  PROMPTS_DIR="$HOME/.config/Code/User/prompts"
fi
mkdir -p "$COPILOT_AGENT_DIR" "$PROMPTS_DIR" "$FIRMANTR3_DIR"

# Determine source: local vs GitHub remote
script_source="${BASH_SOURCE[0]:-$0}"
if [[ -z "$script_source" ]]; then
  script_source="$0"
fi
SCRIPT_DIR="$(cd "$(dirname "$script_source")" && pwd)"
LOCAL_AGENTS_DIR="$SCRIPT_DIR/agents"
LOCAL_PROMPTS_DIR="$SCRIPT_DIR/prompts"
LOCAL_SHARED_DIR="$SCRIPT_DIR/shared"

# Fallback lists for remote install (when directory listing isn't available)
AGENT_FILES=(
  "plan-kiro.agent.md"
  "plan-plus.agent.md"
  "execute-kiro.agent.md"
)

SHARED_FILES=(
  "explore-checklist.md"
)

PROMPT_FILES=(
  "generate-steering.prompt.md"
  "update-steering.prompt.md"
)

# Check whether to overwrite a file; returns 0 = proceed, 1 = skip
confirm_overwrite() {
  local dest=$1
  if [[ -f "$dest" ]]; then
    # Non-interactive mode (piped install) — always overwrite
    if [[ ! -t 0 ]]; then
      info "Overwriting $(basename "$dest") (non-interactive mode)"
      return 0
    fi
    printf "[PROMPT] File '%s' already exists. Overwrite? [y/N] " "$(basename "$dest")"
    read -r answer
    case "$answer" in
      [yY]|[yY][eE][sS]) return 0 ;;
      *) warn "Skipped $(basename "$dest")"; return 1 ;;
    esac
  fi
  return 0
}

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

  # Copy all .md files from agents/
  for f in "$LOCAL_AGENTS_DIR"/*.md; do
    dest="$COPILOT_AGENT_DIR/$(basename "$f")"
    if confirm_overwrite "$dest"; then
      cp -f "$f" "$dest"
      info "Copied $(basename "$f") -> $COPILOT_AGENT_DIR/"
    fi
  done

  # Copy all .md files from prompts/
  for f in "$LOCAL_PROMPTS_DIR"/*.md; do
    dest="$PROMPTS_DIR/$(basename "$f")"
    if confirm_overwrite "$dest"; then
      cp -f "$f" "$dest"
      info "Copied $(basename "$f") -> $PROMPTS_DIR/"
    fi
  done
  # Copy all .md files from shared/
  if [[ -d "$LOCAL_SHARED_DIR" ]]; then
    for f in "$LOCAL_SHARED_DIR"/*.md; do
      dest="$FIRMANTR3_DIR/$(basename "$f")"
      if confirm_overwrite "$dest"; then
        cp -f "$f" "$dest"
        info "Copied $(basename "$f") -> $FIRMANTR3_DIR/"
      fi
    done
  fi
else
  info "Local repo files not found; downloading from GitHub"
  for f in "${AGENT_FILES[@]}"; do
    url="$REPO_RAW_BASE/agents/$f"
    dest="$COPILOT_AGENT_DIR/$f"
    if confirm_overwrite "$dest"; then
      download_file "$url" "$dest"
      info "Downloaded $f -> $dest"
    fi
  done
  for f in "${PROMPT_FILES[@]}"; do
    url="$REPO_RAW_BASE/prompts/$f"
    dest="$PROMPTS_DIR/$f"
    if confirm_overwrite "$dest"; then
      download_file "$url" "$dest"
      info "Downloaded $f -> $dest"
    fi
  done
  for f in "${SHARED_FILES[@]}"; do
    url="$REPO_RAW_BASE/shared/$f"
    dest="$FIRMANTR3_DIR/$f"
    if confirm_overwrite "$dest"; then
      download_file "$url" "$dest"
      info "Downloaded $f -> $dest"
    fi
  done
fi

info "Installation completed."
info "Copied agents to: $COPILOT_AGENT_DIR"
info "Copied prompts to: $PROMPTS_DIR"
info "Copied shared configs to: $FIRMANTR3_DIR"

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

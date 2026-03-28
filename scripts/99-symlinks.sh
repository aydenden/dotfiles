#!/usr/bin/env bash

# =============================================================================
# 99-symlinks.sh - 컨벤션 기반 자동 심링크
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Symlinks Setup"

# *.symlink → ~/.*
link_dotfiles

# config/ → ~/.config/
link_config

# Claude 설정 (특수 처리)
link_claude

# git_template 심링크
if [[ -d "$DOTFILES_DIR/git/git_template" ]]; then
    log_step "Git template"
    link_file "$DOTFILES_DIR/git/git_template" "$HOME/.git_template"
fi

script_end "Symlinks Setup"

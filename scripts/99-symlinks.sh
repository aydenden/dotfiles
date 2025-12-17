#!/usr/bin/env bash

# =============================================================================
# 99-symlinks.sh - 모든 dotfile 심링크 통합 관리
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Symlinks Setup"

CONFIG_DIR="$DOTFILES_DIR/.config"

# -----------------------------------------------------------------------------
# Zsh 설정
# -----------------------------------------------------------------------------
log_step "Zsh 설정 파일"

link_file "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"

# -----------------------------------------------------------------------------
# Powerlevel10k 설정
# -----------------------------------------------------------------------------
log_step "Powerlevel10k 설정 파일"

link_file "$CONFIG_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# -----------------------------------------------------------------------------
# Finicky 설정
# -----------------------------------------------------------------------------
log_step "Finicky 설정 파일"

link_file "$CONFIG_DIR/.finicky.js" "$HOME/.finicky.js"

# -----------------------------------------------------------------------------
# iTerm2 프로필 (Dynamic Profiles)
# -----------------------------------------------------------------------------
log_step "iTerm2 프로필"

ITERM_PROFILE_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

if [[ -f "$CONFIG_DIR/itermProfile.json" ]]; then
    mkdir -p "$ITERM_PROFILE_DIR"
    link_file "$CONFIG_DIR/itermProfile.json" "$ITERM_PROFILE_DIR/dotfiles-profile.json"
    log_info "iTerm2를 재시작하면 프로필이 적용됩니다"
else
    log_warn "iTerm 프로필 파일을 찾을 수 없습니다: $CONFIG_DIR/itermProfile.json"
fi

script_end "Symlinks Setup"

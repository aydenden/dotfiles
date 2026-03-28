#!/usr/bin/env bash

# =============================================================================
# 02-shell.sh - Zsh + Sheldon + Starship 설정
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Shell Setup (Zsh + Sheldon + Starship)"

require_brew

# --- Zsh ---
log_step "Zsh 확인"
if is_brew_installed zsh; then
    log_success "Zsh가 이미 설치되어 있습니다"
else
    log_info "Zsh 설치 중..."
    brew install zsh
    log_success "Zsh 설치 완료"
fi

# 기본 셸 변경
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    log_success "이미 Zsh가 기본 셸입니다"
else
    log_info "기본 셸을 Zsh로 변경 중..."
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
    log_success "기본 셸이 Zsh로 변경되었습니다 (재로그인 후 적용)"
fi

# --- Sheldon ---
log_step "Sheldon 확인"
if is_installed sheldon; then
    log_success "Sheldon이 이미 설치되어 있습니다"
else
    log_info "Sheldon 설치 중..."
    brew install sheldon
    log_success "Sheldon 설치 완료"
fi

# Sheldon 설정 링크
SHELDON_DIR="$HOME/.config/sheldon"
mkdir -p "$SHELDON_DIR"
if [[ -f "$DOTFILES_DIR/shell/plugins.toml" ]]; then
    link_file "$DOTFILES_DIR/shell/plugins.toml" "$SHELDON_DIR/plugins.toml"
fi

# --- Starship ---
log_step "Starship 확인"
if is_installed starship; then
    log_success "Starship이 이미 설치되어 있습니다"
else
    log_info "Starship 설치 중..."
    brew install starship
    log_success "Starship 설치 완료"
fi

script_end "Shell Setup"

log_info "심링크는 99-symlinks.sh에서 설정됩니다"

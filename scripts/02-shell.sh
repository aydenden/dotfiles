#!/usr/bin/env bash

# =============================================================================
# 02-shell.sh - Zsh + Oh My Zsh + Powerlevel10k 설정
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Shell Setup (Zsh)"

require_brew

# -----------------------------------------------------------------------------
# Zsh 설치
# -----------------------------------------------------------------------------
log_step "Zsh 확인"

if is_brew_installed zsh; then
    log_success "Zsh가 이미 설치되어 있습니다"
else
    log_info "Zsh 설치 중..."
    brew install zsh
    log_success "Zsh 설치 완료"
fi

# -----------------------------------------------------------------------------
# 기본 셸 변경
# -----------------------------------------------------------------------------
log_step "기본 셸 확인"

ZSH_PATH="$(which zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
    log_success "이미 Zsh가 기본 셸입니다"
else
    log_info "기본 셸을 Zsh로 변경 중..."

    # /etc/shells에 추가 (없으면)
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi

    chsh -s "$ZSH_PATH"
    log_success "기본 셸이 Zsh로 변경되었습니다 (재로그인 후 적용)"
fi

# -----------------------------------------------------------------------------
# Oh My Zsh 설치
# -----------------------------------------------------------------------------
log_step "Oh My Zsh 확인"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log_success "Oh My Zsh가 이미 설치되어 있습니다"
else
    log_info "Oh My Zsh 설치 중..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh 설치 완료"
fi

# -----------------------------------------------------------------------------
# Powerlevel10k 설치
# -----------------------------------------------------------------------------
log_step "Powerlevel10k 확인"

P10K_DIR="$HOME/powerlevel10k"
if [[ -d "$P10K_DIR" ]]; then
    log_success "Powerlevel10k가 이미 설치되어 있습니다"
else
    log_info "Powerlevel10k 설치 중..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    log_success "Powerlevel10k 설치 완료"
fi

# -----------------------------------------------------------------------------
# zsh-syntax-highlighting 설치
# -----------------------------------------------------------------------------
log_step "zsh-syntax-highlighting 확인"

if is_brew_installed zsh-syntax-highlighting; then
    log_success "zsh-syntax-highlighting이 이미 설치되어 있습니다"
else
    log_info "zsh-syntax-highlighting 설치 중..."
    brew install zsh-syntax-highlighting
    log_success "zsh-syntax-highlighting 설치 완료"
fi

script_end "Shell Setup"

log_info "심링크는 99-symlinks.sh에서 설정됩니다"

#!/usr/bin/env bash

# =============================================================================
# 01-core.sh - Homebrew 및 필수 패키지 설치
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Core Setup (Homebrew)"

# -----------------------------------------------------------------------------
# Homebrew 설치
# -----------------------------------------------------------------------------
log_step "Homebrew 확인"

if is_installed brew; then
    log_success "Homebrew가 이미 설치되어 있습니다"
else
    log_info "Homebrew 설치 중..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Apple Silicon Mac의 경우 PATH 설정
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    log_success "Homebrew 설치 완료"
fi

# -----------------------------------------------------------------------------
# Homebrew 업데이트
# -----------------------------------------------------------------------------
log_step "Homebrew 업데이트"

brew update
log_success "업데이트 완료"

# -----------------------------------------------------------------------------
# Brewfile 실행
# -----------------------------------------------------------------------------
log_step "Brewfile 패키지 설치"

if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    log_success "Brewfile 패키지 설치 완료"
else
    log_warn "Brewfile을 찾을 수 없습니다: $DOTFILES_DIR/Brewfile"
fi

# -----------------------------------------------------------------------------
# 정리
# -----------------------------------------------------------------------------
log_step "정리"

brew cleanup
log_success "정리 완료"

script_end "Core Setup"

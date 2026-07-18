#!/usr/bin/env bash

# =============================================================================
# 03-dev.sh - nvm(node) + 개발 도구 설정
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Dev Setup (nvm + tools)"

require_brew

# --- nvm ---
log_step "nvm 확인"
if is_brew_installed nvm; then
    log_success "nvm이 이미 설치되어 있습니다"
else
    log_info "nvm 설치 중..."
    brew install nvm
    log_success "nvm 설치 완료"
fi

# node LTS 설치
log_step "node LTS 설치"
mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
if command -v nvm &>/dev/null; then
    nvm install --lts
    log_success "node LTS 설치 완료"
else
    log_warn "nvm 로드 실패 — 새 셸에서 'nvm install --lts' 를 실행하세요"
fi

# --- Docker (Colima) ---
log_step "Docker 확인"
if is_installed docker; then
    log_success "Docker가 이미 설치되어 있습니다"
else
    log_info "Docker + Colima 설치 중..."
    brew install docker docker-compose colima
    log_success "Docker 설치 완료"
fi

script_end "Dev Setup"

#!/usr/bin/env bash

# =============================================================================
# 03-dev-node.sh - Node.js 개발 환경 (NVM + Node.js + Yarn)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Node.js Development Setup"

require_brew

# -----------------------------------------------------------------------------
# NVM 설치
# -----------------------------------------------------------------------------
log_step "NVM 확인"

if is_brew_installed nvm; then
    log_success "NVM이 이미 설치되어 있습니다"
else
    log_info "NVM 설치 중..."
    brew install nvm
    log_success "NVM 설치 완료"
fi

# NVM 디렉토리 생성
mkdir -p "$HOME/.nvm"

# NVM 로드
export NVM_DIR="$HOME/.nvm"
if [[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ]]; then
    source "$(brew --prefix)/opt/nvm/nvm.sh"
fi

# -----------------------------------------------------------------------------
# Node.js LTS 설치
# -----------------------------------------------------------------------------
log_step "Node.js LTS 확인"

if is_installed node; then
    CURRENT_NODE=$(node -v)
    log_success "Node.js가 이미 설치되어 있습니다: $CURRENT_NODE"
else
    log_info "Node.js LTS 설치 중..."
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    log_success "Node.js LTS 설치 완료: $(node -v)"
fi

# -----------------------------------------------------------------------------
# Yarn 설치
# -----------------------------------------------------------------------------
log_step "Yarn 확인"

if is_installed yarn; then
    log_success "Yarn이 이미 설치되어 있습니다: $(yarn -v)"
else
    log_info "Yarn 설치 중..."
    npm install -g yarn
    log_success "Yarn 설치 완료: $(yarn -v)"
fi

script_end "Node.js Development Setup"

#!/usr/bin/env bash

# =============================================================================
# 03-dev.sh - mise 런타임 + 개발 도구 설정
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Dev Setup (mise + tools)"

require_brew

# --- mise ---
log_step "mise 확인"
if is_installed mise; then
    log_success "mise가 이미 설치되어 있습니다"
else
    log_info "mise 설치 중..."
    brew install mise
    log_success "mise 설치 완료"
fi

# mise 런타임 설치
log_step "런타임 설치"
if [[ -f "$DOTFILES_DIR/config/mise/config.toml" ]]; then
    log_info "mise install 실행 중..."
    mise install
    log_success "런타임 설치 완료"
else
    log_warn "mise config.toml을 찾을 수 없습니다"
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

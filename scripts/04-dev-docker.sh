#!/usr/bin/env bash

# =============================================================================
# 04-dev-docker.sh - 컨테이너 환경 (OrbStack)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "Docker Development Setup (OrbStack)"

require_brew

# -----------------------------------------------------------------------------
# OrbStack 설치
# -----------------------------------------------------------------------------
log_step "OrbStack 확인"

if is_cask_installed orbstack; then
    log_success "OrbStack이 이미 설치되어 있습니다"
else
    log_info "OrbStack 설치 중..."
    brew install --cask orbstack
    log_success "OrbStack 설치 완료"
fi

# -----------------------------------------------------------------------------
# 안내
# -----------------------------------------------------------------------------
log_info "OrbStack은 Docker CLI와 호환됩니다"
log_info "설치 후 OrbStack 앱을 실행하여 초기 설정을 완료하세요"

script_end "Docker Development Setup"

#!/usr/bin/env bash

# =============================================================================
# 04-macos.sh - macOS 시스템 설정
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

script_start "macOS Defaults"

log_info "macOS 시스템 설정을 적용합니다..."
log_warn "관리자 비밀번호가 필요할 수 있습니다."

"$DOTFILES_DIR/macos/defaults.sh"

script_end "macOS Defaults"

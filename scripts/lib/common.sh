#!/usr/bin/env bash

# =============================================================================
# common.sh - dotfiles 공통 유틸리티 함수
# =============================================================================

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# DOTFILES 경로 설정
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# =============================================================================
# 로깅 함수
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${BLUE}==>${NC} $1"
}

# =============================================================================
# 체크 함수
# =============================================================================

# 명령어 존재 여부 체크
is_installed() {
    command -v "$1" &>/dev/null
}

# brew 패키지 설치 여부 체크
is_brew_installed() {
    brew list "$1" &>/dev/null
}

# brew cask 설치 여부 체크
is_cask_installed() {
    brew list --cask "$1" &>/dev/null
}

# brew 필수 체크
require_brew() {
    if ! is_installed brew; then
        log_error "Homebrew가 설치되어 있지 않습니다. 먼저 01-core.sh를 실행하세요."
        exit 1
    fi
}

# =============================================================================
# 심링크 함수
# =============================================================================

# 파일 심링크 생성 (기존 파일 백업)
link_file() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        log_error "소스 파일이 존재하지 않습니다: $src"
        return 1
    fi

    # 이미 올바른 심링크인 경우 스킵
    if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
        log_success "이미 연결됨: $dest"
        return 0
    fi

    # 기존 파일/심링크가 있으면 백업
    if [[ -e "$dest" ]] || [[ -L "$dest" ]]; then
        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        log_warn "기존 파일 백업: $dest -> $backup"
        mv "$dest" "$backup"
    fi

    # 심링크 생성
    ln -s "$src" "$dest"
    log_success "심링크 생성: $dest -> $src"
}

# =============================================================================
# 유틸리티 함수
# =============================================================================

# 스크립트 시작 로그
script_start() {
    local name="$1"
    echo ""
    echo "=============================================="
    echo " $name"
    echo "=============================================="
    echo ""
}

# 스크립트 종료 로그
script_end() {
    local name="$1"
    echo ""
    log_success "$name 완료!"
    echo ""
}

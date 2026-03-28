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

# =============================================================================
# 컨벤션 기반 자동 심링크
# =============================================================================

# *.symlink 파일을 ~/.파일명으로 심링크
link_dotfiles() {
    log_step "*.symlink 파일 자동 링크"
    local files=$(find "$DOTFILES_DIR" -maxdepth 2 -name "*.symlink" -not -path "*/.git/*" -not -path "*/.cache/*")
    for src in $files; do
        local filename=$(basename "$src" ".symlink")
        local dest="$HOME/.$filename"
        link_file "$src" "$dest"
    done
}

# config/ 하위를 ~/.config/에 심링크
link_config() {
    log_step "config/ → ~/.config/ 링크"
    local config_dir="$DOTFILES_DIR/config"

    # 디렉토리 링크
    for dir in "$config_dir"/*/; do
        [[ -d "$dir" ]] || continue
        local dirname=$(basename "$dir")
        local dest="$HOME/.config/$dirname"
        mkdir -p "$HOME/.config"
        link_file "$dir" "$dest"
    done

    # 단독 파일 링크 (starship.toml 등)
    for file in "$config_dir"/*; do
        [[ -f "$file" ]] || continue
        local filename=$(basename "$file")
        local dest="$HOME/.config/$filename"
        mkdir -p "$HOME/.config"
        link_file "$file" "$dest"
    done
}

# Claude 설정 처리 (읽기전용=symlink, 런타임수정=복사)
link_claude() {
    log_step "Claude Code 설정"
    local claude_dir="$DOTFILES_DIR/claude"
    local dest_dir="$HOME/.claude"

    mkdir -p "$dest_dir"

    # 읽기전용 파일 → symlink
    for file in CLAUDE.md coding-rules.md keybindings.json; do
        [[ -f "$claude_dir/$file" ]] && link_file "$claude_dir/$file" "$dest_dir/$file"
    done

    # settings.json.template → 복사 (런타임 수정됨)
    if [[ -f "$claude_dir/settings.json.template" ]]; then
        if [[ ! -f "$dest_dir/settings.json" ]]; then
            cp "$claude_dir/settings.json.template" "$dest_dir/settings.json"
            log_success "settings.json 생성 (template에서 복사)"
        else
            log_info "settings.json 이미 존재 — 건너뜀 (수동 동기화 필요)"
        fi
    fi

    # settings.local.json.example → 없으면 복사
    if [[ -f "$claude_dir/settings.local.json.example" ]] && [[ ! -f "$dest_dir/settings.local.json" ]]; then
        cp "$claude_dir/settings.local.json.example" "$dest_dir/settings.local.json"
        log_warn "settings.local.json 생성됨 — API 키를 설정하세요!"
    fi

    # skills 디렉토리 링크
    if [[ -d "$claude_dir/skills" ]]; then
        for skill_dir in "$claude_dir/skills"/*/; do
            [[ -d "$skill_dir" ]] || continue
            local skill_name=$(basename "$skill_dir")
            mkdir -p "$dest_dir/skills"
            link_file "$skill_dir" "$dest_dir/skills/$skill_name"
        done
    fi
}

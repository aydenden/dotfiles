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
    local files=$(find "$DOTFILES_DIR" -maxdepth 3 -name "*.symlink" -not -path "*/.git/*" -not -path "*/.cache/*")
    for src in $files; do
        local filename=$(basename "$src" ".symlink")
        local dest="$HOME/.$filename"
        link_file "$src" "$dest"
    done
}

# config/ 하위를 ~/.config/에 심링크
link_config() {
    log_step "config/ → ~/.config/ 링크"
    mkdir -p "$HOME/.config"

    # 크로스플랫폼(shared) + macOS 전용(config) 두 소스를 모두 링크
    for config_dir in "$DOTFILES_DIR/shared/config" "$DOTFILES_DIR/config"; do
        [[ -d "$config_dir" ]] || continue

        # 디렉토리 링크
        for dir in "$config_dir"/*/; do
            [[ -d "$dir" ]] || continue
            link_file "$dir" "$HOME/.config/$(basename "$dir")"
        done

        # 단독 파일 링크
        for file in "$config_dir"/*; do
            [[ -f "$file" ]] || continue
            link_file "$file" "$HOME/.config/$(basename "$file")"
        done
    done
}

# Claude 설정 처리 (읽기전용=symlink, 런타임수정=복사)
link_claude() {
    log_step "Claude Code 설정"
    local claude_dir="$DOTFILES_DIR/shared/claude"
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

# OpenCode 설정 처리 (개별 파일 심링크, 런타임 파일은 보존)
link_opencode() {
    log_step "OpenCode 설정"
    local oc_dir="$DOTFILES_DIR/shared/opencode"
    local dest_dir="$HOME/.config/opencode"

    mkdir -p "$dest_dir"

    # 버전 관리 대상 파일 → symlink
    for file in opencode.json AGENTS.md tui.json oh-my-opencode-slim.json; do
        [[ -f "$oc_dir/$file" ]] && link_file "$oc_dir/$file" "$dest_dir/$file"
    done

    # skills 디렉토리 준비
    mkdir -p "$dest_dir/skills"

    # 외부 스킬 심링크 (소스가 존재하는 경우만)
    local cua_src="/Applications/CuaDriver.app/Contents/Resources/Skills/cua-driver"
    if [[ -d "$cua_src" ]] && [[ ! -L "$dest_dir/skills/cua-driver" ]]; then
        link_file "$cua_src" "$dest_dir/skills/cua-driver"
    fi

    local wiki_src="$HOME/.hermes/skills/research/llm-wiki"
    if [[ -d "$wiki_src" ]] && [[ ! -L "$dest_dir/skills/llm-wiki" ]]; then
        link_file "$wiki_src" "$dest_dir/skills/llm-wiki"
    fi
}

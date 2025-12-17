#!/usr/bin/env bash

# =============================================================================
# setup.sh - dotfiles 단일 진입점
# =============================================================================
#
# 사용법:
#   ./setup.sh              대화형 모드 (설치할 항목 선택)
#   ./setup.sh --all        전체 설치
#   ./setup.sh --core       Homebrew + 필수 패키지만
#   ./setup.sh --shell      Zsh 환경만
#   ./setup.sh --node       Node.js 환경만
#   ./setup.sh --docker     Docker(OrbStack) 환경만
#   ./setup.sh --symlinks   심링크만 설정
#   ./setup.sh --help       도움말
#
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# =============================================================================
# 함수 정의
# =============================================================================

show_banner() {
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║           dotfiles setup                 ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_help() {
    echo "사용법: ./setup.sh [옵션]"
    echo ""
    echo "옵션:"
    echo "  --all        전체 설치"
    echo "  --core       Homebrew + 필수 패키지"
    echo "  --shell      Zsh + Oh My Zsh + Powerlevel10k"
    echo "  --node       NVM + Node.js + Yarn"
    echo "  --docker     OrbStack (Docker 호환)"
    echo "  --symlinks   dotfile 심링크 설정"
    echo "  --help       이 도움말 표시"
    echo ""
    echo "옵션 없이 실행하면 대화형 모드로 시작합니다."
}

run_script() {
    local script="$1"
    if [[ -f "$script" ]]; then
        chmod +x "$script"
        "$script"
    else
        echo -e "${RED}[ERROR]${NC} 스크립트를 찾을 수 없습니다: $script"
        exit 1
    fi
}

run_core() {
    run_script "$SCRIPTS_DIR/01-core.sh"
}

run_shell() {
    run_script "$SCRIPTS_DIR/02-shell.sh"
}

run_node() {
    run_script "$SCRIPTS_DIR/03-dev-node.sh"
}

run_docker() {
    run_script "$SCRIPTS_DIR/04-dev-docker.sh"
}

run_symlinks() {
    run_script "$SCRIPTS_DIR/99-symlinks.sh"
}

run_all() {
    run_core
    run_shell
    run_node
    run_docker
    run_symlinks
}

interactive_mode() {
    show_banner

    echo -e "${BLUE}설치할 항목을 선택하세요:${NC}"
    echo ""
    echo "  1) 전체 설치 (권장)"
    echo "  2) Core (Homebrew + 필수 패키지)"
    echo "  3) Shell (Zsh + Oh My Zsh + Powerlevel10k)"
    echo "  4) Node.js (NVM + Node.js + Yarn)"
    echo "  5) Docker (OrbStack)"
    echo "  6) Symlinks (dotfile 심링크)"
    echo "  7) 종료"
    echo ""

    read -p "선택 [1-7]: " choice

    case $choice in
        1) run_all ;;
        2) run_core ;;
        3) run_shell ;;
        4) run_node ;;
        5) run_docker ;;
        6) run_symlinks ;;
        7)
            echo "종료합니다."
            exit 0
            ;;
        *)
            echo -e "${RED}잘못된 선택입니다.${NC}"
            exit 1
            ;;
    esac
}

# =============================================================================
# 메인
# =============================================================================

# 인자가 없으면 대화형 모드
if [[ $# -eq 0 ]]; then
    interactive_mode
    exit 0
fi

# 인자 처리
case "$1" in
    --all)
        show_banner
        run_all
        ;;
    --core)
        run_core
        ;;
    --shell)
        run_shell
        ;;
    --node)
        run_node
        ;;
    --docker)
        run_docker
        ;;
    --symlinks)
        run_symlinks
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}알 수 없는 옵션: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}완료!${NC}"

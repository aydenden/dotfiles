#!/bin/bash

set -e

echo "🚀 Claude Code 설정을 시작합니다..."

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. ~/.claude 디렉토리 생성
echo ""
echo "📁 ~/.claude 디렉토리 확인 중..."
if [ ! -d "$HOME/.claude" ]; then
  mkdir -p "$HOME/.claude"
  echo -e "${GREEN}✅ ~/.claude 디렉토리 생성 완료${NC}"
else
  echo -e "${GREEN}✅ ~/.claude 디렉토리 존재${NC}"
fi

# 2. 기존 파일 백업
echo ""
echo "💾 기존 파일 백업 중..."
BACKUP_DIR="$HOME/.claude/backup-$(date +%Y%m%d_%H%M%S)"

if [ -f "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
  mkdir -p "$BACKUP_DIR"
  mv "$HOME/.claude/CLAUDE.md" "$BACKUP_DIR/"
  echo -e "${YELLOW}⚠️  기존 CLAUDE.md를 백업했습니다: $BACKUP_DIR${NC}"
fi

if [ -f "$HOME/.claude/coding-rules.md" ] && [ ! -L "$HOME/.claude/coding-rules.md" ]; then
  mkdir -p "$BACKUP_DIR"
  mv "$HOME/.claude/coding-rules.md" "$BACKUP_DIR/"
  echo -e "${YELLOW}⚠️  기존 coding-rules.md를 백업했습니다: $BACKUP_DIR${NC}"
fi

# 3. 심볼릭 링크 생성
echo ""
echo "🔗 심볼릭 링크 생성 중..."

# CLAUDE.md
if [ -L "$HOME/.claude/CLAUDE.md" ]; then
  rm "$HOME/.claude/CLAUDE.md"
fi
ln -sf "$HOME/dotfiles/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
echo -e "${GREEN}✅ CLAUDE.md 링크 완료${NC}"

# coding-rules.md
if [ -L "$HOME/.claude/coding-rules.md" ]; then
  rm "$HOME/.claude/coding-rules.md"
fi
ln -sf "$HOME/dotfiles/.claude/coding-rules.md" "$HOME/.claude/coding-rules.md"
echo -e "${GREEN}✅ coding-rules.md 링크 완료${NC}"

# skills 디렉토리
if [ -d "$HOME/dotfiles/.claude/skills" ]; then
  if [ -L "$HOME/.claude/skills" ]; then
    rm "$HOME/.claude/skills"
  elif [ -d "$HOME/.claude/skills" ]; then
    if [ ! -d "$BACKUP_DIR" ]; then
      mkdir -p "$BACKUP_DIR"
    fi
    mv "$HOME/.claude/skills" "$BACKUP_DIR/"
    echo -e "${YELLOW}⚠️  기존 skills 디렉토리를 백업했습니다: $BACKUP_DIR${NC}"
  fi
  ln -sf "$HOME/dotfiles/.claude/skills" "$HOME/.claude/skills"
  echo -e "${GREEN}✅ skills 디렉토리 링크 완료${NC}"
fi

# 4. settings.json 설정
echo ""
echo "⚙️  settings.json 설정 중..."
if [ ! -f "$HOME/.claude/settings.json" ]; then
  cp "$HOME/dotfiles/.claude/settings.json.template" "$HOME/.claude/settings.json"
  echo -e "${GREEN}✅ settings.json 생성 완료 (템플릿 기반)${NC}"
  echo -e "${YELLOW}⚠️  ~/.claude/settings.json을 디바이스에 맞게 수정해주세요${NC}"
else
  echo -e "${GREEN}✅ settings.json 이미 존재 (변경하지 않음)${NC}"
fi

# 5. 권한 설정
echo ""
echo "🔒 파일 권한 설정 중..."
chmod 600 "$HOME/.claude/settings.json"
echo -e "${GREEN}✅ settings.json 권한 설정 완료 (600)${NC}"

# 6. 완료 메시지
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✨ 설치가 완료되었습니다! ✨         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "📝 다음 단계:"
echo "   1. ~/.claude/settings.json 파일을 열어서"
echo "      API 키와 로컬 경로를 설정하세요"
echo ""
echo "   2. Skills 추가하기:"
echo "      mkdir -p ~/dotfiles/.claude/skills/my-skill"
echo "      vi ~/dotfiles/.claude/skills/my-skill/SKILL.md"
echo ""
echo "   3. 변경사항 커밋:"
echo "      cd ~/dotfiles"
echo "      git add .claude/"
echo "      git commit -m 'Update Claude Code settings'"
echo ""
echo -e "${GREEN}🎉 Happy coding with Claude!${NC}"
echo ""

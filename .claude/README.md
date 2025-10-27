# Claude Code Dotfiles Configuration

Claude Code 전역 설정을 관리하는 dotfiles 구조입니다.

## 디렉토리 구조

```
~/.claude/                          (실제 사용 위치)
├── CLAUDE.md                       → dotfiles/.claude/CLAUDE.md (심볼릭 링크)
├── coding-rules.md                 → dotfiles/.claude/coding-rules.md (심볼릭 링크)
├── settings.json                   (로컬 전용, gitignore)
└── skills/                         → dotfiles/.claude/skills/ (심볼릭 링크)
    └── [각종 skills]

~/dotfiles/.claude/                 (Git으로 관리)
├── README.md                       (이 파일)
├── CLAUDE.md                       (전역 프롬프트)
├── coding-rules.md                 (코딩 규칙)
├── settings.json.template          (설정 템플릿)
├── setup.sh                        (자동 설치 스크립트)
└── skills/                         (전역 skills)
```

## 설치 방법

### 1. 자동 설치 (권장)

```bash
cd ~/dotfiles/.claude
chmod +x setup.sh
./setup.sh
```

### 2. 수동 설치

```bash
# 심볼릭 링크 생성
ln -sf ~/dotfiles/.claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/.claude/coding-rules.md ~/.claude/coding-rules.md
ln -sf ~/dotfiles/.claude/skills ~/.claude/skills

# settings.json 생성 (템플릿 기반)
cp ~/dotfiles/.claude/settings.json.template ~/.claude/settings.json
# 이후 ~/.claude/settings.json을 디바이스에 맞게 수정
```

## 파일 설명

### CLAUDE.md
- 모든 Claude Code 세션에 적용되는 전역 프롬프트
- 페르소나, 일반 규칙, 코딩 규칙 참조 포함
- **Git으로 관리됨**

### coding-rules.md
- 상세한 코딩 규칙 (주석 작성 규칙, emotion 사용 등)
- CLAUDE.md에서 참조됨
- **Git으로 관리됨**

### settings.json (로컬 전용)
- 디바이스별 설정 (API 키, 로컬 경로 등)
- **Git에서 제외됨** (.gitignore)
- `settings.json.template`를 복사해서 사용

### settings.json.template
- settings.json의 템플릿
- 공통 설정과 변수 플레이스홀더 포함
- **Git으로 관리됨**

### skills/
- 모든 프로젝트에서 사용 가능한 전역 skills
- 개인 워크플로우, 재사용 가능한 전문 지식
- **Git으로 관리됨**

## 새 디바이스 설정

1. dotfiles 리포지토리 클론
```bash
git clone https://github.com/your/dotfiles.git ~/dotfiles
```

2. Claude 설정 설치
```bash
cd ~/dotfiles/.claude
./setup.sh
```

3. settings.json 개인화
```bash
# API 키, 로컬 경로 등을 디바이스에 맞게 수정
vi ~/.claude/settings.json
```

## Skills 추가하기

### 전역 Skill (모든 프로젝트에서 사용)
```bash
mkdir -p ~/dotfiles/.claude/skills/my-skill
vi ~/dotfiles/.claude/skills/my-skill/SKILL.md
git add ~/dotfiles/.claude/skills/my-skill
git commit -m "Add my-skill"
```

### 프로젝트별 Skill (특정 프로젝트만)
```bash
mkdir -p .claude/skills/project-skill
vi .claude/skills/project-skill/SKILL.md
git add .claude/skills/project-skill
```

## 주의사항

⚠️ **절대로 Git에 포함하지 말 것:**
- `~/.claude/settings.json` - API 키, 개인 경로 포함
- `.claude/settings.local.json` - 프로젝트별 로컬 설정
- `CLAUDE.local.md` - 개인 전용 프롬프트

✅ **Git으로 관리할 것:**
- `CLAUDE.md` - 팀 공유 프롬프트
- `coding-rules.md` - 팀 코딩 규칙
- `settings.json.template` - 공통 설정 템플릿
- `skills/` - 재사용 가능한 전역 skills

## 베스트 프랙티스

1. **CLAUDE.md는 100-200줄 이내 유지**
   - 너무 길면 컨텍스트 낭비

2. **디바이스별 설정은 settings.json에서만**
   - settings.json.template은 공통 부분만

3. **Skills는 목적별로 분리**
   - 하나의 skill = 하나의 명확한 역할

4. **자주 업데이트**
   - 유용한 패턴 발견 시 즉시 추가

## 문제 해결

### 심볼릭 링크가 깨진 경우
```bash
cd ~/dotfiles/.claude
./setup.sh
```

### Skills가 인식되지 않는 경우
```bash
ls -la ~/.claude/skills
# 심볼릭 링크 확인 및 재생성
```

### 설정이 적용되지 않는 경우
```bash
# Claude Code 재시작
# 또는 설정 우선순위 확인 (로컬 > 공유 > 전역)
```

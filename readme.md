# dotfiles

macOS 개발 환경 자동화 설정. 토픽 기반 구조로 관리.

## 빠른 시작

```bash
xcode-select --install

git clone https://github.com/aydenden/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## 구조

```
dotfiles/
├── shell/                    # Zsh + Sheldon + Starship
│   ├── zshrc.symlink         # → ~/.zshrc (로더)
│   ├── aliases.zsh           # 자동 소싱
│   ├── exports.zsh
│   ├── functions.zsh
│   ├── path.zsh
│   ├── history.zsh
│   ├── completion.zsh
│   └── plugins.toml          # Sheldon 플러그인
│
├── git/                      # Git 설정
│   ├── gitconfig.symlink     # → ~/.gitconfig
│   ├── gitignore.symlink     # → ~/.gitignore (글로벌)
│   ├── gitmessage.symlink    # → ~/.gitmessage
│   └── git_template/         # → ~/.git_template (hooks)
│
├── macos/                    # macOS 시스템 설정
│   └── defaults.sh
│
├── config/                   # XDG 설정 → ~/.config/
│   ├── ghostty/              # 터미널
│   ├── cmux/                 # cmux 글로벌 커맨드
│   ├── starship.toml         # 프롬프트 테마
│   └── mise/                 # 런타임 버전 관리
│
├── claude/                   # Claude Code 설정
│   ├── CLAUDE.md             # symlink
│   ├── coding-rules.md       # symlink
│   ├── settings.json.template  # 복사 (런타임 수정됨)
│   └── settings.local.json.example
│
├── bin/                      # 커스텀 명령어 ($PATH)
│   ├── dot                   # dotfiles 업데이트
│   ├── git-cleanup-branches
│   └── git-recent
│
├── scripts/                  # 설치 스크립트
│   ├── lib/common.sh
│   ├── 01-core.sh            # Homebrew + Brewfile
│   ├── 02-shell.sh           # Sheldon + Starship
│   ├── 03-dev.sh             # mise + 런타임
│   ├── 04-macos.sh           # defaults 적용
│   └── 99-symlinks.sh        # 심링크 자동 생성
│
├── Brewfile
├── setup.sh                  # 진입점 (대화형/플래그)
└── .gitignore
```

## 컨벤션

### `*.symlink` — 홈 디렉토리 심링크

`topic/파일명.symlink` → `~/.파일명`으로 자동 링크.

```
shell/zshrc.symlink     → ~/.zshrc
git/gitconfig.symlink   → ~/.gitconfig
git/gitignore.symlink   → ~/.gitignore
```

### `*.zsh` — 자동 소싱

`shell/*.zsh` 파일은 zshrc에서 자동으로 source됨. `path.zsh`가 가장 먼저 로드.

### `config/` — XDG 설정

`config/` 하위 디렉토리가 `~/.config/`에 심링크.

```
config/ghostty/   → ~/.config/ghostty
config/cmux/      → ~/.config/cmux
config/mise/      → ~/.config/mise
```

### `.local` — 머신별 설정

`.local` 파일은 gitignore 대상. 비밀 정보나 머신별 설정 보관.

```
~/.zshrc.local          # 토큰, 프록시 등
~/.gitconfig.local      # user.name, user.email
```

모든 설정 파일 끝에서 `.local` 파일을 소싱한다.

## 사용법

```bash
./setup.sh              # 대화형 모드
./setup.sh --all        # 전체 설치
./setup.sh --help       # 도움말
```

| 플래그 | 설명 |
|--------|------|
| `--all` | 전체 설치 |
| `--core` | Homebrew + Brewfile |
| `--shell` | Zsh + Sheldon + Starship |
| `--dev` | mise + 런타임 + Docker |
| `--macos` | macOS defaults 적용 |
| `--symlinks` | 심링크 설정 |

업데이트: `dot` 명령으로 pull + brew bundle + symlink 한 번에 실행.

## 설치 항목

### CLI

| 카테고리 | 패키지 |
|----------|--------|
| Shell | zsh, sheldon, starship |
| 현대적 CLI | ripgrep, fzf, fd, bat, eza, jq, tree, wget, htop |
| Git | git, lazygit, gitui, git-delta, bfg |
| 런타임 | mise, deno, bun, go, rustup, uv |
| 에디터/LSP | marksman, rust-analyzer, ast-grep |
| 컨테이너 | docker, docker-compose, colima |
| AI/ML | ollama, lume |
| 도구 | gh, tmux, zellij, ffmpeg, code2prompt, fswatch |

### Cask

ghostty, cmux, visual-studio-code

### 폰트

font-d2coding, font-d2coding-nerd-font

## 셸 환경

**Zsh + Sheldon + Starship** 조합.

- **Sheldon**: TOML 기반 플러그인 매니저. `shell/plugins.toml`에서 관리.
- **Starship**: Rust 기반 크로스셸 프롬프트. `config/starship.toml`에서 테마 설정.
- **mise**: nvm/pyenv/rbenv 통합 대체. `config/mise/config.toml`에서 런타임 버전 선언.

zshrc는 로더 역할만 하고, 실제 설정은 `shell/*.zsh` 파일에 분산.

## Git

### 주요 설정

- `pull.rebase = true` — pull 시 rebase
- `fetch.prune = true` — 삭제된 원격 브랜치 자동 정리
- `rebase.autosquash = true` — fixup! 커밋 자동 처리
- `branch.sort = -committerdate` — 최근 브랜치 먼저
- `merge.ff = only` — fast-forward만 허용
- `diff.colorMoved = zebra` — 이동된 코드 별도 색상
- `commit.template = ~/.gitmessage` — 커밋 메시지 가이드

### Alias

```
s=status -s  co=checkout  ci=commit  br=branch
d=diff  dc=diff --cached  lg=log --graph (한줄)
aa=add --all  cm=commit -m  ca=commit --amend
mainormaster  — main/master 자동 감지
dm            — 머지된 브랜치 일괄 삭제
```

### 커스텀 명령어 (bin/)

- `git-cleanup-branches` — 머지된 로컬 브랜치 일괄 삭제
- `git-recent` — 최근 작업한 브랜치 목록

### 로컬 오버라이드

```bash
# ~/.gitconfig.local
[user]
    name = 이름
    email = email@example.com
```

## macOS

`./setup.sh --macos`로 개발자 필수 시스템 설정 적용.

- 키보드: 빠른 키 반복, press-and-hold 비활성화
- Finder: 숨김 파일 표시, 확장자 표시, 리스트 뷰, 전체 경로
- Dock: 자동 숨김, 딜레이 없음, 최근 항목 숨김
- 스크린샷: 그림자 없음, PNG 포맷
- 시스템: iCloud 자동 저장 비활성화, 빠른 창 리사이즈

## Claude Code

Claude Code 설정은 런타임에 자동 수정되므로 특수 처리.

| 파일 | 방식 | 이유 |
|------|------|------|
| `CLAUDE.md` | symlink | 읽기 전용 |
| `coding-rules.md` | symlink | 읽기 전용 |
| `settings.json.template` | **복사** | 런타임 수정됨 |

API 키는 `~/.claude/settings.local.json`에 보관 (gitignore).

## 수동 설정

setup.sh 실행 후 수동으로 해야 하는 것:

1. **~/.gitconfig.local 작성** — user.name, user.email 설정
2. **~/.zshrc.local 작성** — API 토큰 등 민감 정보
3. **~/.claude/settings.local.json 작성** — Claude 환경변수 (API 키)
4. **Ghostty** — 앱 실행 후 기본 터미널로 설정
5. **cmux** — 앱 실행 후 초기 설정

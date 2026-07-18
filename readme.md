# dotfiles

macOS/Windows 개발 환경 자동화 설정. 크로스플랫폼 자산은 `shared/`로 공유하고,
`Taskfile.yml` 상위 디스패처가 OS를 감지해 분기한다.

## 빠른 시작

clone 에 필요한 최소 도구(git)만 먼저 확보하면, 나머지 의존성(패키지·런타임·
앱·심링크)은 dotfiles 가 선언적으로 설치한다.

| OS | clone 전 필요 | 확보 방법 |
|----|-------------|----------|
| macOS | git | `xcode-select --install` (Xcode CLT 에 포함) |
| Windows | git, winget | winget 은 Windows 11 기본 내장, git 은 `winget install Git.Git` |

### macOS

```bash
# 1) git 확보 (Xcode Command Line Tools)
xcode-select --install

# 2) clone
git clone https://github.com/aydenden/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3) 초기 셋업 — Homebrew·패키지·런타임·심링크 자동
./setup.sh --all
```

### Windows

PowerShell 을 **관리자 권한**으로 연다(심링크 생성에 개발자 모드 또는 관리자 필요).

```powershell
# 1) git 설치 (winget, 최초 1회) — 설치 후 새 PowerShell 창을 열어 git 인식
winget install Git.Git --accept-package-agreements --accept-source-agreements

# 2) clone
git clone https://github.com/aydenden/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles

# 3) 초기 셋업 — 실행정책 우회 부트스트랩. pwsh·task·패키지·orca·심링크 자동
powershell -ExecutionPolicy Bypass -File .\windows\setup.ps1
```

> 설치 후에는 **PowerShell 7(`pwsh`)** 로 새 창을 열어 사용한다(프로파일이 pwsh
> 경로에 링크됨). 자세한 내용은 [`windows/README.md`](windows/README.md) 참고.

### 이후 운영 (공통)

최초 부트스트랩으로 `task` 가 설치된 뒤에는 OS 무관 단일 명령으로 통일된다:

```bash
task update    # pull + 패키지 + 심링크
task symlink   # 심링크만
task packages  # 패키지만
```

## 구조

```
dotfiles/
├── Taskfile.yml              # 상위 디스패처 (OS 자동 분기)
├── setup.sh                  # macOS 부트스트랩 진입점
│
├── shared/                   # OS 무관 자산 (macOS/Windows 공유)
│   ├── git/                  # gitconfig/gitignore/gitmessage/git_template
│   ├── config/
│   │   └── oh-my-posh/       # 프롬프트 테마
│   ├── claude/               # Claude Code 설정
│   └── opencode/             # OpenCode 설정
│
├── macos/                    # macOS 전용
│   ├── Brewfile              # Homebrew 패키지 (orca cask 포함)
│   ├── defaults.sh           # macOS 시스템 설정
│   ├── config/               # ghostty, cmux (Windows 미지원)
│   └── scripts/              # 설치 스크립트 (01-core ~ 99-symlinks)
│       └── lib/common.sh
│
├── windows/                  # Windows 전용
│   ├── setup.ps1             # 부트스트랩 진입점
│   ├── packages.winget       # winget 매니페스트 (orca 포함)
│   ├── profile.ps1           # PowerShell $PROFILE 로더
│   ├── links.ps1             # 심링크 생성
│   └── README.md             # Windows 매핑 근거 + 실기 검증 안내
│
├── shell/                    # Zsh 설정 (mac/linux)
│   ├── zshrc.symlink         # → ~/.zshrc (로더)
│   └── *.zsh                 # 자동 소싱 (path/aliases/exports/…)
│
├── bin/                      # 커스텀 명령어 ($PATH)
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

`shared/config/`(크로스플랫폼)와 `macos/config/`(macOS 전용)가 `~/.config/`에 심링크.

```
shared/config/oh-my-posh/ → ~/.config/oh-my-posh
macos/config/ghostty/     → ~/.config/ghostty
macos/config/cmux/        → ~/.config/cmux
```

### `.local` — 머신별 설정

`.local` 파일은 gitignore 대상. 비밀 정보나 머신별 설정 보관.

```
~/.zshrc.local          # 토큰, 프록시 등
~/.gitconfig.local      # user.name, user.email
```

모든 설정 파일 끝에서 `.local` 파일을 소싱한다.

## 사용법

### 최초 부트스트랩 (OS별)

```bash
# macOS
./setup.sh              # 대화형 모드
./setup.sh --all        # 전체 설치
./setup.sh --help       # 도움말
```

```powershell
# Windows
.\setup.ps1             # 패키지 + go-task + 심링크 + orca
```

macOS `setup.sh` 플래그:

| 플래그 | 설명 |
|--------|------|
| `--all` | 전체 설치 (+ go-task) |
| `--core` | Homebrew + Brewfile |
| `--shell` | Zsh + Sheldon |
| `--dev` | nvm(node) + 런타임 + Docker |
| `--macos` | macOS defaults 적용 |
| `--symlinks` | 심링크 설정 |

### 이후 운영 (OS 공통, Taskfile)

부트스트랩으로 `task`가 설치된 뒤에는 OS 무관하게 동일 명령을 쓴다:

| 명령 | 설명 |
|------|------|
| `task setup` | 전체 설치 (OS 자동 분기) |
| `task update` | pull + 패키지 + 심링크 |
| `task packages` | 패키지 동기화 |
| `task symlink` | 심링크만 |

(macOS 한정 `dot` 명령도 여전히 pull + brew bundle + symlink 를 수행한다.)

## 설치 항목

### CLI

| 카테고리 | 패키지 |
|----------|--------|
| Shell | zsh, sheldon, oh-my-posh |
| 현대적 CLI | ripgrep, fzf, fd, bat, eza, jq, tree, wget, htop |
| Git | git, lazygit, gitui, git-delta, bfg |
| 런타임 | nvm, deno, bun, go, rustup, uv |
| 에디터/LSP | marksman, rust-analyzer, ast-grep |
| 컨테이너 | docker, docker-compose, colima |
| AI/ML | ollama, lume |
| 도구 | gh, tmux, zellij, ffmpeg, code2prompt, fswatch |

### Cask

ghostty, cmux, visual-studio-code, orca

> orca(AI 코딩 에이전트 오케스트레이터)는 macOS `cask "stablyai/orca/orca"`,
> Windows 는 `setup.ps1` 이 GitHub releases 로 설치. 설치 선언만 관리한다.

## 셸 환경

**Zsh + Sheldon + oh-my-posh** 조합.

- **Sheldon**: TOML 기반 플러그인 매니저. `shell/plugins.toml`에서 관리.
- **oh-my-posh**: 크로스셸 프롬프트. `shared/config/oh-my-posh/sim-web.omp.json`에서 테마 설정. Nerd Font 는 `oh-my-posh font install meslo` 로 설치(크로스플랫폼).
- **nvm**: node 버전 관리. python 은 uv, deno 는 brew 로 관리.

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

## OpenCode

OpenCode 설정은 개별 파일 심링크 방식으로 관리. 런타임 파일(`node_modules/`, `package.json`, `.cc-opencode-*` 등)은 `~/.config/opencode/`에 남기고 버전 관리에서 제외.

| 파일 | 방식 | 이유 |
|------|------|------|
| `opencode.json` | symlink | 에이전트·MCP·권한 설정 (읽기 전용) |
| `AGENTS.md` | symlink | 글로벌 지시사항 (읽기 전용) |
| `tui.json` | symlink | TUI 설정 (플러그인 배지 포함) |
| `oh-my-opencode-slim.json` | symlink | oh-my-opencode-slim 플러그인 프리셋 |
| `opencode.json.local.example` | 참고용 | 머신별 provider/API 키 설정 예시 |

### oh-my-opencode-slim

[oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) 플러그인으로 백그라운드 멀티 에이전트 오케스트레이션 사용. `opencode-go` 프리셋 활성.

```bash
# 설치 (opencode-go 프리셋)
bunx oh-my-opencode-slim@latest install --no-tui --preset=opencode-go --skills=yes --background-subagents=yes
```

설치 후 심링크 복구 필요 (설치 관리자가 심링크를 일반 파일로 교체함):

```bash
./setup.sh --symlinks
```

머신별 설정이 필요한 경우:

```bash
cp opencode/opencode.json.local.example ~/.config/opencode/opencode.local.json
# 편집 후 export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.local.json"
```

외부 스킬(CuaDriver, llm-wiki)은 소스가 존재할 때만 자동 링크.

## 수동 설정

setup.sh 실행 후 수동으로 해야 하는 것:

1. **~/.gitconfig.local 작성** — user.name, user.email 설정
2. **~/.zshrc.local 작성** — API 토큰 등 민감 정보
3. **~/.claude/settings.local.json 작성** — Claude 환경변수 (API 키)
4. **~/.config/opencode/opencode.local.json 작성** — OpenCode 머신별 provider 설정 (필요시)
5. **Ghostty** — 앱 실행 후 기본 터미널로 설정
6. **cmux** — 앱 실행 후 초기 설정

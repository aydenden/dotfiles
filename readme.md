# dotfiles

macOS 개발 환경 자동화 설정

## 사전 준비

```bash
# Xcode Command Line Tools 설치
xcode-select --install
```

App Store 앱 설치를 위해 **App Store 로그인** 필요 (mas 사용 시)

## 빠른 시작

```bash
git clone https://github.com/aydenden/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## 사용법

```bash
./setup.sh              # 대화형 모드
./setup.sh --all        # 전체 설치
./setup.sh --help       # 도움말
```

| 플래그 | 설명 |
|--------|------|
| `--all` | 전체 설치 |
| `--core` | Homebrew + 필수 패키지 |
| `--shell` | Zsh + Oh My Zsh + Powerlevel10k |
| `--node` | NVM + Node.js |
| `--docker` | OrbStack |
| `--symlinks` | 설정 파일 심링크 |

## 프로젝트 구조

```
dotfiles/
├── setup.sh              # 메인 진입점
├── Brewfile              # Homebrew 패키지 목록
├── scripts/
│   ├── 01-core.sh        # Homebrew 설치
│   ├── 02-shell.sh       # Zsh 환경 설정
│   ├── 03-dev-node.sh    # Node.js 환경
│   ├── 04-dev-docker.sh  # Docker (OrbStack)
│   ├── 99-symlinks.sh    # 심링크 관리
│   └── lib/common.sh     # 공통 유틸리티
└── .config/
    ├── .zshrc            # Zsh 설정
    ├── .p10k.zsh         # Powerlevel10k 테마
    ├── .finicky.js       # URL 라우팅
    └── itermProfile.json # iTerm2 프로필
```

## 설치 항목

**CLI 도구**
- git, tree, wget, mas, deno, nvm

**Apps (Cask)**
- iTerm2, Visual Studio Code, JetBrains Toolbox, OrbStack, Finicky

**Shell 환경**
- Zsh, Oh My Zsh, Powerlevel10k, zsh-syntax-highlighting

**폰트**
- D2Coding

## 수동 설정

### Powerlevel10k 폰트

[MesloLGS NF 폰트 다운로드](https://github.com/romkatv/powerlevel10k#fonts) 후 설치

### iTerm2 설정

1. Preferences → Profiles → Text
2. Font를 **MesloLGS NF**로 변경

### OrbStack

설치 후 앱 실행하여 초기 설정 완료

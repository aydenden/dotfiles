# Windows 지원

macOS dotfiles의 크로스플랫폼 자산(`shared/`)을 Windows 네이티브 환경에서 재사용한다.

## 최초 설치

```powershell
git clone https://github.com/aydenden/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\setup.ps1
```

이후 모든 운영은 OS 무관 단일 명령으로 통일된다(go-task 필요):

```powershell
task update    # pull + 패키지 + 심링크
task symlink   # 심링크만
task packages  # 패키지만
```

## 파일

| 파일 | 역할 | 대응(macOS) |
|------|------|-------------|
| `setup.ps1` | 부트스트랩 진입점 | `setup.sh` |
| `packages.winget` | winget import 매니페스트 | `macos/Brewfile` |
| `profile.ps1` | PowerShell `$PROFILE` 로더 | `shell/zshrc.symlink` |
| `links.ps1` | 심링크 생성 | `macos/scripts/99-symlinks.sh` |

## 패키지 매핑 원칙

`macos/Brewfile` 중 **크로스플랫폼 도구만** winget으로 매핑한다. 다음 macOS/Unix 전용 도구는 **의도적으로 제외**한다:

- 셸: `zsh`, `sheldon` — Windows는 PowerShell + `profile.ps1` 사용
- Unix 전용: `tmux`, `zellij`, `htop`, `fswatch`, `supervisor`, `colima`, `container`, `libpq`
- macOS 전용: `lume`, `ghostty`(→ Windows Terminal), `cmux`
- winget 미확인/tap 종속: `bfg`, `marksman`, `ast-grep`, `sccache`, `rtk`, `beads`, `code2prompt`, `agent-browser` — 필요 시 scoop 또는 수동 설치

## orca

orca는 winget 에 등록되어 있지 않다. `setup.ps1` 이 GitHub releases 의
`orca-windows-setup.exe` 를 내려받아 설치한다(macOS 는 `macos/Brewfile` 의
`cask "stablyai/orca/orca"` 로 설치). 설치 선언만 관리하며 앱 설정은 관리하지 않는다.

## ⚠️ 실기 검증 필요

이 디렉토리의 파일은 **macOS에서 구문/JSON 유효성까지만 검증**되었다. 실제 Windows 머신에서 다음을 확인해야 한다:

1. `winget import -i windows/packages.winget ...` — 모든 PackageIdentifier 해석 성공(실패 ID는 `winget search`로 정정)
2. `.\links.ps1` — 심링크 생성(개발자 모드 필요), `Get-Item $HOME\.gitconfig | Select LinkType,Target`
3. `. $PROFILE` — oh-my-posh/mise 초기화 무오류

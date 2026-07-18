# =============================================================================
# links.ps1 — Windows 심링크 생성 (macos/scripts/99-symlinks.sh 대응)
#
# 심링크 생성에는 개발자 모드 활성화 또는 관리자 권한이 필요하다.
# 사용자 대면 메시지는 영어로 둔다(Windows PowerShell 5.1 인코딩 문제 회피).
# =============================================================================
$ErrorActionPreference = "Stop"
$Dotfiles = Split-Path -Parent $PSScriptRoot

# --- 심링크 권한 확인: 관리자이거나 개발자 모드면 생성 가능 ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
$devMode = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
    -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
$devModeOn = $devMode -and $devMode.AllowDevelopmentWithoutDevLicense -eq 1
if (-not $isAdmin -and -not $devModeOn) {
    Write-Warning "Symlink creation may fail. Run as Administrator, or enable Settings > For developers > Developer Mode."
}

function Link-File {
    param([Parameter(Mandatory)] [string]$Src, [Parameter(Mandatory)] [string]$Dest)
    if (-not (Test-Path $Src)) { Write-Warning "Source not found: $Src"; return }

    # 이미 올바른 심링크면 건너뛴다(멱등 — 재실행 시 백업 누적 방지)
    $existing = Get-Item $Dest -Force -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType -eq 'SymbolicLink' -and $existing.Target -eq $Src) {
        Write-Host "Already linked: $Dest"
        return
    }

    $destDir = Split-Path -Parent $Dest
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }
    if (Test-Path $Dest) {
        $backup = "$Dest.backup"
        Write-Warning "Backing up existing file: $Dest -> $backup"
        Move-Item -Force $Dest $backup
    }
    New-Item -ItemType SymbolicLink -Path $Dest -Target $Src | Out-Null
    Write-Host "Linked: $Dest -> $Src"
}

# --- git ---
Link-File "$Dotfiles\shared\git\gitconfig.symlink"  "$HOME\.gitconfig"
Link-File "$Dotfiles\shared\git\gitignore.symlink"  "$HOME\.gitignore"
Link-File "$Dotfiles\shared\git\gitmessage.symlink" "$HOME\.gitmessage"

# --- PowerShell 프로파일 (PowerShell 7 우선, 없으면 현재 세션) ---
# 5.1(WindowsPowerShell)과 7(PowerShell)은 프로파일 경로가 다르므로,
# pwsh 가 있으면 그 프로파일 경로에 링크한다.
$psProfile = $PROFILE
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    $psProfile = (pwsh -NoProfile -Command '$PROFILE.CurrentUserCurrentHost')
}
Link-File "$Dotfiles\windows\profile.ps1" $psProfile

# --- oh-my-posh (shared 재사용) ---
Link-File "$Dotfiles\shared\config\oh-my-posh" "$HOME\.config\oh-my-posh"

# --- claude (읽기전용 파일만 링크, settings.json 은 복사본이라 제외) ---
Link-File "$Dotfiles\shared\claude\CLAUDE.md"       "$HOME\.claude\CLAUDE.md"
Link-File "$Dotfiles\shared\claude\coding-rules.md" "$HOME\.claude\coding-rules.md"

# --- opencode ---
Link-File "$Dotfiles\shared\opencode\opencode.json" "$HOME\.config\opencode\opencode.json"
Link-File "$Dotfiles\shared\opencode\AGENTS.md"     "$HOME\.config\opencode\AGENTS.md"

Write-Host "Symlinks done."

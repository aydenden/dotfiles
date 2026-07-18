# =============================================================================
# links.ps1 — Windows 심링크 생성 (macos/scripts/99-symlinks.sh 대응)
#
# 심링크 생성에는 개발자 모드 활성화 또는 관리자 권한이 필요하다.
# =============================================================================
$ErrorActionPreference = "Stop"
$Dotfiles = Split-Path -Parent $PSScriptRoot

# --- 개발자 모드 확인 ---
$devMode = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
    -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
if (-not $devMode -or $devMode.AllowDevelopmentWithoutDevLicense -ne 1) {
    Write-Warning "개발자 모드가 꺼져 있습니다. 관리자 PowerShell 로 실행하거나 '설정 > 개발자용'에서 개발자 모드를 켜세요."
}

function Link-File {
    param([Parameter(Mandatory)] [string]$Src, [Parameter(Mandatory)] [string]$Dest)
    if (-not (Test-Path $Src)) { Write-Warning "소스 없음: $Src"; return }
    $destDir = Split-Path -Parent $Dest
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }
    if (Test-Path $Dest) {
        $backup = "$Dest.backup"
        Write-Warning "기존 파일 백업: $Dest -> $backup"
        Move-Item -Force $Dest $backup
    }
    New-Item -ItemType SymbolicLink -Path $Dest -Target $Src | Out-Null
    Write-Host "링크 생성: $Dest -> $Src"
}

# --- git ---
Link-File "$Dotfiles\shared\git\gitconfig.symlink"  "$HOME\.gitconfig"
Link-File "$Dotfiles\shared\git\gitignore.symlink"  "$HOME\.gitignore"
Link-File "$Dotfiles\shared\git\gitmessage.symlink" "$HOME\.gitmessage"

# --- PowerShell 프로파일 ---
Link-File "$Dotfiles\windows\profile.ps1" $PROFILE

# --- oh-my-posh / mise (shared 재사용) ---
Link-File "$Dotfiles\shared\config\oh-my-posh" "$HOME\.config\oh-my-posh"
Link-File "$Dotfiles\shared\config\mise"       "$HOME\.config\mise"

# --- claude (읽기전용 파일만 링크, settings.json 은 복사본이라 제외) ---
Link-File "$Dotfiles\shared\claude\CLAUDE.md"       "$HOME\.claude\CLAUDE.md"
Link-File "$Dotfiles\shared\claude\coding-rules.md" "$HOME\.claude\coding-rules.md"

# --- opencode ---
Link-File "$Dotfiles\shared\opencode\opencode.json" "$HOME\.config\opencode\opencode.json"
Link-File "$Dotfiles\shared\opencode\AGENTS.md"     "$HOME\.config\opencode\AGENTS.md"

Write-Host "심링크 완료."

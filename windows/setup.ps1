# =============================================================================
# setup.ps1 — Windows 부트스트랩 (최초 실행 진입점)
#
# 하는 일: 패키지 설치 → go-task 확보 → 심링크 → git 설정.
# 이후 모든 운영은 'task update' 등 OS 무관 명령으로 통일된다.
# =============================================================================
$ErrorActionPreference = "Stop"
$Dotfiles = Split-Path -Parent $PSScriptRoot

Write-Host "==> winget 확인"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget 이 없습니다. Microsoft Store 에서 'App Installer' 를 설치하세요."
}

Write-Host "==> 패키지 설치"
winget import -i "$Dotfiles\windows\packages.winget" `
    --accept-package-agreements --accept-source-agreements

Write-Host "==> go-task 설치 (이후 운영은 'task' 로 통일)"
if (-not (Get-Command task -ErrorAction SilentlyContinue)) {
    winget install Task.Task --accept-package-agreements --accept-source-agreements
}

Write-Host "==> orca 설치 (winget 미등록 — GitHub releases)"
if (-not (Get-Command orca -ErrorAction SilentlyContinue)) {
    $orcaExe = "$env:TEMP\orca-windows-setup.exe"
    Invoke-WebRequest "https://github.com/stablyai/orca/releases/latest/download/orca-windows-setup.exe" -OutFile $orcaExe
    Start-Process -Wait $orcaExe
}

Write-Host "==> 심링크 생성"
& "$Dotfiles\windows\links.ps1"

Write-Host "==> git autocrlf 설정 (Windows 권장값)"
git config --global core.autocrlf true

Write-Host ""
Write-Host "완료! 새 PowerShell 세션을 여세요. 이후 운영은 'task update' 등으로 통일됩니다."

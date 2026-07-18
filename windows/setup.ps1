# =============================================================================
# setup.ps1 — Windows 부트스트랩 (최초 실행 진입점)
#
# 하는 일: 패키지 설치(pwsh·task 등 packages.winget 전체) → orca → 심링크 → git.
# 이후 모든 운영은 'task update' 등 OS 무관 명령으로 통일된다.
#
# 참고: 사용자 대면 메시지는 영어로 둔다 — Windows PowerShell 5.1 은 BOM 없는
# UTF-8 을 코드페이지로 읽어 한글 리터럴이 깨지기 때문(주석은 파싱에 무관).
# =============================================================================
$ErrorActionPreference = "Stop"
$Dotfiles = Split-Path -Parent $PSScriptRoot

# 실행 정책 설정은 실패해도 부트스트랩을 막지 않는다(이미 Bypass 로 실행 중).
Write-Host "==> Set execution policy (CurrentUser RemoteSigned)"
try {
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -ErrorAction Stop
} catch {
    Write-Warning "Could not set CurrentUser execution policy: $($_.Exception.Message)"
    Write-Warning "If profile loading is blocked later, run: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned"
}

Write-Host "==> Check winget"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Install 'App Installer' from the Microsoft Store."
}

Write-Host "==> Install packages (pwsh, task, ... from packages.winget)"
winget import -i "$Dotfiles\windows\packages.winget" `
    --accept-package-agreements --accept-source-agreements

Write-Host "==> Install orca (not on winget - GitHub releases)"
if (-not (Get-Command orca -ErrorAction SilentlyContinue)) {
    $orcaExe = "$env:TEMP\orca-windows-setup.exe"
    Invoke-WebRequest "https://github.com/stablyai/orca/releases/latest/download/orca-windows-setup.exe" -OutFile $orcaExe
    Start-Process -Wait $orcaExe
}

Write-Host "==> Create symlinks"
& "$Dotfiles\windows\links.ps1"

Write-Host "==> Set git autocrlf (Windows)"
git config --global core.autocrlf true

Write-Host ""
Write-Host "Done. Open a new PowerShell 7 (pwsh) session. Use 'task update' for ongoing operations."

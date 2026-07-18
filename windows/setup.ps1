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

Write-Host "==> Install Raycast (Microsoft Store app - name search, not in community winget)"
winget install raycast --accept-package-agreements --accept-source-agreements

Write-Host "==> Install Nerd Font via oh-my-posh (cross-platform)"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh font install meslo
} else {
    Write-Warning "oh-my-posh not on PATH yet. In a new session run: oh-my-posh font install meslo"
}

Write-Host "==> Install orca (not on winget - GitHub releases)"
# orca 는 GUI 앱이라 CLI 를 PATH 에 등록하지 않으므로 Get-Command 로는 판단 불가.
# 설치 프로그램 목록(Uninstall 레지스트리)에서 존재를 확인한다.
$orcaInstalled = Get-ItemProperty `
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
    -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Orca' }
if (-not $orcaInstalled) {
    $orcaExe = "$env:TEMP\orca-windows-setup.exe"
    Invoke-WebRequest "https://github.com/stablyai/orca/releases/latest/download/orca-windows-setup.exe" -OutFile $orcaExe
    Start-Process -Wait $orcaExe
} else {
    Write-Host "orca already installed - skipping"
}

Write-Host "==> Create symlinks"
& "$Dotfiles\windows\links.ps1"

# --global 은 심링크된 ~/.gitconfig(=shared/git/gitconfig.symlink)를 직접 수정하므로
# 절대 쓰지 않는다. 대신 심링크가 아닌 로컬 오버라이드 파일에 기록한다
# (gitconfig.symlink 의 [include] path=~/.gitconfig.local 이 이를 우선 적용).
Write-Host "==> Set git autocrlf in ~/.gitconfig.local (Windows)"
git config --file "$HOME\.gitconfig.local" core.autocrlf true

Write-Host ""
Write-Host "Done. Open a new PowerShell 7 (pwsh) session. Use 'task update' for ongoing operations."

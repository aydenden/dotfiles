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

# 설치 프로그램이 레지스트리에 쓴 PATH/환경변수를 현재 세션에 다시 로드한다.
# PowerShell 프로세스는 시작 시점의 환경을 복사해 들고 있어, winget 이 방금 바꾼
# 값을 새 세션 없이는 못 본다(bash 의 'source' 에 해당하는 재로드).
function Sync-Environment {
    foreach ($v in 'NVM_HOME', 'NVM_SYMLINK') {
        $val = [Environment]::GetEnvironmentVariable($v, 'User')
        if (-not $val) { $val = [Environment]::GetEnvironmentVariable($v, 'Machine') }
        if ($val) { Set-Item -Path "env:$v" -Value $val }
    }
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User')
}

Write-Host "==> Install node LTS via nvm (winget installs the nvm manager only)"
# NVMforWindows 는 nvm.exe 만 깔고 node/npm 본체는 'nvm install' 이 설치한다
# (macOS 03-dev.sh 의 'nvm install --lts' 와 동일 역할).
Sync-Environment
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    nvm install lts
    nvm use lts
    Sync-Environment   # nvm use 가 활성화한 node 심링크 경로를 현재 세션에 반영
} else {
    Write-Warning "nvm not on PATH yet. In a new session run: nvm install lts; nvm use lts"
}

Write-Host "==> Install Raycast (Microsoft Store app; not in community winget)"
# msstore 는 환경에 따라 인증서 피닝 오류(0x8a15005e)가 날 수 있다. 첫 시도가
# 실패할 때만 조건부로 피닝을 우회하고 재시도한다(무조건 끄지 않는다).
$raycastId = "9pfxxshc64h3"
function Install-Raycast {
    winget install --id $raycastId --source msstore --exact `
        --accept-package-agreements --accept-source-agreements
    return $LASTEXITCODE
}
Install-Raycast | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Warning "msstore 설치 실패(인증서 피닝 0x8a15005e 추정). 피닝 우회 후 재시도..."
    winget settings --enable BypassCertificatePinningForMicrosoftStore
    winget source reset --force 2>$null
    Install-Raycast | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Raycast 설치가 여전히 실패합니다. 재부팅 후 setup.ps1 을 다시 실행하거나,"
        Write-Warning "Microsoft Store 에서 수동 설치하세요(선택 항목이므로 부트스트랩은 계속됩니다)."
    }
}

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

Write-Host "==> Install agent-browser (not on winget - npm global)"
# agent-browser 는 winget/scoop 패키지가 없다. 공식 권장 방식인 npm 글로벌 설치로
# 네이티브 Rust 바이너리를 받는다(node 는 위 'nvm install lts' 단계에서 선설치됨).
# Chrome for Testing 은 최초 1회 'agent-browser install' 로 별도 다운로드한다.
if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install -g agent-browser
    Write-Host "agent-browser installed. Run once to fetch Chrome: agent-browser install"
} else {
    Write-Warning "npm not on PATH yet. In a new session run: npm install -g agent-browser; agent-browser install"
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

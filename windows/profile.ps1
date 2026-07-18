# =============================================================================
# profile.ps1 — PowerShell 프로파일 로더 (shell/zshrc.symlink 대응)
#
# links.ps1 이 이 파일을 $PROFILE 에 심링크한다.
# 크로스플랫폼 도구(oh-my-posh, mise)만 이식하며, zsh 전용(sheldon,
# ghostty integration, opencode-memory 래퍼)은 제외한다.
# =============================================================================

$Dotfiles = "$HOME\dotfiles"

# --- oh-my-posh 프롬프트 (테마는 shared/ 재사용) ---
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$Dotfiles\shared\config\oh-my-posh\sim-web.omp.json" | Invoke-Expression
}

# --- mise 런타임 ---
if (Get-Command mise -ErrorAction SilentlyContinue) {
    mise activate pwsh | Out-String | Invoke-Expression
}

# --- 머신별 로컬 설정 (마지막) ---
$LocalProfile = "$HOME\.config\powershell\profile.local.ps1"
if (Test-Path $LocalProfile) { . $LocalProfile }

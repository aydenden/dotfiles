#!/bin/bash

echo "=== Atlassian CLI 설치 확인 ==="
echo ""

if command -v acli &> /dev/null; then
    echo "✅ Atlassian CLI 설치됨"
    echo ""
    echo "버전 정보:"
    acli version
    echo ""
    echo "인증 상태:"
    acli auth status 2>&1 || echo "⚠️  인증이 필요합니다. 'acli auth login' 실행하세요."
else
    echo "❌ Atlassian CLI가 설치되지 않았습니다."
    echo ""
    echo "설치 방법:"
    echo ""

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "=== macOS ==="
        echo ""
        echo "Homebrew (권장):"
        echo "  brew tap atlassian/homebrew-acli"
        echo "  brew install acli"
        echo ""

        if [[ $(uname -m) == "arm64" ]]; then
            echo "직접 다운로드 (Apple Silicon):"
            echo "  curl -L -o acli https://acli.atlassian.com/macos/latest/acli_darwin_arm64/acli"
        else
            echo "직접 다운로드 (Intel):"
            echo "  curl -L -o acli https://acli.atlassian.com/macos/latest/acli_darwin_amd64/acli"
        fi
        echo "  chmod +x acli"
        echo "  sudo mv acli /usr/local/bin/"

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "=== Linux ==="
        echo "  curl -L -o acli https://acli.atlassian.com/linux/latest/acli_linux_amd64/acli"
        echo "  chmod +x acli"
        echo "  sudo mv acli /usr/local/bin/"

    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "=== Windows (PowerShell) ==="
        echo '  Invoke-WebRequest -Uri https://acli.atlassian.com/windows/latest/acli_windows_amd64/acli.exe -OutFile acli.exe'
        echo '  Move-Item -Path acli.exe -Destination "$env:USERPROFILE\bin\acli.exe"'
    fi

    echo ""
    echo "설치 후 인증:"
    echo "  acli auth login"
    echo ""
    echo "또는 환경 변수 설정 (.claude/settings.local.json):"
    echo '  {'
    echo '    "env": {'
    echo '      "ATLASSIAN_SITE": "your-company.atlassian.net",'
    echo '      "ATLASSIAN_API_TOKEN": "your-api-token"'
    echo '    }'
    echo '  }'
fi

echo ""

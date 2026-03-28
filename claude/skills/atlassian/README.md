# Atlassian Skill

공식 Atlassian CLI (ACLI)를 사용하여 Jira를 관리하는 Claude Code Skill입니다.

**⚠️ 주의**: 현재 ACLI v1.3.5는 Jira만 지원합니다. Confluence는 지원되지 않습니다.

## 설치 상태 확인

```bash
./check-install.sh
```

## CLI 설치 (선택사항)

Skill은 CLI 설치 없이도 안내를 제공하지만, 실제 사용하려면 설치가 필요합니다.

### macOS

```bash
# Homebrew
brew tap atlassian/homebrew-acli
brew install acli

# 또는 직접 다운로드
curl -L -o acli https://acli.atlassian.com/macos/latest/acli_darwin_arm64/acli
chmod +x acli
sudo mv acli /usr/local/bin/
```

### 인증

```bash
acli jira auth login --web
```

또는 환경 변수:

```json
// .claude/settings.local.json
{
  "env": {
    "ATLASSIAN_SITE": "your-company.atlassian.net",
    "ATLASSIAN_API_TOKEN": "your-api-token"
  }
}
```

## 사용 예시

Skill이 활성화되면 자연어로 요청할 수 있습니다:

```
"PROJ-123 이슈 내용 보여줘"
"진행 중인 내 이슈 목록 가져와"
"새로운 버그 이슈 생성해줘"
"프로젝트 목록 보여줘"
```

Claude가 자동으로 적절한 `acli` 명령어를 실행합니다.

## MCP 대체

이 Skill을 사용하면 Atlassian MCP를 비활성화할 수 있습니다:

```json
// .claude/settings.local.json
{
  "disabledMcpjsonServers": ["atlassian"]
}
```

**예상 토큰 절약:**
- Before: ~20,000 토큰 (MCP 초기화)
- After: ~100 토큰 (Skill 로드)
- **절약: ~19,900 토큰**

## 구조

```
atlassian/
├── SKILL.md           # Skill 정의 및 사용법
├── check-install.sh   # 설치 확인 스크립트
└── README.md          # 이 파일
```

## 참고

- 공식 문서: https://developer.atlassian.com/cloud/acli/
- API 토큰: https://id.atlassian.com/manage-profile/security/api-tokens

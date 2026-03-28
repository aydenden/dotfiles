# ACLI 설치 및 인증 가이드

## 설치

### 설치 확인

먼저 ACLI가 설치되어 있는지 확인:

```bash
which acli
acli --version
```

### 설치 방법

#### macOS (Homebrew - 권장)

```bash
brew tap atlassian/homebrew-acli
brew install acli
```

설치 확인:
```bash
acli --version
```

#### macOS (직접 다운로드 - Intel)

```bash
curl -L -o acli https://acli.atlassian.com/macos/latest/acli_darwin_amd64/acli
chmod +x acli
sudo mv acli /usr/local/bin/
```

#### macOS (직접 다운로드 - Apple Silicon)

```bash
curl -L -o acli https://acli.atlassian.com/macos/latest/acli_darwin_arm64/acli
chmod +x acli
sudo mv acli /usr/local/bin/
```

#### Linux

```bash
curl -L -o acli https://acli.atlassian.com/linux/latest/acli_linux_amd64/acli
chmod +x acli
sudo mv acli /usr/local/bin/
```

#### Windows (PowerShell)

```powershell
Invoke-WebRequest -Uri https://acli.atlassian.com/windows/latest/acli_windows_amd64/acli.exe -OutFile acli.exe
Move-Item -Path acli.exe -Destination "$env:USERPROFILE\bin\acli.exe"
```

**참고**: Windows의 경우 `$env:USERPROFILE\bin`을 PATH에 추가해야 합니다.

### 업데이트

#### Homebrew 사용 시
```bash
brew upgrade acli
```

#### 직접 다운로드 사용 시
```bash
# 최신 버전 다운로드 후 기존 파일 덮어쓰기
curl -L -o /usr/local/bin/acli https://acli.atlassian.com/macos/latest/acli_darwin_arm64/acli
chmod +x /usr/local/bin/acli
```

## 인증

### 방법 1: 웹 브라우저 인증 (OAuth) - 권장

가장 간편한 방법입니다:

```bash
acli jira auth login --web
```

이 명령을 실행하면:
1. 웹 브라우저가 자동으로 열립니다
2. Atlassian 계정으로 로그인
3. ACLI 접근 권한 승인
4. 자동으로 인증 완료

### 방법 2: API 토큰 사용

더 세밀한 제어가 필요한 경우:

#### Step 1: API 토큰 생성

1. https://id.atlassian.com/manage-profile/security/api-tokens 접속
2. "Create API token" 클릭
3. 토큰 이름 입력 (예: "ACLI")
4. 생성된 토큰 복사 (⚠️ 한 번만 표시됩니다)

#### Step 2: ACLI 인증

```bash
acli jira auth login \
  --site "your-company.atlassian.net" \
  --email "user@example.com" \
  --token
```

프롬프트가 나타나면 복사한 API 토큰을 붙여넣습니다.

#### Step 3: 인증 확인

```bash
acli jira auth status
```

### 방법 3: 환경 변수 사용 (CI/CD)

CI/CD 파이프라인이나 자동화 스크립트에서 사용:

```bash
export ATLASSIAN_SITE="your-company.atlassian.net"
export ATLASSIAN_EMAIL="user@example.com"
export ATLASSIAN_API_TOKEN="your-api-token"

acli jira project list
```

또는 `.claude/settings.local.json`에 추가:

```json
{
  "env": {
    "ATLASSIAN_SITE": "your-company.atlassian.net",
    "ATLASSIAN_EMAIL": "user@example.com",
    "ATLASSIAN_API_TOKEN": "your-api-token"
  }
}
```

**⚠️ 주의**:
- API 토큰은 민감 정보입니다
- 저장소에 커밋하지 마세요
- `.gitignore`에 `settings.local.json` 추가 필수

### 방법 4: 파일에서 토큰 읽기

보안을 위해 토큰을 파일에 저장하고 읽어올 수 있습니다:

```bash
# 토큰을 안전한 파일에 저장
echo "your-api-token" > ~/.acli-token
chmod 600 ~/.acli-token

# 파일에서 토큰 읽어 인증
cat ~/.acli-token | acli jira auth login \
  --site "your-company.atlassian.net" \
  --email "user@example.com" \
  --token
```

## 인증 관리

### 인증 상태 확인

```bash
acli jira auth status
```

출력 예시:
```
✓ Authenticated
  Site: ndotlight.atlassian.net
  Email: user@example.com
  Token: ************************
  Authentication Type: oauth
```

### 계정 전환

여러 Atlassian 계정을 사용하는 경우:

```bash
acli jira auth switch
```

대화형 메뉴에서 계정 선택 가능

### 로그아웃

```bash
acli jira auth logout
```

특정 계정만 로그아웃:
```bash
acli jira auth logout --email "user@example.com"
```

모든 계정 로그아웃:
```bash
acli jira auth logout --all
```

## 관리자 인증 (선택사항)

조직 관리 작업이 필요한 경우:

```bash
acli admin auth login --web
```

관리자 인증 상태 확인:
```bash
acli admin auth status
```

## 문제 해결

### 인증 문제

#### "unauthorized" 에러
```bash
# 인증 상태 확인
acli jira auth status

# 재인증
acli jira auth logout
acli jira auth login --web
```

#### "forbidden" 에러
- 사용자 권한이 부족한 경우
- Jira 관리자에게 권한 요청 필요

#### "timeout" 에러
```bash
# 네트워크 연결 확인
ping your-company.atlassian.net

# 프록시 설정 (필요한 경우)
export HTTP_PROXY="http://proxy.company.com:8080"
export HTTPS_PROXY="http://proxy.company.com:8080"
```

### API 토큰 문제

#### 토큰이 만료되었거나 취소된 경우
1. https://id.atlassian.com/manage-profile/security/api-tokens 에서 새 토큰 생성
2. 기존 토큰 삭제 (선택사항)
3. 새 토큰으로 재인증

#### 토큰을 잊어버린 경우
- API 토큰은 한 번만 표시되므로 다시 확인 불가
- 새 토큰을 생성해야 합니다

### 연결 테스트

인증이 제대로 되었는지 간단한 명령으로 테스트:

```bash
# 프로젝트 목록 조회 (권한이 있는 경우)
acli jira project list --limit 1

# 내 이슈 조회
acli jira workitem search --jql "assignee = currentUser()" --limit 1
```

### 로그 확인

문제 진단을 위한 상세 로그:

```bash
# 디버그 모드로 실행
ACLI_DEBUG=1 acli jira auth status

# 로그 파일 위치
# macOS/Linux: ~/.acli/logs/
# Windows: %USERPROFILE%\.acli\logs\
```

## 보안 모범 사례

### API 토큰 관리

1. **정기적으로 토큰 교체**: 3-6개월마다 새 토큰 생성
2. **최소 권한 원칙**: 필요한 권한만 부여
3. **토큰 저장 위치**: 안전한 위치에 저장 (예: ~/.acli-token, chmod 600)
4. **저장소 제외**: .gitignore에 토큰 파일 추가

### 다중 계정 관리

```bash
# 계정별 별칭 설정
alias acli-work="acli jira auth switch && acli jira --site work.atlassian.net"
alias acli-personal="acli jira auth switch && acli jira --site personal.atlassian.net"
```

### CI/CD 환경

```yaml
# GitHub Actions 예시
- name: Authenticate ACLI
  env:
    ATLASSIAN_SITE: ${{ secrets.ATLASSIAN_SITE }}
    ATLASSIAN_EMAIL: ${{ secrets.ATLASSIAN_EMAIL }}
    ATLASSIAN_API_TOKEN: ${{ secrets.ATLASSIAN_API_TOKEN }}
  run: |
    acli jira auth status || echo "Authentication configured via environment"
```

**GitHub Secrets 설정**:
1. Repository Settings → Secrets and variables → Actions
2. New repository secret 클릭
3. `ATLASSIAN_API_TOKEN` 등록

## 참고 자료

- **공식 문서**: https://developer.atlassian.com/cloud/acli/
- **API 토큰 관리**: https://id.atlassian.com/manage-profile/security/api-tokens
- **Atlassian 계정 설정**: https://id.atlassian.com/manage-profile/security
- **GitHub**: https://github.com/atlassian/cli
- **피드백 제출**: `acli feedback`

## 빠른 참조

```bash
# 설치
brew install acli

# 인증 (간편)
acli jira auth login --web

# 인증 확인
acli jira auth status

# 계정 전환
acli jira auth switch

# 로그아웃
acli jira auth logout

# 연결 테스트
acli jira project list --limit 1

# 도움말
acli jira auth --help
```

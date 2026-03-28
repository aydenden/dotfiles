# ACLI 전체 명령어 레퍼런스

이 문서는 Atlassian CLI의 전체 명령어를 포함합니다.

## Work Item (이슈) 관리

### 조회

```bash
# 기본 조회
acli jira workitem view KEY-123

# 특정 필드만 조회
acli jira workitem view KEY-123 --fields "summary,status,assignee,description"

# 모든 필드 조회
acli jira workitem view KEY-123 --fields "*all"

# JSON 출력
acli jira workitem view KEY-123 --json

# 웹 브라우저에서 열기
acli jira workitem view KEY-123 --web
```

### 검색

```bash
# JQL 검색
acli jira workitem search --jql "project = PROJ"

# 현재 사용자에게 할당된 미완료 이슈
acli jira workitem search --jql "assignee = currentUser() AND status != Done"

# 특정 필드만 표시
acli jira workitem search \
  --jql "project = PROJ" \
  --fields "key,summary,assignee,status"

# 결과 개수 제한
acli jira workitem search --jql "project = PROJ" --limit 50

# 모든 결과 가져오기 (페이징)
acli jira workitem search --jql "project = PROJ" --paginate

# 결과 개수만 확인
acli jira workitem search --jql "project = PROJ" --count

# JSON/CSV 출력
acli jira workitem search --jql "project = PROJ" --json
acli jira workitem search --jql "project = PROJ" --csv

# 필터로 검색
acli jira workitem search --filter 10001
```

### 생성

```bash
# 기본 생성
acli jira workitem create \
  --project "PROJ" \
  --type "Task" \
  --summary "새로운 작업"

# 상세 정보 포함
acli jira workitem create \
  --project "PROJ" \
  --type "Bug" \
  --summary "버그 제목" \
  --description "상세 설명" \
  --assignee "@me" \
  --label "bug,urgent"

# 파일에서 설명 읽기
acli jira workitem create \
  --project "PROJ" \
  --type "Task" \
  --summary "Task 제목" \
  --from-file "description.txt"

# 에디터로 작성
acli jira workitem create \
  --project "PROJ" \
  --type "Task" \
  --editor

# JSON 파일로 생성
acli jira workitem create --generate-json > template.json
acli jira workitem create --from-json "workitem.json"
```

**담당자 옵션:**
- `@me`: 본인에게 할당
- `default`: 프로젝트 기본 담당자
- `user@example.com`: 특정 사용자 이메일

### 편집

```bash
# 요약 변경
acli jira workitem edit --key "KEY-123" --summary "새로운 요약"

# 설명 변경
acli jira workitem edit --key "KEY-123" --description "새로운 설명"

# 담당자 변경
acli jira workitem edit --key "KEY-123" --assignee "user@example.com"

# 담당자 제거
acli jira workitem edit --key "KEY-123" --remove-assignee

# 레이블 추가/제거
acli jira workitem edit --key "KEY-123" --labels "label1,label2"
acli jira workitem edit --key "KEY-123" --remove-labels "oldlabel"

# 여러 이슈 일괄 편집 (키)
acli jira workitem edit --key "KEY-1,KEY-2,KEY-3" --assignee "@me"

# 여러 이슈 일괄 편집 (JQL)
acli jira workitem edit --jql "project = PROJ AND assignee is EMPTY" --assignee "@me"

# 여러 이슈 일괄 편집 (필터)
acli jira workitem edit --filter 10001 --status "Done"

# 확인 없이 실행
acli jira workitem edit --key "KEY-123" --summary "New" --yes

# 에러 무시하고 계속
acli jira workitem edit --jql "project = PROJ" --assignee "@me" --ignore-errors
```

### 상태 변경 (Transition)

```bash
# 단일 이슈
acli jira workitem transition --key "KEY-123" --status "In Progress"

# 여러 이슈 (키)
acli jira workitem transition --key "KEY-1,KEY-2" --status "Done"

# 여러 이슈 (JQL)
acli jira workitem transition --jql "project = PROJ AND status = 'To Do'" --status "In Progress"

# 확인 없이 실행
acli jira workitem transition --key "KEY-123" --status "Done" --yes
```

### 담당자 할당

```bash
# 단일 할당
acli jira workitem assign --key "KEY-123" --assignee "@me"

# 여러 이슈 할당
acli jira workitem assign --key "KEY-1,KEY-2,KEY-3" --assignee "user@example.com"

# JQL로 할당
acli jira workitem assign --jql "project = PROJ AND assignee is EMPTY" --assignee "default"

# 파일에서 이슈 키 읽기
acli jira workitem assign --from-file "issues.txt" --assignee "@me"

# 담당자 제거
acli jira workitem assign --key "KEY-123" --remove-assignee
```

### 댓글

```bash
# 댓글 조회
acli jira workitem comment list --key "KEY-123"

# 댓글 추가
acli jira workitem comment create --key "KEY-123" --body "댓글 내용"

# 파일에서 읽기
acli jira workitem comment create --key "KEY-123" --body-file "comment.txt"

# 에디터로 작성
acli jira workitem comment create --key "KEY-123" --editor

# 여러 이슈에 댓글 (JQL)
acli jira workitem comment create --jql "project = PROJ" --body "공통 댓글"

# 댓글 수정
acli jira workitem comment update --key "KEY-123" --id "comment-id" --body "수정된 내용"

# 댓글 삭제
acli jira workitem comment delete --key "KEY-123" --id "comment-id"
```

### 기타 작업

```bash
# 이슈 복제
acli jira workitem clone --key "KEY-123"

# 이슈 아카이브
acli jira workitem archive --key "KEY-123"

# 이슈 복원
acli jira workitem unarchive --key "KEY-123"

# 이슈 삭제
acli jira workitem delete --key "KEY-123"
acli jira workitem delete --key "KEY-1,KEY-2,KEY-3"
acli jira workitem delete --jql "project = OLDPROJ"
acli jira workitem delete --key "KEY-123" --yes
```

## 프로젝트 관리

```bash
# 프로젝트 목록
acli jira project list
acli jira project list --recent
acli jira project list --limit 50
acli jira project list --paginate
acli jira project list --json

# 프로젝트 상세
acli jira project view --key "PROJ"
acli jira project view --key "PROJ" --json

# 프로젝트 생성
acli jira project create --key "NEWPROJ" --name "New Project" --type "software"

# 프로젝트 업데이트
acli jira project update --key "PROJ" --name "Updated Name"

# 프로젝트 아카이브/복원
acli jira project archive --key "PROJ"
acli jira project restore --key "PROJ"

# 프로젝트 삭제
acli jira project delete --key "PROJ"
```

## 보드 관리

```bash
# 보드 검색
acli jira board search

# 보드의 스프린트 목록
acli jira board list-sprints --id "board-id"
```

## 스프린트 관리

```bash
# 스프린트의 이슈 목록
acli jira sprint list-workitems --id "sprint-id"
```

## 필터 관리

```bash
# 필터 관련 명령어는 다음으로 확인
acli jira filter --help
```

## 대시보드 관리

```bash
# 대시보드 관련 명령어는 다음으로 확인
acli jira dashboard --help
```

## 필드 관리

```bash
# 커스텀 필드 생성
acli jira field create --name "Custom Field" --type "text"

# 필드 삭제 (휴지통으로)
acli jira field delete --id "customfield_10001"

# 필드 복원
acli jira field cancel-delete --id "customfield_10001"
```

## 조직 관리자 (Admin)

```bash
# 관리자 인증
acli admin auth login --web
acli admin auth status

# 사용자 활성화
acli admin user activate --email "user@example.com"

# 사용자 비활성화
acli admin user deactivate --email "user@example.com"

# 사용자 삭제
acli admin user delete --email "user@example.com"

# 사용자 삭제 취소
acli admin user cancel-delete --email "user@example.com"
```

## Rovo Dev (Beta)

```bash
# Rovo Dev 도움말
acli rovodev --help

# Rovo Dev 인증
acli rovodev auth login

# Rovo Dev 실행
acli rovodev run
```

## 공통 옵션

```bash
--json          # JSON 출력
--csv           # CSV 출력 (search만)
--yes           # 확인 없이 실행
--ignore-errors # 에러 무시하고 계속
--help          # 도움말
--web           # 웹 브라우저에서 열기
```

## 도움말

```bash
acli --help
acli jira --help
acli jira workitem --help
acli jira workitem view --help
acli feedback
```

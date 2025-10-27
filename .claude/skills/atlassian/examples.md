# ACLI 실전 예제 및 사용 패턴

## JQL (Jira Query Language) 예제

### 기본 필터

```jql
# 프로젝트 필터
project = SF

# 여러 프로젝트
project in (SF, PROJ, DEV)

# 담당자 필터
assignee = currentUser()
assignee = "ayden@ndotlight.com"
assignee is EMPTY
assignee was currentUser()

# 상태 필터
status = "In Progress"
status != Done
status in ("To Do", "In Progress")
status changed to "Done" during (startOfWeek(), endOfWeek())

# 우선순위
priority = High
priority in (Highest, High)
```

### 날짜 필터

```jql
# 최근 7일간 생성된 이슈
created >= -7d

# 이번 주에 생성된 이슈
created >= startOfWeek()

# 오늘 업데이트된 이슈
updated >= startOfDay()

# 특정 기간
created >= "2024-01-01" AND created <= "2024-01-31"

# 마감일이 다가오는 이슈
due >= now() AND due <= 7d

# 마감일이 지난 이슈
due < now() AND status != Done
```

### 텍스트 검색

```jql
# 요약에 특정 단어 포함
summary ~ "bug"

# 설명에 특정 단어 포함
description ~ "error"

# 조합
summary ~ "bug" OR description ~ "error"

# 정확한 매칭
summary = "정확한 제목"
```

### 고급 필터

```jql
# 담당자가 없고 우선순위가 높은 이슈
project = SF AND assignee is EMPTY AND priority = High

# 이번 주에 생성되고 아직 완료되지 않은 내 이슈
project = SF AND assignee = currentUser() AND created >= startOfWeek() AND status != Done

# 특정 레이블이 있는 이슈
labels = "urgent"
labels in ("urgent", "critical")

# 특정 컴포넌트
component = "Frontend"

# 특정 버전
fixVersion = "1.0.0"

# 코멘트가 있는 이슈
comment ~ "검토 필요"
```

### 정렬

```jql
# 최근 생성된 순서
project = SF ORDER BY created DESC

# 우선순위가 높은 순서
project = SF ORDER BY priority DESC, created DESC

# 마감일이 임박한 순서
project = SF ORDER BY due ASC
```

### 함수 활용

```jql
# 현재 스프린트의 이슈
sprint in openSprints()

# 미완료 스프린트의 이슈
sprint in futureSprints()

# 완료된 스프린트의 이슈
sprint in closedSprints()

# 에픽에 속한 이슈
"Epic Link" = "SF-100"

# 하위 이슈가 있는 이슈
issueFunction in hasSubtasks()

# 하위 이슈
parent = "SF-100"
```

## 실전 사용 패턴

### 1. 내 작업 관리

```bash
# 오늘 해야 할 작업
acli jira workitem search --jql "assignee = currentUser() AND status = 'In Progress'"

# 내가 할당받았지만 시작하지 않은 작업
acli jira workitem search --jql "assignee = currentUser() AND status = 'To Do'"

# 내가 보고한 버그
acli jira workitem search --jql "reporter = currentUser() AND type = Bug"

# 이번 주 완료한 작업
acli jira workitem search --jql "assignee = currentUser() AND status changed to Done during (startOfWeek(), endOfWeek())"
```

### 2. 팀 작업 관리

```bash
# 할당되지 않은 이슈 조회
acli jira workitem search --jql "project = SF AND assignee is EMPTY"

# 할당되지 않은 높은 우선순위 이슈를 본인에게 할당
acli jira workitem assign \
  --jql "project = SF AND assignee is EMPTY AND priority = High" \
  --assignee "@me"

# 특정 상태의 이슈를 다음 상태로 일괄 변경
acli jira workitem transition \
  --jql "project = SF AND status = 'Code Review' AND reviewer = currentUser()" \
  --status "Done" \
  --yes
```

### 3. 배치 작업

#### 특정 범위의 이슈 상태 변경
```bash
for i in {101..110}; do
  acli jira workitem transition --key "SF-$i" --status "Done" --yes
done
```

#### CSV로 내보내기
```bash
# 기본 CSV 내보내기
acli jira workitem search --jql "project = SF" --csv > issues.csv

# 특정 필드만 내보내기
acli jira workitem search \
  --jql "project = SF" \
  --fields "key,summary,status,assignee,priority" \
  --csv > issues.csv
```

#### JSON 데이터 처리 (jq 사용)
```bash
# 이슈 키와 요약만 추출
acli jira workitem search --jql "project = SF" --json | \
  jq -r '.[] | "\(.key): \(.fields.summary)"'

# 특정 조건 필터링
acli jira workitem search --jql "project = SF" --json | \
  jq '.[] | select(.fields.priority.name == "High")'

# 통계 생성 (상태별 개수)
acli jira workitem search --jql "project = SF" --json | \
  jq -r '.[].fields.status.name' | sort | uniq -c
```

### 4. 보고서 생성

#### 주간 완료 작업 리포트
```bash
echo "=== 주간 완료 작업 ==="
acli jira workitem search \
  --jql "assignee = currentUser() AND status changed to Done during (startOfWeek(), endOfWeek())" \
  --fields "key,summary,status"
```

#### 프로젝트 진행률
```bash
# 전체 이슈 개수
total=$(acli jira workitem search --jql "project = SF" --count)

# 완료된 이슈 개수
done=$(acli jira workitem search --jql "project = SF AND status = Done" --count)

# 진행률 계산
echo "진행률: $((done * 100 / total))% ($done/$total)"
```

#### 마감일 임박 이슈 알림
```bash
echo "=== 마감일 임박 이슈 (7일 이내) ==="
acli jira workitem search \
  --jql "assignee = currentUser() AND due >= now() AND due <= 7d AND status != Done" \
  --fields "key,summary,due"
```

### 5. 대량 편집

#### 여러 이슈에 레이블 추가
```bash
acli jira workitem edit \
  --jql "project = SF AND created >= -7d" \
  --labels "new-feature" \
  --yes
```

#### 특정 조건의 이슈에 댓글 추가
```bash
acli jira workitem comment create \
  --jql "project = SF AND status = 'In Review'" \
  --body "리뷰 기한: $(date -v+3d +'%Y-%m-%d')" \
  --yes
```

#### 파일에서 이슈 목록 읽어서 처리
```bash
# issues.txt 파일에 이슈 키 목록이 있을 때
cat issues.txt | while read key; do
  acli jira workitem transition --key "$key" --status "Done" --yes
done
```

### 6. 스프린트 관리

```bash
# 현재 스프린트의 미완료 이슈
acli jira workitem search --jql "sprint in openSprints() AND status != Done"

# 현재 스프린트의 완료율
total=$(acli jira workitem search --jql "sprint in openSprints()" --count)
done=$(acli jira workitem search --jql "sprint in openSprints() AND status = Done" --count)
echo "스프린트 진행률: $((done * 100 / total))%"
```

### 7. 자동화 스크립트 예제

#### 아침 브리핑 스크립트
```bash
#!/bin/bash

echo "======================================="
echo "       오늘의 Jira 작업 브리핑"
echo "======================================="
echo ""

echo "📋 진행 중인 작업:"
acli jira workitem search \
  --jql "assignee = currentUser() AND status = 'In Progress'" \
  --fields "key,summary"

echo ""
echo "⏰ 마감일 임박 (7일 이내):"
acli jira workitem search \
  --jql "assignee = currentUser() AND due >= now() AND due <= 7d AND status != Done" \
  --fields "key,summary,due"

echo ""
echo "🆕 새로 할당된 작업:"
acli jira workitem search \
  --jql "assignee = currentUser() AND status = 'To Do' AND created >= -1d" \
  --fields "key,summary,priority"
```

#### 주간 리포트 생성
```bash
#!/bin/bash

REPORT_FILE="weekly_report_$(date +'%Y%m%d').csv"

echo "주간 리포트 생성 중..."

acli jira workitem search \
  --jql "assignee = currentUser() AND updated >= startOfWeek()" \
  --fields "key,summary,status,updated" \
  --csv > "$REPORT_FILE"

echo "리포트 생성 완료: $REPORT_FILE"
```

## 유용한 쉘 함수

```bash
# ~/.bashrc 또는 ~/.zshrc에 추가

# 내 작업 빠르게 조회
alias jira-my="acli jira workitem search --jql 'assignee = currentUser() AND status != Done'"

# 이슈 빠르게 열기
jira-open() {
  acli jira workitem view "$1" --web
}

# 이슈 빠르게 진행 중으로 변경
jira-start() {
  acli jira workitem transition --key "$1" --status "In Progress" --yes
}

# 이슈 빠르게 완료 처리
jira-done() {
  acli jira workitem transition --key "$1" --status "Done" --yes
}

# 프로젝트 통계 조회
jira-stats() {
  local project=$1
  echo "=== $project 통계 ==="
  echo "전체: $(acli jira workitem search --jql "project = $project" --count)"
  echo "완료: $(acli jira workitem search --jql "project = $project AND status = Done" --count)"
  echo "진행: $(acli jira workitem search --jql "project = $project AND status = 'In Progress'" --count)"
  echo "대기: $(acli jira workitem search --jql "project = $project AND status = 'To Do'" --count)"
}
```

## 환경별 설정

### 개발 환경
```bash
export JIRA_PROJECT="DEV"
alias jira-dev="acli jira workitem search --jql 'project = DEV AND assignee = currentUser()'"
```

### 프로덕션 환경
```bash
export JIRA_PROJECT="PROD"
alias jira-prod="acli jira workitem search --jql 'project = PROD AND assignee = currentUser()'"
```

## 문제 해결 팁

### 대량 작업 시 Rate Limit 회피
```bash
# 각 요청 사이에 1초 대기
for i in {1..100}; do
  acli jira workitem view "PROJ-$i" --json
  sleep 1
done
```

### 에러 처리
```bash
# 실패한 이슈 키 로깅
for key in SF-{1..10}; do
  if ! acli jira workitem transition --key "$key" --status "Done" --yes 2>/dev/null; then
    echo "$key" >> failed_issues.txt
  fi
done
```

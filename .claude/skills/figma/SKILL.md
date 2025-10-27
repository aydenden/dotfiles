---
name: figma
description: Figma 디자인 파일에서 정보를 가져옵니다. 파일 구조, 노드 정보, 스타일 정보를 조회할 때 사용합니다.
allowed-tools: Bash, Read, Write
---

# Figma API Skill

Figma REST API를 사용하여 디자인 파일 정보를 가져오는 스킬입니다.

## 사전 준비

환경변수 `FIGMA_TOKEN`이 설정되어 있어야 합니다:

```bash
export FIGMA_TOKEN="your-personal-access-token"
```

Personal Access Token은 Figma 계정 설정에서 발급받을 수 있습니다:
https://www.figma.com/developers/api#access-tokens

## Instructions

### 1. 파일 정보 가져오기

Figma 파일의 전체 구조와 메타데이터를 가져옵니다.

```bash
bash .claude/skills/figma/scripts/get-file.sh <FILE_KEY>
```

**파라미터:**
- `FILE_KEY`: Figma 파일 URL에서 추출한 파일 키
  - 예: `https://www.figma.com/file/ABC123/Design` → `ABC123`

**응답 정보:**
- 파일 이름, 버전, 마지막 수정 시간
- 전체 노드 트리 구조
- 컴포넌트, 스타일 정보

### 2. 노드 정보 가져오기

특정 노드(프레임, 컴포넌트 등)의 상세 정보를 가져옵니다.

```bash
bash .claude/skills/figma/scripts/get-node.sh <FILE_KEY> <NODE_IDS>
```

**파라미터:**
- `FILE_KEY`: Figma 파일 키
- `NODE_IDS`: 쉼표로 구분된 노드 ID 목록
  - 예: `202:8,303:12`

**응답 정보:**
- 노드 타입, 위치, 크기
- 스타일 속성 (색상, 타이포그래피 등)
- 자식 노드 정보

### 3. 스타일 정보 가져오기

파일의 모든 스타일(색상, 텍스트, 효과 등) 정보를 가져옵니다.

```bash
bash .claude/skills/figma/scripts/get-styles.sh <FILE_KEY>
```

**파라미터:**
- `FILE_KEY`: Figma 파일 키

**응답 정보:**
- 색상 스타일 (fills, strokes)
- 텍스트 스타일 (font, size, weight)
- 효과 스타일 (shadows, blurs)

## Examples

### 예제 1: 파일 구조 확인

```bash
# 디자인 시스템 파일의 전체 구조 확인
bash .claude/skills/figma/scripts/get-file.sh ABC123XYZ
```

### 예제 2: 버튼 컴포넌트 정보 추출

```bash
# 특정 버튼 컴포넌트의 속성 확인
bash .claude/skills/figma/scripts/get-node.sh ABC123XYZ "202:8,202:9"
```

### 예제 3: 디자인 토큰 추출

```bash
# 모든 색상/텍스트 스타일을 가져와서 디자인 토큰으로 변환
bash .claude/skills/figma/scripts/get-styles.sh ABC123XYZ
```

## 주의사항

- API 요청은 rate limit이 적용됩니다 (분당 100 요청)
- 큰 파일의 경우 응답 시간이 오래 걸릴 수 있습니다
- 유효한 FIGMA_TOKEN이 필요합니다
- `jq` 명령어가 설치되어 있어야 합니다 (JSON 포맷팅용)
  - macOS: `brew install jq`
  - Ubuntu/Debian: `apt-get install jq`

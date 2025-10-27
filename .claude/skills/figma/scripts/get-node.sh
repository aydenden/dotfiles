#!/bin/bash

FILE_KEY=$1
NODE_IDS=$2

if [ -z "$FIGMA_TOKEN" ]; then
  echo "Error: FIGMA_TOKEN 환경변수가 설정되지 않았습니다."
  echo "다음 명령어로 토큰을 설정하세요:"
  echo "  export FIGMA_TOKEN=\"your-personal-access-token\""
  exit 1
fi

if [ -z "$FILE_KEY" ] || [ -z "$NODE_IDS" ]; then
  echo "Usage: $0 <FILE_KEY> <NODE_IDS>"
  echo ""
  echo "Example:"
  echo "  $0 ABC123XYZ \"202:8,303:12\""
  echo ""
  echo "Parameters:"
  echo "  FILE_KEY  - Figma 파일 키"
  echo "  NODE_IDS  - 쉼표로 구분된 노드 ID 목록 (따옴표로 감싸야 함)"
  exit 1
fi

echo "Figma 노드 정보를 가져오는 중..."
echo "File: $FILE_KEY"
echo "Nodes: $NODE_IDS"
echo ""

curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/$FILE_KEY/nodes?ids=$NODE_IDS" | jq '.'

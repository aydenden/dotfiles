#!/bin/bash

FILE_KEY=$1

if [ -z "$FIGMA_TOKEN" ]; then
  echo "Error: FIGMA_TOKEN 환경변수가 설정되지 않았습니다."
  echo "다음 명령어로 토큰을 설정하세요:"
  echo "  export FIGMA_TOKEN=\"your-personal-access-token\""
  exit 1
fi

if [ -z "$FILE_KEY" ]; then
  echo "Usage: $0 <FILE_KEY>"
  echo ""
  echo "Example:"
  echo "  $0 ABC123XYZ"
  exit 1
fi

echo "=== Figma 스타일 목록 가져오는 중 ==="
echo ""

STYLES=$(curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/$FILE_KEY/styles")

echo "$STYLES" | jq '.'

NODE_IDS=$(echo "$STYLES" | jq -r '.meta.styles[].node_id' 2>/dev/null | paste -sd "," -)

if [ -n "$NODE_IDS" ]; then
  echo ""
  echo "=== 스타일 상세 정보 가져오는 중 ==="
  echo "Node IDs: $NODE_IDS"
  echo ""

  curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
    "https://api.figma.com/v1/files/$FILE_KEY/nodes?ids=$NODE_IDS" | jq '.'
else
  echo ""
  echo "스타일 정보가 없거나 가져오기에 실패했습니다."
fi

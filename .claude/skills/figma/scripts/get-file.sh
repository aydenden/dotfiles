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
  echo ""
  echo "FILE_KEY는 Figma URL에서 추출할 수 있습니다:"
  echo "  https://www.figma.com/file/ABC123XYZ/Design-Name → ABC123XYZ"
  exit 1
fi

echo "Figma 파일 정보를 가져오는 중..."
echo ""

curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/$FILE_KEY" | jq '.'

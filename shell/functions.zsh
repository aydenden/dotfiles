# --- Functions ---

# 디렉토리 생성 후 이동
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# 포트 사용 프로세스 확인
port() {
  lsof -i ":$1" | grep LISTEN
}

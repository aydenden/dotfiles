# 코딩 규칙 (절대 준수)

## 주석 작성 규칙

### ❌ 절대 금지 (NEVER DO THIS)
- 라인별 주석 작성 금지
- 변수 선언 옆 설명 주석
- 단순 함수 호출 옆 설명 주석  
- 자명한 로직 설명 주석
- TypeScript 타입 정의 옆 설명 주석

**금지 예시:**
```typescript
const user = getCurrentUser() // 현재 사용자 정보 가져오기
const isValid = user.isActive // 활성 상태 확인  
setLoading(true) // 로딩 상태 설정
const [state, setState] = useState(false) // 상태 관리
```

### ✅ 허용되는 주석 (매우 제한적)
- 복잡한 알고리즘의 전체적인 설명 (함수 상단 블록 주석)
- 비즈니스 로직이 매우 복잡한 경우
- API 제약사항이나 중요한 주의사항
- 성능상 특별한 구현 이유

**허용 예시:**
```typescript
/**
 * 복잡한 사용자 권한 검증 알고리즘
 * 역할 기반 + 리소스 기반 권한을 조합하여 최종 권한 결정
 * 캐싱을 위해 Map 구조 사용
 */
function checkComplexPermission(user, resource) {
  // 구현...
}
```

**이 규칙들은 절대적이며 반드시 따라야 합니다.**
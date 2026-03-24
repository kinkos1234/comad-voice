<!-- COMAD-VOICE:START -->
<!-- COMAD-VOICE:VERSION:1.0.0 -->
# Comad Voice — "말만 해. 나머지는 AI가 다 한다."

비개발자 바이브코더를 위한 AI 워크플로우 하네스.
이 설정은 ~/.claude/CLAUDE.md에 추가하여 사용합니다.

## 전제 조건
- oh-my-claudecode (OMC) 설치 필수
- gstack 설치 필수
- Codex CLI + tmux (선택: 병렬 작업에 필요)

---

<comad_voice_triggers>
아래 트리거는 사용자가 슬래시 명령어를 입력하지 않아도 자동으로 감지하여 실행됩니다.
비개발자가 짧은 한마디만 해도 적절한 워크플로우가 자동 시작됩니다.

### T1. 상황 검토 & 개선 제안 (비전공자 모드)

**감지 키워드:** "상황 검토", "검토해봐", "개선 가능성", "뭐 개선할 수 있어?", "어디가 문제야?", "health check", "진단해봐", "분석해봐", "어떤 실험 할 수 있어?"

**실행 절차:**
1. 코드베이스 전체 탐색 (`explore` agent)
2. 최근 커밋 히스토리 분석 (어떤 작업을 해왔는지 파악)
3. 코드 품질/성능/구조 문제 자동 진단
4. 개선 가능한 영역을 **3-5개 카드**로 정리하여 제시:

```
## 현재 상황 진단 결과

### 카드 1: [영역명] — 난이도 (별) / 예상 효과 (불)
- 현재 상태: ...
- 문제점: ...
- 개선 방향: ...
- 이걸 하면: [한 줄 요약]
- 예상 실험: 3-5개 autoresearch 실험
- 예상 소요: ~30분 (AI) / ~3시간 (사람)

### 카드 2: [영역명] — 난이도 (별) / 예상 효과 (불)
...

어떤 카드를 먼저 진행할까요? (번호 선택 또는 "전부 다")
```

5. 사용자가 카드 번호를 선택하면 -> 해당 카드의 실험을 autoresearch로 자동 실행
6. "전부 다" 선택 시 -> full-cycle 파이프라인으로 병렬 실행

**카드 작성 규칙:**
- 전문 용어 최소화, 효과를 체감할 수 있는 언어로 설명
- 난이도와 효과를 직관적으로 표시
- 각 카드에 "이걸 하면 뭐가 좋아지는지" 한 줄 요약 필수
- 사용자가 판단할 수 있도록 trade-off 명시 (시간 vs 효과)

### T2. Full-Cycle / 대주제 요청 감지

**감지 키워드:** "풀사이클", "full-cycle", "대주제", "이거 통째로", "알아서 다 해줘", "end-to-end로", "처음부터 끝까지", or broad topic without specific file/function targets

**실행:** 6-Stage Full-Cycle Pipeline (아래 참조)

### T3. 멀티-AI 병렬 자동 감지

DECOMPOSE 단계에서 5-Point Checklist로 의존성 자동 분석.
사용자가 의존성을 판단할 필요 없음. Claude가 자동 체크:

| # | 질문 | 독립 | 의존 |
|---|------|------|------|
| 1 | **파일 겹침**: 다른 태스크와 같은 파일을 수정? | 없음 | 있음 |
| 2 | **인터페이스 의존**: 새로 만들어질 함수를 호출? | 아니오 | 예 |
| 3 | **데이터 흐름**: 다른 태스크 출력이 입력? | 아니오 | 예 |
| 4 | **실행 순서**: 반드시 다른 태스크 이후? | 아니오 | 예 |
| 5 | **상태 공유**: 공유 상태를 변경? | 아니오 | 예 |

분류 결과:
- 독립 태스크 2개 이상 -> `/pumasi`로 Codex 자동 위임
- 의존 태스크 -> Claude가 순서대로 실행
- 독립이지만 맥락 필요 -> Claude가 직접 처리

### T4. 레포 광택 (Repo Polish)

**감지 키워드:** "광택", "레포 정리", "repo polish", "배포 준비", "GitHub 정리", "레포 꾸며줘", "professional하게", "허접해 보여"

GitHub 레포를 인기 오픈소스 수준으로 자동 포장하는 트리거.
코드 품질이 아니라 레포의 **포장(presentation)** 을 개선한다.

**실행 절차:**

1. **SCAN** — 레포 구조 스캔, 누락 파일 자동 감지
   - README.md 뱃지 여부
   - .gitignore 존재 여부
   - LICENSE 존재 여부
   - CHANGELOG.md 존재 여부
   - CONTRIBUTING.md 존재 여부
   - CODE_OF_CONDUCT.md 존재 여부
   - SECURITY.md 존재 여부
   - .github/ISSUE_TEMPLATE/ 존재 여부
   - .github/PULL_REQUEST_TEMPLATE.md 존재 여부
   - .github/workflows/ (CI/CD) 존재 여부
   - Social preview 이미지 존재 여부
   - Git tag / GitHub Release 존재 여부
   - README에 TOC 존재 여부 (섹션 5개 이상일 때)

2. **DIAGNOSE** — 갭을 카드로 제시

```
## 레포 광택 진단 결과

### 카드 1: README 광택 — 난이도 낮 / 효과 높
- 현재: 뱃지 없음, TOC 없음, 히어로 이미지 없음
- 개선: shields.io 뱃지 3-4개 + TOC + 센터 정렬 히어로
- 이걸 하면: 첫인상이 프로 레포처럼 보임

### 카드 2: 커뮤니티 인프라 — 난이도 낮 / 효과 중
- 현재: CONTRIBUTING, CODE_OF_CONDUCT, SECURITY 없음
- 개선: 한국어 템플릿 자동 생성
- 이걸 하면: GitHub "Community Standards" 점수 100%

### 카드 3: Issue/PR 템플릿 — 난이도 낮 / 효과 중
- 현재: .github/ 폴더 없음
- 개선: Bug Report, Feature Request, PR 체크리스트 자동 생성
- 이걸 하면: 기여자가 구조화된 양식으로 소통

### 카드 4: 릴리스 관리 — 난이도 낮 / 효과 높
- 현재: Git tag 없음, CHANGELOG 없음
- 개선: v1.0.0 태그 + Keep a Changelog 형식 + GitHub Release
- 이걸 하면: 버전 관리가 프로페셔널하게 보임

### 카드 5: Social Preview — 난이도 중 / 효과 높
- 현재: 공유 시 썸네일 없음
- 개선: 1280x640 브랜드 이미지 자동 생성
- 이걸 하면: SNS/슬랙 공유 시 눈에 띄는 썸네일

어떤 카드를 진행할까요? (번호 선택 또는 "전부 다")
```

3. **GENERATE** — 선택된 카드의 파일들을 프로젝트에 맞게 자동 생성
   - 프로젝트명, 저자, 라이선스 등을 자동 감지하여 반영
   - 한국어 프로젝트면 한국어로, 영어면 영어로 생성
   - README 뱃지는 실제 GitHub 사용자명/레포명으로 URL 생성

4. **RELEASE** — Git tag + GitHub Release 자동 생성
   - CHANGELOG.md에서 최신 버전 추출
   - `git tag v{version}` + `git push --tags`
   - `gh release create` 로 GitHub Release 생성

5. **VERIFY** — 최종 체크리스트 통과 확인
   - 모든 필수 파일 존재 확인
   - `gh api repos/{owner}/{repo}/community/profile` 로 커뮤니티 점수 확인
   - README 렌더링 확인

**자동 감지 규칙:**
- 프로젝트의 주 언어 감지 (Python, Node.js, Go 등) → .gitignore 자동 맞춤
- package.json / pyproject.toml / go.mod 등에서 버전 추출
- git remote에서 GitHub owner/repo 추출
- 기존 README 구조를 최대한 유지하면서 뱃지/TOC만 추가
</comad_voice_triggers>

---

## 6-Stage Full-Cycle Pipeline

```
RESEARCH -> DECOMPOSE -> EXPERIMENT -> INTEGRATE -> POLISH -> DELIVER
```

### 도구 역할 분배

| 도구 | 역할 | 언제 |
|------|------|------|
| **Claude Code (Opus)** | 총괄 + 핵심 구현 | 항상 |
| **Codex** | 병렬 독립 모듈 구현 | 독립 서브태스크 3개+ |
| **Gemini** | 리서치 + 대규모 분석 | RESEARCH 단계 |

### Stage 1: RESEARCH
- `/deep-research` 스킬로 대주제의 landscape 파악
- 기존 코드베이스 탐색: `explore` agent (haiku)
- 산출물: `.omc/research/topic-landscape.md`

### Stage 2: DECOMPOSE
- `analyst` + `architect`로 서브주제 3-5개 도출
- 각 서브주제에 측정 가능한 메트릭 부여
- `critic`이 분해 결과를 도전
- 의존성 자동 판단 (5-Point Checklist)
- 산출물: `.omc/plans/decomposition.md`

**decomposition.md 형식:**

```markdown
## 서브태스크 분해

### [S1] 태스크명 — 독립 -> Codex 위임
- 설명: ...
- 메트릭: ...
- 수정 파일: file_a.py, file_b.py
- 의존: 없음
- Codex 적합: O (새 모듈 작성)

### [S2] 태스크명 — 의존 -> Claude 직접
- 설명: ...
- 메트릭: ...
- 수정 파일: file_a.py, file_d.py (S1과 겹침)
- 의존: S1 완료 후 실행
- Codex 적합: X (S1 결과에 의존)

## 실행 계획
- 병렬 1차: S1(Codex) + S3(Claude)
- 순차 2차: S2(Claude, S1 완료 후)
```

### Stage 3: EXPERIMENT
- 각 서브주제마다 `/autoresearch` 루프 실행
- 독립적 서브주제 -> `/team` 또는 `/pumasi`로 동시 실험
- 의존적 서브주제 -> 순차 체이닝
- 실험마다 git commit으로 keep/discard
- 산출물: 각 서브주제별 `experiment-log.md` + 최적 결과 커밋

### Stage 4: INTEGRATE
- 최적 결과를 하나로 병합
- 코드 리뷰 + 중복 제거 + 리팩토링
- 테스트 추가
- 산출물: 통합된 클린 코드 + 테스트

### Stage 5: POLISH
- 웹/UI: 디자인 리뷰 + QA
- 비-UI: 성능 최적화 + 코드 리뷰
- 문서화
- 산출물: DESIGN.md, 성능 벤치마크, 최종 문서

### Stage 6: DELIVER
- PR 생성, CHANGELOG 업데이트
- 이번 사이클 회고
- 산출물: PR, CHANGELOG, retro 기록

---

## 로컬 모델 대기 시간 활용

로컬 LLM (ollama 등) 추론은 수 분~수십 분 걸린다.
이 대기 시간을 낭비하지 않는다.

**규칙: 로컬 모델 실행은 항상 `run_in_background: true`로 돌리고, 대기 시간에 다른 작업 수행.**

### 대기 시간 우선순위

| 우선순위 | 작업 |
|---------|------|
| 1 | 다음 실험 코드 미리 준비 |
| 2 | 다른 독립 서브태스크 진행 |
| 3 | 이전 코드 리뷰/리팩토링 |
| 4 | 테스트 코드 작성 |
| 5 | 문서화 / 실험 로그 정리 |
| 6 | 관련 기법 리서치 |

### autoresearch + 로컬 모델 패턴

```
실험 N 코드 수정 -> background로 테스트 실행
  | 대기 시간 동안
  | 실험 N+1 코드 준비 (가설 + 코드, 실행은 안 함)
  | 또는 다른 독립 서브태스크 진행
  v
실험 N 완료 -> 결과 분석 -> keep/discard
  -> 실험 N+1 즉시 실행 (이미 준비됨)
```

---

## 세션 관리 & 메모리

긴 세션 = 풍부한 맥락이지만, 컨텍스트 오염 위험.
적정 세션 길이 + 메모리 기록을 병행한다.

### 세션 길이 가이드

| 작업 유형 | 권장 세션 길이 |
|----------|--------------|
| autoresearch 실험 | 실험 5-7개 단위로 세션 교체 |
| 풀사이클 | DECOMPOSE까지 1세션, EXPERIMENT부터 새 세션 |
| 단일 버그 수정 | 1세션으로 완료 |
| 코드 리뷰/리팩토링 | 1세션으로 완료 |

### 자동 메모리 기록

세션이 길어지거나 중요한 결과가 나오면 Claude가 자동으로 기록:
- 실험 결과 핵심 요약 -> `memory/experiments.md`
- 아키텍처 결정 -> `memory/architecture.md`
- 발견된 문제점 -> `memory/MEMORY.md`의 Known Issues
- 현재 진행 상태 -> `memory/MEMORY.md`의 Current State

### 세션 교체 시점

Claude가 다음을 감지하면 세션 교체 권장:
- 동일 대화에서 실험 7개 이상
- 컴팩트가 2회 이상 발생
- 작업 주제가 크게 전환
- "아까 그거"의 정확한 참조가 어려워짐

---

## 토큰 극대화 규칙

1. **AI와 대화하라**: 코드 변경 전후로 "왜?", "다른 방법은?", "이게 최선이야?"
2. **리서치를 아끼지 마라**: `/deep-research`로 시작
3. **병렬로 돌려라**: `/team`, `/pumasi`로 여러 agent 동시 실행
4. **Opus를 써라**: 아키텍처/분석은 항상 Opus
5. **실험 해석을 AI에게 맡겨라**: "이 결과를 분석해줘"
6. **Codex를 놀리지 마라**: 독립 태스크는 Codex에 위임
7. **대기 시간을 낭비하지 마라**: 테스트는 background, 대기 중에 다음 작업

<!-- COMAD-VOICE:END -->

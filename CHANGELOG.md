# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.1.0] - 2026-03-24

### Added
- 영어 README (`README.en.md`) + 한/영 언어 토글
- bats 테스트 스위트 (`tests/test_install.bats`) — 파일 구조, 설치 흐름 검증
- 트리거 모듈 분리 (`core/triggers/t1~t4`) — 개별 업데이트 가능
- CI에 bats 테스트 단계 추가

### Changed
- `install.sh` 견고성 대폭 개선
  - `set -euo pipefail` 적용
  - macOS/Linux 호환 `sed_inplace()` 함수
  - 타임스탬프 백업 (`CLAUDE.md.bak.YYYYMMDDHHMMSS`)
  - curl 다운로드 실패 검증 + 빈 파일 체크
  - cleanup trap으로 임시 파일 자동 정리
- 메모리 템플릿에 작성 가이드 + 구체적 예시 추가
- `core/comad-voice.md` 443줄 → 278줄로 축소 (T4 상세를 모듈로 분리)

## [1.0.0] - 2026-03-24

### Added
- 초기 릴리스
- "검토해봐" 트리거 — 코드베이스 자동 진단 + 개선 카드 제시
- "풀사이클" 트리거 — 6단계 자동 파이프라인 (RESEARCH → DELIVER)
- 멀티-AI 병렬 위임 — 5-Point 의존성 체크리스트로 Codex 자동 위임
- 세션 메모리 관리 — 컨텍스트 오염 방지 + 자동 메모리 기록
- 로컬 모델 대기 시간 활용 전략
- 원클릭 설치 스크립트 (`install.sh`)
- 메모리 템플릿 (MEMORY.md, experiments.md, architecture.md)
- 첫 세션 가이드 (`examples/first-session.md`)

### Credits
- oh-my-claudecode (OMC), gstack, autoresearch, pumasi, Nexus 위에 구축
- Andrej Karpathy "Software in the era of AI" 영감

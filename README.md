<p align="center">
  <img src="docs/images/slide-1-cover.png" alt="Comad Voice" width="400">
</p>

<h1 align="center">Comad Voice</h1>

<p align="center">
  <strong>"말만 해. 나머지는 AI가 다 한다."</strong>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://github.com/kinkos1234/comad-voice/releases"><img src="https://img.shields.io/github/v/release/kinkos1234/comad-voice?include_prereleases" alt="Release"></a>
  <img src="https://img.shields.io/badge/Made%20with-AI-22D3EE" alt="Made with AI">
  <img src="https://img.shields.io/badge/Claude%20Code-compatible-blueviolet" alt="Claude Code">
</p>

<p align="center">
  비개발자 바이브코더를 위한 AI 워크플로우 하네스.<br>
  Claude Code + Codex + Gemini를 하나의 음성처럼 통합해서,<br>
  대주제 하나 던지면 리서치 → 실험 → 리팩토링 → 완성까지 자동으로 돌아간다.
</p>

<p align="center">
  한국어 · <a href="README.en.md">English</a>
</p>

---

## 목차

- [Comad 시리즈](#comad-시리즈)
- [누구를 위한 건가요?](#누구를-위한-건가요)
- [이걸 쓰면 뭐가 달라지나요?](#이걸-쓰면-뭐가-달라지나요)
- [필수 요구 사항](#필수-요구-사항)
- [설치](#설치)
- [사용법](#사용법)
- [핵심 명령어 치트시트](#핵심-명령어-치트시트)
- [작동 원리](#작동-원리)
- [크레딧](#크레딧)
- [기여하기](#기여하기)
- [라이선스](#라이선스)

---

## Comad 시리즈

| 이름            | 역할                          |
| --------------- | ----------------------------- |
| **ComadEye**    | 미래 시뮬레이터 (보다)        |
| **Comad Ear**   | 디스코드 봇 서버 (듣다)       |
| **Comad Brain** | 지식 온톨로지 (생각하다)      |
| **Comad Voice** | AI 워크플로우 하네스 (말하다) |

---

## 누구를 위한 건가요?

- 코딩은 모르지만 AI로 프로젝트를 만들고 싶은 사람
- Claude Max, ChatGPT Plus, Google Pro 등 구독은 있는데 제대로 활용을 못 하는 사람
- "뭘 시켜야 할지 모르겠는" 바이브코더

## 이걸 쓰면 뭐가 달라지나요?

**Before:** "이거 개선해줘" → Claude가 한 가지만 고치고 끝

**After:** "검토해봐" → Claude가 알아서 진단하고, 선택지 카드를 보여주고, 선택만 하면 자동 실험 루프

---

## 필수 요구 사항

| 도구                       | 필요 여부 | 설명                                      |
| -------------------------- | --------- | ----------------------------------------- |
| **Claude Code**            | 필수      | Claude Max 구독 권장 (Opus 모델 사용)     |
| **oh-my-claudecode (OMC)** | 필수      | 멀티 에이전트 오케스트레이션              |
| **gstack**                 | 필수      | 스프린트 워크플로우 + QA                  |
| **Codex CLI**              | 선택      | 병렬 작업 위임 (없어도 Claude만으로 동작) |
| **tmux**                   | 선택      | Codex CLI 병렬 실행에 필요                |

### 사전 설치

```bash
# OMC 설치 (Claude Code 내에서)
# → Claude Code에서 "setup omc" 입력

# gstack 설치
# → https://github.com/anthropics/gstack 참조

# Codex CLI (선택)
npm install -g @openai/codex

# tmux (선택, macOS)
brew install tmux
```

---

## 설치

```bash
curl -fsSL https://raw.githubusercontent.com/kinkos1234/comad-voice/main/install.sh | bash
```

또는 수동 설치:

```bash
git clone https://github.com/kinkos1234/comad-voice.git
cd comad-voice
./install.sh
```

설치 스크립트가 하는 일:

1. `~/.claude/CLAUDE.md`에 Comad Voice 설정을 추가
2. 현재 프로젝트에 메모리 템플릿 복사 (선택)

---

## 사용법

### 1. "검토해봐" — 가장 쉬운 시작

프로젝트 폴더에서 Claude Code를 열고 이렇게만 말하세요:

```
검토해봐
```

Claude가 알아서:

1. 코드베이스를 분석하고
2. 개선 가능한 영역을 카드로 보여주고
3. 번호만 선택하면 자동으로 실험 루프를 돌립니다

### 2. "풀사이클" — 대주제 던지기

```
ComadEye의 리포트 품질을 전반적으로 개선해줘
```

6단계 파이프라인이 자동 실행:

```
RESEARCH → DECOMPOSE → EXPERIMENT → INTEGRATE → POLISH → DELIVER
```

### 3. 로컬 모델 대기 시간 활용

로컬 LLM 테스트가 돌아가는 동안:

```
이 대기 시간에 다음 실험 코드 미리 준비해줘
```

Claude가 백그라운드 실행 + 병렬 작업을 자동으로 관리합니다.

### 4. 세션 관리

긴 작업은 세션을 나눠서:

```
지금까지 결과 메모리에 저장하고 새 세션 시작하자
```

---

## 핵심 명령어 치트시트

| 하고 싶은 것     | 이렇게 말하세요                            |
| ---------------- | ------------------------------------------ |
| 현재 상태 진단   | "검토해봐", "어디가 문제야?"               |
| 대주제 자동 실행 | "풀사이클", "알아서 다 해줘"               |
| 실험 반복        | "autoresearch", "실험해봐"                 |
| 세션 정리        | "메모리에 저장하고 새 세션"                |
| 대기 시간 활용   | "다음 실험 미리 준비해줘"                  |
| 코덱스 병렬 작업 | 자동 감지 (의존성 없는 작업을 알아서 위임) |

---

## 작동 원리

### Full-Cycle Pipeline

```
사용자: "리포트 품질 개선해줘"
         ↓
[RESEARCH] 현재 코드 분석 + 관련 기술 리서치
         ↓
[DECOMPOSE] 서브태스크 분해 + 의존성 자동 판단
   🟢 독립 → Codex에 병렬 위임
   🔴 의존 → Claude가 순차 실행
   🟡 맥락 필요 → Claude가 직접
         ↓
[EXPERIMENT] 각 서브태스크별 autoresearch 루프
         ↓
[INTEGRATE] 최적 결과 병합 + 리팩토링
         ↓
[POLISH] QA + 성능 + 문서화
         ↓
[DELIVER] PR 생성 + 회고
```

### 의존성 자동 판단

비개발자가 "이건 독립적이야, 저건 의존적이야"를 판단할 필요 없습니다.
Claude가 5가지 기준으로 자동 분석합니다:

1. 파일 겹침이 있는가?
2. 다른 태스크가 만드는 함수를 쓰는가?
3. 다른 태스크의 출력을 입력으로 받는가?
4. 반드시 순서가 있는가?
5. 공유 상태를 변경하는가?

### 세션 메모리

긴 세션의 컨텍스트 오염을 방지합니다:

- 실험 5-7개마다 세션 교체 권장
- 중요한 결과는 자동으로 메모리 파일에 저장
- 새 세션에서 자동 복원

---

## 크레딧

Comad Voice는 다음 오픈소스 도구들 위에 만들어진 하네스입니다:

- **[oh-my-claudecode (OMC)](https://github.com/anthropics/oh-my-claudecode)** — 멀티 에이전트 오케스트레이션
- **[gstack](https://github.com/anthropics/gstack)** — 스프린트 워크플로우 + 브라우저 QA
- **autoresearch** — 자율 실험 루프 (Andrej Karpathy 영감)
- **pumasi** — Codex CLI 병렬 위임
- **Nexus** — 통합 자율 개발 시스템

> 이 도구들의 원작자분들께 감사드립니다.
> Comad Voice는 이 도구들을 비개발자도 쉽게 쓸 수 있도록 워크플로우를 정리한 것입니다.

### 영감

- [Andrej Karpathy — "Software in the era of AI"](https://www.youtube.com/watch?v=kwSVtQ7dziU)
  - Generation + Verification 루프
  - Autonomy Slider 개념
  - "부분적 자율성"으로 AI와 협업

---

## 기여하기

기여를 환영합니다! [CONTRIBUTING.md](CONTRIBUTING.md)를 참고해주세요.

---

## 라이선스

[MIT](LICENSE) - 자유롭게 사용, 수정, 배포할 수 있습니다.

---

<p align="center">
  <strong>Made with AI by Comad J</strong>
</p>

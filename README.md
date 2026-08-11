# ddara

<img width="100%" alt="ddara" src="https://github.com/user-attachments/assets/97ad4521-2b8a-44a1-99c1-b66c7a788407" />

[![Google Play](https://img.shields.io/badge/Google_Play-Download-green?logo=google-play)](https://play.google.com/store/apps/details?id=com.ddara.team3)
[![App Store](https://img.shields.io/badge/App_Store-Download-blue?logo=app-store)](https://apps.apple.com/kr/app/ddara/id6788298933)

---

## 1. 프로젝트 개요

초대 기반 소규모 지인 그룹 사진 챌린지 앱.

한 멤버(**스타터**)가 특정 포즈·컨셉으로 사진을 찍어 회차를 열면, 나머지
멤버(**팔로워**)가 마감 시간 안에 같은 구도로 따라 찍는다. 회차가 쌓이면
"지난 따라찍기" 기록이 된다. 모임은 초대 코드·링크로만 들어올 수 있다.

---

## 2. 기술 스택

| 분류 | 사용 기술 |
|---|---|
| 프레임워크 | Flutter (Dart SDK `^3.12.1`) |
| 플랫폼 | Android · iOS |
| 상태 관리 | Riverpod |
| 라우팅 | go_router |
| 네트워크 | Dio |
| 직렬화 · 코드 생성 | freezed · json_serializable · build_runner |
| 딥링크 | app_links |
| 소셜 로그인 | 카카오 · 구글 · 애플 |
| Firebase | Auth · Messaging · Crashlytics · Performance · Analytics |
| 로컬 저장소 | flutter_secure_storage · shared_preferences |
| 카메라 · 이미지 | camera · image_picker · image_cropper · flutter_image_compress · cached_network_image |
| 아이콘 · 애니메이션 | flutter_svg · lottie |
| 알림 · 권한 | flutter_local_notifications · permission_handler |
| 사용자 분석 | Mixpanel · Firebase Analytics |
| 다국어 | flutter_localizations · intl (한국어 · 영어) |
| 폰트 | Pretendard · Poppins |
| 테스트 · 린트 | flutter_test · mocktail · flutter_lints |
| CI/CD | GitHub Actions · Firebase App Distribution |

---

## 3. CI/CD

<img width="100%" alt="Image" src="https://github.com/user-attachments/assets/70d9f1f9-7ee6-4bba-9f7f-c00be0e24b8a" />

GitHub Actions 기반. 워크플로 4개가 브랜치 전략과 1:1로 대응한다.

| 워크플로 | 트리거 | 역할 |
|---|---|---|
| `pr-check` | 모든 PR | 머지 게이트 — 분석 · 테스트 · 디버그 빌드 |
| `build-debug` | `dev` push · 수동 | QA 배포 — Firebase App Distribution + Discord 알림 |
| `release-android` | `main` push · 수동 | Google Play internal 트랙 업로드 |
| `release-ios` | `main` push · 수동 | App Store Connect(TestFlight) 업로드 |

- 시크릿 파일(`.env` · Firebase 설정 · 키스토어 · 인증서)은 커밋하지 않고
  GitHub Secrets에서 빌드 직전에 복원한다.
- 빌드 번호는 `pubspec.yaml`을 건드리지 않고 `--build-number`로 주입한다.
  QA는 `run_number`, 릴리스는 `10000 + run_number`로 번호 공간을 분리한다.
- 스토어 승격(Play production · App Store 심사 제출)은 콘솔에서 수동으로 한다.

---

## 4. 아키텍처

<img width="100%" alt="Image" src="https://github.com/user-attachments/assets/eca35f90-a7f9-4a6c-9c8a-3145a52fef1c" />

### Clean Architecture

```
feature ──▶ domain ◀── data ──▶ core/network
   │           │                    │
   └───────────┴──── core ──────────┘
```

### 폴더 구조

```
lib/
├── main.dart                앱 진입점 (초기화 전 스플래시 → 끝나면 라우터 앱)
├── l10n/                    다국어 (app_ko.arb · app_en.arb)
│
├── core/                    전 레이어 공용
│   ├── analytics/           Mixpanel + Firebase Analytics 파사드
│   ├── auth/                소셜 로그인 (apple · google · kakao)
│   ├── bootstrap/           앱 초기화 (SDK · 인증 상태 · 콜드 스타트 딥링크)
│   ├── comment/             댓글 CRUD 공용 로직
│   ├── design_system/       원시 토큰 · 의미 토큰 · 공용 컴포넌트
│   ├── exception/           도메인별 예외 + 에러 코드
│   ├── invite/              초대 링크 · 딥링크
│   ├── local/               로컬 저장소
│   ├── model/               도메인 모델 (freezed)
│   ├── network/             Dio · 토큰 인터셉터 · 성능 계측 · DTO
│   ├── notification/        FCM · 로컬 알림
│   ├── permission/          권한 요청
│   ├── router/              go_router 설정
│   ├── util/                날짜 포맷 등 공용 헬퍼
│   └── widget/              기능을 가진 공용 위젯 (camera · photo_viewer …)
│
├── domain/                  비즈니스 규칙
│   ├── model/               UseCase 입력 커맨드
│   ├── repository/          Repository 인터페이스
│   ├── usecase/             기능별 UseCase (파일 하나당 동작 하나)
│   └── provider/            UseCase Provider
│
├── data/                    데이터 구현
│   ├── datasource/          서버 통신
│   ├── repository/          Repository 구현체 + Mapper
│   └── provider/            DataSource · Repository Provider
│
└── feature/                 화면 단위 UI
    ├── home/                홈 — 모임 목록 · 최근 업데이트 피드
    ├── group/               모임 상세 · 스타터 · 팔로워 · 갤러리 · 히스토리
    ├── group_create/        모임 생성
    ├── group_join/          모임 참여 (코드 입력 · 초대 링크 랜딩)
    ├── notification/        알림 목록
    ├── onboarding/          온보딩
    ├── permission/          권한 안내
    ├── profile/             프로필 · 설정 · 차단 · 약관
    ├── sign/                로그인 · 회원가입
    └── splash/              스플래시
```


---

## 5. 주요 기능
### 1. 자동 로그인
- [로그인 및 회원가입](https://github.com/ddara-app/ddara-app/wiki/%EB%A1%9C%EA%B7%B8%EC%9D%B8_%EB%B0%8F_%ED%9A%8C%EC%9B%90%EA%B0%80%EC%9E%85)
- [Interceptor와 자동 로그인](https://github.com/ddara-app/ddara-app/wiki/Interceptor%EC%99%80_%EC%9E%90%EB%8F%99_%EB%A1%9C%EA%B7%B8%EC%9D%B8)

### 2. 촬영 후 저장
<img width="60%" alt="Image" src="https://github.com/user-attachments/assets/43c67d6f-790e-4cb0-840c-1e0810947f3f" />

### 3. 카카오 딥링크
<img width="90%" alt="Image" src="https://github.com/user-attachments/assets/b2fc1dc6-8253-4f41-9ce6-b546d83c09ef" />



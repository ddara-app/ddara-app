# GitHub Actions CI/CD 사전 조사 — Debug 빌드 산출물 추출

목표: **GitHub Actions로 Android `.apk` 와 iOS 서명된 `.ipa` 를 자동 생성하여 실기기에 설치**하기 위한 사전 조사.
용도: **팀 내부 QA 배포** (고정된 소수 테스터 기기에 설치 → 수동 테스트)
QA 기기 구성: **iOS 6대 + Android 1대**(Android = 개발자 본인) → iOS가 QA의 주 대상
대상 프로젝트: Flutter `ddara` (Firebase + Kakao 로그인 사용)
산출물: Android = 디버그 APK(바로 설치 가능) / iOS = 서명된 `.ipa`(ad-hoc·development, 실기기 설치)

> 이 문서는 구현 전 리서치입니다. 실제 워크플로(`.yml`)는 별도로 작성합니다.

---

## 0. 먼저 짚어야 할 중요한 사실

### 산출물 형태 (이번 목표: **실기기 설치**)
- **Android → `.apk`** : 디버그 APK는 debug 키로 서명돼 **실기기에 바로 설치 가능**. (가장 단순)
- **iOS → `.ipa`** : iOS에는 APK가 없고, **실기기 설치는 코드사이닝이 필수**입니다.
  - ⚠️ `--no-codesign` 으로 만든 무서명 `.app` 이나 시뮬레이터용 `.app` 은 **실기기에 설치 불가** → 이번 목표에서는 제외.
  - 실기기 설치하려면 **Apple Developer 인증서(.p12) + 프로비저닝 프로파일** 로 서명한 **`.ipa`** 가 필요합니다.
- 즉 이번 결정은 **"Android APK + iOS 서명된 .ipa 를 실기기에 설치"** 이며, iOS는 서명/배포 단계가 핵심 난관입니다.

### iOS `.ipa` 를 실기기에 "설치"하는 현실적 경로 (QA 관점)
서명된 `.ipa` 를 아티팩트로 내려받아도 **더블클릭으로 설치되지 않습니다.** QA 배포 후보:

| 경로 | UDID 등록 | 빌드 배포 방식 | QA 적합성 |
|------|-----------|----------------|-----------|
| **Ad-hoc + Firebase App Distribution** | **필요**(기기마다) | Firebase에 IPA 업로드 → 이메일 초대/링크 OTA 설치 | ✅ **소수 고정 QA팀에 권장** (Android APK도 같은 채널로 통합 배포) |
| **Development** | 필요 | 개발자 기기 위주, 수동 설치 | 개발자 내부 확인용 |
| **TestFlight (내부 테스트)** | **불필요** | App Store Connect 업로드(내부는 심사 X) | 테스터 늘거나 UDID 관리가 번거로우면 유리 |

### 확정 권장 (iOS 6 + Android 1, 고정 기기)
> ⚠️ **Apple Distribution(ad-hoc) 발급이 막혀 있어 Apple Development(개발용) 서명으로 진행.**
> Development 프로파일도 **등록된 기기 UDID**가 있어야 설치되고, **Firebase App Distribution 으로 배포 가능**.
> 차이: 인증서 종류 = Apple Development, 프로파일 = iOS App Development, export `method` = `development`.

- **iOS: Development 서명 + Firebase App Distribution** ✅
  - 기기 6대는 **Development 기기 한도(100대) 대비 매우 적고 고정** → UDID 등록은 **1회성, 부담 거의 없음**.
  - TestFlight 의 업로드/처리 지연·파이프라인 부담이 6대 고정 환경에선 **오버스펙** → 불필요.
  - 6개 기기 UDID 를 **Development 프로파일**에 등록 → CI 가 `.ipa` 빌드 → Firebase App Distribution 으로 6명에게 OTA 배포.
- **Android(1대 = 본인)**: APK 아티팩트를 직접 받아 설치해도 충분. 다만 **같은 Firebase App Distribution 채널**로 묶으면 iOS와 배포 흐름이 일관됨.
- **결론**: 양 플랫폼 모두 **Firebase App Distribution** 단일 채널 권장. iOS만 **Development 서명 + UDID 6개 등록**이라는 1회성 준비가 추가됨.
- **유지보수 포인트**: QA 기기가 교체/추가될 때만 UDID 갱신 → 프로파일 재발급 → 재빌드. (빈도 낮음)

### 러너(OS) 요구사항
- **Android 빌드**: `ubuntu-latest` (리눅스, 가장 저렴/빠름)
- **iOS 빌드**: `macos-latest` (**필수** — iOS 빌드는 macOS + Xcode 에서만 가능, 분당 과금 더 높음)
- 두 빌드는 **별도 job**으로 분리(서로 다른 러너)하는 것이 정석.

---

## 1. 빌드에 필요한 비밀 파일 (gitignore 대상 → CI에서 주입 필요)

현재 레포에 커밋되지 않는(=러너에 없는) 파일들. **빌드가 실패하지 않으려면 CI에서 생성해줘야 함.**

| 파일 | 용도 | 누락 시 영향 | 주입 방법 |
|------|------|--------------|-----------|
| `.env` | dotenv 환경변수 (assets로 번들됨) | **pubspec assets에 선언되어 있어 없으면 빌드 실패** (키 구성은 아래 1-1 참고) | GitHub Secret → 디코딩하여 생성 |
| `android/app/google-services.json` | Firebase(Android) | google-services 플러그인 단계에서 실패 | Secret(base64) → 디코딩 |
| `ios/Runner/GoogleService-Info.plist` | Firebase(iOS) | iOS Firebase 초기화/빌드 문제 | Secret(base64) → 디코딩 |
| `android/local.properties` 의 `KAKAO_NATIVE_APP_KEY` | 카카오 로그인 키 | (빌드 설정이 이 값을 참조할 경우) 카카오 인증 동작 불가 | Secret → local.properties 에 주입 |
| `ios/Flutter/Secrets.xcconfig` | **iOS URL 스킴 값**(카카오·Google reversed client ID) | iOS Google/카카오 로그인 콜백 URL 스킴이 빈 값이 되어 **로그인 복귀 실패** | Secret → 파일 생성 (아래 1-2 참고) |

**커밋되어 있어 별도 주입 불필요**한 것:
- `lib/firebase_options.dart` (추적됨 — 그대로 빌드에 사용)
- `android/app/src/main/AndroidManifest.xml`, Gradle 스크립트 등

> 참고: `android/local.properties` 의 `flutter.sdk` 경로는 CI에서 의미 없음. `flutter build` 가 러너 환경에 맞게 자동 생성하므로, **KAKAO 키만** 주입하면 됨(빌드 설정이 참조하는 경우).

### 1-1. `.env` 키 구성
현재 `.env` 가 담고 있는 키 (CI에서 `ENV_FILE` 시크릿으로 통째 복원 시, 아래 키가 **모두** 포함돼야 함):

| 키 | 용도 |
|----|------|
| `API_BASE_URL` | 백엔드 API 베이스 URL |
| `KAKAO_NATIVE_APP_KEY` | 카카오 로그인 네이티브 앱 키 |
| `GOOGLE_CLIENT_ID` | Google 로그인 클라이언트 ID (서버/공용) |
| `GOOGLE_IOS_CLIENT_ID` | **Google 로그인 iOS 전용 클라이언트 ID** (신규 추가) |

> ⚠️ **`GOOGLE_IOS_CLIENT_ID` 관련 iOS 추가 설정 주의**
> - iOS 에서 Google 로그인을 쓰려면 이 클라이언트 ID에 대응하는 **reversed client ID** 를
>   iOS `Info.plist` 의 `CFBundleURLTypes`(URL 스킴)에 등록해야 OAuth 리다이렉트가 동작합니다.
> - 즉 이 값은 `.env`(런타임)뿐 아니라 **iOS 네이티브(Info.plist)** 설정과도 연관됩니다.
> - 본 프로젝트는 Info.plist 에 값을 하드코딩하지 않고 **`$(VAR)` 빌드 변수**로 참조하며,
>   값은 **`ios/Flutter/Secrets.xcconfig`**(gitignore) 에서 주입합니다. → 아래 1-2 참고.

### 1-2. iOS `Secrets.xcconfig` 구성
Android `local.properties`(manifestPlaceholders) 의 iOS 대응. **gitignore 되어 있어 CI에서 생성 필요.**

- 경로: `ios/Flutter/Secrets.xcconfig` (`Debug.xcconfig` / `Release.xcconfig` 가 `#include?` 로 포함)
- `Info.plist` 의 `CFBundleURLTypes` 가 아래 변수를 `$(...)` 로 참조:
  - 카카오: `kakao$(KAKAO_NATIVE_APP_KEY)`
  - Google: `$(GOOGLE_REVERSED_CLIENT_ID)`
- 파일이 담아야 할 키:

| 키 | 값 형태 | 비고 |
|----|---------|------|
| `KAKAO_NATIVE_APP_KEY` | 카카오 네이티브 앱 키 | URL 스킴 `kakao{key}` 로 조합됨 |
| `GOOGLE_REVERSED_CLIENT_ID` | `com.googleusercontent.apps.{...}` | `GOOGLE_IOS_CLIENT_ID` 의 **역순** 형태 |

> ⚠️ xcconfig 는 `//` 를 주석으로 처리함 → 값에 `//` 가 들어가면 잘림. 위 두 값은 `//` 가 없어 안전.
> CI 에서는 이 파일을 **Secret 으로부터 생성**(아래 Secrets 목록의 `IOS_SECRETS_XCCONFIG`)해야 iOS 빌드 시 URL 스킴이 채워짐.

### 비밀 주입 패턴 (base64)
바이너리/멀티라인 파일은 base64로 인코딩해 GitHub Secret에 저장 후, 워크플로에서 디코딩:

- 로컬에서 인코딩 (한 번):
  - macOS/Linux: `base64 -i android/app/google-services.json | pbcopy`
  - Windows(PowerShell): `[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/google-services.json"))`
- 워크플로에서 디코딩(개념):
  - Linux 러너: `base64 --decode` 사용
  - macOS 러너: `base64 --decode` 또는 `base64 -D`
- `.env` 처럼 단순 텍스트는 Secret 에 원문 저장 후 `printf '%s' "$SECRET" > .env` 방식도 가능.

### 정리할 GitHub Secrets 목록 (예시 네이밍)
- `ENV_FILE` — `.env` 내용(base64 또는 원문)
- `GOOGLE_SERVICES_JSON` — `google-services.json` (base64)
- `GOOGLE_SERVICE_INFO_PLIST` — `GoogleService-Info.plist` (base64)
- `KAKAO_NATIVE_APP_KEY` — 카카오 네이티브 앱 키
- `IOS_SECRETS_XCCONFIG` — `ios/Flutter/Secrets.xcconfig` 내용 (iOS URL 스킴 값; base64 또는 원문)

**iOS 실기기 설치(.ipa 서명)용 — 이번 목표에서 필수:**
- `IOS_CERTIFICATE_P12` — Apple Development 인증서(.p12, base64)
- `IOS_CERTIFICATE_PASSWORD` — 인증서 비밀번호
- `IOS_PROVISIONING_PROFILE` — Development 프로비저닝 프로파일(.mobileprovision, base64)
- `IOS_TEAM_ID` — Apple Developer Team ID
- `IOS_KEYCHAIN_PASSWORD` — CI 임시 키체인용 비밀번호(임의 값)
- (Firebase App Distribution 사용 시) `FIREBASE_APP_ID_IOS`, `FIREBASE_SERVICE_ACCOUNT` 등 배포 자격증명

> 🔐 **보안**: 이 파일들은 절대 레포에 커밋 금지(이미 `.gitignore` 처리됨). 워크플로 로그에 내용이 찍히지 않도록 `echo`로 출력하지 말 것.

---

## 2. 공통 사전 준비 (모든 job 공통 스텝)

1. **Checkout** — 소스 체크아웃 (`actions/checkout`)
2. **Flutter 설치** — `subosito/flutter-action` 등으로 **고정 버전** 설치
   - 현재 로컬: **Flutter 3.44.1 (stable)** / Dart SDK 제약 `^3.12.1`
   - 재현성을 위해 채널이 아닌 **정확한 버전 핀** 권장
3. **비밀 파일 복원** — 위 Secrets 디코딩하여 해당 경로에 생성
4. **의존성 설치** — `flutter pub get`
5. (선택) **캐시** — pub 캐시, Gradle 캐시로 속도 개선

---

## 3. Android — 디버그 APK 추출

### 러너 / 도구
- `ubuntu-latest`
- **Java 17** (프로젝트가 `JavaVersion.VERSION_17` / `jvmTarget 17` 사용) → `actions/setup-java` (temurin 17)
- Android SDK 는 flutter-action / 러너에 기본 포함

### 핵심 절차
1. 공통 사전 준비(2번) 수행
2. `android/app/google-services.json` 복원
3. (필요 시) `KAKAO_NATIVE_APP_KEY` 를 `android/local.properties` 에 주입
4. 디버그 APK 빌드:
   - `flutter build apk --debug`
   - (분할 빌드가 필요하면 `--split-per-abi`)
5. 산출물 경로: **`build/app/outputs/flutter-apk/app-debug.apk`**
6. 아티팩트 업로드: `actions/upload-artifact` 로 위 APK 업로드

### 고려사항
- 디버그 APK는 **debug 키로 서명**되어 바로 설치/테스트 가능(별도 키스토어 불필요).
- Gradle 첫 빌드가 느림 → Gradle/`~/.pub-cache` 캐시 적극 권장.
- `minSdk/targetSdk/compileSdk` 는 Flutter 기본값(`flutter.*`)을 따름 → 러너 Flutter 버전과 일치해야 함.

---

## 4. iOS — 서명된 `.ipa` 빌드 (실기기 설치용)

### 러너 / 도구
- `macos-latest` (Xcode 포함)
- CocoaPods (러너 기본 포함, 필요 시 `pod install`)
- 현재 레포에 **Podfile 미포함** → `flutter build ipa` 가 기본 Podfile 생성/`pod install` 수행

### 사전 준비물 (Apple Developer)
> ⚠️ Apple Distribution 이 막혀 **Apple Development(개발용)** 자산으로 진행.

- **Apple Developer Program 멤버십** (유료, 연 $99) — 인증서/프로파일 발급에 필수
- **Apple Development 인증서**(`.p12`) + 인증서 비밀번호
- **프로비저닝 프로파일**(`.mobileprovision`) — **iOS App Development**
  - Development 프로파일에는 **설치할 기기의 UDID 가 등록**돼 있어야 함
- **Team ID**, 번들 ID(`com.swyp.ddara`)와 프로파일이 일치해야 함

### 핵심 절차 (서명 빌드)
1. 공통 사전 준비(2번) 수행
2. `ios/Flutter/Secrets.xcconfig` 복원 (URL 스킴 값 — 1-2 참고), `ios/Runner/GoogleService-Info.plist` 복원(Firebase 사용 시)
3. **서명 자산 설치**:
   - `.p12` 인증서를 임시 키체인에 import (`security create-keychain` / `import`)
   - 프로비저닝 프로파일을 `~/Library/MobileDevice/Provisioning Profiles/` 에 배치
   - (실무에서는 `apple-actions/import-codesign-certs` 액션으로 단순화 가능)
4. **`.ipa` 빌드**:
   - `flutter build ipa --export-options-plist=ios/ExportOptions.plist`
   - `ExportOptions.plist` 에 `method`(**`development`**), `teamID`, `signingCertificate`(**Apple Development**) 명시
   - (Development 서명은 디버그/개발 구성과 잘 맞음 → QA 빌드 구성 정책만 확정하면 됨)
5. 산출물: **`build/ios/ipa/*.ipa`**
6. **배포: Firebase App Distribution 으로 업로드** (확정 채널)
   - `firebase appdistribution:distribute build/ios/ipa/*.ipa --app $FIREBASE_APP_ID_IOS --groups qa`
   - 테스터 그룹(qa)에게 OTA 설치 링크가 전달됨.
   - (아티팩트 업로드는 **CI 디버깅/백업용 보조**로만, 실제 QA 배포 경로는 Firebase App Distribution)

### 고려사항
- macOS 러너는 **분당 과금이 Linux의 약 10배** → iOS job 빈도/트리거를 신중히 설계.
- **서명 자산은 민감 정보** → 반드시 GitHub Secrets 로 주입, 로그 노출 금지, 임시 키체인 사용 후 정리.
- 기기 UDID 미등록 시 Development `.ipa` 는 **해당 기기에 설치 실패** → 새 테스터 추가 시 프로파일 재발급 필요.
- CocoaPods 캐시, DerivedData 캐시로 빌드 시간 단축 가능.
- `permission_handler` 사용 시 iOS Podfile 권한 매크로 설정이 필요할 수 있음(별도 정리한 권한 리서치 참고).

---

## 4-A. 사전 준비물 — 어떻게 구하나

> iOS 실기기 QA(.ipa)의 1회성 준비물들. 대부분 **macOS + Xcode** 또는 Apple/Firebase 웹 콘솔에서 발급.

### ① Apple Developer Program 멤버십 (유료, 연 $99)
- `developer.apple.com` → **Account** → **Enroll**.
- 개인(Individual) 또는 조직(Organization, D-U-N-S 번호 필요). 승인까지 보통 1~2일.
- ⚠️ **무료 Apple ID로는 불가**: 무료는 7일 제한 + ad-hoc 배포 불가 → 멤버십 필수.

### ② Team ID
- `developer.apple.com` → **Account** → **Membership details** 에 10자리 영숫자로 표시.
- 또는 Xcode → Settings → Accounts → 팀 선택.

### ③ 인증서 (.p12)
- 필요한 종류: **Apple Development** 인증서. (Distribution 이 막혀 개발용으로 진행)
- **쉬운 방법(Xcode)**: Xcode → Settings → Accounts → **Manage Certificates** → `+` → **Apple Development** 생성.
  → **Keychain Access(키체인 접근)** 에서 해당 인증서 + 개인키를 선택 → 우클릭 **Export** → `.p12` 저장(비밀번호 지정).
- **수동 방법**: Keychain Access → Certificate Assistant → **Request a Certificate from a CA**(CSR 생성)
  → `developer.apple.com` → **Certificates** → `+` → Apple Development → CSR 업로드 → `.cer` 다운로드
  → 더블클릭으로 키체인 등록 → 위와 같이 `.p12` 로 export.
- `.p12` 는 **인증서+개인키 묶음** → CI엔 base64로 등록(`IOS_CERTIFICATE_P12`), 비밀번호는 `IOS_CERTIFICATE_PASSWORD`.

### ④ 기기 UDID 수집 (iOS 6대)
- 각 기기 UDID 얻는 법(택1):
  - Mac에 기기 연결 → Finder → 기기 선택 → 정보줄 클릭 시 UDID 표시 → 우클릭 복사.
  - **Firebase App Distribution 의 UDID 자동 수집**: 테스터가 초대 링크로 등록용 프로파일 설치 시 UDID 가 콘솔에 모임 → **QA에 가장 편함**(아래 ④-1).
  - `udid.io` 등 OTA 수집 서비스.

#### ④-1. Firebase App Distribution UDID 자동 수집 흐름 (권장)
iOS 신규 테스터의 UDID 를 수동으로 묻지 않고, Firebase 가 모아주는 방식.

> **전제(닭-달걀 구조)**: 테스터 초대는 **릴리즈(빌드) 초대**로 트리거됨 → **App Distribution 에 IPA 가 1개 이상 업로드돼 있어야** 테스터를 초대해 기기 등록을 유도할 수 있음.
> 단, 이 **첫 빌드는 미등록 6대엔 설치되지 않음**(서명에 UDID 없음). 첫 빌드의 역할은 "설치"가 아니라 **"테스터가 등록 프로파일을 깔게 만드는 것"**.
> → 수동 수집(Finder/udid.io)으로 UDID 를 먼저 확보하면 이 단계를 건너뛰고 첫 빌드부터 설치 가능.

1. **(전제) 첫 IPA 업로드** → **테스터 초대**: Firebase Console → App Distribution → iOS 앱 → 테스터 그룹(예: `qa`)에 6명 이메일 추가(또는 초대 링크 발급).
2. **테스터 동작**: 테스터가 **iOS 기기의 Safari** 로 초대 메일/링크를 열고 → 안내에 따라 **등록 프로파일(registration profile)** 을 설치.
   - (앱 IPA 설치가 아니라, **UDID 등록용 프로파일**을 먼저 까는 단계)
3. **자동 수집**: 프로파일 설치 시 해당 기기 **UDID 가 Firebase Console 에 자동 등록**됨 → 콘솔에서 목록 확인/내보내기 가능.
4. **Apple 에 반영**(택1):
   - **연동 자동화**: Firebase 에 **Apple Developer 계정을 연결**해 두면, 수집된 UDID 를 Apple **Devices 에 자동 등록**해줌.
   - **수동**: 콘솔에서 UDID 를 받아 `developer.apple.com` → Devices 에 직접 추가.
5. **프로파일 재발급 + 재빌드**: UDID 가 늘었으므로 **Development 프로파일을 재생성**하고 **앱을 재빌드/재배포**해야 그 기기에서 설치 가능.
   - ⚠️ **중요**: Firebase 는 UDID 수집/배포만 도와줄 뿐, **IPA 를 대신 재서명하지 않음** → 기기 추가 후엔 반드시 CI 재빌드 필요.

> 효과: "기기 일일이 연결해서 UDID 따기"를 없애고, 테스터가 셀프로 등록 → 개발자는 프로파일 갱신·재빌드만. 6대 + 향후 추가 모두 이 흐름으로 처리.

> **레이어 구분 (중요)**: **UDID = Apple 코드사이닝 요구사항**(프로파일에 있어야 그 기기에서 설치 허용) / **Firebase App Distribution = 전달(배포) 채널**.
> Firebase 는 UDID 가 없어도 IPA 를 **전달**할 수 있지만, 그 IPA 가 기기 UDID 로 **서명**돼 있지 않으면 **전달은 되고 설치는 실패**함.
> 즉 Firebase 의 UDID 수집은 "배포 기능"이 아니라 **Apple 서명에 필요한 UDID 를 모아주는 보조 도구**이며, 수집 후 **Apple 등록 + 재서명(재빌드)** 은 CI/개발자 몫.

### ⑤ Development 프로비저닝 프로파일 (.mobileprovision)
- `developer.apple.com` →
  1. **Devices** → `+` → 수집한 UDID 6개 등록.
  2. **Identifiers** → App ID `com.swyp.ddara` 등록(없으면).
  3. **Profiles** → `+` → **iOS App Development** → App ID 선택 → ③의 Apple Development 인증서 선택 → **등록 기기 선택** → 생성 → `.mobileprovision` 다운로드.
- CI엔 base64로 등록(`IOS_PROVISIONING_PROFILE`).
- ⚠️ **기기 추가/교체 시**: Devices에 UDID 추가 → 프로파일 재발급 → 재빌드 필요.

### ⑥ ExportOptions.plist
- `.ipa` export 옵션 파일. `method`(**development**), `teamID`, `signingStyle`(manual), `signingCertificate`(**Apple Development**), `provisioningProfiles` 매핑 포함.
- 가장 쉬운 생성: Xcode에서 한 번 **Archive → Distribute App → Development** 진행하면 export 폴더에 `ExportOptions.plist` 가 생성됨 → 이를 레포 `ios/ExportOptions.plist` 로 커밋(민감정보 아님).

### ⑦ Firebase App Distribution 설정 + 배포 자격증명
- **콘솔 설정**: Firebase Console → 프로젝트 → **App Distribution** → 시작.
  - iOS/Android 앱은 이미 `GoogleService-Info.plist`/`google-services.json` 으로 등록돼 있을 것.
  - **테스터 그룹** 생성(예: `qa`) → 테스터 7명 이메일 추가.
- **App ID**(`FIREBASE_APP_ID_IOS` / `..._ANDROID`): Firebase Console → 프로젝트 설정 → 각 앱의 **앱 ID**.
- **CI 업로드 자격증명**(택1):
  - **서비스 계정 JSON**(`FIREBASE_SERVICE_ACCOUNT`): Google Cloud Console → IAM 및 관리자 → **서비스 계정** 생성 →
    역할 **Firebase App Distribution Admin** 부여 → **키 추가(JSON)** 발급 → base64로 Secret 등록.
  - 또는 `firebase login:ci` 로 발급한 CI 토큰(레거시).
- 배포 액션: 공식 `firebase appdistribution:distribute` 또는 `wzieba/Firebase-Distribution-Github-Action`.

> 정리: ①②는 계정/식별자, ③⑤는 서명(인증서·프로파일), ⑥은 export 설정, ⑦은 배포 채널. **③⑤⑦이 CI Secrets 로 들어가는 핵심**입니다.

---

## 5. 트리거 전략 (when to run)

| 트리거 | 용도 |
|--------|------|
| `workflow_dispatch` | 수동 실행(원할 때 빌드 추출) — **가장 먼저 추천** |
| `push` (특정 브랜치: dev/main) | 머지 시 자동 빌드 |
| `pull_request` | PR 검증용 빌드 |
| `push` tags (`v*`) | 릴리스 후보 빌드 |

- 비용 큰 iOS는 `workflow_dispatch` + 주요 브랜치 push 정도로 제한 권장.
- `paths-filter` 로 관련 변경 시에만 빌드하도록 최적화 가능.

---

## 6. 아티팩트 관리

- `actions/upload-artifact@v4` 로 업로드 → Actions 실행 페이지에서 다운로드.
- 보관 기간(`retention-days`) 설정으로 스토리지 관리.
- 산출물 네이밍에 커밋 SHA/빌드 번호 포함 권장 (예: `app-debug-${{ github.sha }}.apk`).
- **배포 채널 = Firebase App Distribution (확정)**: Android APK / iOS IPA **둘 다** Firebase App Distribution 으로 테스터 그룹(qa)에 OTA 배포.
  - `actions/upload-artifact` 는 **CI 산출물 디버깅/백업용 보조**일 뿐, **QA 전달은 Firebase App Distribution** 으로 일원화.
  - Android 1대(본인)도 같은 채널로 받으면 iOS와 흐름이 통일됨(원하면 APK 직접 다운로드도 가능).

---

## 7. 캐싱 (빌드 속도)

- **Pub**: `~/.pub-cache`
- **Gradle**: `~/.gradle/caches`, `~/.gradle/wrapper` (Android)
- **CocoaPods**: `ios/Pods`, `~/Library/Caches/CocoaPods` (iOS)
- `subosito/flutter-action` 의 `cache: true` 옵션으로 Flutter SDK 캐시.

---

## 8. 구현 전 결정/준비 체크리스트

- [ ] GitHub Secrets 등록(공통): `ENV_FILE`, `GOOGLE_SERVICES_JSON`, `GOOGLE_SERVICE_INFO_PLIST`, `KAKAO_NATIVE_APP_KEY`, `IOS_SECRETS_XCCONFIG`
- [ ] **iOS 서명 자산 확보**: Apple Developer 멤버십, **Apple Development 인증서(.p12)**, **Development** 프로비저닝 프로파일, Team ID
- [ ] **iOS 기기 6대 UDID 등록** (Development 프로파일에 포함) — 1회성
- [x] 배포 경로 결정: **Firebase App Distribution** (iOS+Android 통합), iOS export method = **development** *(Distribution 차단으로 개발용 서명)*
- [ ] Firebase App Distribution 설정: 테스터 그룹(7명) 구성, 앱(iOS/Android) 등록, 배포 자격증명(`FIREBASE_SERVICE_ACCOUNT` 등)
- [ ] Flutter 버전 핀 확정 (예: 3.44.1)
- [ ] 트리거 정책 확정 (`workflow_dispatch` 우선 + 브랜치 push 여부)
- [ ] `.env` 가 실제로 빌드에 필요한지 최종 확인(현재 pubspec assets에 선언됨)
- [ ] KAKAO 키를 빌드 설정이 참조하는지 확인(현재 build.gradle.kts 상태 기준 재확인 필요)
- [ ] 비용 한도/사용량(특히 macOS 분) 검토
- [ ] 워크플로 파일 위치: `.github/workflows/*.yml` (이 리서치는 `.github/research-debug.md`)

---

## 9. 워크플로 구조 초안 (개념 — 실제 .yml 미작성)

```
name: build-debug
on: [workflow_dispatch, push(dev)]
jobs:
  android:
    runs-on: ubuntu-latest
    steps:
      - checkout
      - setup-java (17)
      - flutter-action (3.44.1, cache)
      - 복원: .env, google-services.json, (kakao key)
      - flutter pub get
      - flutter build apk --debug
      - Firebase App Distribution 업로드 (app-debug.apk → 그룹 qa)
  ios:
    runs-on: macos-latest
    steps:
      - checkout
      - flutter-action (3.44.1, cache)
      - 복원: .env, Secrets.xcconfig, GoogleService-Info.plist
      - 서명 자산 설치: .p12 → 임시 키체인, 프로비저닝 프로파일 배치
      - flutter pub get
      - flutter build ipa --export-options-plist=ios/ExportOptions.plist
      - Firebase App Distribution 업로드 (*.ipa → 그룹 qa)
```

> 위 초안은 **개념용**입니다. iOS job 은 서명 자산 설치 스텝이 추가돼 Android 보다 복잡합니다.

---

## 참고 링크

- Flutter CI 문서: https://docs.flutter.dev/deployment/cd
- subosito/flutter-action: https://github.com/subosito/flutter-action
- upload-artifact: https://github.com/actions/upload-artifact
- setup-java: https://github.com/actions/setup-java
- iOS 코드사이닝(필요 시): https://docs.flutter.dev/deployment/ios

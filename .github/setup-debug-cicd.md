# Debug CI/CD 구축 — 실행 작업 순서 가이드

> `research-debug.md`(조사)를 바탕으로 한 **실행용 체크리스트**. 위에서부터 **순서대로** 진행하면 됩니다.
> 목표: GitHub Actions 로 **Android APK + iOS 서명 IPA** 빌드 → **Firebase App Distribution** 으로 QA 7명 실기기 배포.
> 기기: iOS 6대 + Android 1대(본인). iOS 서명 준비가 핵심.

## 의존성 순서 (왜 이 순서인가)
```
Phase 1 Apple Developer 가입
   └─> Phase 3 서명 자산(Team ID·인증서·App ID)
            └─> Phase 4 UDID 수집 → Development 프로파일
                     └─> Phase 5 ExportOptions.plist
Phase 2 Firebase App Distribution (Apple과 독립 → 병행 가능)
Phase 1~5 끝나면 → Phase 6 GitHub Secrets 등록 → Phase 7 워크플로(.yml) → Phase 8 실행·검증
```
> ⚠️ iOS 인증서/프로파일 단계는 원래 Mac(Xcode)이 편하지만, **본인은 Windows** 이므로 아래는 **Mac 없이 `openssl`(Git Bash)** 로 처리하는 경로를 기본으로 적었습니다. (Mac 있으면 Xcode 경로가 더 쉬움 — 각 단계에 병기)

---

## Phase 1. Apple Developer Program 가입 (블로킹 1순위)
- [ ] `developer.apple.com` → **Account** → **Enroll** → 멤버십 가입(연 $99, 승인 1~2일)
  - 팀 계정이 이미 있으면 본인을 **멤버로 초대**받기(App Manager 이상 권한).
- [ ] ⚠️ 무료 Apple ID 로는 developer.apple.com 의 Devices/Profiles 관리가 제한 → 안정적 QA 배포엔 **유료 멤버십 권장/필수**.

**산출물**: Apple Developer 접근 권한.

---

## Phase 2. Firebase App Distribution 세팅 (Apple과 병행 가능)
- [ ] Firebase Console → 프로젝트 `ddara` → **App Distribution** → 시작하기
- [ ] **앱 등록 확인**: iOS 앱(번들 `com.swyp.ddara`), Android 앱(`com.swyp.ddara`) 둘 다 등록돼 있는지 확인
  - (없으면 추가 → `GoogleService-Info.plist` / `google-services.json` 재발급 받아 두기)
- [ ] **테스터 그룹 생성**: 이름 `qa` → 테스터 7명 이메일 추가
- [ ] **각 앱의 App ID 메모**: 프로젝트 설정 → 내 앱 → `앱 ID`
  - iOS: `1:xxxx:ios:xxxx` → `FIREBASE_APP_ID_IOS`
  - Android: `1:xxxx:android:xxxx` → `FIREBASE_APP_ID_ANDROID`
- [ ] **CI 업로드용 서비스 계정 발급** (⚠️ 기존 `firebase-adminsdk` 재사용 말고 **CI 전용 SA 새로 생성** = 최소권한):
  1. Google Cloud Console → 해당 프로젝트 → **IAM 및 관리자 → 서비스 계정 → 만들기**
     - 이름 예: `github-actions-appdistribution` (이게 "신원"을 새로 만드는 단계)
  2. 역할: **Firebase App Distribution Admin** 부여
     - 생성 마법사의 "역할 선택"에서 주거나, 나중에 **IAM → 액세스 권한 부여**에서 *이 서비스 계정 이메일*을 구성원으로 추가하며 부여
  3. 만든 계정 → **키 → 키 추가 → JSON** → 다운로드 → 이 JSON 이 `FIREBASE_SERVICE_ACCOUNT`

  > 구분: **"서비스 계정 → 만들기"** = 신원 생성(여기서 새 SA 생성). **"IAM → 액세스 권한 부여"** = 기존 구성원에 역할만 바인딩(여기선 SA 생성 불가).
  > 기존 `firebase-adminsdk` 에 역할만 더해 써도 동작하지만 **과도 권한**이라 비권장.

**산출물**: 테스터 그룹 `qa`, `FIREBASE_APP_ID_IOS/ANDROID`, 서비스 계정 JSON.

---

## Phase 3. iOS 서명 자산 만들기 (Mac·Xcode 기준)

> **Mac(Xcode) 기준.** Apple ID 가 팀 멤버로 연결돼 있어야 함(Phase 1).

### 3-0. Xcode 에 계정 연결
- [ ] Xcode → **Settings(⌘,) → Accounts** → `+` → **Apple ID** 로그인 → 팀 표시 확인

### 3-1. Team ID 확인
- [ ] Xcode → Settings → Accounts → 팀 선택 시 우측에 표시, 또는 `developer.apple.com` → Account → **Membership details** → **Team ID**(10자리) 메모 → `IOS_TEAM_ID`

### 3-2. App ID(Identifier) 등록
- [ ] `developer.apple.com` → **Certificates, IDs & Profiles → Identifiers** → `+`
  - Bundle ID: **`com.swyp.ddara`** (Explicit) 등록 (이미 있으면 생략)

### 3-3. 개발 인증서 생성 (Xcode)
> ⚠️ **Apple Distribution 이 막혀 있어 Apple Development(개발용)로 진행.**
> Development 인증서/프로파일도 등록된 기기에서 설치 가능하고 Firebase App Distribution 으로 배포 가능.
> 차이: `method`/인증서 종류가 `development`, 프로파일이 **iOS App Development**(아래 Phase 4·5 반영).

- [ ] Xcode → Settings → Accounts → 팀 선택 → **Manage Certificates...**
- [ ] 좌측 하단 `+` → **Apple Development** 선택
  → 로그인 키체인에 **인증서 + 개인키**가 함께 생성됨.
  - (이미 "Apple Development" 이 목록에 있으면 새로 만들지 말고 그걸 export — 인증서는 종류당 개수 제한 있음)

### 3-4. `.p12` 로 내보내기 (Keychain Access)
- [ ] **키체인 접근(Keychain Access)** 앱 실행 → 좌측 **로그인(login)** 키체인 → 상단 분류 **내 인증서(My Certificates)**
- [ ] 목록에서 **`Apple Development: <팀명> (TeamID)`** 항목 찾기
  - ⚠️ 반드시 **"내 인증서"** 분류에서 (개인키가 함께 묶인 상태여야 `.p12` export 가능 — 삼각형 펼치면 개인키가 보임)
- [ ] 우클릭 → **"... 내보내기(Export)"** → 파일 형식 **개인 정보 교환(.p12)** → 저장
  - **export 비밀번호 지정** → 이 값이 `IOS_CERTIFICATE_PASSWORD`
  - (중간에 로그인 키체인 비밀번호 입력 요구 시 입력 → "허용")
- [ ] 저장된 파일 예: `ios_dist.p12`

**산출물**: `ios_dist.p12`(+ export 비밀번호), Team ID.

> Mac 이 없을 때는 `openssl` 로 CSR→인증서→p12 를 만들 수도 있음(별도 경로) — 지금은 Mac 기준이라 생략.

---

## Phase 4. UDID 수집 → Development 프로파일

> **권장(6대 고정)**: 닭-달걀 회피를 위해 **UDID 를 먼저 수집**한 뒤 프로파일을 만든다. (Firebase 자동수집은 첫 빌드 배포가 선행돼야 해서, 초기엔 수동이 단순)

### 4-1. 테스터 6명 UDID 수집
- [ ] 각 테스터에게 **`get.udid.io`** 안내 → iOS Safari 로 접속 → 안내 프로파일 설치 → 표시된 **UDID 를 본인에게 전송**
  - (대안) Mac 연결 Finder 로 직접 확인 / Firebase 자동수집(첫 빌드 후)

### 4-2. 기기 등록
- [ ] `developer.apple.com` → **Devices** → `+` → 수집한 **UDID 6개** 등록(이름 자유)

### 4-3. Development 프로비저닝 프로파일 생성
- [ ] `developer.apple.com` → **Profiles** → `+` → **iOS App Development**
  - App ID: `com.swyp.ddara` 선택
  - 인증서: Phase 3 의 **Apple Development** 선택
  - 기기: 등록한 6대 선택
  - 생성 → **`.mobileprovision` 다운로드** → 프로파일 **이름 메모**(ExportOptions 에서 사용)

**산출물**: `*.mobileprovision`, 프로파일 이름.

---

## Phase 5. ExportOptions.plist 작성 (레포에 커밋 — Team ID 는 플레이스홀더)
- [ ] 레포에 `ios/ExportOptions.plist` 생성 (teamID 는 `__IOS_TEAM_ID__` 로 두고 CI에서 치환):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string>__IOS_TEAM_ID__</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>signingCertificate</key>
    <string>Apple Development</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.swyp.ddara</key>
        <string>여기에_프로파일_이름</string>
    </dict>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```
- [ ] **CI 빌드 직전** Team ID 치환 스텝 추가 (`flutter build ipa` 전):
```bash
sed -i '' "s/__IOS_TEAM_ID__/${{ secrets.IOS_TEAM_ID }}/" ios/ExportOptions.plist
```
> `method`/`signingCertificate` 가 **Apple Development** 자산과 일치해야 함. (Distribution 자산으로 빌드 시 서명 실패)
> Team ID 는 레포에 하드코딩하지 않고 **`IOS_TEAM_ID` Secret** 으로 주입. (프로파일 "이름"은 비밀 아님 → 그대로 둠)
> 로컬 Mac 빌드 시엔 `__IOS_TEAM_ID__` 를 실제 값으로 바꾼 뒤 빌드.

---

## Phase 6. GitHub Secrets 등록
레포 → **Settings → Secrets and variables → Actions → New repository secret**.

### 6-1. base64 인코딩 (Windows PowerShell)
파일형 시크릿은 base64 로 변환해 등록:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/google-services.json")) | Set-Clipboard
[Convert]::ToBase64String([IO.File]::ReadAllBytes("ios/Runner/GoogleService-Info.plist")) | Set-Clipboard
[Convert]::ToBase64String([IO.File]::ReadAllBytes("ios_dist.p12")) | Set-Clipboard
[Convert]::ToBase64String([IO.File]::ReadAllBytes("AdHoc_ddara.mobileprovision")) | Set-Clipboard
```

### 6-2. 등록할 시크릿 목록
- [x] `ENV_FILE` — `.env` 내용(원문 또는 base64)
- [x] `GOOGLE_SERVICES_JSON` — google-services.json (base64)
- [x] `GOOGLE_SERVICE_INFO_PLIST` — GoogleService-Info.plist (base64)
- [x] `IOS_SECRETS_XCCONFIG` — `ios/Flutter/Secrets.xcconfig` 내용(원문 또는 base64)
- [x] `KAKAO_NATIVE_APP_KEY` — 카카오 네이티브 앱 키
- [x] `IOS_CERTIFICATE_P12` — `ios_dist.p12` (base64)
- [x] `IOS_CERTIFICATE_PASSWORD` — p12 export 비밀번호
- [x] `IOS_PROVISIONING_PROFILE` — `.mobileprovision` (base64)
- [x] `IOS_TEAM_ID` — Team ID
- [x] `IOS_KEYCHAIN_PASSWORD` — 임의 문자열(러너 임시 키체인용)
- [x] `FIREBASE_APP_ID_IOS` / `FIREBASE_APP_ID_ANDROID`
- [x] `FIREBASE_SERVICE_ACCOUNT` — 서비스 계정 JSON(원문 또는 base64)

---

## Phase 7. 워크플로 작성 (.yml) — dev 브랜치에 위치
> 이 파일은 **dev 브랜치**에 있어야 PR/머지 시 동작. (계획: 현재 브랜치 → dev 올린 뒤 작성)

- [x] `.github/workflows/build-debug.yml` 작성 완료 (Android job + iOS job)
  - 트리거: `workflow_dispatch`(입력 `platform`: all/android/ios) → 안정화 후 `push: dev` 주석 해제
  - 각 job: 시크릿 복원 → `flutter pub get` → 빌드 → **Firebase App Distribution 업로드(그룹 qa)**
  - iOS job: 임시 키체인 생성 → `.p12` import → 프로파일 배치 → ExportOptions Team ID 치환 → `flutter build ipa`
- 사용 액션: `subosito/flutter-action`, `wzieba/Firebase-Distribution-Github-Action`
- [ ] **이 워크플로 파일을 dev 브랜치로 올려야** push 트리거/PR 검증이 동작 (현재는 작업 브랜치에 있음)

> ⚠️ 시크릿 인코딩 규약(워크플로 상단 주석 참고): p12/프로파일/google-services/plist 는 **base64**,
> `.env`/`Secrets.xcconfig`/서비스계정 JSON 은 **원문**. 등록값이 규약과 다르면 복원 스텝에서 실패.

---

## Phase 8. 첫 실행 & 검증
- [ ] `workflow_dispatch` 로 수동 실행 → Android job 먼저 성공 확인(간단)
- [ ] iOS job 성공 확인 → Firebase App Distribution 에 IPA 올라오는지 확인
- [ ] 테스터(본인 포함)에게 초대 → **실기기 OTA 설치** 확인
  - iOS 설치 실패 시: 해당 기기 UDID 가 프로파일에 있는지부터 점검 → 없으면 Phase 4 반복(UDID 추가→프로파일 재발급→재빌드)
- [ ] 안정화되면 트리거에 `push: dev` 추가

---

## 빠른 요약 (한 줄 흐름)
```
Apple 가입 → (Team ID·Development p12 인증서·App ID) → UDID 6개 수집 → Development 프로파일 → ExportOptions.plist(method=development)
→ Firebase(App Distribution·테스터그룹·서비스계정) → GitHub Secrets 등록 → 워크플로(.yml) → 수동 실행 검증 → dev 자동화
```

## 자주 막히는 지점
- **"Signing for Runner requires a development team"** → 아카이브에 Team ID/수동서명 필요.
  → CI가 `ios/Flutter/Release.xcconfig` 에 `CODE_SIGN_STYLE=Manual / DEVELOPMENT_TEAM / PROVISIONING_PROFILE_SPECIFIER` 주입(워크플로 처리). pbxproj 미변경.
- **"requires minimum platform version 15.0"** (firebase-core/crashlytics) → `IPHONEOS_DEPLOYMENT_TARGET` 을 **15.0** 으로 상향(완료).
- iOS 설치 안 됨 → **UDID 미등록** 또는 **프로파일/인증서 불일치**가 대부분.
- 기기 추가/교체 → UDID 등록 → **프로파일 재발급 → 재빌드** 필수(Firebase 가 재서명 안 함).
- 빌드 실패 → 시크릿 누락(특히 `.env`, `Secrets.xcconfig`, `google-services.json`) 먼저 확인.
- macOS 러너 분당 과금 큼 → iOS job 은 `workflow_dispatch`/`dev push` 로 빈도 제한.

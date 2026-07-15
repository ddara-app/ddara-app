# 모임 만들기 → 공유(카카오톡) → 초대코드 딥링크 리서치

> 작성 목적: "만들기" 버튼 → BottomSheet(카카오톡 공유 / 초대코드 / 더보기) → 카카오톡
> 채팅방 선택 → 해당 톡방에 **초대코드 + 앱 딥링크** 전송. 이 흐름을 구현하기 위한
> 사전 조사 정리.

---

## 0. 전체 플로우 한눈에

```
[모임 만들기] 버튼
      │  (모임 생성 API 호출 → groupId / inviteCode 수신)
      ▼
BottomSheet 표시
  ├─ 카카오톡 공유하기  ──▶ ShareClient.shareDefault/shareCustom
  │                          → launchUrl(uri) → 카카오톡이 "채팅방 선택" UI 표시
  │                          → 선택한 톡방에 카드(초대코드+딥링크 버튼) 전송
  ├─ 초대코드            ──▶ 코드 텍스트 복사 / 표시
  └─ 더보기              ──▶ OS 기본 공유 시트(share_plus) 등
      ▼
(수신자) 톡방 카드의 "앱에서 열기" 클릭
  ├─ 앱 설치됨   → kakao{NATIVE_KEY}://kakaolink?invite_code=... 또는 App/Universal Link 로 앱 열림
  │               → 딥링크 파라미터(inviteCode) 파싱 → 모임 참여 API → 가입 완료
  └─ 미설치      → mobileWebUrl/webUrl(랜딩 페이지) → 스토어 유도
```

**핵심 사실**: "카톡 단톡 선택" 화면은 **우리가 만드는 게 아니라 카카오톡 앱이 제공**한다.
우리는 공유 메시지(템플릿)를 만들어 `launchUrl`로 띄우기만 하면, 카카오톡이 채팅방
선택 UI를 띄우고 전송까지 처리한다.

---

## 1. 필요한 패키지 & 현재 상태

| 패키지 | 용도 | 현재 |
|---|---|---|
| `kakao_flutter_sdk_user` `^1.9.5` (→1.10.0) | 로그인 | ✅ 설치됨 |
| **`kakao_flutter_sdk_share`** `^1.10.0` | **카카오톡 공유** | ✅ **설치됨 (1.10.0)** |
| `url_launcher` `^6.3.2` | 공유 uri 실행 | ✅ 설치됨 (6.3.2) |
| `app_links` `^7.1.2` | 딥링크 수신(커스텀 스킴/App Link/Universal Link) | ✅ 설치됨 (7.1.2) |
| `share_plus` | "더보기"(OS 기본 공유 시트) | ❌ (더보기 구현 시) |
| `go_router` `^16` | 라우팅(딥링크 라우팅) | ✅ 설치됨 |

> ✅ **1단계 완료**: 아래 명령으로 추가했고, `kakao_flutter_sdk_share`는 기존 카카오
> 모듈과 **동일하게 1.10.0**으로 해석되어 충돌 없음. (`kakao_flutter_sdk_template` 1.10.0 동반 설치)
> ```bash
> flutter pub add kakao_flutter_sdk_share url_launcher app_links
> ```

**이미 되어 있는 것** (카카오 로그인 설정 덕분에 공유에 그대로 재사용):
- `KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"))` — `main.dart`
- Android `AndroidManifest.xml`: `kakao{KAKAO_NATIVE_APP_KEY}://kakaolink` intent-filter 존재
- iOS `Info.plist`: `kakao$(KAKAO_NATIVE_APP_KEY)` URL Scheme 존재
- `.env`: `KAKAO_NATIVE_APP_KEY`, `API_BASE_URL`

**iOS `LSApplicationQueriesSchemes`**: 공유에는 **`kakaolink`만 필요**하며,
`isKakaoTalkSharingAvailable()`도 이 스킴을 조회한다. 현재 plist에
`kakaokompassauth`, `kakaolink`, `kakaoplus`가 등록돼 있어 **공유용으로는 이미 충분**.
(`kakaotalk` 스킴은 공유에 불필요)

---

## 2. BottomSheet 구현

Cupertino 기반 앱이므로 `showCupertinoModalPopup` 또는 `showModalBottomSheet`(Material) 사용.
프로젝트가 Cupertino 위주이나 BottomSheet는 Material `showModalBottomSheet`가 더 유연하다.

```dart
void _openShareSheet(BuildContext context, {required String inviteCode}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.bgSurface,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetItem(label: '카카오톡 공유하기', onTap: () => _shareKakao(inviteCode)),
          _SheetItem(label: '초대코드',       onTap: () => _copyInviteCode(inviteCode)),
          _SheetItem(label: '더보기',         onTap: () => _shareMore(inviteCode)),
        ],
      ),
    ),
  );
}
```

- `GroupCreatePage`의 "만들기" `onPressed`에서 **모임 생성 API 성공 후** 이 시트를 연다.
  (초대코드는 생성 응답에서 받음 → 1번 플로우 참고)

---

## 3. 카카오톡 공유 구현 (핵심)

### 3-1. 기본 템플릿(FeedTemplate) — 콘솔 등록 불필요

```dart
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _shareKakao(String inviteCode) async {
  // 1) 초대코드를 담은 딥링크 URL (앱 미설치자용 웹 폴백 겸용)
  final link = Link(
    // 앱 설치 시: 카카오가 kakao{KEY}://kakaolink?{params} 로 앱 실행
    androidExecutionParams: {'invite_code': inviteCode},
    iosExecutionParams: {'invite_code': inviteCode},
    // 앱 미설치 시: 웹 랜딩(스토어 유도 페이지)
    mobileWebUrl: Uri.parse('https://ddara.app/invite?code=$inviteCode'),
    webUrl: Uri.parse('https://ddara.app/invite?code=$inviteCode'),
  );

  final template = FeedTemplate(
    content: Content(
      title: '우리 모임에 초대합니다',
      description: '초대코드 $inviteCode 로 모임에 참여해요',
      imageUrl: Uri.parse('https://ddara.app/og/invite.png'), // 카카오 서버 업로드 이미지 권장
      link: link,
    ),
    buttons: [
      Button(title: '앱에서 참여하기', link: link),
    ],
  );

  // 2) 카카오톡 설치 여부
  final installed = await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (installed) {
    // 3) 공유 uri 생성 → 실행하면 카카오톡이 "채팅방 선택" UI 표시
    final uri = await ShareClient.instance.shareDefault(template: template);
    await launchUrl(uri);
  } else {
    // 4) 미설치 → 웹 공유(브라우저)로 폴백
    final uri = await WebSharerClient.instance.makeDefaultUrl(template: template);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
```

> **시그니처 확정 (설치 버전 `1.10.0` 소스 확인 완료)**:
> - `shareDefault({required DefaultTemplate template})` → **`Future<Uri>`**
> - `shareCustom({required int templateId, Map<String,String>? templateArgs})` → **`Future<Uri>`**
> - `WebSharerClient.makeDefaultUrl({required DefaultTemplate template})` → **`Future<Uri>`**
> - `isKakaoTalkSharingAvailable()` → `Future<bool>`
>   → 셋 다 `Uri`를 반환하므로 위 코드처럼 **`await` 후 `launchUrl(uri)`** 필요.
> - `Link`: `webUrl`/`mobileWebUrl`은 **`Uri?`**, `androidExecutionParams`/
>   `iosExecutionParams`는 **`Map<String,String>?`** (쿼리스트링 형태는 JS SDK 방식 — 혼동 주의).

### 3-2. 커스텀 템플릿(shareCustom) — 카카오 콘솔 등록 필요

디자인을 카카오 콘솔 "메시지 템플릿 도구"에서 만들고 `templateId`로 호출.
가변값은 `templateArgs`로 치환(`${invite_code}` 등).

```dart
await ShareClient.instance.shareCustom(
  templateId: 123456,                       // 콘솔에서 발급
  templateArgs: {'invite_code': inviteCode},
).then((uri) => launchUrl(uri));
```

**선택 기준**: 디자인 자유도/브랜딩이 중요하면 커스텀 템플릿(콘솔 작업 필요),
빠른 구현이면 FeedTemplate(코드만으로 가능).

---

## 4. 초대코드 + 딥링크 설계

초대를 "받은" 사람이 앱으로 들어오게 하려면 **딥링크 경로가 2가지** 필요하다.

### (A) 카카오 실행 파라미터 (앱 설치자, 가장 쉬움)
카카오 메시지의 앱 실행 버튼을 누르면 카카오가 아래 스킴으로 앱을 연다:
```
kakao{KAKAO_NATIVE_APP_KEY}://kakaolink?invite_code=ABC123
```
- 이 스킴은 **카카오 로그인용으로 이미 등록**돼 있어(Android intent-filter / iOS URL Scheme)
  별도 도메인/검증 없이 동작한다. ← **MVP로 가장 빠른 길**
- 단, "앱이 이미 설치된 사람"에게만 유효.

### (B) App Link(Android) / Universal Link(iOS) — 정식 딥링크
`https://ddara.app/invite?code=ABC123` 형태의 https 링크가 앱을 열거나(설치 시),
웹 랜딩으로 가게(미설치 시) 한다. 위 템플릿 `mobileWebUrl/webUrl`에 넣는 값이 이것.
- **도메인 소유 + 검증 파일 호스팅 필요** (아래 6번).
- 카카오톡 채팅 본문 링크나, 카톡 외 공유(더보기)에서도 동작 → 범용성 높음.

> 권장: **MVP는 (A)** 로 시작 → 추후 (B) 추가. 둘 다 결국 `invite_code`를 앱에 전달.

---

## 5. 딥링크 수신 처리 (`app_links` + `go_router`)

`app_links`로 앱이 열릴 때의 URI를 받아 `invite_code`를 파싱하고 라우팅한다.

```dart
import 'package:app_links/app_links.dart';

final _appLinks = AppLinks();

// 앱이 죽어있다 링크로 켜진 경우
final initialUri = await _appLinks.getInitialLink();

// 앱이 떠 있는 중 링크 수신
_appLinks.uriLinkStream.listen((uri) => _handleInvite(uri));

void _handleInvite(Uri uri) {
  // (A) kakao{KEY}://kakaolink?invite_code=...
  // (B) https://ddara.app/invite?code=...
  final code = uri.queryParameters['invite_code'] ?? uri.queryParameters['code'];
  if (code != null && code.isNotEmpty) {
    // go_router 로 모임 참여 화면 이동 + 코드 전달
    router.push('/group/join?code=$code');
  }
}
```

> ⚠️ **충돌 주의**: `app_links`(또는 타 딥링크 플러그인)와 Flutter 기본 딥링크 핸들러는
> 동시에 쓰면 충돌한다. `app_links`로 직접 처리할 경우 Android `AndroidManifest.xml`에
> `<meta-data android:name="flutter_deeplinking_enabled" android:value="false" />` 로
> 기본 핸들러를 끄거나, 반대로 go_router의 기본 딥링크에 맡기고 `app_links`는 커스텀
> 스킴만 처리하도록 역할을 명확히 나눈다. (한 가지 방식으로 통일)

---

## 6. 플랫폼 설정 체크리스트

### Android
- [x] `kakao{KEY}://kakaolink` intent-filter — **`.MainActivity`에 등록 확인됨**
  (딥링크가 Flutter/app_links 로 전달됨)
- [ ] **Android 11+ 패키지 가시성**: KakaoTalk 설치 감지/실행에 `<queries>` 가 필요.
  보통 `kakao_flutter_sdk_common` 매니페스트가 병합으로 제공하나, 감지가 안 되면
  앱 매니페스트 `<queries>`에 `<package android:name="com.kakao.talk" />` 추가.
- [ ] (B 정식 딥링크) App Link intent-filter 추가:
  ```xml
  <intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="https" android:host="ddara.app" android:pathPrefix="/invite"/>
  </intent-filter>
  ```
- [ ] (B) `https://ddara.app/.well-known/assetlinks.json` 호스팅 (패키지명 + 릴리스 SHA256)

### iOS
- [x] `kakao$(KAKAO_NATIVE_APP_KEY)` URL Scheme (이미 있음)
- [x] `LSApplicationQueriesSchemes`에 `kakaolink` 포함 (이미 있음 — 공유엔 이것만 필요)
- [ ] (B) Xcode → Signing & Capabilities → **Associated Domains** → `applinks:ddara.app`
- [ ] (B) `https://ddara.app/.well-known/apple-app-site-association` 호스팅 (AASA, JSON)

---

## 7. 백엔드 / API 의존성

> **초대코드는 백엔드에서 임의로 발급한 문자열(opaque random string)이다.**
> 앱은 코드를 **생성하지 않고**, 받아서 그대로 전달/표시만 한다. 어떤 모임에 매핑되는지는
> **서버가 코드로 조회**한다 (앱은 코드의 의미/구조를 알 필요 없음).

- **모임 생성 API**: 응답에 `groupId` + **`inviteCode`(백엔드 발급 랜덤 문자열)** 포함.
  → "만들기" 누를 때 생성 → 응답의 `inviteCode`를 시트/공유/딥링크에 그대로 사용.
- **초대코드로 가입 API**: `POST /groups/join { inviteCode }` — 서버가 코드→모임 해석 후 가입.
  (잘못된/만료된 코드면 4xx → 앱은 "유효하지 않은 초대코드" 등 안내)
- 코드 문자셋: **영숫자(대소문자+숫자), 예: `A82TSJXk2`** → **URL-safe** 이므로
  쿼리 파라미터에 별도 인코딩 없이 그대로 싣고 받으면 된다.
  `kakao{KEY}://kakaolink?invite_code=A82TSJXk2` / `https://ddara.app/invite?code=A82TSJXk2`
- 확인 필요: 초대코드 **만료/재발급 정책** (코드 길이/문자셋은 고정 가정).
- (선택) `https://ddara.app/invite?code=` 랜딩 페이지: 앱 설치 여부 판단 → 스토어/앱 분기.

> 현재 코드 미구현 상태(`GroupCreatePage`의 onPressed가 `// TODO`)이므로,
> API 스펙이 나오면 notifier(`GroupCreateNotifier`: 로딩/성공/에러)를 도입해
> 생성 → 시트 오픈을 연결한다.

---

## 8. 함정 / 주의사항

1. **비즈앱 여부**: 친구에게 메시지를 *직접* 보내는 "메시지 보내기" API(`talk`)는
   비즈앱 전환이 필요. 하지만 **여기서 쓰는 "공유하기"(채팅방 선택 후 전송)는 일반 앱도
   가능**하다. 우리가 필요한 건 공유(share)지 메시지 전송(message)이 아님 → 비즈앱 불필요.
2. **이미지 URL**: 템플릿 이미지는 공개적으로 접근 가능한 https URL이어야 함.
   직접 호스팅하거나 `ShareClient.uploadImage()`/`scrapImage()`로 카카오 서버 업로드 후 사용.
3. **카카오톡 미설치 분기 필수**: `isKakaoTalkSharingAvailable()` false → 웹 공유 폴백 처리 안 하면 크래시/무반응.
4. **딥링크 핸들러 이중화 금지**: 5번의 충돌 주의 참고.
5. **실행 파라미터 타입**: SDK 버전별로 `Map` vs 쿼리스트링 차이 → 추가 후 즉시 확인.
6. **테스트**: 카카오 공유/딥링크는 시뮬레이터/에뮬레이터에서 카카오톡 미설치라 제대로
   안 됨 → **실기기 + 카카오톡 로그인 계정**으로 테스트.
7. **release 서명 SHA256**: App Link 검증(assetlinks.json)은 디버그/릴리스 키가 다르므로
   CI 배포 키의 SHA256을 등록해야 실제 배포본에서 동작.

---

## 9. 디버그 모드 테스트

디버그 빌드로도 테스트 가능하나 기능별 조건이 다르다.

| 항목 | 디버그 테스트 | 조건 |
|---|---|---|
| 카카오 공유 흐름(채팅방 선택→전송) | ✅ | **실기기 + 카카오톡 설치** + Android **디버그 키 해시 등록** |
| 커스텀 스킴 딥링크 (A) `kakao{KEY}://kakaolink?...` | ✅ | 별도 설정 불필요 (manifest/plist는 빌드 모드 무관) |
| App/Universal Link (B) `https://ddara.app/...` | ⚠️ | assetlinks에 **디버그 SHA256** 추가 / iOS AASA·엔티틀먼트 |
| 딥링크 **수신 로직만** | ✅ | adb/simctl 로 스킴 직접 발사 |

**주의점**
- **에뮬레이터/시뮬레이터엔 카카오톡이 없음** → `isKakaoTalkSharingAvailable()`가 false →
  실제 공유 흐름은 **실기기**에서만. (시뮬레이터에선 웹 폴백 경로만 확인 가능)
- **Android 디버그 키 해시**: 카카오는 패키지명 + 키 해시로 앱을 검증한다. 디버그 빌드는
  디버그 키스토어의 키 해시를 쓰므로, 릴리스와 **별도로 디버그 키 해시를 카카오 콘솔에 등록**
  해야 공유가 동작한다. (미등록 시 "등록되지 않은 앱" 에러)
  ```bash
  # 디버그 키 해시 추출 (macOS/Linux)
  keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore \
    -storepass android -keypass android | openssl sha1 -binary | openssl base64
  ```
- iOS는 번들 ID로 검증(키 해시 없음) → 디버그에서도 그대로 동작.

**카카오톡 없이 딥링크 수신만 검증** (공유→카톡 단계 건너뛰기):
```bash
# Android (앱 설치 상태)
adb shell am start -a android.intent.action.VIEW \
  -d "kakao{NATIVE_APP_KEY}://kakaolink?invite_code=A82TSJXk2"

# iOS 시뮬레이터
xcrun simctl openurl booted "https://ddara.app/invite?code=A82TSJXk2"
```

---

## 10. 단계별 작업 순서(권장)

- [x] 1. `kakao_flutter_sdk_share`, `url_launcher`, `app_links` 추가 — **완료(1.10.0/6.3.2/7.1.2)**,
  설치 버전 소스로 시그니처 검증 완료 (3-1 코드 그대로 사용 가능)
- [x] 2. iOS 공유 스킴 `kakaolink` — 이미 등록됨(추가 작업 불필요)
- [ ] 3. BottomSheet UI (카카오톡 공유 / 초대코드 / 더보기)
- [ ] 4. 모임 생성 API + notifier → 생성 성공 시 `inviteCode` 확보 *(백엔드 스펙 대기 — 임시 더미 코드로 선행 가능)*
- [x] 5. **(A) 카카오 실행 파라미터 방식**으로 공유 구현 (FeedTemplate, 가장 빠름)
  → `lib/core/share/kakao_share_service.dart` (`KakaoShareService.shareInvite`),
    `invite_share_sheet.dart` `_onKakaoShare`에 연결 (설치 분기 + 웹 폴백 + 실패 안내)
- [x] 6. `app_links`로 `kakao{KEY}://kakaolink?invite_code=` 수신 → `/group/join?code=` 라우팅
  → `lib/core/deeplink/deep_link_service.dart`(콜드스타트+스트림 수신, `invite_code`/`code` 파싱),
    `main.dart` `MyApp`(ConsumerStatefulWidget)에서 init/dispose,
    `app_router.dart`에 `RoutePath.groupJoin`(`GroupJoinPage`) 추가,
    Android `flutter_deeplinking_enabled=false`로 기본 핸들러 비활성화(이중화 방지)
- [ ] 7. 모임 참여 API 연동
- [ ] 8. (이후) **(B) App Link/Universal Link** 도메인·검증 파일·랜딩 페이지로 미설치 사용자까지 커버

> **진행 메모**: 1·2단계 완료. 4단계(생성 API)는 백엔드 스펙 미정으로 대기 중 →
> 3단계(BottomSheet) + 5단계(공유)를 **임시 더미 inviteCode**로 먼저 구현해 실기기 공유
> 흐름을 검증하는 방안 가능.

---

## 11. 참고 링크

- [ShareClient class — Kakao Flutter SDK API](https://developers.kakao.com/sdk/reference/flutter/release/kakao_flutter_sdk/ShareClient-class.html)
- [카카오톡 공유 — Flutter (Kakao Developers)](https://developers.kakao.com/docs/latest/ko/kakaotalk-share/flutter-link)
- [카카오톡 공유 — Android (실행 파라미터/스킴 상세)](https://developers.kakao.com/docs/latest/ko/kakaotalk-share/android-link)
- [메시지 기본 템플릿 (Kakao Developers)](https://developers.kakao.com/docs/latest/ko/message-template/default)
- [kakao_flutter_sdk_share (pub.dev)](https://pub.dev/packages/kakao_flutter_sdk_share)
- [app_links (pub.dev)](https://pub.dev/packages/app_links)
- [Flutter Deep Linking 가이드 — Code With Andrea](https://codewithandrea.com/articles/flutter-deep-links/)
- [Set up app links for Android — Flutter Docs](https://docs.flutter.dev/cookbook/navigation/set-up-app-links)
- [Set up universal links for iOS — Flutter Docs](https://docs.flutter.dev/cookbook/navigation/set-up-universal-links)
- [flutter 카카오톡으로 공유하기 (예제 블로그)](https://1kl1.github.io/flutter_kakao_share/)

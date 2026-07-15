import 'dart:async';

import 'package:app_links/app_links.dart';

/// 초대 딥링크 수신 서비스. (research.md 섹션 5 / 작업 6번)
///
/// 처리 대상 URI 두 종류:
/// - (A) 카카오 실행 파라미터: `kakao{KEY}://kakaolink?invite_code=...`
/// - (B) App/Universal Link: `https://ddara.app/invite?code=...`
///
/// 둘 다 결국 초대코드를 [onInvite] 로 전달한다. 딥링크 핸들러 이중화를 피하기
/// 위해 Flutter 기본 딥링크는 비활성화하고(Android `flutter_deeplinking_enabled=false`)
/// 이 서비스가 단일 진입점으로 동작한다.
class DeepLinkService {
  DeepLinkService({required this.onInvite});

  /// 초대코드를 파싱했을 때 호출되는 콜백. (라우팅 등)
  final void Function(String inviteCode) onInvite;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  /// 실행 중(앱이 떠 있을 때) 들어오는 링크 스트림을 구독한다.
  ///
  /// 콜드 스타트(링크로 앱이 켜진) 최초 URI 는 라우터 초기 위치를 잡기 위해
  /// `main()` 에서 [parseInviteCode] 로 먼저 읽어 처리하므로 여기선 다루지 않는다.
  /// (그래야 홈이 먼저 그려졌다 landing 으로 튕기는 깜빡임이 없다)
  Future<void> init() async {
    _subscription = _appLinks.uriLinkStream.listen(_handle);
  }

  void _handle(Uri uri) {
    final code = parseInviteCode(uri);
    if (code != null) onInvite(code);
  }

  /// URI 에서 초대코드를 뽑아낸다. 초대 링크가 아니면 null.
  ///
  /// 콜드 스타트(main) 와 실행 중 스트림(_handle) 이 같은 규칙을 쓰도록 공유한다.
  static String? parseInviteCode(Uri? uri) {
    if (uri == null) return null;

    // 카카오 로그인 콜백(kakao{KEY}://oauth?code=...)은 KakaoSDK 가 처리한다.
    // oauth 콜백도 code 파라미터를 갖고 있어, host 로 거르지 않으면 인가 코드를
    // 초대코드로 오인해 참여 화면으로 튕긴다. (로그인과 같은 스킴·host 만 다름)
    if (uri.scheme.startsWith('kakao') && uri.host == 'oauth') return null;

    // (A) invite_code / (B) code 둘 다 지원.
    final code =
        uri.queryParameters['invite_code'] ?? uri.queryParameters['code'];
    return (code != null && code.isNotEmpty) ? code : null;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

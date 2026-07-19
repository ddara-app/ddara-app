import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';

/// 카카오톡 "공유하기"(채팅방 선택 후 전송) 서비스.
///
/// 채팅방 선택 UI는 카카오톡 앱이 직접 제공한다. 앱은 공유 템플릿을 만들어
/// 공유 URI 를 [launchUrl] 로 띄우기만 하면 된다. (research.md 3번 참고)
///
/// "공유(share)"는 일반 앱도 가능하므로 비즈앱 전환이 필요 없다.
class KakaoShareService {
  /// 카카오 콘솔 "메시지 템플릿 도구"에서 발급받은 커스텀 템플릿 ID.
  static const int _inviteTemplateId = 134632;

  /// 초대코드와 대표 이미지를 담아 카카오톡 공유 흐름을 실행한다.
  ///
  /// - 카카오톡 설치됨: [ShareClient.shareCustom] 으로 공유 URI 생성 → 채팅방 선택 UI.
  /// - 미설치: [WebSharerClient.makeCustomUrl] 로 웹 공유(브라우저) 폴백.
  ///
  /// [imageUrl] 은 템플릿의 `${THU}` 변수로 치환되므로, 카카오가 접근 가능한
  /// **공개 https URL** 이어야 한다. (로컬 에셋 경로는 사용 불가)
  /// 두 경로 모두 실패 시 [Exception] 을 던지므로 호출부에서 사용자 안내 처리.
  Future<void> shareInvite(
    String inviteCode, {
    required String imageUrl,
  }) async {
    // 콘솔 템플릿의 가변 인자(${invite_code}, ${THU})에 실제 값을 치환한다.
    // 키는 템플릿의 사용자 인자 이름과 정확히 일치해야 한다. (이미지 = THU)
    final templateArgs = {'invite_code': inviteCode, 'THU': imageUrl};

    // 카카오톡 설치 여부에 따라 공유 경로 분기. (미분기 시 미설치 기기에서 크래시)
    final installed = await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (installed) {
      final uri = await ShareClient.instance.shareCustom(
        templateId: _inviteTemplateId,
        templateArgs: templateArgs,
      );
      await launchUrl(uri);
    } else {
      // 카카오톡 미설치 → 웹 공유로 폴백.
      final uri = await WebSharerClient.instance.makeCustomUrl(
        templateId: _inviteTemplateId,
        templateArgs: templateArgs,
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 안 읽은 알림이 하나라도 있는지. (홈 AppBar 종 아이콘 분기)
///
/// TODO: 안 읽음 전용 API 로 교체. (백엔드 추가 예정 — 임시 구현)
///
/// 지금은 안 읽음 여부만 주는 API 가 없어 목록을 통째로 받아 판단한다.
/// 그래서 홈에 들어올 때마다 알림 목록을 한 번 더 받는다.
/// API 가 생기면 이 provider 안쪽만 바꾸면 된다. (호출부는 그대로)
///
/// 조회에 실패하면 없는 것으로 본다 — 확실하지 않은 채로 종을 강조하지 않는다.
///
/// 알림을 읽고 나면 `ref.invalidate(hasUnreadNotificationProvider)` 로 재조회한다.
/// (autoDispose 로 두면 홈이 떠 있는 동안 폐기되지 않아 의미가 없다)
final hasUnreadNotificationProvider = FutureProvider<bool>((ref) async {
  try {
    final result = await ref.read(getNotificationsUseCaseProvider)();
    return result.items.any((item) => !item.isRead);
  } catch (e) {
    debugPrint('[Notification] 안 읽음 여부 조회 실패: $e');
    return false;
  }
});

import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 안 읽은 알림이 하나라도 있는지. (홈 AppBar 종 아이콘 분기)
///
/// 여부만 주는 경량 API(`GET /api/notifications/unread`)를 쓴다.
/// 목록을 통째로 받아 판단하던 임시 구현을 대체한 것이다.
///
/// 조회에 실패하면 없는 것으로 본다 — 확실하지 않은 채로 종을 강조하지 않는다.
///
/// 알림을 읽고 나면 `ref.invalidate(hasUnreadNotificationProvider)` 로 재조회한다.
/// (autoDispose 로 두면 홈이 떠 있는 동안 폐기되지 않아 의미가 없다)
final hasUnreadNotificationProvider = FutureProvider<bool>((ref) async {
  try {
    return await ref.read(getUnreadNotificationUseCaseProvider)();
  } catch (e) {
    debugPrint('[Notification] 안 읽음 여부 조회 실패: $e');
    return false;
  }
});

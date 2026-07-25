import 'package:ddara/core/model/notification/notification_item.dart';

/// 알림 목록 화면 상태. 로딩·실패·완료가 상호배타인 sealed 설계라
/// "로딩 중인데 에러", "목록 있는데 에러 화면" 같은 조합이 타입상 불가능하다.
sealed class NotificationState {
  const NotificationState();
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// 초기 조회 실패. (본문 문구는 화면이 l10n 으로 표시)
final class NotificationLoadError extends NotificationState {
  const NotificationLoadError();
}

final class NotificationLoaded extends NotificationState {
  const NotificationLoaded({required this.items, required this.blockedUserIds});

  /// 조회된 알림 목록. (비어 있으면 빈 상태 화면)
  final List<NotificationItem> items;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 썸네일을 가리는 데 사용)
  final Set<int> blockedUserIds;
}
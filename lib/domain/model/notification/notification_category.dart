/// 알림 목록 조회 시 필터링할 카테고리. (`category` 쿼리 파라미터)
enum NotificationCategory {
  // 전체 알림.
  all('all'),

  // 활동 관련 알림.
  activity('activity'),

  // 기타 알림.
  etc('etc');

  const NotificationCategory(this.value);

  final String value;
}

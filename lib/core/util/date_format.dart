/// 서버에서 받은 시각을 'yyyy.MM.dd' 로 포맷한다. null 이면 빈 문자열.
///
/// 서버는 시각을 UTC 로 내려주므로 반드시 기기 시간대로 변환한 뒤 포맷한다.
/// (UTC 그대로 포맷하면 KST 자정~오전 9시의 시각이 전날 날짜로 표시된다)
String formatDate(DateTime? date) {
  if (date == null) return '';
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}.$month.$day';
}

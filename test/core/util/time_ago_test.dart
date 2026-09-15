import 'package:ddara/core/util/time_ago.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('ko'));

  test('1분 미만이면 방금 전으로 표시한다', () {
    final result = timeAgoLabel(DateTime.now(), l10n);

    expect(result, l10n.timeAgoJustNow);
  });

  test('1분 이상 1시간 미만이면 분 단위로 표시한다', () {
    final result = timeAgoLabel(
      DateTime.now().subtract(const Duration(minutes: 5)),
      l10n,
    );

    expect(result, l10n.timeAgoMinutes(5));
  });

  test('1시간 이상 하루 미만이면 시간 단위로 표시한다', () {
    final result = timeAgoLabel(
      DateTime.now().subtract(const Duration(hours: 2)),
      l10n,
    );

    expect(result, l10n.timeAgoHours(2));
  });

  test('하루 이상 일주일 미만이면 일 단위로 표시한다', () {
    final result = timeAgoLabel(
      DateTime.now().subtract(const Duration(days: 3)),
      l10n,
    );

    expect(result, l10n.timeAgoDays(3));
  });

  test('일주일 이상 한 달 미만이면 주 단위로 표시한다', () {
    final result = timeAgoLabel(
      DateTime.now().subtract(const Duration(days: 14)),
      l10n,
    );

    expect(result, l10n.timeAgoWeeks(2));
  });

  test('한 달 이상 1년 미만이면 개월 단위로 표시한다', () {
    final result = timeAgoLabel(
      DateTime.now().subtract(const Duration(days: 60)),
      l10n,
    );

    expect(result, l10n.timeAgoMonths(2));
  });

  test('1년 이상이면 연 단위로 표시한다', () {
    final result = timeAgoLabel(
      DateTime.now().subtract(const Duration(days: 400)),
      l10n,
    );

    expect(result, l10n.timeAgoYears(1));
  });
}

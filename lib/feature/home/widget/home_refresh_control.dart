import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 홈 탭 공용 '당겨서 새로고침' 컨트롤.
///
/// 탭 헤더가 하단 여백을 갖지 않으므로(여백은 스크롤되는 본문이 갖는다),
/// 기본 스피너는 탭 인디케이터에 바로 붙어 나타난다. 본문 상단 여백만큼
/// 스피너를 아래로 밀고 인디케이터 영역도 함께 키워, 첫 카드가 놓이는 자리와
/// 같은 간격을 두게 한다.
class HomeRefreshControl extends StatelessWidget {
  const HomeRefreshControl({super.key, required this.onRefresh});

  /// 스피너를 탭 인디케이터에서 떼어 놓는 여백.
  /// (본문이 갖는 인디케이터 아래 여백과 같은 값으로 맞춘다)
  static const double _spinnerGap = AppSpacing.s4;

  /// CupertinoSliverRefreshControl 의 기본 인디케이터 높이.
  /// (패키지 비공개 상수라 값을 옮겨 적는다)
  static const double _defaultIndicatorExtent = 60;

  /// 새로고침 시 다시 조회할 데이터. (탭마다 다르다)
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      // 스피너를 밀어낸 만큼 자리도 넓혀야 새로고침 중에 잘리지 않는다.
      refreshIndicatorExtent: _defaultIndicatorExtent + _spinnerGap,
      builder:
          (
            context,
            refreshState,
            pulledExtent,
            refreshTriggerPullDistance,
            refreshIndicatorExtent,
          ) => Padding(
            padding: const EdgeInsets.only(top: _spinnerGap),
            child: CupertinoSliverRefreshControl.buildRefreshIndicator(
              context,
              refreshState,
              pulledExtent,
              refreshTriggerPullDistance,
              refreshIndicatorExtent,
            ),
          ),
    );
  }
}

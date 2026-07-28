import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_constraints.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 대시보드 높이. 모임 카드보다 낮게 고정해, 우측 열 카드들이 이 높이 차이만큼
/// 위로 덜 내려오며 지그재그 오프셋이 만들어진다. (카드 높이는 열 폭 ×
/// photoCardAspectRatio 로 가변이라 토큰 스케일과 무관한 디자인 고정값)
const double _dashboardHeight = 142;

/// 대시보드에 담는 내용의 종류. (탭마다 문구 구성이 다르다)
enum _HomeDashboardVariant {
  /// 따라찍기 모임 탭: 현재 참여 중인 모임 개수 (N/최대 개).
  groupCount,

  /// 최근 업데이트 탭: 친구들의 업데이트 개수 (N개).
  updateCount,
}

/// 홈 화면 우측 상단에 고정되는 요약 위젯.
///
/// 모임 리스트의 지그재그 오프셋을 위해 모임 카드보다 낮은 높이를 갖는다.
class HomeDashboard extends StatelessWidget {
  /// 현재 참여 중인 모임 개수([count]/[maxCount]) 대시보드.
  const HomeDashboard.groupCount({
    super.key,
    required this.count,
    this.maxCount = maxJoinedGroupCount,
  }) : _variant = _HomeDashboardVariant.groupCount;

  /// 친구들의 업데이트 개수([count]개) 대시보드.
  const HomeDashboard.updateCount({super.key, required this.count})
    : maxCount = 0,
      _variant = _HomeDashboardVariant.updateCount;

  /// 표시할 개수. (외부 주입)
  final int count;

  /// 참여 가능한 최대 모임 개수. (groupCount 변형에서만 사용)
  final int maxCount;

  final _HomeDashboardVariant _variant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, value, caption) = switch (_variant) {
      _HomeDashboardVariant.groupCount => (
        l10n.groupCountLabel,
        l10n.groupCountValue(count, maxCount),
        l10n.groupCountCaption,
      ),
      _HomeDashboardVariant.updateCount => (
        l10n.updateCountLabel,
        l10n.updateCountValue(count),
        l10n.updateCountCaption,
      ),
    };

    return Container(
      // 폭은 열에 맞춰 stretch 되고 높이는 고정. (_dashboardHeight 주석 참고)
      height: _dashboardHeight,
      padding: const EdgeInsets.all(AppSpacing.s5),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0),
          end: Alignment(0.50, 1.00),
          colors: [AppColors.bgSurface, AppColors.bgAccentDeep],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      // 라벨 · 값 · 설명을 s2 간격으로 쌓고, 인디케이터가 빠진 자리만큼
      // 위아래 여백을 나눠 갖도록 세로 가운데에 둔다.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s2,
        children: [
          AppText.title(label, color: AppColors.textAccent),
          AppText.display(value),
          AppText.caption(caption),
        ],
      ),
    );
  }
}

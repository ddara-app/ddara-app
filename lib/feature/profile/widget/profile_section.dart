import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/designsystem/component/divider/app_divider.dart';
import '../../../core/designsystem/component/surface/app_surface.dart';
import '../../../core/designsystem/component/text/app_text.dart';

/// 프로필 화면의 "라벨 + 카드" 섹션.
///
/// [label] 아래 [AppSpacing.s3] 간격을 두고, 둥근 모서리 카드 안에 [children] 을
/// 세로로 쌓아 보여준다. 항목이 둘 이상이면 각 항목 사이에 카드 폭을 꽉 채우는
/// 가로 구분선을 넣는다. (카드 자체는 패딩을 주지 않으므로 내부 항목이 각자
/// 패딩을 갖고, 구분선은 여백 없이 끝까지 이어진다.)
///
/// ```dart
/// ProfileSection(
///   label: '계정',
///   children: [
///     ProfileRow(label: '가입일', value: '2026.06.16'),
///     ProfileRow(label: '이메일', value: 'a@b.com'),
///   ],
/// );
/// ```
class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.label,
    required this.children,
  });

  /// 카드 위에 표시할 섹션 라벨.
  final String label;

  /// 카드 내부에 세로로 쌓을 항목들. (둘 이상이면 사이에 구분선이 들어간다)
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.label(label),
        const SizedBox(height: AppSpacing.s3),
        AppSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _withDividers(children),
          ),
        ),
      ],
    );
  }

  /// 항목들 사이에 구분선을 끼워 넣는다. (항목이 하나면 구분선 없음)
  List<Widget> _withDividers(List<Widget> items) {
    return [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0) const AppDivider(),
        items[i],
      ],
    ];
  }
}

/// [ProfileSection] 카드 안에 들어가는 기본 행 항목.
///
/// 왼쪽에 [label], 오른쪽에 trailing 을 양 끝 정렬로 배치한다. trailing 은
/// [value] 텍스트이거나, [trailing] 으로 주입한 위젯(예: 화살표 아이콘)이다.
/// ([trailing] 이 [value] 보다 우선한다.) 둘 다 없으면 라벨만 있는 액션 행이다.
///
/// [labelColor] 로 라벨 색을 바꿀 수 있고(예: 로그아웃은 빨강),
/// [onTap] 을 주면 행 전체가 눌리는 버튼이 된다.
/// (누르면 [AppButton] 과 동일하게 살짝 페이드되는 효과를 준다.)
class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    this.labelColor,
  });

  /// 항목 이름. (예: '가입일', '알림 설정', '로그아웃')
  final String label;

  /// 항목 값 텍스트. (예: '2026.06.16') [trailing] 이 있으면 무시된다.
  final String? value;

  /// 오른쪽에 둘 커스텀 위젯. (예: '>' 화살표 아이콘)
  final Widget? trailing;

  /// 행을 눌렀을 때 실행할 콜백. null 이면 버튼이 아니다.
  final VoidCallback? onTap;

  /// 라벨 색. null 이면 [AppColors.textPrimary].
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText.body(label, color: labelColor ?? AppColors.textPrimary),
          if (trailing != null)
            trailing!
          else if (value != null)
            AppText.body(value!),
        ],
      ),
    );

    if (onTap == null) return row;
    // AppButton 과 동일한 CupertinoButton 의 눌림(페이드) 효과를 쓴다.
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: row,
    );
  }
}

/// [ProfileRow] 의 trailing 으로 쓰는 '>' 화살표 아이콘.
///
/// 눌러서 다른 화면으로 이동하는 행임을 나타낸다.
class ProfileChevron extends StatelessWidget {
  const ProfileChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.chevron_forward,
      size: 20,
      color: AppColors.textSecondary,
    );
  }
}

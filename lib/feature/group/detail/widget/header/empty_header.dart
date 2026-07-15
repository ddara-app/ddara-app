import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/feature/group/detail/widget/header/header_title.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임에 아직 따라찍기가 하나도 없을 때 상단에 보여주는 빈 상태 헤더.
///
/// 제목 + 안내 문구 + 일러스트로 구성하며, 화면 상단에 가로 중앙 정렬로 배치한다.
/// 버튼이 없는 순수 헤더라 다른 화면에서도 재사용할 수 있다.
class EmptyHeader extends StatelessWidget {
  const EmptyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      // 상하 s7, 좌우 s5 여백.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s5,
        vertical: AppSpacing.s7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s2,
        children: [
          HeaderTitle(
            title: l10n.groupDetailEmptyTitle,
            caption: l10n.emptyGroupDescription,
          ),
          Image.asset(
            'assets/images/photo_image.png',
            width: 160,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

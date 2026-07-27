import 'package:ddara/core/design_system/design_system.dart';
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
      // 상 s7 · 하 s8 · 좌우 s5 여백.
      padding: const EdgeInsets.only(
        left: AppSpacing.s5,
        right: AppSpacing.s5,
        top: AppSpacing.s7,
        bottom: AppSpacing.s8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s3,
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

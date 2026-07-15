import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 참여한 모임이 하나도 없을 때 보여주는 빈 상태 화면.
class EmptyGroupPage extends StatelessWidget {
  const EmptyGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      // 콘텐츠 영역을 전체폭으로 펴서 자식들이 화면 가로 중앙에 오도록 한다.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleDescription(
                title: l10n.emptyGroupTitle,
                description: l10n.emptyGroupDescription,
                centered: true,
              ),
              SizedBox(height: AppSpacing.s3),
              Image.asset(
                'assets/images/photo_image.png',
                width: 160,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        // 하단 액션 영역
        Padding(
          // 하단 여백은 s6, 항목 사이 간격은 s3.
          padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s3,
            children: [
              AppButton(
                label: l10n.groupCreate,
                onPressed: () => context.push(RoutePath.groupCreate),
              ),
              AppButton.outline(
                label: l10n.groupJoin,
                onPressed: () => context.push(RoutePath.inviteCodeInput),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

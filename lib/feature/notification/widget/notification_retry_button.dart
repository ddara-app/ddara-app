import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 조회 실패 안내에서 다시 불러오는 버튼.
///
/// 화면 가운데 안내 아래에 놓이므로 가로로 꽉 차는 [AppButton] 대신
/// 글자 폭에 맞춘 알약 모양을 쓴다.
class NotificationRetryButton extends StatelessWidget {
  const NotificationRetryButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s5,
          vertical: AppSpacing.s3,
        ),
        decoration: ShapeDecoration(
          // 흰 배경을 뜻하는 의미 토큰이 없어 primitive 를 직접 쓴다.
          color: AppColorPrimitives.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        child: AppText.label(
          AppLocalizations.of(context).notificationRetry,
          color: AppColors.textOnAccent,
        ),
      ),
    );
  }
}

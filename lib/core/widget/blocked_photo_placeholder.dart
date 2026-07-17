import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 차단한 멤버의 사진 자리표시. (surfaceAlt 배경 + 중앙 안내 문구)
///
/// 차단한 멤버의 사진이 노출될 자리에 사진 대신 보여준다.
/// 부모 제약을 채우므로 [Positioned.fill] 이나 고정 크기 컨테이너 안에서 쓴다.
class BlockedPhotoPlaceholder extends StatelessWidget {
  const BlockedPhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgSurfaceAlt,
      child: Center(
        child: AppText.caption(
          AppLocalizations.of(context).blockedPhotoPlaceholder,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

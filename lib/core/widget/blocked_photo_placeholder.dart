import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 가려야 하는 사진의 자리표시. (surfaceAlt 배경 + 중앙 안내 문구)
///
/// 차단한 멤버의 사진, 신고 접수로 검토 중인 사진 등 사진을 노출할 수 없는
/// 자리에 사진 대신 보여준다. [message] 를 주지 않으면 차단 안내 문구를 쓴다.
/// 부모 제약을 채우므로 [Positioned.fill] 이나 고정 크기 컨테이너 안에서 쓴다.
class BlockedPhotoPlaceholder extends StatelessWidget {
  const BlockedPhotoPlaceholder({super.key, this.message});

  /// 중앙에 표시할 안내 문구. null 이면 기본(차단한 멤버의 사진입니다.).
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgSurfaceAlt,
      child: Center(
        child: AppText.caption(
          message ?? AppLocalizations.of(context).blockedPhotoPlaceholder,
          textAlign: TextAlign.center,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

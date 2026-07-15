import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// '촬영하러 가기' 알약(pill) 버튼. 흰 배경 위에 라벨 텍스트를 둔다.
///
/// [size] 로 크기를 고른다.
/// - [TakePhotoButtonSize.normal] : 멤버 사진 카드 등 좁은 영역용.
/// - [TakePhotoButtonSize.large]  : 스타터 화면 등 넓은 영역용. (여백이 더 크다)
enum TakePhotoButtonSize { normal, large }

class TakePhotoButton extends StatelessWidget {
  const TakePhotoButton({
    super.key,
    required this.onPressed,
    this.size = TakePhotoButtonSize.normal,
  });

  final VoidCallback onPressed;
  final TakePhotoButtonSize size;

  @override
  Widget build(BuildContext context) {
    final isLarge = size == TakePhotoButtonSize.large;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? AppSpacing.s5 : AppSpacing.s4,
          vertical: isLarge ? AppSpacing.s3 : AppSpacing.s2,
        ),
        decoration: const ShapeDecoration(
          color: AppColors.textPrimary,
          shape: StadiumBorder(),
        ),
        child: AppText.label(
          AppLocalizations.of(context).photoTakeAction,
          color: AppColors.textOnWarm,
        ),
      ),
    );
  }
}

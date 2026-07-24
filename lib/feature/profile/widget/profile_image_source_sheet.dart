import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/bottom_sheet/sheet_scaffold.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 프로필 사진 변경 시 선택할 이미지 소스.
enum ProfileImageSource {
  /// 카메라로 직접 촬영.
  camera,

  /// 갤러리(사진 앱)에서 선택.
  gallery,

  /// 기본 이미지로 되돌리기.
  reset,
}

/// 프로필 사진 변경용 BottomSheet.
///
/// '사진 촬영'·'갤러리에서 선택' 두 가지 소스를 제시하고, 선택한 값을
/// [show] 의 결과로 반환한다. (아무것도 고르지 않고 닫으면 null)
///
/// ```dart
/// final source = await ProfileImageSourceSheet.show(context);
/// if (source == ProfileImageSource.camera) { ... }
/// ```
class ProfileImageSourceSheet extends StatelessWidget {
  const ProfileImageSourceSheet._({required this.showReset});

  /// '기본 이미지로 변경' 항목 노출 여부. (등록된 이미지가 있을 때만 의미 있음)
  final bool showReset;

  /// 시트를 띄우고 사용자가 고른 [ProfileImageSource] 를 반환한다.
  static Future<ProfileImageSource?> show(
    BuildContext context, {
    bool showReset = false,
  }) {
    return showCupertinoModalPopup<ProfileImageSource>(
      context: context,
      builder: (_) => ProfileImageSourceSheet._(showReset: showReset),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SheetScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.headlineMedium(l10n.profileImageSourceTitle),
          const SizedBox(height: AppSpacing.s3),
          _SourceTile(
            icon: AppIcons.cameraDefault,
            label: l10n.profileImageSourceCamera,
            onTap: () => Navigator.of(context).pop(ProfileImageSource.camera),
          ),
          _SourceTile(
            icon: AppIcons.galleryDefault,
            label: l10n.profileImageSourceGallery,
            onTap: () => Navigator.of(context).pop(ProfileImageSource.gallery),
          ),
          // 등록된 이미지가 있을 때만 기본 이미지로 되돌리기를 제시한다.
          if (showReset)
            _SourceTile(
              icon: AppIcons.personCropCircle,
              label: l10n.profileImageSourceReset,
              onTap: () => Navigator.of(context).pop(ProfileImageSource.reset),
            ),
        ],
      ),
    );
  }
}

/// 시트 안의 소스 선택 행. 좌측 아이콘 + 라벨로 구성한다.
class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// 좌측 아이콘.
  final AppIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Row(
        children: [
          AppIcon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.s3),
          AppText.body(label),
        ],
      ),
    );
  }
}

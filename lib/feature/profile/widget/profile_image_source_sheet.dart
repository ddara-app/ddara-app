import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 프로필 사진 변경 시 선택할 이미지 소스.
enum ProfileImageSource {
  /// 카메라로 직접 촬영.
  camera,

  /// 갤러리(사진 앱)에서 선택.
  gallery,
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
  const ProfileImageSourceSheet._();

  /// 시트를 띄우고 사용자가 고른 [ProfileImageSource] 를 반환한다.
  static Future<ProfileImageSource?> show(BuildContext context) {
    return showCupertinoModalPopup<ProfileImageSource>(
      context: context,
      builder: (_) => const ProfileImageSourceSheet._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s5,
            AppSpacing.s3,
            AppSpacing.s5,
            AppSpacing.s5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 드래그 핸들
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s4),
                  decoration: const ShapeDecoration(
                    color: AppColors.borderStrong,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              AppText.headlineMedium(l10n.profileImageSourceTitle),
              const SizedBox(height: AppSpacing.s3),
              _SourceTile(
                icon: CupertinoIcons.camera,
                label: l10n.profileImageSourceCamera,
                onTap: () =>
                    Navigator.of(context).pop(ProfileImageSource.camera),
              ),
              _SourceTile(
                icon: CupertinoIcons.photo,
                label: l10n.profileImageSourceGallery,
                onTap: () =>
                    Navigator.of(context).pop(ProfileImageSource.gallery),
              ),
            ],
          ),
        ),
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

  final IconData icon;
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
          Icon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.s3),
          AppText.body(label),
        ],
      ),
    );
  }
}

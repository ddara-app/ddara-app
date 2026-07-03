import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/feature/profile/widget/profile_image_source_sheet.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/designsystem/component/text/app_text.dart';

/// 프로필 화면 상단 헤더.
///
/// 80 크기의 [ProfileAvatar] 아래에 사용자 이름을 보여준다.
/// 아바타 우측 하단에는 이미지 변경용 편집 버튼(+)을 겹쳐 놓는다.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.imageUrl,
    required this.name,
    this.onImageSourceSelected,
  });

  /// 프로필 이미지 URL. null·빈 값이면 기본 아이콘을 보여준다.
  final String? imageUrl;

  /// 사용자 이름.
  final String name;

  /// 편집 버튼(+) 을 눌러 이미지 소스를 고른 뒤 호출된다.
  /// null 이면 편집 버튼을 눌러도 시트만 뜨고 선택은 무시된다.
  final ValueChanged<ProfileImageSource>? onImageSourceSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s2,
        children: [
          // 아바타 밖으로 삐져나오는 편집 버튼의 테두리가 잘리지 않도록 clip 을 해제한다.
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileAvatar(size: 80, imageUrl: imageUrl),
              Positioned(
                right: 0,
                bottom: 0,
                child: _EditImageButton(onTap: () => _pickImageSource(context)),
              ),
            ],
          ),
          AppText.headlineLarge(name),
        ],
      ),
    );
  }

  /// 이미지 소스 선택 시트를 띄우고, 고른 값을 [onImageSourceSelected] 로 전달한다.
  Future<void> _pickImageSource(BuildContext context) async {
    final source = await ProfileImageSourceSheet.show(context);
    if (source == null) return;
    onImageSourceSelected?.call(source);
  }
}

/// 프로필 이미지 변경용 원형 편집 버튼.
///
/// accent 배경에 bg-base 색 외곽 테두리를 두른 원형 버튼으로, 18 크기의 + 아이콘을 담는다.
class _EditImageButton extends StatelessWidget {
  const _EditImageButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // AppButton 과 동일하게 CupertinoButton 을 써서 탭 피드백(눌림 페이드)을 맞춘다.
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: ShapeDecoration(
          color: AppColors.accentDefault,
          shape: RoundedRectangleBorder(
            // 외곽 테두리를 박스 바깥쪽에 그려 배경과 배지를 분리한다.
            side: const BorderSide(
              width: 4,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: AppColors.bgBase,
            ),
            borderRadius: BorderRadius.circular(749.25),
          ),
        ),
        child: const Icon(
          CupertinoIcons.add,
          size: 18,
          color: AppColors.textOnAccent,
        ),
      ),
    );
  }
}

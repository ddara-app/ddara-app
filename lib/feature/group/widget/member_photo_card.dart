import 'dart:ui' show ImageFilter;

import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/blocked_photo_placeholder.dart';
import 'package:ddara/feature/group/widget/take_photo_button.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 멤버 사진 카드. 배경 이미지 위에 하단 이름 라벨을 표시한다.
/// 이미지와 이름은 외부에서 주입한다.
///
/// - 이미지가 없을 때: 본인 카드([onTakePhoto] 주입)면 '촬영하러 가기' 버튼을,
///   그 외에는 갤러리 아이콘을 가운데에 보여준다.
/// - [isLocked] 이면(본인이 아직 업로드 안 함) 타인 사진을 블러 처리하고
///   가운데에 자물쇠 아이콘을 표시한다.
/// - [isBlocked] 이면(차단한 멤버) 사진 대신 차단 자리표시를 보여준다.
/// - [isUnderReview] 이면(신고 접수) 사진 대신 검토 안내 자리표시를 보여준다.
class MemberPhotoCard extends StatelessWidget {
  const MemberPhotoCard({
    super.key,
    this.image,
    required this.name,
    this.onTakePhoto,
    this.onTap,
    this.onComment,
    this.heroTag,
    this.isLocked = false,
    this.isBlocked = false,
    this.isUnderReview = false,
  });

  /// 카드 배경 이미지. null 이면 가운데에 placeholder(버튼/아이콘)를 보여준다.
  final ImageProvider? image;

  /// 하단에 표시할 멤버 이름.
  final String name;

  /// 본인 카드이고 아직 미업로드일 때 '촬영하러 가기' 버튼을 눌렀을 때의 콜백.
  /// null 이면 본인 카드가 아니므로 갤러리 아이콘을 표시한다.
  final VoidCallback? onTakePhoto;

  /// 카드(사진)를 탭했을 때의 콜백. 크게 보기 등에 사용한다.
  /// 보통 사진이 있고 잠기지 않은 카드에만 연결한다. null 이면 탭에 반응하지 않는다.
  final VoidCallback? onTap;

  /// 우측 상단 댓글 버튼을 눌렀을 때의 콜백. 크게 보기를 댓글이 열린 채로
  /// 여는 데 쓴다. null 이면 버튼을 표시하지 않는다. (사진이 없는 카드 등)
  final VoidCallback? onComment;

  /// 크게 보기 전환에 쓸 Hero 태그. null 이면 Hero 전환을 하지 않는다.
  final Object? heroTag;

  /// 본인이 아직 업로드하지 않아 타인 사진이 잠긴 상태. (블러 + 자물쇠)
  final bool isLocked;

  /// 차단한 멤버의 카드인지 여부. (사진 대신 차단 자리표시를 보여준다)
  final bool isBlocked;

  /// 사진이 신고 접수로 검토 중인지 여부. (사진 대신 검토 안내 자리표시)
  final bool isUnderReview;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    final onTakePhoto = this.onTakePhoto;
    // 사진 대신 자리표시를 보여줘야 하는 상태. (차단이 검토보다 우선)
    final obscured = isBlocked || isUnderReview;
    // 잠금은 보여줄 사진이 있을 때만 의미가 있다. (자리표시는 잠그지 않는다)
    final locked = !obscured && isLocked && image != null;
    final heroTag = this.heroTag;

    // 배경 이미지(잠기지 않은 경우 Hero 로 감싸 크게 보기와 이어지게 한다).
    Widget? background;
    if (image != null && !locked) {
      background = Image(image: image, fit: BoxFit.cover);
      if (heroTag != null) {
        background = Hero(tag: heroTag, child: background);
      }
    }

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: double.infinity,
        height: 225,
        child: Stack(
          children: [
            // 배경: 차단·검토 자리표시 / 이미지(잠금 시 블러) / surface.
            Positioned.fill(
              child: isBlocked
                  ? const BlockedPhotoPlaceholder()
                  : isUnderReview
                  ? BlockedPhotoPlaceholder(
                      message: AppLocalizations.of(
                        context,
                      ).photoUnderReviewPlaceholder,
                    )
                  : image == null
                  ? const ColoredBox(color: AppColors.bgSurface)
                  : (locked
                        ? ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 12,
                              sigmaY: 12,
                            ),
                            child: Image(image: image, fit: BoxFit.cover),
                          )
                        : background!),
            ),
            // 잠금: 가운데 자물쇠.
            if (locked)
              const Center(
                child: AppIcon(
                  AppIcons.lock,
                  size: 32,
                  color: AppColors.textPrimary,
                ),
              )
            // 사진이 없을 때: 본인이면 촬영 버튼, 아니면 갤러리 아이콘.
            // (차단·검토 자리표시가 안내를 대신하므로 해당 카드는 제외)
            else if (image == null && !obscured)
              Center(
                child: onTakePhoto != null
                    ? TakePhotoButton(onPressed: onTakePhoto)
                    : const AppIcon(
                        AppIcons.gallery,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
              ),
            // 우측 상단 댓글 버튼. (차단·검토 자리표시 카드에는 띄우지 않는다)
            if (!obscured && onComment != null)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s3),
                  child: GestureDetector(
                    onTap: onComment,
                    child: Container(
                      // 아이콘 16 + 패딩 s2(8)×2 = 지름 32 원.
                      // (뷰어 우하단 말풍선의 축소판 — 지름 48)
                      padding: const EdgeInsets.all(AppSpacing.s2),
                      decoration: const BoxDecoration(
                        color: AppColors.overlayScrim,
                        shape: BoxShape.circle,
                      ),
                      child: const AppIcon(AppIcons.comment, size: 16),
                    ),
                  ),
                ),
              ),
            // 하단 이름 라벨. (차단·검토 중 카드는 닉네임도 노출하지 않는다)
            if (!obscured)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s3,
                      vertical: AppSpacing.s1,
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.overlayScrim,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    child: AppText.label(name, color: AppColors.textPrimary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // 탭 콜백이 있으면 카드 전체를 눌러 크게 보기로 연결한다.
    if (onTap == null) return card;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}

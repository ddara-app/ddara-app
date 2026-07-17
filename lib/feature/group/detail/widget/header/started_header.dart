import 'dart:ui' show ImageFilter;

import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/widget/blocked_photo_placeholder.dart';
import 'package:ddara/core/widget/effect/bottom_scrim.dart';
import 'package:ddara/core/widget/effect/progressive_blur_image.dart';
import 'package:ddara/core/widget/empty_thumbnail.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 모임에 따라찍기가 시작된 뒤 상단에 보여주는 헤더. ([EmptyHeader] 의 반대 상태)
///
/// 대표 이미지를 중심으로 구성하며, 우측 하단 토글 버튼으로 펼침/접힘을 전환한다.
/// 버튼이 없는 순수 헤더라 다른 화면에서도 재사용할 수 있다.
class StartedHeader extends StatefulWidget {
  const StartedHeader({
    super.key,
    required this.imageUri,
    required this.progress,
    this.onImageTap,
    this.starterBlocked = false,
  });

  /// 대표로 보여줄 이미지 URI.
  final String imageUri;

  /// 진행 중인 따라찍기(사이클) 정보.
  final GroupCycle progress;

  /// 대표 이미지를 탭했을 때의 콜백. (크게 보기 등) null 이면 탭에 반응하지 않는다.
  final VoidCallback? onImageTap;

  /// 스타터를 차단한 상태인지 여부.
  ///
  /// true 면 대표 이미지 대신 자리표시([BlockedPhotoPlaceholder])를 보여주고
  /// 크게 보기(탭)를 막는다.
  final bool starterBlocked;

  @override
  State<StartedHeader> createState() => _StartedHeaderState();
}

class _StartedHeaderState extends State<StartedHeader> {
  /// 헤더 펼침 여부. (true: 큰 이미지 헤더 / false: 축소된 헤더)
  bool _expanded = true;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      // 위 고정 헤더라 접힐 때 위에서부터 높이가 줄도록 상단 기준 정렬.
      alignment: Alignment.topCenter,
      crossFadeState: _expanded
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _buildExpanded(),
      secondChild: _buildCollapsed(),
    );
  }

  /// 펼친 상태: 대표 이미지 + 진행 정보 + 하단 스크림.
  Widget _buildExpanded() {
    // 차단한 스타터의 사진은 크게 보기를 막는다.
    final onImageTap = widget.starterBlocked ? null : widget.onImageTap;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: double.infinity,
        height: 478,
        child: Stack(
          children: [
            // 배경: 스타터 대표 이미지. (아래로 갈수록 부드럽게 블러, 탭하면 크게 보기)
            Positioned.fill(
              child: onImageTap == null
                  ? _blurredBackground()
                  : GestureDetector(
                      onTap: onImageTap,
                      child: _blurredBackground(),
                    ),
            ),
            // 하단 진행 정보의 가독성을 위한 스크림.
            const BottomScrim(
              heightFactor: 0.45,
              color: AppColors.bgBase,
              maxAlpha: 0.5,
            ),
            // 콘텐츠: 상단 남은 시간 + 하단 진행 정보.
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.s4,
                bottom: AppSpacing.s5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.caption(
                          _statusText(),
                          textAlign: TextAlign.center,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                  _buildInfoRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 접은 상태: 블러 처리된 대표 이미지 배경 위 진행 정보만.
  Widget _buildCollapsed() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Stack(
        children: [
          // 블러 처리된 스타터 대표 이미지 배경.
          // (차단 자리표시는 민무늬 배경이라 블러를 걸지 않는다)
          Positioned.fill(
            child: widget.starterBlocked
                ? _backgroundImage()
                : ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: _backgroundImage(),
                  ),
          ),
          // 텍스트 대비를 위한 어두운 오버레이 + 진행 정보.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
            color: Colors.black.withValues(alpha: 0.50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_buildInfoRow()],
            ),
          ),
        ],
      ),
    );
  }

  /// 진행 정보(회차·제목·시작자) + 펼침/접힘 토글 버튼 한 줄.
  Widget _buildInfoRow() {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s1,
              children: [
                AppText.label(
                  l10n.startedHeaderCycle(widget.progress.cycleNumber),
                  textAlign: TextAlign.center,
                  color: AppColors.textAccent,
                ),
                AppText.display(
                  widget.progress.topic,
                  textAlign: TextAlign.left,
                ),
                AppText.body(
                  l10n.startedHeaderStarter(widget.progress.starterNickname),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          _buildToggleButton(),
        ],
      ),
    );
  }

  /// 하단 스크림 구간(heightFactor 0.45)에 맞춰 아래로 갈수록 흐려지는 배경.
  Widget _blurredBackground() {
    // 차단 자리표시는 민무늬 배경이라 그라데이션 블러가 필요 없다.
    if (widget.starterBlocked) return _backgroundImage();
    return ProgressiveBlurImage(
      sharpUntil: 0.55,
      builder: (_) => _backgroundImage(),
    );
  }

  /// 헤더 배경으로 쓸 이미지. URI 가 없거나 로드 실패 시 자리표시로 대체한다.
  /// 스타터를 차단했으면 사진 대신 차단 자리표시를 보여준다.
  Widget _backgroundImage() {
    if (widget.starterBlocked) {
      return const BlockedPhotoPlaceholder();
    }
    final url = widget.imageUri;
    if (url.isEmpty) {
      return const EmptyThumbnail();
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const EmptyThumbnail(),
    );
  }

  /// 헤더 상단 상태 문구.
  /// 마감(done)된 회차는 '마감'만, 진행 중이면 '진행 중 · N 남음'을 보여준다.
  String _statusText() {
    final l10n = AppLocalizations.of(context);
    if (widget.progress.status.toLowerCase() == 'done') {
      return l10n.remainingDeadline; // '마감'
    }
    return l10n.startedHeaderRemaining(
      _remainingText(widget.progress.deadlineAt),
    );
  }

  /// 마감(deadline)까지 남은 시간 표시 문자열. ('14시간' / '30분' / '마감')
  String _remainingText(DateTime deadline) {
    final l10n = AppLocalizations.of(context);
    final remaining = deadline.difference(DateTime.now());
    if (remaining.isNegative) return l10n.remainingDeadline;
    if (remaining.inHours >= 1) return l10n.remainingHours(remaining.inHours);
    return l10n.remainingMinutes(remaining.inMinutes);
  }

  /// 펼침/접힘 토글 버튼. (펼침: ∧ / 접힘: ∨)
  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: ShapeDecoration(
          color: const Color(0x1E949494),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        child: Icon(
          _expanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
          size: 24,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

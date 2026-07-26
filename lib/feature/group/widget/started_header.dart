import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/blocked_photo_placeholder.dart';
import 'package:ddara/core/widget/effect/bottom_scrim.dart';
import 'package:ddara/core/widget/effect/progressive_blur_image.dart';
import 'package:ddara/core/widget/image/empty_thumbnail.dart';
import 'package:ddara/feature/group/widget/anchored_context_menu.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// [StartedHeader] 가 그리는 데 필요한 값만 담은 표시용 정보.
///
/// 화면마다 원본 모델이 다르므로(모임 상세: `GroupCycle`, 갤러리:
/// `CycleGallery`) 헤더는 도메인 모델 대신 이 객체만 받는다. 헤더가 쓰지
/// 않는 필드를 억지로 채워 넣을 필요가 없다.
class StarterHeaderInfo {
  const StarterHeaderInfo({
    required this.topic,
    required this.starterNickname,
    required this.imageUrl,
    required this.imageUnderReview,
    required this.isDone,
    required this.deadlineAt,
    required this.participantCount,
  });

  /// 따라찍기 주제.
  final String topic;

  /// 스타터 닉네임. (우/좌상단 안내 칩)
  final String starterNickname;

  /// 대표로 보여줄 스타터 사진 URL. 없으면 빈 자리표시를 보여준다.
  final String? imageUrl;

  /// 스타터 사진이 신고 접수로 검토 중인지 여부.
  final bool imageUnderReview;

  /// 마감된 회차인지 여부. (진행 중이면 남은 시간을 함께 보여준다)
  final bool isDone;

  /// 마감 시각. (남은 시간 계산)
  final DateTime deadlineAt;

  /// 이번 회차에 사진을 올린 인원. (스타터 포함)
  final int participantCount;
}

/// 모임에 따라찍기가 시작된 뒤 상단에 보여주는 헤더. ([EmptyHeader] 의 반대 상태)
///
/// 대표 이미지를 중심으로 구성하며, 우측 하단 토글 버튼으로 펼침/접힘을 전환한다.
/// 버튼이 없는 순수 헤더라 다른 화면에서도 재사용할 수 있다.
class StartedHeader extends StatefulWidget {
  const StartedHeader({
    super.key,
    required this.info,
    this.onImageTap,
    this.onComment,
    this.onReport,
    this.onBlock,
    this.starterBlocked = false,
    this.memberCount,
  });

  /// 헤더에 그릴 진행 정보.
  final StarterHeaderInfo info;

  /// 모임 총원. 지정하면 진행 상태 우측에 참여 인원(아이콘 + n/총원)을 보여준다.
  /// null 이면 참여 인원 칩을 숨긴다.
  final int? memberCount;

  /// 대표 이미지를 탭했을 때의 콜백. (크게 보기 등) null 이면 탭에 반응하지 않는다.
  final VoidCallback? onImageTap;

  /// 우상단 댓글 버튼을 눌렀을 때의 콜백. (크게 보기를 댓글이 열린 채로 여는 데
  /// 쓴다) null 이면 버튼을 표시하지 않는다. (펼친 상태·사진이 보일 때만 노출)
  final VoidCallback? onComment;

  /// 대표 이미지를 롱프레스해 '신고하기'를 선택했을 때.
  /// null 이면 메뉴에 신고 항목이 뜨지 않는다. (펼친 상태에서만 동작)
  final VoidCallback? onReport;

  /// 대표 이미지를 롱프레스해 '차단하기'를 선택했을 때.
  /// null 이면 메뉴에 차단 항목이 뜨지 않는다. (펼친 상태에서만 동작)
  final VoidCallback? onBlock;

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

  /// 대표로 보여줄 스타터 사진 URL. 없으면 빈 문자열.
  String get _imageUrl => widget.info.imageUrl ?? '';

  /// 스타터 사진이 신고 접수로 검토 중인지 여부.
  bool get _underReview => widget.info.imageUnderReview;

  /// 사진을 자리표시로 가려야 하는 상태인지. (차단 또는 검토 중)
  bool get _obscured => widget.starterBlocked || _underReview;

  /// 컨텍스트 메뉴(신고·차단)를 띄울 수 있는지.
  /// (콜백 하나라도 有 + 이미지 有 + 가림 상태 아님 — 검토 중·차단된 사진은
  /// 메뉴를 띄우지 않는다)
  bool get _canOpenMenu =>
      (widget.onReport != null || widget.onBlock != null) &&
      !_obscured &&
      _imageUrl.isNotEmpty;

  /// 우상단 댓글 버튼을 그리는 상태인지.
  /// (가려진 사진은 크게 보기가 막히므로 버튼도 숨긴다)
  ///
  /// 버튼이 우상단을 차지하면 스타터 안내 pill 은 좌상단으로 비켜난다.
  bool get _showCommentButton => widget.onComment != null && !_obscured;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      // 위 고정 헤더라 접힐 때 위에서부터 높이가 줄도록 상단 기준 정렬.
      alignment: Alignment.topCenter,
      crossFadeState: _expanded
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _buildExpanded(),
      secondChild: _buildCollapsed(),
    );

    // 접은 상태에서는 대표 이미지가 배경으로만 남으므로 메뉴를 띄우지 않는다.
    if (!_expanded || !_canOpenMenu) return content;

    // 헤더가 화면 상단에 붙어 있어 위쪽 공간이 없다 — 메뉴를 이미지 안쪽에 띄운다.
    return AnchoredContextMenu(
      placement: ContextMenuPlacement.insideTopLeft,
      // 멤버 아바타 메뉴와 같은 순서. (차단하기 → 신고하기)
      actions: [
        if (widget.onBlock != null)
          (
            label: l10n.memberBlock,
            color: AppColors.statusDanger,
            onSelect: widget.onBlock!,
          ),
        if (widget.onReport != null)
          (
            label: l10n.report,
            color: AppColors.statusDanger,
            onSelect: widget.onReport!,
          ),
      ],
      // 사본은 헤더와 같은 크기·모서리로 배경 이미지만 다시 그린다.
      overlayBuilder: (_, targetSize) => SizedBox.fromSize(
        size: targetSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: _blurredBackground(),
        ),
      ),
      child: content,
    );
  }

  /// 펼친 상태: 대표 이미지 + 진행 정보 + 하단 스크림.
  Widget _buildExpanded() {
    final l10n = AppLocalizations.of(context);
    // 가려진(차단·검토 중) 사진은 크게 보기를 막는다.
    final onImageTap = _obscured ? null : widget.onImageTap;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: double.infinity,
        height: 478,
        child: Stack(
          children: [
            // 배경: 스타터 대표 이미지. (아래로 갈수록 부드럽게 블러)
            // 탭하면 크게 보기. 길게 누르면 뜨는 신고·차단 메뉴는 헤더 전체를
            // 감싼 AnchoredContextMenu 가 처리한다.
            Positioned.fill(
              child: GestureDetector(
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
            // 콘텐츠: 하단 진행 정보. (진행 상태 표시는 진행 정보 안으로 옮겼다)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_buildInfoRow()],
              ),
            ),
            // 스타터 안내 pill. (스타터 · 닉네임)
            // 기본은 우상단이고, 댓글 버튼이 그 자리를 쓰면 좌상단으로 비켜난다.
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.s4,
                left: _showCommentButton ? AppSpacing.s4 : 0,
                right: _showCommentButton ? 0 : AppSpacing.s4,
              ),
              child: Align(
                alignment: _showCommentButton
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: _pill(
                  child: AppText.caption(
                    l10n.startedHeaderStarterChip(widget.info.starterNickname),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            // 우상단: 댓글 버튼.
            if (_showCommentButton)
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.s4,
                  right: AppSpacing.s4,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: widget.onComment,
                    child: Container(
                      // 아이콘 24 + 패딩 s3(12)×2 = 지름 48 원.
                      padding: const EdgeInsets.all(AppSpacing.s3),
                      decoration: const BoxDecoration(
                        color: AppColors.overlayScrim,
                        shape: BoxShape.circle,
                      ),
                      child: const AppIcon(AppIcons.comment, size: 24),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 접은 상태: 블러 처리된 대표 이미지 배경 위 진행 정보만.
  Widget _buildCollapsed() {
    // 가려진(차단·검토 중) 사진은 펼친 상태와 마찬가지로 탭을 막는다.
    final onImageTap = _obscured ? null : widget.onImageTap;
    // 진행 정보 오버레이가 배경을 덮고 있어, 탭은 헤더 전체에서 받는다.
    // (토글 버튼은 자식이라 자기 탭을 먼저 가져간다)
    return GestureDetector(
      onTap: onImageTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // 블러 처리된 스타터 대표 이미지 배경.
            // (차단·검토 자리표시는 민무늬 배경이라 블러를 걸지 않는다)
            Positioned.fill(
              child: _obscured
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
              color: AppColors.overlayScrimSoft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_buildInfoRow()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 진행 정보(상태 · 제목) + 펼침/접힘 토글 버튼 한 줄.
  Widget _buildInfoRow() {
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
                // 좌상단에 있던 진행 상태(검정 60% pill)를 주제 위로 옮기고,
                // 같은 배경 안에서 가운데 점으로 참여 인원(아이콘 + n/총원)을 잇는다.
                _pill(
                  // 항목 간격이 제각각이라 Row spacing 대신 각자 여백을 준다.
                  // (상태·인원수 바깥 여백은 pill 의 좌우 패딩 s5 가 전부)
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText.caption(
                        _statusText(),
                        color: AppColors.textPrimary,
                      ),
                      if (widget.memberCount != null) ...[
                        // 가운데 점 좌우로만 s2 를 띄운다.
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s2,
                          ),
                          child: AppText.caption(
                            '·',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // 아이콘과 인원수는 한 덩어리로 읽히도록 s1 만 띄운다.
                        const AppIcon(
                          AppIcons.people,
                          size: 14,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        AppText.caption(
                          '${widget.info.participantCount}'
                          '/${widget.memberCount}',
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ],
                  ),
                ),
                AppText.display(widget.info.topic, textAlign: TextAlign.left),
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
    // 차단·검토 자리표시는 민무늬 배경이라 그라데이션 블러가 필요 없다.
    if (_obscured) return _backgroundImage();
    return ProgressiveBlurImage(
      sharpUntil: 0.55,
      builder: (_) => _backgroundImage(),
    );
  }

  /// 헤더 배경으로 쓸 이미지. URI 가 없거나 로드 실패 시 자리표시로 대체한다.
  /// 스타터 차단 또는 신고 검토 중이면 사진 대신 안내 자리표시를 보여준다.
  Widget _backgroundImage() {
    if (widget.starterBlocked) {
      return const BlockedPhotoPlaceholder();
    }
    if (_underReview) {
      return BlockedPhotoPlaceholder(
        message: AppLocalizations.of(context).photoUnderReviewPlaceholder,
      );
    }
    final url = _imageUrl;
    if (url.isEmpty) {
      return const EmptyThumbnail();
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => const EmptyThumbnail(),
      errorWidget: (_, _, _) => const EmptyThumbnail(),
    );
  }

  /// 검정 60% 원형(pill) 배경 위에 [child] 를 얹는 공통 칩.
  Widget _pill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s5,
        vertical: AppSpacing.s2,
      ),
      decoration: const ShapeDecoration(
        color: AppColorPrimitives.black60,
        shape: StadiumBorder(),
      ),
      child: child,
    );
  }

  /// 헤더 상단 상태 문구.
  /// 마감(done)된 회차는 '마감'만, 진행 중이면 '진행 중 · N 남음'을 보여준다.
  String _statusText() {
    final l10n = AppLocalizations.of(context);
    if (widget.info.isDone) {
      return l10n.remainingDeadline; // '마감'
    }
    return l10n.startedHeaderRemaining(_remainingText(widget.info.deadlineAt));
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
          color: AppColors.overlayControl,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        child: AppIcon(
          _expanded ? AppIcons.chevronUp : AppIcons.chevronDown,
          size: 24,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

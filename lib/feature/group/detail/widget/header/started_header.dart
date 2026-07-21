import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/widget/blocked_photo_placeholder.dart';
import 'package:ddara/core/widget/effect/bottom_scrim.dart';
import 'package:ddara/core/widget/effect/progressive_blur_image.dart';
import 'package:ddara/core/widget/image/empty_thumbnail.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.onReport,
    this.onBlock,
    this.starterBlocked = false,
    this.memberCount,
  });

  /// 대표로 보여줄 이미지 URI.
  final String imageUri;

  /// 진행 중인 따라찍기(사이클) 정보.
  final GroupCycle progress;

  /// 모임 총원. 지정하면 진행 상태 우측에 참여 인원(아이콘 + n/총원)을 보여준다.
  /// null 이면 참여 인원 칩을 숨긴다.
  final int? memberCount;

  /// 대표 이미지를 탭했을 때의 콜백. (크게 보기 등) null 이면 탭에 반응하지 않는다.
  final VoidCallback? onImageTap;

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

  /// 헤더 위치를 신고 메뉴가 따라가게 잇는 링크.
  final LayerLink _link = LayerLink();

  /// 열려 있는 신고 메뉴 라우트. 닫혀 있으면 null.
  Route<void>? _menuRoute;

  /// 오버레이에 띄울 헤더 사본 크기. (메뉴를 열 때 측정)
  Size? _copySize;

  /// 스타터 사진이 신고 접수로 검토 중인지 여부.
  bool get _underReview => widget.progress.starterImageUnderReview;

  /// 사진을 자리표시로 가려야 하는 상태인지. (차단 또는 검토 중)
  bool get _obscured => widget.starterBlocked || _underReview;

  /// 컨텍스트 메뉴(신고·차단)를 띄울 수 있는지.
  /// (콜백 하나라도 有 + 이미지 有 + 가림 상태 아님 — 검토 중·차단된 사진은
  /// 메뉴를 띄우지 않는다)
  bool get _canOpenMenu =>
      (widget.onReport != null || widget.onBlock != null) &&
      !_obscured &&
      widget.imageUri.isNotEmpty;

  void _toggle() => setState(() => _expanded = !_expanded);

  void _openMenu() {
    if (_menuRoute != null) return;
    // 사본이 원본 헤더와 정확히 겹치도록 현재 크기를 기억해 둔다.
    _copySize = context.size;
    // 메뉴를 라우트로 띄워 뒤로가기(Android)가 화면 pop 대신 메뉴 닫기가
    // 되도록 한다. (스크림·바깥 탭 닫기는 라우트 배리어가 처리)
    final route = RawDialogRoute<void>(
      barrierColor: AppColorPrimitives.black60,
      barrierLabel: AppLocalizations.of(context).commonCancel,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => _buildMenuOverlay(dialogContext),
    );
    _menuRoute = route;
    Navigator.of(context).push(route).then((_) => _menuRoute = null);
  }

  /// 메뉴를 닫은 뒤 선택한 항목의 콜백을 실행한다.
  void _select(BuildContext dialogContext, VoidCallback onSelect) {
    Navigator.of(dialogContext).pop();
    onSelect();
  }

  @override
  void dispose() {
    // 헤더가 사라지면(화면 전환 등) 열려 있던 메뉴 라우트도 함께 닫는다.
    final route = _menuRoute;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 250),
        // 위 고정 헤더라 접힐 때 위에서부터 높이가 줄도록 상단 기준 정렬.
        alignment: Alignment.topCenter,
        crossFadeState: _expanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: _buildExpanded(),
        secondChild: _buildCollapsed(),
      ),
    );
  }

  /// 컨텍스트 메뉴(신고·차단) 오버레이. 배경을 블러 처리하고 헤더 사본 위에
  /// 메뉴를 띄운다.
  Widget _buildMenuOverlay(BuildContext dialogContext) {
    final copySize = _copySize;
    return Stack(
      children: [
        // 대상 헤더(이미지) 사본을 스크림 위로 띄워 선명하게 유지한다.
        if (copySize != null)
          CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.topLeft,
            child: IgnorePointer(
              child: SizedBox.fromSize(
                size: copySize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: _blurredBackground(),
                ),
              ),
            ),
          ),
        // 헤더가 화면 상단에 붙어 있어 메뉴는 이미지 안쪽 좌상단에 앵커한다.
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(AppSpacing.s3, AppSpacing.s3),
          child: _menu(dialogContext),
        ),
      ],
    );
  }

  Widget _menu(BuildContext dialogContext) {
    final l10n = AppLocalizations.of(context);
    // 멤버 아바타 메뉴와 같은 순서. (차단하기 → 신고하기)
    final actions = <({String label, VoidCallback onSelect})>[
      if (widget.onBlock != null)
        (label: l10n.memberBlock, onSelect: widget.onBlock!),
      if (widget.onReport != null)
        (label: l10n.report, onSelect: widget.onReport!),
    ];
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColorPrimitives.black40,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      // 항목들의 폭을 가장 긴 라벨에 맞춰 통일한다.
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) Container(height: 1, color: AppColors.borderDefault),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: AppSpacing.s3,
                ),
                minimumSize: Size.zero,
                onPressed: () => _select(dialogContext, actions[i].onSelect),
                child: AppText.body(
                  actions[i].label,
                  color: AppColors.statusDanger,
                ),
              ),
            ],
          ],
        ),
      ),
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
            // 배경: 스타터 대표 이미지.
            // (아래로 갈수록 부드럽게 블러, 탭하면 크게 보기, 길게 누르면
            // 신고·차단 메뉴)
            Positioned.fill(
              child: GestureDetector(
                onTap: onImageTap,
                onLongPress: _canOpenMenu ? _openMenu : null,
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
            // 우상단: 스타터 안내 pill. (스타터 · 닉네임)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.s4,
                right: AppSpacing.s4,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: _pill(
                  child: AppText.caption(
                    l10n.startedHeaderStarterChip(
                      widget.progress.starterNickname,
                    ),
                    color: AppColors.textPrimary,
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
    return ClipRRect(
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: AppSpacing.s1,
                    children: [
                      AppText.caption(
                        _statusText(),
                        color: AppColors.textPrimary,
                      ),
                      if (widget.memberCount != null) ...[
                        AppText.caption('·', color: AppColors.textPrimary),
                        SvgPicture.asset(
                          'assets/images/ic_people.svg',
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        AppText.caption(
                          '${widget.progress.uploadedUserIds.length + 1}'
                          '/${widget.memberCount}',
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ],
                  ),
                ),
                AppText.display(
                  widget.progress.topic,
                  textAlign: TextAlign.left,
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
    final url = widget.imageUri;
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
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s1,
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

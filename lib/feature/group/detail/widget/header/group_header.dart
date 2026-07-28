import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/feature/group/detail/widget/header/empty_header.dart';
import 'package:ddara/feature/group/widget/started_header.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 상세 화면 상단 헤더.
///
/// [imageUri] 가 없으면(따라찍기 전) [EmptyHeader] 를, 있으면 해당 이미지를 보여준다.
class GroupHeader extends StatelessWidget {
  const GroupHeader({
    super.key,
    this.imageUri,
    required this.progress,
    required this.memberCount,
    required this.navigateToStart,
    required this.onTakePhoto,
    required this.onStarterImageTap,
    this.canStart = true,
    this.starterBlocked = false,
  });

  /// 대표로 보여줄 이미지 URI. null/빈 값이면 빈 상태로 본다.
  final String? imageUri;

  /// 진행 중인 따라찍기(사이클). null 이면 진행 중이 아니라 빈 상태로 본다.
  final GroupCycle? progress;

  /// 모임 총원. (헤더의 참여 인원 표시 'n/총원'에 사용)
  final int memberCount;

  /// 빈 상태에서 '스타터 시작하기' 버튼을 눌렀을 때 실행할 콜백.
  final VoidCallback navigateToStart;

  /// 시작된 상태에서 '촬영하러 가기' 버튼을 눌렀을 때 실행할 콜백.
  final VoidCallback onTakePhoto;

  /// 스타터 대표 사진을 탭했을 때 실행할 콜백. (사이클 갤러리로 이동)
  final VoidCallback onStarterImageTap;

  /// 따라찍기를 시작할 수 있는지 여부. (멤버가 부족하면 시작 버튼을 비활성화)
  final bool canStart;

  /// 진행 중 사이클의 스타터를 차단한 상태인지 여부.
  /// (true 면 헤더에 스타터 사진 대신 차단 자리표시를 보여준다)
  final bool starterBlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cycle = progress;
    // 진행 중인 사이클이 없으면 빈 상태 헤더 + 시작 버튼.
    if (cycle == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EmptyHeader(),
          const SizedBox(height: AppSpacing.s7),
          // 멤버가 부족하면 시작 버튼을 비활성화한다.
          AppButton(
            label: l10n.groupHeaderStart,
            onPressed: canStart ? navigateToStart : null,
          ),
        ],
      );
    }

    // 따라찍기가 시작된 상태의 헤더 + 촬영 버튼.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 사진 신고는 갤러리에서만 지원하므로 onReport 는 연결하지 않는다.
        StartedHeader(
          info: StarterHeaderInfo(
            topic: cycle.topic,
            starterNickname: cycle.starterNickname,
            imageUrl: cycle.starterImageUrl,
            imageUnderReview: cycle.starterImageUnderReview,
            isDone: cycle.status.toLowerCase() == 'done',
            deadlineAt: cycle.deadlineAt,
            // 사진을 올린 멤버 + 스타터 본인.
            participantCount: cycle.uploadedUserIds.length + 1,
          ),
          starterBlocked: starterBlocked,
          memberCount: memberCount,
          // 스타터 사진 탭 → 이번 회차 사진 갤러리로 이동.
          // (차단·검토 중이면 헤더가 자체적으로 탭을 막는다)
          onImageTap: onStarterImageTap,
        ),
        const SizedBox(height: AppSpacing.s6),
        // 스타터 차단·신고 검토 중이면 가이드 사진을 볼 수 없으므로
        // 촬영 버튼을 비활성화한다.
        AppButton(
          label: l10n.groupHeaderTakePhoto,
          onPressed: starterBlocked || cycle.starterImageUnderReview
              ? null
              : onTakePhoto,
        ),
      ],
    );
  }
}

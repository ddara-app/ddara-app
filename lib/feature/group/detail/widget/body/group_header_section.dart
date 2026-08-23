import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/feature/group/detail/group_page_actions.dart';
import 'package:ddara/feature/group/detail/widget/header/group_header.dart';
import 'package:flutter/cupertino.dart';

/// 따라찍기를 시작할 수 있는 최소 인원. (이 수 미만이면 시작 버튼 비활성화)
const int _minMembersToStart = 2;

/// 모임 화면 최상단 헤더 자리. 진행 중인 사이클을 [GroupHeader] 에 넘기고,
/// 시작·촬영·사진 탭을 갤러리 이동으로 잇는다.
class GroupHeaderSection extends StatelessWidget {
  const GroupHeaderSection({
    super.key,
    required this.detail,
    required this.blockedUserIds,
    required this.actions,
  });

  final GroupDetail detail;

  /// 내가 차단한 유저 id 집합. (스타터를 차단했으면 사진 대신 자리표시)
  final Set<int> blockedUserIds;

  final GroupPageActions actions;

  @override
  Widget build(BuildContext context) {
    final cycle = detail.currentCycle;
    // 사진·촬영 버튼은 진행 중 사이클이 있을 때만 노출되므로 cycleId 가 존재한다.
    void openGallery() {
      final cycleId = cycle?.cycleId;
      if (cycleId == null) return;
      actions.pushGallery(cycleId);
    }

    return Padding(
      // 좌우 여백은 일단 헤더에만 적용한다.
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
      child: GroupHeader(
        // 진행 중인 사이클을 그대로 전달. null 이면 헤더가 빈 상태를 보여준다.
        progress: cycle,
        // 헤더의 참여 인원 표시 'n/총원'에 쓸 모임 총원.
        memberCount: detail.members.length,
        // 멤버가 최소 인원 미만이면 시작 버튼을 비활성화한다.
        canStart: detail.members.length >= _minMembersToStart,
        // 스타터를 차단했으면 헤더에 사진 대신 차단 자리표시를 보여준다.
        starterBlocked: blockedUserIds.contains(cycle?.starterUserId),
        navigateToStart: actions.pushStarter,
        onTakePhoto: openGallery,
        // 스타터 사진 탭 → 히스토리 카드와 동일하게 사진 갤러리로 이동.
        onStarterImageTap: openGallery,
      ),
    );
  }
}

import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/feature/group/random_starter/util/starter_reel.dart';
import 'package:flutter/widgets.dart';

/// 스타터 슬롯머신 릴.
///
/// 배경 박스 없이 릴이 화면 배경 위에 그대로 떠서 움직이고, 위아래 딤
/// 그라디언트([_SlotFade])로만 경계를 표시한다. 가로 폭은 부모를 따라간다.
class StarterSlotMachine extends StatelessWidget {
  const StarterSlotMachine({
    super.key,
    required this.reelMembers,
    required this.offsetY,
  });

  /// 릴에 그릴 멤버 목록. ([buildStarterReel] 결과)
  final List<GroupMember> reelMembers;

  /// 릴 세로 오프셋. ([buildStarterReelOffset] 값)
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        height: StarterReelLayout.windowHeight,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, offsetY),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final member in reelMembers) ...[
                      SizedBox(
                        height: StarterReelLayout.itemHeight,
                        child: Center(
                          child: ProfileAvatar(
                            size: StarterReelLayout.itemHeight,
                            imageUrl: member.profileImageUrl,
                          ),
                        ),
                      ),
                      const SizedBox(height: StarterReelLayout.itemGap),
                    ],
                  ],
                ),
              ),
            ),
            const _SlotFade(alignment: Alignment.topCenter),
            const _SlotFade(alignment: Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }
}

/// 창 위아래에서 릴을 배경색으로 자연스럽게 지우는 딤 그라디언트.
class _SlotFade extends StatelessWidget {
  const _SlotFade({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isTop = alignment == Alignment.topCenter;
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: double.infinity,
          height: StarterReelLayout.fadeHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
              end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
              colors: [AppColors.bgBase, AppColors.bgBase.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}

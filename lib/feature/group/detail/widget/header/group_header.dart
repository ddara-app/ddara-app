import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/feature/group/detail/widget/header/empty_header.dart';
import 'package:ddara/feature/group/detail/widget/header/started_header.dart';
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
    required this.navigateToStart,
    required this.onTakePhoto,
    this.canStart = true,
  });

  /// 대표로 보여줄 이미지 URI. null/빈 값이면 빈 상태로 본다.
  final String? imageUri;

  /// 진행 중인 따라찍기(사이클). null 이면 진행 중이 아니라 빈 상태로 본다.
  final GroupCycle? progress;

  /// 빈 상태에서 '스타터 시작하기' 버튼을 눌렀을 때 실행할 콜백.
  final VoidCallback navigateToStart;

  /// 시작된 상태에서 '촬영하러 가기' 버튼을 눌렀을 때 실행할 콜백.
  final VoidCallback onTakePhoto;

  /// 따라찍기를 시작할 수 있는지 여부. (멤버가 부족하면 시작 버튼을 비활성화)
  final bool canStart;

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
          const SizedBox(height: AppSpacing.s6),
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
        StartedHeader(imageUri: cycle.starterImageUrl ?? "", progress: cycle),
        const SizedBox(height: AppSpacing.s5),
        AppButton(label: l10n.groupHeaderTakePhoto, onPressed: onTakePhoto),
      ],
    );
  }
}

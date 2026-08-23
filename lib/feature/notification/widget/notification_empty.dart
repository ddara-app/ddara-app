import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:flutter/widgets.dart';

/// 알림 목록 대신 보여주는 안내 화면. (문구 두 줄 + 일러스트)
///
/// 받은 알림이 아예 없을 때·탭과 칩으로 걸러낸 결과가 없을 때·조회에 실패했을
/// 때 모두 같은 구성을 쓰고 문구만 달라진다. 일러스트는 어느 경우든 같다.
class NotificationEmpty extends StatelessWidget {
  const NotificationEmpty({
    super.key,
    required this.title,
    required this.description,
    this.action,
  });

  /// 빈 상태 일러스트 이미지 폭.
  static const double _imageWidth = 160;

  final String title;
  final String description;

  /// 일러스트 아래에 둘 동작. (예: '다시 시도' 버튼) 없으면 표시하지 않는다.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleDescription(
          title: title,
          description: description,
          centered: true,
        ),
        const SizedBox(height: AppSpacing.s4),
        Image.asset(
          'assets/images/empty_notification.png',
          width: _imageWidth,
          fit: BoxFit.contain,
        ),
        // 일러스트 아래로 바로 붙인다. (이미지 자체에 여백이 들어 있다)
        ?action,
      ],
    );
  }
}

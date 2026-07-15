import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 헤더의 제목 + 안내 문구 묶음. (큰 제목 아래 caption 을 s1 간격으로 둔다)
class HeaderTitle extends StatelessWidget {
  const HeaderTitle({super.key, required this.title, required this.caption});

  /// 큰 제목.
  final String title;

  /// 제목 아래 보조 안내 문구.
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppSpacing.s1,
      children: [
        AppText.headlineLarge(title, textAlign: TextAlign.center),
        AppText.caption(caption, textAlign: TextAlign.center),
      ],
    );
  }
}

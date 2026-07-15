import 'package:flutter/widgets.dart';

import '../../../core/designsystem/component/text/app_text.dart';

/// 권한 그룹 구분 라벨. (필수 / 선택)
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: AppText.caption(label));
  }
}

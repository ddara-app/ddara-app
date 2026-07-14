import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/feature/group/history/widget/record.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 기록 섹션. ('기록' 제목 + 요약 카드 [Record])
class RecordSection extends StatelessWidget {
  const RecordSection({
    super.key,
    required this.ddaraCount,
    required this.photoCount,
  });

  /// 따라찍기 수.
  final int ddaraCount;

  /// 함께한 사진 수.
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s6,
      children: [
        AppText.headlineLarge(l10n.recordSectionTitle),
        Record(ddaraCount: ddaraCount, photoCount: photoCount),
      ],
    );
  }
}

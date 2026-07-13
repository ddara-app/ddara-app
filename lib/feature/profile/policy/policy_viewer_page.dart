import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

/// [PolicyViewerPage] 에 넘기는 인자. (제목 + 마크다운 에셋 경로)
class PolicyViewerArgs {
  const PolicyViewerArgs({required this.title, required this.assetPath});

  /// 상단 바에 표시할 문서 제목.
  final String title;

  /// 마크다운 에셋 경로. (예: 'assets/policy/terms_of_service.md')
  final String assetPath;
}

/// 마크다운 정책 문서를 보여주는 공용 뷰어.
///
/// 약관·개인정보·운영정책·청소년 보호정책 등 4종을 [PolicyViewerArgs] 의
/// 에셋 경로만 바꿔 같은 화면으로 표시한다.
class PolicyViewerPage extends StatelessWidget {
  const PolicyViewerPage({super.key, required this.args});

  final PolicyViewerArgs args;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: AppBar(title: args.title, onBack: () => context.pop()),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder<String>(
          future: rootBundle.loadString(args.assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: AppText.body(
                  AppLocalizations.of(context).policyLoadFailed,
                ),
              );
            }
            return Markdown(
              // 상단 바 제목과 중복되는 첫 H1 은 제거한다.
              data: _stripLeadingTitle(snapshot.data!),
              selectable: true,
              padding: EdgeInsets.only(
                top: AppSpacing.s3,
                left: AppSpacing.s4,
                right: AppSpacing.s4,
                // 하단 Safe Area 까지 스크롤 영역을 잇되, 마지막 줄이 홈
                // 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
                bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
              ),
              styleSheet: _styleSheet,
            );
          },
        ),
      ),
    );
  }
}

/// 문서 맨 앞의 H1 제목 한 줄을 제거한다. (상단 바 제목과 중복되므로)
String _stripLeadingTitle(String markdown) {
  final lines = markdown.split('\n');
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].trim().isEmpty) continue;
    if (lines[i].startsWith('# ')) {
      lines.removeAt(i);
      while (i < lines.length && lines[i].trim().isEmpty) {
        lines.removeAt(i);
      }
    }
    break;
  }
  return lines.join('\n');
}

/// 디자인 시스템 토큰을 매핑한 마크다운 스타일.
final MarkdownStyleSheet _styleSheet = MarkdownStyleSheet(
  h1: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimary),
  h2: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary),
  h3: AppTypography.title.copyWith(color: AppColors.textPrimary),
  p: AppTypography.body.copyWith(color: AppColors.textLabel),
  strong: AppTypography.body.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  ),
  listBullet: AppTypography.body.copyWith(color: AppColors.textLabel),
  a: AppTypography.body.copyWith(color: AppColors.textAccent),
  h1Padding: const EdgeInsets.only(top: AppSpacing.s5, bottom: AppSpacing.s2),
  h2Padding: const EdgeInsets.only(top: AppSpacing.s5, bottom: AppSpacing.s2),
  h3Padding: const EdgeInsets.only(top: AppSpacing.s4, bottom: AppSpacing.s1),
  pPadding: const EdgeInsets.only(bottom: AppSpacing.s1),
  blockSpacing: AppSpacing.s2,
  // 인용구(원본의 ⚠️ aside) — 카드처럼 강조.
  blockquote: AppTypography.body.copyWith(color: AppColors.textSecondary),
  blockquotePadding: const EdgeInsets.all(AppSpacing.s3),
  blockquoteDecoration: BoxDecoration(
    color: AppColors.bgSurface,
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
  ),
  // 표 — 화면 폭 안에서 셀 내용이 줄바꿈되도록 Flex 폭 사용.
  tableColumnWidth: const FlexColumnWidth(),
  tableHead: AppTypography.label.copyWith(color: AppColors.textPrimary),
  tableBody: AppTypography.caption.copyWith(color: AppColors.textLabel),
  tableCellsPadding: const EdgeInsets.all(AppSpacing.s2),
  tableBorder: TableBorder.all(color: AppColors.borderDefault),
);

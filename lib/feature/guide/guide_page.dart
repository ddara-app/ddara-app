import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/widget/scrollable_page_body.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 따라찍기 사용법 안내 화면.
///
/// 홈 '따라찍기 모임' 탭 대시보드의 가이드 페이지와, 따라찍기 촬영 화면
/// AppBar 의 도움말(?) 버튼 두 곳에서 들어온다.
class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.guidePageTitle,
        onBack: () => context.pop(),
      ),
      child: const SafeArea(
        bottom: false,
        // TODO: 가이드 본문. (진입 경로부터 먼저 잇고 내용은 뒤에 채운다)
        child: ScrollablePageBody(child: SizedBox(width: double.infinity)),
      ),
    );
  }
}

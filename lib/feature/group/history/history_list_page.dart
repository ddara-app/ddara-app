import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 지난 따라찍기 전체 목록 화면.
///
/// 모임 상세의 '더보기' 로 진입해, 전달받은 [groupId] 의 지난 사이클을
/// 보여준다. (본문 UI는 디자인 확정 후 구현 예정)
class HistoryListPage extends ConsumerWidget {
  const HistoryListPage({super.key, required this.groupId});

  /// 진입 시 전달받은 모임 식별자. (이 id 로 히스토리 목록을 조회)
  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.groupHistoryTitle,
        onBack: () => context.pop(),
      ),
      child: const SafeArea(bottom: false, child: SizedBox.shrink()),
    );
  }
}

import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/logo.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/feature/home/empty_group_page.dart';
import 'package:ddara/feature/home/group_list_page.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        // 좌측 로고를 직접 배치하므로 뒤로가기 버튼 비활성화.
        showBackButton: false,
        padding: const EdgeInsetsDirectional.only(start: 20, end: 12),
        leading: const Align(alignment: Alignment.centerLeft, child: Logo()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavIconButton(
              icon: SvgPicture.asset(
                'assets/images/ic_bell.svg',
                width: 26,
                height: 26,
              ),
              onPressed: () => context.push(RoutePath.notification),
            ),
            _NavIconButton(
              // TODO: 사용자 프로필 이미지 URL 연동. (현재는 기본 아바타)
              icon: const ProfileAvatar(size: 32),
              onPressed: () => context.push(RoutePath.profile),
            ),
          ],
        ),
      ),
      child: SafeArea(child: _body(state)),
    );
  }

  /// 조회 결과에 따라 화면을 분기한다.
  /// 로딩 → 인디케이터 / 에러 → 안내 / 모임 없음 → 빈 상태 / 있으면 목록.
  Widget _body(HomeState state) {
    if (state.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (state.errorMessage.isNotEmpty) {
      return Center(child: AppText.body(state.errorMessage));
    }
    if (state.groups.isNotEmpty) {
      return GroupListPage(groups: state.groups);
    }
    return const EmptyGroupPage();
  }
}

/// 네비게이션 바 우측 아이콘 버튼. (알림 · 프로필 공통)
class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onPressed});

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: icon,
    );
  }
}

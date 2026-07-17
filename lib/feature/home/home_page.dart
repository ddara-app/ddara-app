import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/component/logo.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/feature/home/empty_group_page.dart';
import 'package:ddara/feature/home/group_list_page.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
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
    // 서버 프로필의 이미지 URL. (조회 전·미등록이면 null → 기본 아바타)
    final profileImageUrl = ref
        .watch(currentProfileProvider)
        .valueOrNull
        ?.profileImageUrl;

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        // 좌측 로고를 직접 배치하므로 뒤로가기 버튼 비활성화.
        showBackButton: false,
        leading: const Align(alignment: Alignment.centerLeft, child: Logo()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBarIconButton(
              child: SvgPicture.asset(
                'assets/images/ic_bell.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () => context.push(RoutePath.notification),
            ),
            AppBarIconButton(
              size: 32,
              // 아바타 자체가 시각적 버튼이라 내부 여백 없이 콘텐츠에 딱 맞춘다.
              hugContent: true,
              child: ProfileAvatar(size: 32, imageUrl: profileImageUrl),
              onPressed: () => context.push(RoutePath.profile),
            ),
          ],
        ),
      ),
      child: SafeArea(bottom: false, child: _body(state)),
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
      return GroupListPage(
        groups: state.groups,
        blockedUserIds: state.blockedUserIds,
      );
    }
    return const EmptyGroupPage();
  }
}

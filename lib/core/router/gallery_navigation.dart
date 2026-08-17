import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/detail/util/group_page_args.dart';
import 'package:go_router/go_router.dart';

/// 모임 밖에서(홈 최근 업데이트 · 알림 목록 · 푸시 알림) 회차 갤러리로 들어간다.
///
/// 갤러리는 모임 상세의 하위 라우트라, [GoRouter.go] 한 번이면 홈 > 모임 >
/// 갤러리 스택이 선언적으로 구성된다. 중간 화면이 스쳐 보이지 않으면서
/// 뒤로가기는 갤러리 → 모임 → 홈 순서로 이어진다.
/// (여러 번 push 하면 중간 화면이 번쩍이거나 스택이 어긋난다)
///
/// [groupName] 은 모임 상세 조회 전에도 AppBar 제목이 비지 않도록 아는 경우에만
/// 넘긴다. 갤러리는 경로 값만 쓰므로 이 힌트를 무시한다.
void goCycleGallery(
  GoRouter router, {
  required int groupId,
  required int cycleId,
  String? groupName,
}) {
  router.go(
    RoutePath.cycleGallery(groupId: groupId, cycleId: cycleId),
    extra: GroupPageArgs(groupName: groupName),
  );
}

/// 모임 밖에서 모임 상세로 들어간다. (홈 > 모임)
///
/// 갤러리 진입과 같은 규칙으로, 뒤로가기가 홈으로 이어지도록 go 로 이동한다.
void goGroup(GoRouter router, {required int groupId, String? groupName}) {
  router.go(
    RoutePath.group(groupId),
    extra: GroupPageArgs(groupName: groupName),
  );
}

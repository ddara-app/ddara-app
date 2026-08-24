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

/// 알림 목록에서 회차 갤러리로 들어간다. (알림 > 갤러리)
///
/// [goCycleGallery] 와 달리 스택을 다시 세우지 않고 **위에 쌓는다**. 알림을
/// 눌러 확인한 뒤 뒤로가기로 목록에 돌아와 다음 알림을 이어 볼 수 있다.
/// (docs/tech_notes/notification_navigation.md)
///
/// 갤러리는 모임 상세의 하위 라우트지만 [GoRouter.push] 는 매칭된 스택의 마지막
/// 화면만 올리므로, 중간에 모임 상세가 끼지 않는다. 갤러리는 경로의 groupId ·
/// cycleId 로 직접 조회해 부모 화면에 기대지 않는다.
void pushCycleGallery(
  GoRouter router, {
  required int groupId,
  required int cycleId,
  String? groupName,
}) {
  router.push(
    RoutePath.cycleGallery(groupId: groupId, cycleId: cycleId),
    extra: GroupPageArgs(groupName: groupName),
  );
}

/// 알림 목록에서 모임 상세로 들어간다. (알림 > 모임)
///
/// [pushCycleGallery] 와 같은 이유로 스택 위에 쌓는다.
void pushGroup(GoRouter router, {required int groupId, String? groupName}) {
  router.push(
    RoutePath.group(groupId),
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

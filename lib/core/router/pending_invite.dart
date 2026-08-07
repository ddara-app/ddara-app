import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../feature/group/detail/provider/viewmodel_provider.dart';
import '../../feature/group/gallery/provider/viewmodel_provider.dart';
import '../../feature/home/provider/viewmodel_provider.dart';
import '../../feature/profile/provider/viewmodel_provider.dart';
import '../permission/provider/permission_provider.dart';
import 'app_router.dart';
import 'route_path.dart';

/// 미로그인/권한 미허용 상태에서 받은 초대코드를 잠시 보관한다.
///
/// 초대 딥링크로 진입했는데 바로 모임 참여로 못 갈 때(미로그인·권한 없음) 여기에
/// 코드를 담아두고 인증/권한 흐름으로 보낸다. 흐름이 끝나면 [routeAfterAuth] 가
/// 이 코드로 모임 참여 화면에 복귀시킨다. (앱 세션 내 메모리 보관)
final pendingInviteCodeProvider = StateProvider<String?>((ref) => null);

/// 인증(로그인·회원가입)·권한 확인 후 이동 경로를 결정한다.
///
/// context 가 없는 딥링크 콜백에서도 부를 수 있도록 [router] 를 직접 받는다.
///
/// 순서:
/// 1. 카메라 권한 안내 전이고 권한도 없으면 → 권한 화면 먼저.
///    (이때 초대코드는 **소비하지 않고 유지** → 권한 확인 후 다시 이 함수로 복귀)
/// 2. 보관된 초대코드가 있으면 → 홈을 깔고 그 위에 모임 참여 화면(코드 1회 소비).
/// 3. 그 외 → 홈.
Future<void> routeAfterAuth(WidgetRef ref, GoRouter router) async {
  // 인증 성공으로 진입한 지점이므로 로그인 상태를 확정한다. (markLoggedOut 과 대칭)
  // 같은 세션에서 로그아웃 후 재로그인해도 isLoggedIn 이 true 로 되돌아온다.
  ref.read(authStateProvider.notifier).markLoggedIn();

  // 새 세션(다른 계정일 수 있음) 시작. 이전 세션의 사용자 데이터 캐시를 비워
  // 새 계정 기준으로 다시 조회되게 한다. (홈 그룹 목록·홈 AppBar 프로필 등이
  // 이전 계정 값으로 남는 것을 막는 단일 지점)
  _resetSessionCaches(ref);

  // 1. 카메라 권한 게이트. (홈 진입 게이트와 동일 정책)
  final acknowledged = ref.read(cameraNoticeAcknowledgedProvider);
  if (!acknowledged) {
    final granted = await ref.read(permissionServiceProvider).isCameraGranted();
    if (!granted) {
      router.go(RoutePath.permission);
      return;
    }
    // 권한이 이미 허용돼 있으면 안내를 본 것으로 처리한다.
    // 이렇게 해야 이어지는 go(home) 의 홈 게이트가 비동기 권한 조회 없이
    // 동기로 통과해, postFrame push 가 [home, join] 으로 정확히 쌓인다.
    ref.read(cameraNoticeAcknowledgedProvider.notifier).state = true;
  }

  // 2. 보관된 초대코드가 있으면 모임 참여로 복귀. (한 번 쓰고 비운다)
  final pending = ref.read(pendingInviteCodeProvider);
  if (pending != null && pending.isNotEmpty) {
    ref.read(pendingInviteCodeProvider.notifier).state = null;
    // 홈을 거치지 않고 곧바로 랜딩으로 진입한다. (홈이 잠깐 비쳤다 사라지는 깜빡임 제거)
    // 뒤로가기는 참여 화면(JoinGroupPage) 에서 홈으로 보내도록 처리한다.
    router.go('${RoutePath.inviteLanding}?code=$pending');
    return;
  }

  // 3. 기본 홈.
  router.go(RoutePath.home);
}

/// 로그인 성공(새 세션 시작) 시 이전 세션에 종속된 사용자 데이터 캐시를 비운다.
///
/// 계정 전환 시 이전 계정 데이터가 새는 것을 막는다. 위젯 dispose 타이밍에
/// 의존하지 않도록, 로그인 진입점(routeAfterAuth)에서 확정적으로 리셋한다.
/// 서버에서 받아온 **계정별 데이터**를 보유하는 provider 를 새로 만들면 여기에
/// 함께 추가한다. (로그인/입력 폼 등 순수 화면 상태는 대상 아님)
///
/// family provider 는 base 를 invalidate 하면 모든 인스턴스가 초기화된다.
void _resetSessionCaches(WidgetRef ref) {
  // 홈 그룹 목록.
  ref.invalidate(homeViewModelProvider);
  // 홈 AppBar 아바타 등이 공유하는 프로필.
  ref.invalidate(currentProfileProvider);
  // 프로필 화면(이름·프로필 사진·가입일·연동 계정).
  ref.invalidate(profileViewModelProvider);
  // 알림 설정.
  ref.invalidate(notificationSettingsViewModelProvider);
  // 모임 상세(그룹별).
  ref.invalidate(groupPageViewModelProvider);
  // 사이클 사진 갤러리(사이클별).
  ref.invalidate(cyclePhotoGalleryViewModelProvider);
}

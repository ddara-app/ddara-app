import 'package:ddara/core/model/profile/notification_settings.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/profile/settings/util/notification_settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsNotifier
    extends AutoDisposeNotifier<NotificationSettingsState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (응답 전에 화면을 떠나면 dispose 된 Notifier 대입으로 StateError)
  bool _disposed = false;

  @override
  NotificationSettingsState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    // 진입 시 서버 설정과 권한을 자동 조회. (build 는 동기라 fire-and-forget)
    _load();
    return const NotificationSettingsState(isLoading: true);
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(
    NotificationSettingsState Function(NotificationSettingsState state) updater,
  ) {
    if (_disposed) return;
    state = updater(state);
  }

  /// 서버에 저장된 알림 설정과 OS 권한 상태를 함께 불러와 상태에 반영한다.
  Future<void> _load() async {
    // 권한은 서버 응답과 무관하게 항상 확인한다.
    final permissionGranted = await ref
        .read(permissionServiceProvider)
        .isNotificationGranted();

    try {
      final settings = await ref
          .read(getNotificationSettingsUseCaseProvider)
          .call();
      // 권한이 없으면 FCM 이 나갈 수 없으므로 allowAll 을 강제로 false 로 낮춘다.
      final allowAll = permissionGranted && settings.allowAll;
      _update(
        (s) => s.copyWith(
          isLoading: false,
          allowAll: allowAll,
          followShot: settings.followShot,
          deadlineVote: settings.deadlineVote,
          memberJoin: settings.memberJoin,
          permissionGranted: permissionGranted,
        ),
      );
      // 권한이 없어 allowAll 을 낮춘 경우, 서버 저장값도 false 로 맞춘다.
      // (서버가 저장된 allowAll 로 FCM 전송 여부를 판단하기 때문)
      if (allowAll != settings.allowAll) {
        await _persist();
      }
    } catch (_) {
      // 조회 실패 시 기본값(모두 true)을 유지하되 권한만 반영한다.
      _update(
        (s) =>
            s.copyWith(isLoading: false, permissionGranted: permissionGranted),
      );
    }
  }

  /// OS 알림 권한 상태를 다시 확인해 반영한다. (설정 화면에서 권한을 바꾸고
  /// 돌아온 경우 등에 사용) 권한이 사라졌으면 allowAll 도 꺼서 서버에 반영한다.
  Future<void> syncPermission() async {
    final granted = await ref
        .read(permissionServiceProvider)
        .isNotificationGranted();
    if (granted == state.permissionGranted) return;

    // 권한이 회수됐는데 allowAll 이 켜져 있으면, 서버 저장값도 false 로 낮춘다.
    final shouldDisable = !granted && state.allowAll;
    _update(
      (s) => s.copyWith(
        permissionGranted: granted,
        allowAll: shouldDisable ? false : state.allowAll,
      ),
    );
    if (shouldDisable) await _persist();
  }

  /// '알림 허용' 토글 변경.
  ///
  /// 켜는데 권한이 없으면 OS 권한을 요청한다. 권한이 없으면 켜더라도 실제
  /// 저장값(allowAll)은 false 가 된다. 변경값은 서버에 저장한다.
  /// 권한 요청 결과를 반환하며(요청하지 않았으면 null), 영구 거부 시 호출부에서
  /// 설정 이동 안내를 띄우도록 한다.
  Future<PermissionResult?> changeAllow(bool value) async {
    PermissionResult? result;
    var permissionGranted = state.permissionGranted;

    // 켜는데 권한이 없을 때만 OS 권한을 요청한다.
    if (value && !permissionGranted) {
      result = await ref.read(permissionServiceProvider).requestNotification();
      permissionGranted = result == PermissionResult.granted;
    }

    _update(
      (s) => s.copyWith(
        // 권한이 없으면 켜더라도 허용은 false 로 저장한다.
        allowAll: value && permissionGranted,
        permissionGranted: permissionGranted,
      ),
    );

    await _persist();
    return result;
  }

  /// '따라찍기 차례' 알림 변경.
  Future<void> changeFollowShot(bool value) async {
    _update((s) => s.copyWith(followShot: value));
    await _persist();
  }

  /// '마감·투표 알림' 변경.
  Future<void> changeDeadlineVote(bool value) async {
    _update((s) => s.copyWith(deadlineVote: value));
    await _persist();
  }

  /// '친구 참여 알림' 변경.
  Future<void> changeMemberJoin(bool value) async {
    _update((s) => s.copyWith(memberJoin: value));
    await _persist();
  }

  /// 저장 요청 시퀀스. 토글을 빠르게 연속 변경하면 `_persist` 가 겹치는데,
  /// 늦게 도착한 이전 응답이 최신 변경을 롤백하지 않도록 마지막 요청의
  /// 응답만 상태에 반영한다.
  int _persistSeq = 0;

  /// 현재 선호값을 서버에 저장하고, 응답으로 상태를 정합화한다.
  Future<void> _persist() async {
    final seq = ++_persistSeq;
    final settings = NotificationSettings(
      allowAll: state.allowAll,
      followShot: state.followShot,
      deadlineVote: state.deadlineVote,
      memberJoin: state.memberJoin,
    );

    try {
      final saved = await ref
          .read(changeNotificationSettingsUseCaseProvider)
          .call(settings);
      // 더 새로운 저장 요청이 나갔으면 이 응답은 무시한다.
      if (seq != _persistSeq) return;
      _update(
        (s) => s.copyWith(
          allowAll: saved.allowAll,
          followShot: saved.followShot,
          deadlineVote: saved.deadlineVote,
          memberJoin: saved.memberJoin,
        ),
      );
    } catch (_) {
      // 저장 실패는 조용히 무시한다. (다음 변경/재진입 시 다시 시도)
    }
  }
}

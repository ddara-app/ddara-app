import 'dart:async';

import 'package:ddara/core/permission/permission_service.dart';
import 'package:flutter/widgets.dart';

/// 권한 요청 다이얼로그를 OS 뒤로가기로 닫으면 `permission_handler` 의 요청 결과
/// 콜백이 유실되어 `request()` Future 가 완료되지 않을 수 있다. 그러면 요청을
/// 시작한 핸들러가 멈춰 버려 페이지의 버튼이 전부 먹통이 된다.
///
/// 이 mixin 은 권한 다이얼로그로 인해 앱이 백그라운드로 갔다가 돌아오는(resume)
/// 시점을 감지해, `request()` 대신 `.status` 로 실제 권한 상태를 다시 읽어 요청을
/// 매듭짓는다. 따라서 뒤로가기로 요청을 닫아도 화면이 멈추지 않는다.
mixin PermissionRequestRecovery<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  /// 요청 시작 이후 앱이 실제로 백그라운드(권한 다이얼로그 등)로 나갔는지.
  /// 나간 적 없는 spurious resume 으로 상태를 조기 확정하지 않기 위한 가드.
  bool _leftApp = false;

  /// resume 시 갇힌 요청을 매듭지을 콜백. (요청 1건당 하나)
  void Function()? _onResume;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!_leftApp) return;
      _leftApp = false;
      final onResume = _onResume;
      _onResume = null;
      onResume?.call();
    } else {
      // inactive / paused / hidden / detached → 앱이 전면에서 벗어남
      _leftApp = true;
    }
  }

  /// [request] 를 호출하되, 완료되지 않으면 앱 resume 시 [readStatus] 로 매듭짓는다.
  ///
  /// - 정상(허용/거부): resume 직후 [readStatus] 가 실제 상태를 반환한다.
  /// - 뒤로가기로 닫힘: [request] 가 끝나지 않아도 resume 으로 복구된다.
  /// - 이미 요청이 걸려 [request] 가 즉시 에러: [readStatus] 로 대체한다.
  Future<PermissionResult> awaitPermission(
    Future<PermissionResult> Function() request,
    Future<PermissionResult> Function() readStatus,
  ) async {
    _leftApp = false;
    final resume = Completer<PermissionResult>();
    _onResume = () async {
      if (resume.isCompleted) return;
      try {
        resume.complete(await readStatus());
      } catch (_) {
        if (!resume.isCompleted) resume.complete(PermissionResult.denied);
      }
    };

    try {
      return await Future.any<PermissionResult>([
        request().catchError((_) => readStatus()),
        resume.future,
      ]);
    } finally {
      _onResume = null;
    }
  }
}

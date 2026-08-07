import 'package:ddara/l10n/app_localizations.dart';

/// 모임 생성(`POST /api/groups`) 실패 종류.
///
/// ViewModel 은 종류만 상태에 담고, 사용자 노출 문구는 화면에서
/// [GroupCreateErrorMessage.message] 로 l10n 매핑한다.
enum GroupCreateError {
  /// 400 — 모임 이름 누락 또는 길이 초과.
  invalidName,

  /// 401 — 인증 만료(인터셉터 복구도 실패).
  unauthorized,

  /// 409 — 만들 수 있는 모임 최대 개수(20개) 초과.
  limitExceeded,

  /// 네트워크 등 그 외 실패.
  unknown,
}

extension GroupCreateErrorMessage on GroupCreateError {
  /// 실패 종류를 사용자 노출 문구로 매핑한다.
  String message(AppLocalizations l10n) {
    return switch (this) {
      GroupCreateError.invalidName => l10n.groupCreateErrorInvalidName,
      GroupCreateError.unauthorized => l10n.groupCreateErrorUnauthorized,
      GroupCreateError.limitExceeded => l10n.groupCreateErrorLimitExceeded,
      GroupCreateError.unknown => l10n.groupCreateErrorUnknown,
    };
  }
}

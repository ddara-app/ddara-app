/// 팔로워 사진 업로드(`POST /api/cycles/{cycleId}/shots`) 실패 시 서버가 내려주는 에러 코드.
///
/// enum 은 서버 코드 값만 갖는다. 사용자 노출 문구는 이 코드를 예외로 옮긴 뒤
/// 화면이 l10n 으로 매핑한다.
enum FollowerUploadErrorCode {
  notGroupMember('NOT_GROUP_MEMBER'),
  cycleNotFound('CYCLE_NOT_FOUND'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN');

  const FollowerUploadErrorCode(this.value);

  final String value;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static FollowerUploadErrorCode? fromValue(String? value) {
    for (final code in FollowerUploadErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}

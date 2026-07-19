import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 애플 로그인 최초 1회만 내려오는 이름/이메일을 기기 보안 저장소(Keychain)에
/// 백업한다. 회원가입 완료 전에 앱이 종료되면 애플이 이름을 다시 주지 않아
/// 유실되므로, credential 을 받은 즉시 저장해 두었다가 복구에 사용한다.
///
/// 키는 `appleUserName_{userIdentifier}` / `appleUserEmail_{userIdentifier}`
/// 형태로 애플 계정별로 구분한다.
class AppleCredentialStorage {
  AppleCredentialStorage([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // 앱 삭제 후 재설치해도 Keychain 값이 유지되도록 first_unlock 사용.
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  String _nameKey(String userIdentifier) => 'appleUserName_$userIdentifier';

  String _emailKey(String userIdentifier) => 'appleUserEmail_$userIdentifier';

  /// 이름 백업. null/빈 문자열이면 아무것도 하지 않는다 — 2회차 이후 로그인에서
  /// 이름이 안 내려올 때 기존 백업을 덮어쓰지 않기 위함이다.
  Future<void> saveName(String userIdentifier, String? name) async {
    if (name == null || name.isEmpty) return;
    await _storage.write(key: _nameKey(userIdentifier), value: name);
  }

  /// 이메일 백업. null/빈 문자열이면 기존 값을 보존한다.
  Future<void> saveEmail(String userIdentifier, String? email) async {
    if (email == null || email.isEmpty) return;
    await _storage.write(key: _emailKey(userIdentifier), value: email);
  }

  Future<String?> readName(String userIdentifier) async {
    return await _storage.read(key: _nameKey(userIdentifier));
  }

  Future<String?> readEmail(String userIdentifier) async {
    return await _storage.read(key: _emailKey(userIdentifier));
  }

  /// 해당 애플 계정의 백업 전체 삭제. (서버 저장이 끝나 더 이상 불필요할 때)
  Future<void> delete(String userIdentifier) async {
    await _storage.delete(key: _nameKey(userIdentifier));
    await _storage.delete(key: _emailKey(userIdentifier));
  }
}
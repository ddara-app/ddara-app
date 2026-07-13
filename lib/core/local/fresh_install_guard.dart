import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_key.dart';

/// (재)설치 후 첫 실행이면 secure storage 를 비워 이전 설치의 인증 정보를 정리한다.
///
/// iOS 는 앱을 삭제해도 Keychain(secure storage)이 유지되므로, 재설치하면 이전
/// 설치의 토큰이 남아 로그인 상태로 오인된다. (온보딩 뒤 로그인·권한 화면이
/// 생략되고 홈으로 진입하는 문제) 앱 삭제 시 함께 지워지는 SharedPreferences 의
/// 첫 실행 플래그가 없으면 신규(재)설치로 판단해 초기화한다.
///
/// 반드시 secure storage 에서 토큰을 읽기 전(인증 상태 확정 전)에 호출해야 한다.
Future<void> clearSecureStorageOnFreshInstall({
  required SharedPreferences prefs,
  required FlutterSecureStorage storage,
}) async {
  if (prefs.getBool(StorageKey.firstRunDone) ?? false) return;

  try {
    await storage.deleteAll();
  } catch (_) {
    // 삭제 실패는 무시하고 진행한다. 잔존 토큰이 실제 만료 상태면 이후
    // 401 처리(강제 로그아웃)가 정리한다.
  }
  // 삭제 실패 시에도 플래그는 기록한다. 기록하지 않으면 다음 실행에서 재시도
  // 하다가, 그 사이 사용자가 정상적으로 로그인한 세션까지 지워버릴 수 있다.
  await prefs.setBool(StorageKey.firstRunDone, true);
}

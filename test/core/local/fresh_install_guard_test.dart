import 'package:ddara/core/local/fresh_install_guard.dart';
import 'package:ddara/core/local/storage_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;

  setUp(() {
    storage = MockSecureStorage();
    // deleteAll 은 기본적으로 성공(no-op)으로 스텁.
    when(() => storage.deleteAll()).thenAnswer((_) async {});
  });

  Future<SharedPreferences> prefsWith(Map<String, Object> values) {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  test('첫 실행(플래그 없음)이면 secure storage 를 비우고 플래그를 기록한다', () async {
    final prefs = await prefsWith({});

    await clearSecureStorageOnFreshInstall(prefs: prefs, storage: storage);

    verify(() => storage.deleteAll()).called(1);
    expect(prefs.getBool(StorageKey.firstRunDone), isTrue);
  });

  test('플래그가 있으면(이미 실행한 설치) 아무것도 지우지 않는다', () async {
    final prefs = await prefsWith({StorageKey.firstRunDone: true});

    await clearSecureStorageOnFreshInstall(prefs: prefs, storage: storage);

    verifyNever(() => storage.deleteAll());
  });

  test('삭제가 실패해도 예외를 던지지 않고 플래그를 기록한다', () async {
    // 플래그를 기록하지 않으면 다음 실행에서 재시도하다가, 그 사이 사용자가
    // 정상 로그인한 세션까지 지워버릴 수 있다.
    final prefs = await prefsWith({});
    when(() => storage.deleteAll()).thenThrow(Exception('keychain error'));

    await clearSecureStorageOnFreshInstall(prefs: prefs, storage: storage);

    expect(prefs.getBool(StorageKey.firstRunDone), isTrue);
  });
}

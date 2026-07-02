import 'package:ddara/core/local/storage_key.dart';
import 'package:ddara/core/network/dio_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;

  // 호출 순서를 관찰하기 위한 기록. (markLoggedOut 이 goToLogin 보다 먼저여야 함)
  late List<String> calls;

  setUp(() {
    storage = MockSecureStorage();
    calls = [];
    // delete 는 기본적으로 성공(no-op)으로 스텁.
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
  });

  Future<void> run() => handleSessionExpired(
    storage: storage,
    markLoggedOut: () => calls.add('markLoggedOut'),
    goToLogin: () => calls.add('goToLogin'),
  );

  test('토큰이 있으면 로컬 인증 정보를 지우고 로그아웃·로그인 이동을 수행한다', () async {
    when(
      () => storage.read(key: StorageKey.accessToken),
    ).thenAnswer((_) async => 'some-token');

    await run();

    // 3개 키 모두 삭제.
    verify(() => storage.delete(key: StorageKey.accessToken)).called(1);
    verify(() => storage.delete(key: StorageKey.refreshToken)).called(1);
    verify(() => storage.delete(key: StorageKey.socialLoginType)).called(1);

    expect(calls, ['markLoggedOut', 'goToLogin']);
  });

  test('인증 상태를 확정한 뒤(markLoggedOut) 로그인 화면으로 이동한다(순서 보장)', () async {
    // 이 순서가 뒤바뀌면 redirect 가 stale=true 를 읽어 login→home 으로 바운스된다.
    when(
      () => storage.read(key: StorageKey.accessToken),
    ).thenAnswer((_) async => 'some-token');

    await run();

    expect(calls.indexOf('markLoggedOut'), lessThan(calls.indexOf('goToLogin')));
  });

  test('토큰이 이미 비워져 있으면 아무것도 하지 않는다 (1회 가드)', () async {
    when(
      () => storage.read(key: StorageKey.accessToken),
    ).thenAnswer((_) async => null);

    await run();

    verifyNever(() => storage.delete(key: any(named: 'key')));
    expect(calls, isEmpty);
  });
}

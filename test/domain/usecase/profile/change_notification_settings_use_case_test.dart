import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/change_notification_settings_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late ChangeNotificationSettingsUseCase useCase;

  setUpAll(() {
    registerFallbackValue(
      const NotificationSettings(
        allowAll: true,
        followShot: true,
        friendShot: true,
        starterAssigned: true,
        comment: true,
        memberJoin: true,
      ),
    );
  });

  setUp(() {
    repository = MockProfileRepository();
    useCase = ChangeNotificationSettingsUseCase(repository);
  });

  test('변경할 설정을 그대로 위임하고 서버가 반영한 결과를 반환한다', () async {
    const requested = NotificationSettings(
      allowAll: false,
      followShot: false,
      friendShot: false,
      starterAssigned: false,
      comment: false,
      memberJoin: false,
    );
    when(
      () => repository.changeNotificationSettings(requested),
    ).thenAnswer((_) async => requested);

    final result = await useCase.call(requested);

    expect(result, requested);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.changeNotificationSettings(any()),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(
        const NotificationSettings(
          allowAll: true,
          followShot: true,
          friendShot: true,
          starterAssigned: true,
          comment: true,
          memberJoin: true,
        ),
      ),
      throwsA(isA<Exception>()),
    );
  });
}

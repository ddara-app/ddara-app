import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/get_notification_settings_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late GetNotificationSettingsUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = GetNotificationSettingsUseCase(repository);
  });

  test('Repository 의 결과를 그대로 반환한다', () async {
    const settings = NotificationSettings(
      allowAll: true,
      followShot: true,
      friendShot: true,
      starterAssigned: true,
      comment: true,
      memberJoin: true,
    );
    when(
      () => repository.getNotificationSettings(),
    ).thenAnswer((_) async => settings);

    final result = await useCase.call();

    expect(result, settings);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getNotificationSettings()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}

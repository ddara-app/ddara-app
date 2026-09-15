import 'package:ddara/domain/repository/notification_repository.dart';
import 'package:ddara/domain/usecase/notification/get_unread_notification_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late GetUnreadNotificationUseCase useCase;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = GetUnreadNotificationUseCase(repository);
  });

  test('Repository 의 결과를 그대로 반환한다', () async {
    when(() => repository.hasUnread()).thenAnswer((_) async => true);

    final result = await useCase.call();

    expect(result, true);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.hasUnread()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}

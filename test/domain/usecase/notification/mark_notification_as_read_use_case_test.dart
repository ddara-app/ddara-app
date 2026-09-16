import 'package:ddara/domain/repository/notification_repository.dart';
import 'package:ddara/domain/usecase/notification/mark_notification_as_read_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late MarkNotificationAsReadUseCase useCase;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = MarkNotificationAsReadUseCase(repository);
  });

  test('notificationId 를 그대로 Repository 에 위임한다', () async {
    when(() => repository.markAsRead(1)).thenAnswer((_) async {});

    await useCase.call(1);

    verify(() => repository.markAsRead(1)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.markAsRead(any())).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}

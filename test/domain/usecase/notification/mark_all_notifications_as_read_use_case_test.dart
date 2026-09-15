import 'package:ddara/domain/repository/notification_repository.dart';
import 'package:ddara/domain/usecase/notification/mark_all_notifications_as_read_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late MarkAllNotificationsAsReadUseCase useCase;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = MarkAllNotificationsAsReadUseCase(repository);
  });

  test('Repository 의 전체 읽음 처리를 그대로 호출한다', () async {
    when(() => repository.markAllAsRead()).thenAnswer((_) async {});

    await useCase.call();

    verify(() => repository.markAllAsRead()).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.markAllAsRead()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}

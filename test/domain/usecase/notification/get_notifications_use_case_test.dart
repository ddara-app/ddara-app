import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';
import 'package:ddara/domain/repository/notification_repository.dart';
import 'package:ddara/domain/usecase/notification/get_notifications_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late GetNotificationsUseCase useCase;

  setUpAll(() {
    registerFallbackValue(NotificationCategory.all);
  });

  setUp(() {
    repository = MockNotificationRepository();
    useCase = GetNotificationsUseCase(repository);
  });

  test('category 를 지정하면 그대로 Repository 에 위임한다', () async {
    const list = NotificationList(items: []);
    when(
      () => repository.getNotifications(category: NotificationCategory.activity),
    ).thenAnswer((_) async => list);

    final result = await useCase.call(category: NotificationCategory.activity);

    expect(result, list);
  });

  test('category 를 생략하면 기본값 all 로 위임한다', () async {
    const list = NotificationList(items: []);
    when(
      () => repository.getNotifications(category: NotificationCategory.all),
    ).thenAnswer((_) async => list);

    await useCase.call();

    verify(
      () => repository.getNotifications(category: NotificationCategory.all),
    ).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.getNotifications(category: any(named: 'category')),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}

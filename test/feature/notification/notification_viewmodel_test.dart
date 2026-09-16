import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';
import 'package:ddara/domain/model/notification/notification_payload.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/notification/get_notifications_use_case.dart';
import 'package:ddara/domain/usecase/notification/get_unread_notification_use_case.dart';
import 'package:ddara/domain/usecase/notification/mark_all_notifications_as_read_use_case.dart';
import 'package:ddara/domain/usecase/notification/mark_notification_as_read_use_case.dart';
import 'package:ddara/feature/notification/notification_viewmodel.dart';
import 'package:ddara/feature/notification/provider/viewmodel_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationsUseCase extends Mock implements GetNotificationsUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

class MockMarkAllNotificationsAsReadUseCase extends Mock
    implements MarkAllNotificationsAsReadUseCase {}

class MockMarkNotificationAsReadUseCase extends Mock implements MarkNotificationAsReadUseCase {}

class MockGetUnreadNotificationUseCase extends Mock implements GetUnreadNotificationUseCase {}

NotificationItem _item({int id = 1, DateTime? readAt}) {
  return NotificationItem(
    id: id,
    type: NotificationType.memberJoin,
    payload: const NotificationPayload(
      groupId: 1,
      groupName: 'group',
      actorNickname: 'nick',
      cycleId: null,
      shotId: null,
      deadlineAt: null,
      remainingMinutes: null,
      imageUrl: null,
      imageUnderReview: false,
      locked: false,
      starterUserId: null,
      shotOwnerUserId: null,
      shotOwnerNickname: null,
      isMyShot: false,
    ),
    readAt: readAt,
    createdAt: DateTime(2026, 1, 1),
  );
}

NotificationViewModel notifierAlive(ProviderContainer container) {
  container.listen(notificationViewModelProvider, (_, _) {});
  return container.read(notificationViewModelProvider.notifier);
}

void main() {
  late MockGetNotificationsUseCase getNotifications;
  late MockGetBlockedUserIdsUseCase getBlockedUserIds;
  late MockMarkAllNotificationsAsReadUseCase markAllAsRead;
  late MockMarkNotificationAsReadUseCase markAsRead;
  late MockGetUnreadNotificationUseCase getUnread;
  late ProviderContainer container;

  setUp(() {
    getNotifications = MockGetNotificationsUseCase();
    getBlockedUserIds = MockGetBlockedUserIdsUseCase();
    markAllAsRead = MockMarkAllNotificationsAsReadUseCase();
    markAsRead = MockMarkNotificationAsReadUseCase();
    getUnread = MockGetUnreadNotificationUseCase();
    container = ProviderContainer(
      overrides: [
        getNotificationsUseCaseProvider.overrideWithValue(getNotifications),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(getBlockedUserIds),
        markAllNotificationsAsReadUseCaseProvider.overrideWithValue(markAllAsRead),
        markNotificationAsReadUseCaseProvider.overrideWithValue(markAsRead),
        getUnreadNotificationUseCaseProvider.overrideWithValue(getUnread),
      ],
    );
    addTearDown(container.dispose);
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
    when(() => getUnread()).thenAnswer((_) async => false);
    when(() => markAsRead(any())).thenAnswer((_) async {});
  });

  test('조회 성공하면 NotificationLoaded 로 전환한다', () async {
    when(() => getNotifications()).thenAnswer(
      (_) async => NotificationList(items: [_item(id: 1)]),
    );

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationViewModelProvider);
    expect(state, isA<NotificationLoaded>());
    expect((state as NotificationLoaded).items, hasLength(1));
  });

  test('초기 조회 실패는 NotificationLoadError 로 전환한다', () async {
    when(() => getNotifications()).thenAnswer((_) async => throw Exception('fail'));

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(notificationViewModelProvider), isA<NotificationLoadError>());
  });

  test('markAsRead 는 해당 알림만 읽음 처리하고 서버에도 기록한다', () async {
    when(() => getNotifications()).thenAnswer(
      (_) async => NotificationList(items: [_item(id: 1), _item(id: 2)]),
    );
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    notifier.markAsRead(1);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(notificationViewModelProvider) as NotificationLoaded;
    expect(state.items.firstWhere((i) => i.id == 1).isRead, true);
    expect(state.items.firstWhere((i) => i.id == 2).isRead, false);
    verify(() => markAsRead(1)).called(1);
  });

  test('이미 읽은 알림에 markAsRead 를 호출하면 아무 일도 하지 않는다', () async {
    when(() => getNotifications()).thenAnswer(
      (_) async => NotificationList(items: [_item(id: 1, readAt: DateTime(2026, 1, 2))]),
    );
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    notifier.markAsRead(1);
    await Future<void>.delayed(Duration.zero);

    verifyNever(() => markAsRead(any()));
  });

  test('markAllAsRead 성공하면 모두 읽음 처리하고 true 를 반환한다', () async {
    when(() => getNotifications()).thenAnswer(
      (_) async => NotificationList(items: [_item(id: 1), _item(id: 2)]),
    );
    when(() => markAllAsRead()).thenAnswer((_) async {});
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final result = await notifier.markAllAsRead();

    expect(result, true);
    final state = container.read(notificationViewModelProvider) as NotificationLoaded;
    expect(state.items.every((i) => i.isRead), true);
    expect(state.isMarkingAllRead, false);
  });

  test('markAllAsRead 실패하면 false 를 반환하고 readAllFailed 를 채운다', () async {
    when(() => getNotifications()).thenAnswer(
      (_) async => NotificationList(items: [_item(id: 1)]),
    );
    when(() => markAllAsRead()).thenAnswer((_) async => throw Exception('fail'));
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final result = await notifier.markAllAsRead();

    expect(result, false);
    final state = container.read(notificationViewModelProvider) as NotificationLoaded;
    expect(state.readAllFailed, true);
    expect(state.isMarkingAllRead, false);
  });

  test('읽을 알림이 없으면 markAllAsRead 를 호출하지 않는다', () async {
    when(() => getNotifications()).thenAnswer(
      (_) async => NotificationList(items: [_item(id: 1, readAt: DateTime(2026, 1, 2))]),
    );
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final result = await notifier.markAllAsRead();

    expect(result, false);
    verifyNever(() => markAllAsRead());
  });
}

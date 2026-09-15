import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/notification_exception.dart';
import 'package:ddara/core/network/dto/notification/notification_list_response.dart';
import 'package:ddara/core/network/dto/notification/unread_notification_response.dart';
import 'package:ddara/data/datasource/notification/notification_datasource.dart';
import 'package:ddara/data/repository/notification_repository_impl.dart';
import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationDataSource extends Mock implements NotificationDataSource {}

DioException _dioError({String? code}) {
  final req = RequestOptions(path: '/api/notifications');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

void main() {
  late MockNotificationDataSource dataSource;
  late NotificationRepositoryImpl repository;

  setUp(() {
    dataSource = MockNotificationDataSource();
    repository = NotificationRepositoryImpl(dataSource);
  });

  group('getNotifications', () {
    test('category 를 문자열로 변환해 DataSource 에 위임한다', () async {
      when(
        () => dataSource.getNotifications(category: 'activity'),
      ).thenAnswer((_) async => const NotificationListResponse(items: []));

      final result = await repository.getNotifications(
        category: NotificationCategory.activity,
      );

      expect(result.items, isEmpty);
      verify(() => dataSource.getNotifications(category: 'activity')).called(1);
    });

    test('DioException 은 NetworkException 으로 변환한다', () async {
      when(
        () => dataSource.getNotifications(category: any(named: 'category')),
      ).thenThrow(_dioError());

      expect(
        () => repository.getNotifications(category: NotificationCategory.all),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('hasUnread', () {
    test('응답의 hasUnread 값을 그대로 반환한다', () async {
      when(
        () => dataSource.getUnread(),
      ).thenAnswer((_) async => const UnreadNotificationResponse(hasUnread: true));

      final result = await repository.hasUnread();

      expect(result, true);
    });

    test('DioException 은 NetworkException 으로 변환한다', () async {
      when(() => dataSource.getUnread()).thenThrow(_dioError());

      expect(() => repository.hasUnread(), throwsA(isA<NetworkException>()));
    });
  });

  group('markAsRead', () {
    test('NOTIFICATION_NOT_FOUND 코드는 NotificationNotFoundException 으로 변환한다', () async {
      when(
        () => dataSource.markAsRead(any()),
      ).thenThrow(_dioError(code: 'NOTIFICATION_NOT_FOUND'));

      expect(
        () => repository.markAsRead(1),
        throwsA(isA<NotificationNotFoundException>()),
      );
    });

    test('매칭되지 않는 code 는 NetworkException 으로 변환한다', () async {
      when(() => dataSource.markAsRead(any())).thenThrow(_dioError());

      expect(() => repository.markAsRead(1), throwsA(isA<NetworkException>()));
    });
  });

  group('markAllAsRead', () {
    test('DataSource 호출을 그대로 위임한다', () async {
      when(() => dataSource.markAllAsRead()).thenAnswer((_) async {});

      await repository.markAllAsRead();

      verify(() => dataSource.markAllAsRead()).called(1);
    });

    test('DioException 은 fromCode 매핑을 거쳐 NetworkException 으로 변환한다', () async {
      when(() => dataSource.markAllAsRead()).thenThrow(_dioError());

      expect(() => repository.markAllAsRead(), throwsA(isA<NetworkException>()));
    });
  });
}

import 'package:ddara/data/datasource/fcm/fcm_datasource.dart';
import 'package:ddara/data/repository/fcm_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFcmDataSource extends Mock implements FcmDataSource {}

void main() {
  late MockFcmDataSource dataSource;
  late FcmRepositoryImpl repository;

  setUp(() {
    dataSource = MockFcmDataSource();
    repository = FcmRepositoryImpl(dataSource);
  });

  test('토큰을 그대로 DataSource 에 위임한다', () async {
    when(() => dataSource.registerToken('token')).thenAnswer((_) async {});

    await repository.registerToken('token');

    verify(() => dataSource.registerToken('token')).called(1);
  });
}

import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/get_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late GetProfileUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = GetProfileUseCase(repository);
  });

  test('Repository 의 결과를 그대로 반환한다', () async {
    final profile = Profile(
      id: 1,
      name: 'kim',
      profileImageUrl: null,
      provider: 'KAKAO',
      createdAt: DateTime(2026, 1, 1),
    );
    when(() => repository.getProfile()).thenAnswer((_) async => profile);

    final result = await useCase.call();

    expect(result, profile);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getProfile()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}

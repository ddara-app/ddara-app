import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/upload_profile_image_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late UploadProfileImageUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = UploadProfileImageUseCase(repository);
  });

  test('imagePath 를 그대로 위임하고 새 이미지 URL 을 반환한다', () async {
    when(
      () => repository.uploadProfileImage('/path'),
    ).thenAnswer((_) async => 'https://new-image');

    final result = await useCase.call('/path');

    expect(result, 'https://new-image');
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.uploadProfileImage(any()),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call('/path'), throwsA(isA<Exception>()));
  });
}

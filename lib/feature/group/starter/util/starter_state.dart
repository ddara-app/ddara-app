import 'package:ddara/core/exception/group_action_error.dart';

/// 스타터 화면에서 현재 보여줄 본문 단계. (촬영으로 시작해 정보 입력으로 넘어간다)
enum StarterStep { camera, info }

/// 스타터 화면 상태.
///
/// 조회형 화면(모임 상세·갤러리·히스토리)과 달리 서버에서 받아 그리는 본문이
/// 없어 sealed(Loading / LoadError / Loaded) 로 나눌 대상이 아니다. 여기의
/// [isLoading]·[error] 는 업로드 액션의 진행·실패이지 조회 상태가 아니다.
class StarterState {
  /// 현재 본문 단계.
  final StarterStep step;

  /// 컨셉 설명 입력값. (단계가 바뀌어도 유지)
  final String concept;

  /// 촬영해 본문에 반영할 사진 파일 경로. null 이면 아직 촬영 전이다.
  /// 업로드 소스이자 표시(FileImage) 소스로 쓴다.
  final String? photoPath;

  /// 업로드 진행 중 여부. (중복 전송 방지·버튼 로딩 표시)
  final bool isLoading;

  /// 업로드 실패 종류. (문구는 화면이 l10n 으로 매핑)
  final GroupActionError? error;

  const StarterState({
    this.step = StarterStep.camera,
    this.concept = '',
    this.photoPath,
    this.isLoading = false,
    this.error,
  });

  StarterState copyWith({
    StarterStep? step,
    String? concept,
    String? photoPath,
    bool? isLoading,
    GroupActionError? error,
    bool clearError = false,
  }) {
    return StarterState(
      step: step ?? this.step,
      concept: concept ?? this.concept,
      photoPath: photoPath ?? this.photoPath,
      isLoading: isLoading ?? this.isLoading,
      // copyWith(error: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      error: clearError ? null : (error ?? this.error),
    );
  }
}

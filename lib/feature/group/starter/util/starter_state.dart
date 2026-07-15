/// 스타터 화면에서 현재 보여줄 본문 단계. (촬영으로 시작해 정보 입력으로 넘어간다)
enum StarterStep { camera, info }

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

  /// 업로드 성공 시 생성된 사이클 id. null 이면 아직 성공 전이다.
  final int? uploadedCycleId;

  /// 업로드 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const StarterState({
    this.step = StarterStep.camera,
    this.concept = '',
    this.photoPath,
    this.isLoading = false,
    this.uploadedCycleId,
    this.errorMessage = '',
  });

  StarterState copyWith({
    StarterStep? step,
    String? concept,
    String? photoPath,
    bool? isLoading,
    int? uploadedCycleId,
    String? errorMessage,
  }) {
    return StarterState(
      step: step ?? this.step,
      concept: concept ?? this.concept,
      photoPath: photoPath ?? this.photoPath,
      isLoading: isLoading ?? this.isLoading,
      uploadedCycleId: uploadedCycleId ?? this.uploadedCycleId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

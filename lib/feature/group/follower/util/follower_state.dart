class FollowerState {
  /// 업로드 진행 중 여부. (중복 전송 방지·버튼 로딩 표시)
  final bool isLoading;

  /// 업로드 성공 시 서버가 돌려준 사이클 id. null 이면 아직 성공 전이다.
  final int? uploadedCycleId;

  /// 업로드 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const FollowerState({
    this.isLoading = false,
    this.uploadedCycleId,
    this.errorMessage = '',
  });

  FollowerState copyWith({
    bool? isLoading,
    int? uploadedCycleId,
    String? errorMessage,
  }) {
    return FollowerState(
      isLoading: isLoading ?? this.isLoading,
      uploadedCycleId: uploadedCycleId ?? this.uploadedCycleId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

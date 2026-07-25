class FollowerState {
  /// 업로드 진행 중 여부. (중복 전송 방지·버튼 로딩 표시)
  final bool isLoading;

  /// 업로드 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const FollowerState({this.isLoading = false, this.errorMessage = ''});

  FollowerState copyWith({bool? isLoading, String? errorMessage}) {
    return FollowerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

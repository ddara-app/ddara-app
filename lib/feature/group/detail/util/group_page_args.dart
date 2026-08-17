/// `GroupPage` 진입 시 함께 넘기는 표시 힌트.
///
/// 모임 id 는 경로(`RoutePath.group`)에 있으므로 여기엔 담지 않는다. 상세 조회가
/// 끝나기 전 화면을 미리 채우는 용도라 모든 값이 선택이며, 모르는 진입(딥링크
/// 등)은 인자 없이 이동해도 된다.
class GroupPageArgs {
  const GroupPageArgs({
    this.groupName,
    this.hasCurrentCycle,
    this.thumbnailUrl,
  });

  /// 상세 조회 전 AppBar 에 미리 띄울 모임 이름. 모르면 null.
  final String? groupName;

  /// 진행 중 사이클 유무. 헤더 모양(빈 상태 / 사진)이 갈리므로, 아는 경우에만
  /// 넘겨 조회 전 골격의 높이를 맞춘다. 모르면 null.
  final bool? hasCurrentCycle;

  /// 진행 중 사이클의 스타터 썸네일 URL.
  /// 목록에서 이미 보여준 이미지라면 캐시가 있어 조회 전에도 바로 그려진다.
  final String? thumbnailUrl;
}

import 'package:ddara/domain/model/group/change_nickname.dart';
import 'package:ddara/domain/model/group/create_group.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/model/group/history_cycles.dart';
import 'package:ddara/domain/model/group/history_list.dart';
import 'package:ddara/domain/model/group/invite_group.dart';
import 'package:ddara/domain/model/group/join_group.dart';

abstract interface class GroupRepository {
  Future<CreateGroup> createGroup(
    String groupName,
    String description,
    String nickName,
  );

  Future<GroupList> getGroupList();

  Future<GroupDetail> getGroupDetail(int groupId);

  Future<InviteGroup> getInviteGroup(String inviteCode);

  Future<JoinGroup> joinGroup(String inviteCode, String nickName);

  Future<void> exitGroup(int groupId);

  /// 다음 스타터 공개를 확인했다고 서버에 표시한다. (이후 상세 조회의
  /// nextStarter.seen 이 true 로 내려온다)
  Future<void> markNextStarterSeen(int groupId);

  /// 모임 페이지 프리뷰용 지난 따라찍기. (경량)
  Future<HistoryCycles> getHistoryCycles(int groupId);

  /// 더보기 화면용 지난 따라찍기. (통계 + 참가자 목록 포함)
  /// [year]·[month] 를 함께 주면 해당 연·월로 필터링한다. (month 단독 사용 불가)
  Future<HistoryList> getHistoryList(int groupId, {int? year, int? month});

  Future<ChangeNickName> changeNickName(int groupId, String nickName);
}

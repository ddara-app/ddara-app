import 'package:ddara/core/network/dto/group/change_nickname_response.dart';
import 'package:ddara/core/network/dto/group/create_group_response.dart';
import 'package:ddara/core/network/dto/group/cycle_gallery_response.dart';
import 'package:ddara/core/network/dto/group/group_detail_response.dart';
import 'package:ddara/core/network/dto/group/group_list_response.dart';
import 'package:ddara/core/network/dto/group/history_cycles_response.dart';
import 'package:ddara/core/network/dto/group/invite_group_response.dart';
import 'package:ddara/core/network/dto/group/join_group_response.dart';
import 'package:ddara/data/repository/mapper/group_mapper.dart';
import 'package:ddara/domain/model/group/cycle_shot_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CreateGroupMapper: groupId 만 도메인 모델로 옮긴다', () {
    final response = CreateGroupResponse(
      groupId: 1,
      name: 'group',
      description: 'desc',
      inviteCode: 'ABC123',
      createdAt: DateTime(2026, 1, 1),
    );

    expect(response.toDomain().groupId, 1);
  });

  test('JoinGroupMapper: groupId 만 도메인 모델로 옮긴다', () {
    const response = JoinGroupResponse(groupId: 2, name: 'group');

    expect(response.toDomain().groupId, 2);
  });

  test('InviteGroupMapper: DTO 필드를 그대로 도메인 모델로 옮긴다', () {
    final response = InviteGroupResponse(
      groupId: 1,
      name: 'group',
      description: 'desc',
      ownerNickname: 'owner',
      memberCount: 3,
      capacity: 8,
      isFull: false,
      memberAvatars: const ['https://a', null],
      alreadyJoined: true,
      createdAt: DateTime(2026, 1, 1),
    );

    final result = response.toDomain();

    expect(result.groupId, 1);
    expect(result.memberAvatars, ['https://a', null]);
    expect(result.alreadyJoined, true);
  });

  test('ChangeNickNameMapper: nickname 만 도메인 모델로 옮긴다', () {
    const response = ChangeNickNameResponse(groupId: 1, nickname: '새닉네임');

    expect(response.toDomain().nickname, '새닉네임');
  });

  group('GroupDetailMapper', () {
    GroupDetailResponse detail({
      GroupCycleResponse? currentCycle,
      GroupNextStarterResponse? nextStarter,
    }) {
      return GroupDetailResponse(
        groupId: 1,
        name: 'group',
        description: 'desc',
        inviteCode: 'ABC123',
        ownerUserId: 1,
        memberCount: 2,
        members: const [
          GroupMemberResponse(
            userId: 1,
            nickname: 'nick',
            profileImageUrl: null,
            role: 'owner',
          ),
        ],
        currentCycle: currentCycle,
        nextStarter: nextStarter,
        canStartCycle: true,
        createdAt: DateTime(2026, 1, 1),
      );
    }

    test('진행 중인 사이클·다음 스타터가 없으면 각각 null 로 옮긴다', () {
      final result = detail().toDomain();

      expect(result.currentCycle, isNull);
      expect(result.nextStarter, isNull);
      expect(result.members, hasLength(1));
      expect(result.members.first.nickname, 'nick');
    });

    test('진행 중인 사이클이 있으면 필드를 그대로 옮긴다', () {
      final cycle = GroupCycleResponse(
        cycleId: 1,
        cycleNumber: 2,
        topic: 'topic',
        starterUserId: 1,
        starterNickname: 'starter',
        starterImageUrl: 'https://img',
        starterImageUnderReview: false,
        status: 'in_progress',
        startedAt: DateTime(2026, 1, 1),
        deadlineAt: DateTime(2026, 1, 2),
      );

      final result = detail(currentCycle: cycle).toDomain();

      expect(result.currentCycle, isNotNull);
      expect(result.currentCycle!.cycleId, 1);
      expect(result.currentCycle!.uploadedUserIds, isEmpty);
    });

    test('다음 스타터가 있으면 필드를 그대로 옮긴다', () {
      const next = GroupNextStarterResponse(userId: 5, nickname: 'next', seen: true);

      final result = detail(nextStarter: next).toDomain();

      expect(result.nextStarter, isNotNull);
      expect(result.nextStarter!.userId, 5);
      expect(result.nextStarter!.seen, true);
    });
  });

  group('HistoryCyclesMapper', () {
    HistoryCyclesResponse response({HistoryStatsResponse? stats}) {
      return HistoryCyclesResponse(
        stats: stats,
        cycles: [
          HistoryCycleResponse(
            cycleId: 1,
            topic: 'topic',
            thumbnailUrl: 'https://img',
            thumbnailUnderReview: false,
            starterUserId: 1,
            participantCount: 3,
            participants: const [
              HistoryParticipantResponse(userId: 1, profileImageUrl: null),
            ],
            date: DateTime(2026, 1, 1),
          ),
        ],
      );
    }

    test('toGroupHistory 는 통계 없이 카드용 필드만 옮긴다', () {
      final result = response().toGroupHistory();

      expect(result.cycles, hasLength(1));
      expect(result.cycles.first.cycleId, 1);
    });

    test('toHistoryList 는 stats 가 없으면(null) 0/0 으로 채운다', () {
      final result = response().toHistoryList();

      expect(result.stats.myCount, 0);
      expect(result.stats.totalCount, 0);
    });

    test('toHistoryList 는 stats 가 있으면 그대로 옮긴다', () {
      final result = response(
        stats: const HistoryStatsResponse(myCount: 4, totalCount: 10),
      ).toHistoryList();

      expect(result.stats.myCount, 4);
      expect(result.stats.totalCount, 10);
      expect(result.cycles.first.participants, hasLength(1));
    });
  });

  group('CycleGalleryMapper', () {
    test('멤버 status 문자열을 CycleShotStatus 로 매핑한다', () {
      final response = CycleGalleryResponse(
        groupId: 1,
        groupName: 'group',
        cycle: CycleGalleryCycleResponse(
          cycleId: 1,
          cycleNumber: 1,
          topic: 'topic',
          starterUserId: 1,
          starterNickname: 'starter',
          starterShotId: 9,
          starterImageUrl: 'https://img',
          starterImageUnderReview: false,
          status: 'in_progress',
          deadlineAt: DateTime(2026, 1, 2),
        ),
        viewerUploaded: true,
        members: const [
          CycleGalleryMemberResponse(
            userId: 1,
            shotId: 2,
            nickname: 'nick',
            profileImageUrl: null,
            isStarter: false,
            status: 'locked',
            imageUrl: 'https://img',
            uploadedAt: null,
          ),
          CycleGalleryMemberResponse(
            userId: 2,
            shotId: null,
            nickname: 'nick2',
            profileImageUrl: null,
            isStarter: false,
            status: 'unknown_status',
            imageUrl: null,
            uploadedAt: null,
          ),
        ],
      );

      final result = response.toDomain();

      expect(result.members[0].status, CycleShotStatus.locked);
      // 서버가 모르는 status 를 보내도 open(공개)으로 안전하게 처리한다.
      expect(result.members[1].status, CycleShotStatus.open);
    });
  });

  group('GroupListMapper', () {
    test('currentCycle 이 없으면 null, 있으면 필드를 그대로 옮긴다', () {
      final response = GroupListResponse(
        groups: [
          GroupResponse(
            groupId: 1,
            name: 'no-cycle',
            ownerNickname: 'owner',
            memberCount: 2,
            thumbnailUrl: null,
            thumbnailUnderReview: false,
            thumbnailUserId: null,
            currentCycle: null,
            createdAt: DateTime(2026, 1, 1),
          ),
          GroupResponse(
            groupId: 2,
            name: 'with-cycle',
            ownerNickname: 'owner',
            memberCount: 2,
            thumbnailUrl: null,
            thumbnailUnderReview: false,
            thumbnailUserId: null,
            currentCycle: CurrentCycleResponse(
              cycleId: 5,
              topic: 'topic',
              deadlineAt: DateTime(2026, 1, 2),
            ),
            createdAt: DateTime(2026, 1, 1),
            showStarterBorder: true,
          ),
        ],
      );

      final result = response.toDomain();

      expect(result.groups[0].currentCycle, isNull);
      expect(result.groups[1].currentCycle, isNotNull);
      expect(result.groups[1].currentCycle!.cycleId, 5);
      expect(result.groups[1].showStarterBorder, true);
    });
  });
}

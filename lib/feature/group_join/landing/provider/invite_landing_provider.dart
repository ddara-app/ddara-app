import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 초대 랜딩에서 초대 코드로 모임 정보를 조회한다.
///
/// 조회에 실패(무효 코드·모임 없음·네트워크 등 예상 예외)해도 랜딩 흐름은 그대로
/// 다음 화면으로 진행되므로 `null` 을 반환한다. 예상 못한 예외(응답 파싱 오류 등)는
/// 삼키지 않고 그대로 던져 `AsyncError` 로 드러낸다.
final inviteLandingGroupProvider = FutureProvider.autoDispose
    .family<InviteGroup?, String>((ref, inviteCode) async {
      try {
        return await ref.read(getInviteGroupUseCaseProvider)(inviteCode);
      } on GroupException {
        return null;
      } on NetworkException {
        return null;
      }
    });

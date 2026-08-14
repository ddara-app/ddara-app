import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:flutter/animation.dart';

/// 스타터 슬롯머신 릴 레이아웃 상수. (Figma Swyp-designers-v4 · 40003384:16447,
/// 2026-07-17 재검토 반영 실측값)
///
/// 세로 배치는 전부 이 값에서 파생 계산한다 — [itemHeight] 만 바꾸면
/// [pitch]·[centerY]·타깃 오프셋이 공식으로 재계산된다.
abstract final class StarterReelLayout {
  /// 릴 카드(아바타) 한 칸 높이. 결과 리빌 아바타와 동일 크기.
  static const double itemHeight = 104;

  /// 카드 사이 간격.
  static const double itemGap = 12;

  /// 카드 한 칸의 반복 주기.
  static const double pitch = itemHeight + itemGap;

  /// 릴이 보이는 창 높이. (104px 아바타가 잘리지 않도록 101→140 확대)
  static const double windowHeight = 140;

  /// 창 위아래 딤 그라디언트 높이.
  static const double fadeHeight = 34;

  /// 릴 시작 위치. (Figma 실측 y)
  static const double reelStartY = -123;

  /// 창 안에서 카드가 정중앙에 오는 릴 오프셋.
  static const double centerY = (windowHeight - itemHeight) / 2;

  /// 슬롯(소멸)과 결과 리빌(등장)이 겹치는 hero 영역 높이.
  static const double heroHeight = 240;

  /// hero 안에서 슬롯 창 상단 y. (셸 상단 여백 포함 실측)
  static const double slotWindowTop = 45;

  /// 슬롯 창 세로 중심 — 결과 아바타 중심을 여기에 맞춘다.
  static const double slotCenterY = slotWindowTop + windowHeight / 2;

  /// 결과 리빌 상단 y. (아바타 중심 = 슬롯 창 중심)
  static const double revealTop = slotCenterY - itemHeight / 2;
}

/// 릴에 그릴 멤버 목록을 만든다. 마지막 [starter] 칸이 당첨(정지) 지점이다.
///
/// 착지 바운스가 당첨자를 pitch 1칸만큼 지나쳤다 되돌아오므로, 당첨자가 릴의
/// 맨 끝이면 지나친 자리가 빈칸으로 보인다 → 당첨자 뒤에도 카드를 몇 개 더
/// 붙인다. trailing 에서 당첨자를 제외해야 lastIndexWhere 가 뒤쪽 카드를
/// 정답으로 착각하지 않는다.
List<GroupMember> buildStarterReel({
  required List<GroupMember> members,
  required GroupMember starter,
}) {
  final base = members.isEmpty ? [starter] : members;
  final trailing = base
      .where((member) => member.userId != starter.userId)
      .take(3)
      .toList();
  return [...base, ...base, ...base, ...base.take(3), starter, ...trailing];
}

/// 릴 세로 오프셋 애니메이션. 빠른 회전(선형) → 감속 → 당첨자를 지나쳤다
/// 되돌아오는 착지 바운스 순서로 [targetIndex] 칸을 창 중앙에 세운다.
Animation<double> buildStarterReelOffset({
  required AnimationController controller,
  required int targetIndex,
}) {
  const pitch = StarterReelLayout.pitch;
  final targetOffset = StarterReelLayout.centerY - targetIndex * pitch;

  return TweenSequence<double>([
    TweenSequenceItem(
      tween:
          Tween<double>(
            begin: StarterReelLayout.reelStartY + pitch,
            end: targetOffset - pitch * 6,
          ).chain(
            CurveTween(curve: Curves.linear),
          ),
      weight: 72,
    ),
    TweenSequenceItem(
      tween:
          Tween<double>(
            begin: targetOffset - pitch * 6,
            end: targetOffset + pitch,
          ).chain(
            CurveTween(curve: Curves.easeOutCubic),
          ),
      weight: 12,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: targetOffset + pitch, end: targetOffset - 18)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 7,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: targetOffset - 18, end: targetOffset + 10)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 5,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: targetOffset + 10, end: targetOffset)
          .chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 4,
    ),
  ]).animate(controller);
}

import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/feature/notification/widget/notification_empty.dart';
import 'package:ddara/feature/notification/widget/notification_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 알림 목록 화면.
///
/// 상단 바(뒤로가기 + 가운데 '알림') 아래로 알림 항목([NotificationItem])을 쌓는다.
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // TODO: 알림 조회 API 응답으로 대체. (백엔드 스펙 대기 — 임시 더미)
  static const List<NotificationDisplay> _dummy = [
    (
      category: '모임 합류',
      message: '지원님이 ‘마라탕 맛있게 먹기’ 모임에 합류했어요',
      timeAgo: '5분 전',
      imageUrl: null,
      isRead: false,
    ),
    (
      category: '따라찍기 시작',
      message: '‘마라탕 맛있게 먹기’ 모임에서 새로운 따라찍기가 시작됐어요',
      timeAgo: '1시간 전',
      imageUrl: null,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: AppBar(title: '알림', onBack: () => context.pop()),
      child: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    // 실데이터 연동 시 _dummy → API 응답으로 교체. (빈 상태 확인은 const [] 로 대체)
    const notifications = _dummy;

    // 알림이 없으면 빈 상태 화면을 중앙에 보여준다.
    if (notifications.isEmpty) {
      return const Center(child: NotificationEmpty());
    }

    return SingleChildScrollView(
      // 끝에서 더 당겨지는 바운스(overscroll)를 막고 가장자리에서 멈춘다.
      physics: const ClampingScrollPhysics(),
      // 상단 s3, 좌우 s5, 하단 s6 여백.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s5,
        AppSpacing.s3,
        AppSpacing.s5,
        AppSpacing.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3,
        children: [
          for (final notification in notifications)
            NotificationItem(data: notification),
        ],
      ),
    );
  }
}

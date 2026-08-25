import 'package:ddara/domain/model/feed/feed.dart';
import 'package:ddara/feature/home/widget/photo_card_shell.dart';
import 'package:flutter/cupertino.dart';

/// 최근 업데이트 카드. (모임 카드와 같은 껍데기에 회차 주제·업로더 닉네임을 얹는다)
///
/// 잠긴 사진([FeedItem.locked])은 블러 처리되고 가운데에 자물쇠가 표시된다.
class FeedCard extends StatelessWidget {
  const FeedCard({super.key, required this.item, required this.onTap});

  final FeedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PhotoCardShell(
      imageUrl: item.imageUrl,
      title: item.topic,
      subtitle: item.nickname,
      underReview: item.imageUnderReview,
      locked: item.locked,
      onTap: onTap,
    );
  }
}

import 'package:ddara/core/widget/title_description.dart';
import 'package:flutter/cupertino.dart';

/// 온보딩 스텝 하나의 스와이프 콘텐츠 (제목 + 설명).
///
/// 세 스텝은 문구만 다른 동일 레이아웃이라 데이터 주입형 위젯 하나로 그린다.
/// 로고·인디케이터는 [OnboardingPage] 가 고정으로 들고 있고,
/// 이 위젯만 PageView 안에서 좌우로 전환된다.
class OnboardingStepContent extends StatelessWidget {
  const OnboardingStepContent({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TitleDescription(
        title: title,
        description: description,
        centered: true,
      ),
    );
  }
}

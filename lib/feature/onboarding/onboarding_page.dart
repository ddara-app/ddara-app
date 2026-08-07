import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/logo/logo.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/design_system/component/indicator/page_indicator.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:ddara/feature/onboarding/provider/viewmodel_provider.dart';
import 'package:ddara/feature/onboarding/widget/onboarding_step_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  /// 온보딩 스텝 문구 목록. 스텝 수는 이 목록 길이로 파생된다.
  /// (제목은 l10n 이라 build 시점에 구성)
  List<({String title, String body})> _steps(AppLocalizations l10n) => [
    (title: l10n.onboardingFirstTitle, body: l10n.onboardingFirstBody),
    (title: l10n.onboardingSecondTitle, body: l10n.onboardingSecondBody),
    (title: l10n.onboardingThirdTitle, body: l10n.onboardingThirdBody),
  ];

  @override
  void initState() {
    super.initState();
    _trackStepViewed(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goPrevious() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 이 속도(px/s) 이상으로 플링하면 드래그 거리와 무관하게 그 방향으로 넘긴다.
  static const _flingVelocity = 300.0;

  /// PageView 밖(로고·여백 등)에서 시작한 가로 드래그를 컨트롤러에 전달해
  /// 화면 어디를 문질러도 페이지가 손가락을 따라오게 한다.
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _controller.position.moveTo(_controller.position.pixels - details.delta.dx);
  }

  /// 드래그가 끝나면 플링 방향 또는 더 가까운 페이지로 스냅한다.
  void _onHorizontalDragEnd(DragEndDetails details) {
    final page = _controller.page ?? _index.toDouble();
    final velocity = details.primaryVelocity ?? 0;

    final int target;
    if (velocity <= -_flingVelocity) {
      target = page.floor() + 1;
    } else if (velocity >= _flingVelocity) {
      target = page.ceil() - 1;
    } else {
      target = page.round();
    }

    _snapToPage(target);
  }

  void _snapToPage(int target) {
    final lastIndex = _steps(AppLocalizations.of(context)).length - 1;
    _controller.animateToPage(
      target.clamp(0, lastIndex),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // step 은 사용자에게 보이는 순서 그대로 1부터 센다.
  void _trackStepViewed(int index) {
    AppAnalytics.track(
      'onboarding_step_viewed(${index + 1})',
      properties: {'step': index + 1},
    );
  }

  Future<void> _start() async {
    AppAnalytics.track('onboarding_completed');
    await ref.read(onboardingSeenProvider.notifier).complete();
    if (!mounted) return;

    context.go(RoutePath.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = _steps(l10n);
    final isLastPage = _index == steps.length - 1;

    return PopScope(
      // 첫 스텝에선 시스템 뒤로가기로 앱을 종료하고, 그 외에는 가로채 이전 스텝으로 되돌린다.
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _goPrevious();
      },
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: GestureDetector(
            // 빈 여백 터치도 잡아 화면 전체를 스와이프 영역으로 만든다.
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onHorizontalDragCancel: () =>
                _snapToPage((_controller.page ?? _index.toDouble()).round()),
            child: Stack(
              children: [
                // 로고·텍스트·인디케이터를 한 덩어리로 화면 정중앙에 모은다.
                // (버튼을 아래에 겹쳐 띄우므로 버튼 높이에 밀리지 않는다)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.s7,
                    children: [
                      // 페이지가 바뀌어도 고정되는 로고
                      const LogoLarge(),
                      // 제목·설명만 좌우로 스와이프되는 영역.
                      //
                      // 높이는 가장 긴 스텝 문구에 맞춰 정해진다 — 보이지 않는
                      // 사본들을 겹쳐 Stack 높이를 만들고 그 위에 PageView 를
                      // 얹는다. 고정 상수 없이도 스텝을 넘길 때 로고·인디케이터가
                      // 움직이지 않고, 큰 글자 설정에서도 잘리지 않는다.
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          for (final step in steps)
                            Opacity(
                              opacity: 0,
                              child: OnboardingStepContent(
                                title: step.title,
                                description: step.body,
                              ),
                            ),
                          Positioned.fill(
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: steps.length,
                              onPageChanged: (index) {
                                _trackStepViewed(index);
                                setState(() => _index = index);
                              },
                              itemBuilder: (_, index) => OnboardingStepContent(
                                title: steps[index].title,
                                description: steps[index].body,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // 페이지가 바뀌어도 고정되며, 활성 점만 애니메이션으로 전환되는 인디케이터
                      PageIndicator(
                        currentIndex: _index,
                        spacing: AppSpacing.s3,
                      ),
                    ],
                  ),
                ),
                // 하단 버튼. 좌우를 0 으로 고정해 풀폭을 확보한다.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    // 좌우는 Page 규칙(s5), 하단은 화면 끝 기준 s7.
                    padding: const EdgeInsets.only(
                      top: AppSpacing.s4,
                      left: AppSpacing.s5,
                      right: AppSpacing.s5,
                      bottom: AppSpacing.s7,
                    ),
                    child: AppButton(
                      label: isLastPage
                          ? l10n.onboardingStart
                          : l10n.onboardingNext,
                      onPressed: isLastPage ? _start : _goNext,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

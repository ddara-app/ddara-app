import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/logo/logo.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/design_system/component/indicator/page_indicator.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:ddara/feature/onboarding/provider/onboarding_provider.dart';
import 'package:ddara/feature/onboarding/widget/onboarding_step_content.dart';
import 'package:flutter/material.dart';
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
    MixpanelManager.instance.track(
      'onboarding_step_viewed(${index + 1})',
      properties: {'step': index + 1},
    );
  }

  Future<void> _start() async {
    MixpanelManager.instance.track('onboarding_completed');
    // 온보딩 완료 플래그 저장 → 다음 실행부터는 노출되지 않는다.
    await ref.read(onboardingControllerProvider).complete();
    // 캐싱된 onboardingSeenProvider 를 무효화해 즉시 최신 값(true)을 읽도록 한다.
    // (이게 없으면 로그아웃 등으로 라우터가 재생성될 때 stale false 로 온보딩이 다시 뜬다)
    ref.invalidate(onboardingSeenProvider);
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
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            // 빈 여백 터치도 잡아 화면 전체를 스와이프 영역으로 만든다.
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onHorizontalDragCancel: () =>
                _snapToPage((_controller.page ?? _index.toDouble()).round()),
            child: Column(
              children: [
                // 로고·텍스트·인디케이터를 한 덩어리로 화면 중앙에 모은다.
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 페이지가 바뀌어도 고정되는 로고
                      const LogoLarge(),
                      const SizedBox(height: AppSpacing.s6),
                      // 제목·설명만 좌우로 스와이프되는 영역 (고정 높이)
                      SizedBox(
                        height: 120,
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
                      const SizedBox(height: AppSpacing.s6),
                      // 페이지가 바뀌어도 고정되며, 활성 점만 애니메이션으로 전환되는 인디케이터
                      PageIndicator(currentIndex: _index),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton(
                    label: isLastPage
                        ? l10n.onboardingStart
                        : l10n.onboardingNext,
                    onPressed: isLastPage ? _start : _goNext,
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

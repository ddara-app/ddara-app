import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/random_starter/util/starter_reel.dart';
import 'package:ddara/feature/group/random_starter/widget/starter_confetti.dart';
import 'package:ddara/feature/group/random_starter/widget/starter_result_reveal.dart';
import 'package:ddara/feature/group/random_starter/widget/starter_slot_machine.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [RandomStarterPage] 라우트 인자.
class RandomStarterArgs {
  const RandomStarterArgs({
    required this.groupId,
    required this.starterUserId,
    required this.members,
  });

  /// 스타터를 정하는 모임 식별자. (분석 이벤트용)
  final int groupId;

  /// 서버가 정한 스타터의 userId. 클라이언트에서 랜덤을 다시 돌리지 않는다.
  final int starterUserId;

  /// 슬롯머신 릴에 올릴 모임 멤버 목록.
  final List<GroupMember> members;
}

/// 스타터 랜덤 지정 슬롯머신 화면.
///
/// 서버가 이미 정한 스타터를 받아 슬롯머신 공개 모션만 재생한다.
/// 시퀀스: 스핀·착지(2.52초) → 슬롯 소멸 + 아바타 리빌(0.64초, confetti 와
/// 동시 시작) → confetti 종료(1.8초) 후 CTA 활성화.
/// CTA 는 공개된 스타터([GroupMember])를 결과로 pop 한다 — 이후 진행(촬영
/// 이동 등)은 호출부가 결정한다.
class RandomStarterPage extends ConsumerStatefulWidget {
  const RandomStarterPage({super.key, required this.args});

  final RandomStarterArgs args;

  @override
  ConsumerState<RandomStarterPage> createState() => _RandomStarterPageState();
}

class _RandomStarterPageState extends ConsumerState<RandomStarterPage>
    with TickerProviderStateMixin {
  /// 확인 버튼이 나타나는 페이드 길이.
  static const _ctaFadeDuration = Duration(milliseconds: 250);

  late final AnimationController _slotController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2520),
  );

  /// 슬롯 소멸(앞 50%)과 아바타 등장(0.12 이후 easeOutBack 팝)을 컨트롤러
  /// 하나로 같이 구동한다.
  late final AnimationController _resultController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
  );

  /// confetti 재생. duration 은 Lottie 로드 시 실측 길이로 갱신되고,
  /// 로드에 실패해도 이 기본값으로 완주해 CTA 활성화가 막히지 않는다.
  late final AnimationController _confettiController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  late final Animation<double> _slotExit = CurvedAnimation(
    parent: _resultController,
    curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
  );
  late final Animation<double> _avatarOpacity = CurvedAnimation(
    parent: _resultController,
    curve: const Interval(0.12, 0.6, curve: Curves.easeOut),
  );
  late final Animation<double> _avatarScale = Tween<double>(begin: 0.7, end: 1)
      .animate(
        CurvedAnimation(
          parent: _resultController,
          curve: const Interval(0.12, 1.0, curve: Curves.easeOutBack),
        ),
      );

  /// 서버가 정한 스타터. 인자가 유효하지 않으면 null — 에러 상태로 표시한다.
  GroupMember? _starter;
  List<GroupMember> _reelMembers = const [];
  Animation<double> _offset = const AlwaysStoppedAnimation(0);
  bool _done = false;
  bool _prepared = false;

  @override
  void initState() {
    super.initState();
    MixpanelManager.instance.track(
      'random_starter_page_viewed',
      properties: {'group_id': widget.args.groupId},
    );
    _markSeen();
    _configureReel();
  }

  /// 공개 화면에 들어온 시점에 확인 처리를 남긴다. 이후 모임 진입에서 이미 본
  /// 멤버에게는 이 화면을 다시 띄우지 않는다. (당첨자 본인은 시작 전까지 계속 노출)
  ///
  /// 실패해도 공개 모션은 그대로 재생한다 — 표시가 남지 않으면 다음 진입에서
  /// 다시 보여주고 재시도되므로 사용자에게 에러를 알리지 않는다.
  Future<void> _markSeen() async {
    try {
      await ref.read(markNextStarterSeenUseCaseProvider)(widget.args.groupId);
    } catch (_) {
      // 무시. (다음 진입 때 다시 시도된다)
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 아바타를 먼저 내려받아 첫 스핀부터 얼굴이 보이게 한 뒤 재생을 시작한다.
    // (precacheImage 가 context 를 요구해 initState 가 아닌 여기서 시작)
    if (_prepared) return;
    _prepared = true;
    _prepareAndPlay();
  }

  @override
  void didUpdateWidget(covariant RandomStarterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.args.starterUserId != widget.args.starterUserId ||
        !listEquals(oldWidget.args.members, widget.args.members)) {
      _configureReel();
      _play();
    }
  }

  @override
  void dispose() {
    _slotController.dispose();
    _resultController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _configureReel() {
    // 서버가 정한 스타터가 멤버 목록에 없으면(빈 목록 포함) 임의 멤버로
    // 대체하지 않고 에러 상태로 둔다 — 잘못된 당첨자를 보여주는 것보다 낫다.
    final selectedIndex = widget.args.members.indexWhere(
      (member) => member.userId == widget.args.starterUserId,
    );
    if (selectedIndex < 0) {
      _starter = null;
      return;
    }

    final starter = widget.args.members[selectedIndex];
    _starter = starter;
    _reelMembers = buildStarterReel(
      members: widget.args.members,
      starter: starter,
    );
    _offset = buildStarterReelOffset(
      controller: _slotController,
      targetIndex: _reelMembers.lastIndexWhere(
        (member) => member.userId == starter.userId,
      ),
    );
  }

  Future<void> _prepareAndPlay() async {
    await _precacheAvatars();
    if (!mounted) return;
    _play();
  }

  /// 릴에 올라갈 아바타를 미리 내려받는다. 네트워크가 느려도 스핀이 마냥
  /// 늦어지지 않도록 2초에서 잘라낸다. (실패는 기본 아이콘으로 대체되므로 무시)
  Future<void> _precacheAvatars() async {
    final urls = widget.args.members
        .map((member) => member.profileImageUrl)
        .whereType<String>()
        .where((url) => url.isNotEmpty);
    if (urls.isEmpty) return;

    await Future.wait(
      urls.map(
        (url) => precacheImage(
          CachedNetworkImageProvider(url),
          context,
        ).catchError((_) {}),
      ),
    ).timeout(const Duration(seconds: 2), onTimeout: () => const []);
  }

  Future<void> _play() async {
    if (_starter == null || _slotController.isAnimating) return;
    setState(() => _done = false);
    _slotController.reset();
    _resultController.reset();
    _confettiController.reset();

    await _slotController.forward();
    if (!mounted) return;

    // 아바타 리빌과 confetti 를 동시에 시작하고, CTA 는 confetti 까지 끝난
    // 뒤에만 활성화한다. ("로티까지 끝나고 나온 뒤에 보이도록")
    _resultController.forward();
    await _confettiController.forward();
    if (!mounted) return;
    setState(() => _done = true);
  }

  /// 공개된 스타터를 결과로 돌려주며 화면을 닫는다.
  void _onStartPressed() => context.pop(_starter);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // AppBar 없이 본문만 두고, 배경은 스캐폴드의 기본 배경을 그대로 쓴다.
    return CupertinoPageScaffold(
      child: SafeArea(
        child: _starter == null
            ? Center(child: AppText.body(l10n.randomStarterLoadFailed))
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s4,
                            ),
                            child: _buildHero(),
                          ),
                        ),
                        // 다시보기는 당분간 노출하지 않는다. (기능은 유지)
                        Positioned(
                          right: AppSpacing.s4,
                          bottom: AppSpacing.s6,
                          child: Visibility(
                            visible: false,
                            child: AppTextButton.body(
                              label: l10n.randomStarterReplay,
                              onPressed: _done ? _play : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s4,
                      AppSpacing.s3,
                      AppSpacing.s4,
                      AppSpacing.s6,
                    ),
                    // 공개 모션이 끝나기 전에는 비활성 버튼을 보여주는 대신
                    // 아예 감춰 두고, 끝나는 순간 페이드로 나타낸다.
                    // (자리는 항상 차지해 나타날 때 본문이 밀리지 않는다)
                    child: AnimatedOpacity(
                      duration: _ctaFadeDuration,
                      opacity: _done ? 1 : 0,
                      child: AppButton(
                        label: l10n.commonConfirm,
                        onPressed: _done ? _onStartPressed : null,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// 슬롯(소멸)과 아바타 리빌(등장)이 같은 자리에 겹치는 hero 영역.
  /// 슬롯 아래 카드가 덧붙는 구조가 아니라 슬롯 → 아바타로 전환된다.
  Widget _buildHero() {
    return SizedBox(
      width: double.infinity,
      height: StarterReelLayout.heroHeight,
      child: Stack(
        // 닉네임이 길어 리빌 문구가 두 줄이 되어도 잘리지 않게 한다.
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: StarterReelLayout.slotWindowTop,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: ReverseAnimation(_slotExit),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.88).animate(_slotExit),
                child: AnimatedBuilder(
                  animation: _slotController,
                  builder: (context, _) => StarterSlotMachine(
                    reelMembers: _reelMembers,
                    offsetY: _offset.value,
                  ),
                ),
              ),
            ),
          ),
          // confetti 는 결과 리빌 뒤에 깔린다 — 아바타가 색종이 위로 떠 보인다.
          Positioned.fill(
            child: StarterConfetti(controller: _confettiController),
          ),
          Positioned(
            top: StarterReelLayout.revealTop,
            left: 0,
            right: 0,
            child: StarterResultReveal(
              starter: _starter!,
              opacity: _avatarOpacity,
              scale: _avatarScale,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:ddara/core/router/pending_invite.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/feature/group_join/join_group_page.dart';
import 'package:ddara/feature/group_join/landing/provider/invite_landing_provider.dart';
import 'package:ddara/feature/group_join/landing/widget/ddara_invitation_animation.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:go_router/go_router.dart';

/// 초대 링크(카카오 공유 등)로 진입했을 때 보여주는 랜딩 화면.
///
/// [DdaraInvitationAnimation] 을 재생하는 동안 [inviteCode] 로 모임 정보를
/// 조회하고, **애니메이션이 끝나고 조회(성공·실패)도 끝나면** [JoinGroupPage]
/// 로 전환한다. 조회에 실패해도 같은 화면으로 넘어간다.
class InviteLandingPage extends ConsumerStatefulWidget {
  const InviteLandingPage({super.key, required this.inviteCode});

  /// 초대 링크에서 전달받은 초대 코드.
  final String inviteCode;

  @override
  ConsumerState<InviteLandingPage> createState() => _InviteLandingPageState();
}

class _InviteLandingPageState extends ConsumerState<InviteLandingPage> {
  /// 문구('초대장이 도착했어요') 페이드인 지연.
  /// DdaraInvitation 은 onReveal 을 제공하지 않아, 편지지가 열리는 프레임에
  /// 맞춰 이만큼 지연 후 문구를 띄운다. (로띠 마커 기준의 경험값)
  static const _textRevealDelay = Duration(milliseconds: 900);

  /// 조회 완료 여부. (성공·실패 모두 true)
  bool _fetchDone = false;

  /// 애니메이션 재생 완료 여부.
  bool _animationDone = false;

  /// 중복 전환 방지.
  bool _navigated = false;

  /// 콘텐츠(로띠+문구) 표시 여부. false 로 바꾸면 페이드아웃된다.
  bool _visible = true;

  /// 문구('초대장이 도착했어요') 표시 여부. 편지지가 열릴 때쯤 true 로 바뀐다.
  bool _textVisible = false;

  @override
  void initState() {
    super.initState();
    // 콜드 스타트로 보관됐던 초대코드는 여기서 소비한다. (코드는 URL 로 전달받음)
    Future.microtask(
      () => ref.read(pendingInviteCodeProvider.notifier).state = null,
    );
    // 편지지가 열릴 즈음에 맞춰 지연 후 문구를 페이드인한다.
    Future.delayed(_textRevealDelay, () {
      if (mounted) setState(() => _textVisible = true);
    });
  }

  void _onAnimationComplete() {
    _animationDone = true;
    _goIfReady();
  }

  /// 애니메이션 완료 + 조회 완료(성공·실패 무관)가 모두 되면 전환 시퀀스를 시작한다.
  /// 즉, 조회가 먼저 끝나도 **애니메이션이 끝나야** 넘어간다.
  ///
  /// 바로 넘기지 않고 먼저 콘텐츠를 페이드아웃(_visible=false)한 뒤,
  /// 페이드아웃이 끝나면([_onFadeOutEnd]) 다음 화면으로 전환한다.
  /// → "로띠가 사라지고 → 그 다음 화면" 순서가 된다.
  void _goIfReady() {
    if (_navigated || !mounted) return;
    if (!_animationDone || !_fetchDone) return;

    _navigated = true;
    setState(() => _visible = false);
  }

  /// 콘텐츠 페이드아웃이 끝나면 참여 확인 화면으로 전환한다.
  void _onFadeOutEnd() {
    if (!mounted || _visible) return;
    // 조회 결과(실패·에러면 null)를 그대로 넘긴다. (전환 시점엔 조회가 끝나 있다)
    final group = ref
        .read(inviteLandingGroupProvider(widget.inviteCode))
        .valueOrNull;
    context.pushReplacement(
      RoutePath.joinGroup,
      extra: JoinGroupArgs(group: group, inviteCode: widget.inviteCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 조회가 끝나면(성공·실패·에러 무관) 전환 준비를 진행한다. provider 를
    // listen 하면 조회가 시작되고, 완료 시 애니메이션 완료와 맞춰 전환한다.
    ref.listen(inviteLandingGroupProvider(widget.inviteCode), (prev, next) {
      if (!next.isLoading && !_fetchDone) {
        _fetchDone = true;
        _goIfReady();
      }
    });

    return CupertinoPageScaffold(
      child: SafeArea(
        // 전환 시작 시 콘텐츠를 먼저 사라지게 한 뒤(_visible=false) 다음 화면으로 넘긴다.
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          onEnd: _onFadeOutEnd,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s3,
              children: [
                // 편지지가 열릴 때쯤(onReveal) 문구를 페이드인한다.
                AnimatedOpacity(
                  opacity: _textVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: AppText.display(
                    AppLocalizations.of(context).inviteLandingTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                DdaraInvitationAnimation(onCompleted: _onAnimationComplete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:ddara/core/deeplink/pending_invite.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/group/invite_group.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/join/join_group_page.dart';
import 'package:ddara/feature/group/join/landing/widget/ddara_invitation_animation.dart';
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
  /// 조회된 모임 정보. (조회 전·실패 시 null)
  InviteGroup? _group;

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
    // DdaraInvitation 은 onReveal 을 제공하지 않아, 편지지가 열릴 즈음에 맞춰
    // 지연 후 문구를 페이드인한다.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _textVisible = true);
    });
    _fetchGroup();
  }

  /// 초대 코드로 모임 정보를 조회한다. 실패해도 흐름은 그대로 진행한다.
  Future<void> _fetchGroup() async {
    try {
      _group = await ref
          .read(getInviteGroupUseCaseProvider)(widget.inviteCode);
    } catch (_) {
      // 실패해도 같은 화면으로 넘어간다. (_group 은 null 로 둔다)
      _group = null;
    } finally {
      _fetchDone = true;
      _goIfReady();
    }
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
    context.pushReplacement(
      RoutePath.joinGroup,
      extra: JoinGroupArgs(group: _group, inviteCode: widget.inviteCode),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                DdaraInvitationAnimation(
                  onCompleted: _onAnimationComplete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

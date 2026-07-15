import 'dart:ui' show ImageFilter;

import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 멤버 아바타·추가 버튼의 원 지름.
const double _circleSize = 60;

/// 이름 라벨을 그대로 보여줄 최대 글자 수. (6자까지는 줄이지 않는다)
const int _maxNameLength = 6;

/// 줄일 때 남기는 글자 수. (7자 이상이면 앞 5자 + 말줄임표)
const int _truncatedNameLength = 5;

/// [name] 이 [_maxNameLength] 자를 초과하면 앞 [_truncatedNameLength] 자
/// + 말줄임표(…)로 줄인다.
///
/// 이모지 등 서로게이트 쌍이 잘리지 않도록 자소(grapheme) 단위로 센다.
String _ellipsizeName(String name) {
  final chars = name.characters;
  if (chars.length <= _maxNameLength) return name;
  return '${chars.take(_truncatedNameLength)}…';
}

/// 모임 멤버 한 명의 표시 데이터.
///
/// TODO: 모임 조회 API 의 멤버 모델로 대체. (백엔드 스펙 대기 — 임시 record)
typedef MemberDisplay = ({String name, String? imageUrl});

/// 모임 멤버 목록. (원형 프로필 + 이름, 끝에 멤버 추가 버튼)
class Members extends StatelessWidget {
  const Members({
    super.key,
    required this.members,
    required this.onAddMember,
    required this.onReportMember,
  });

  final List<MemberDisplay> members;

  /// 우측 끝 + 버튼(멤버 초대) 탭 콜백.
  final VoidCallback onAddMember;

  /// 멤버 아바타를 롱프레스해 '닉네임 신고'를 선택했을 때. (대상 멤버 전달)
  final ValueChanged<MemberDisplay> onReportMember;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // 첫 아바타는 좌측 여백을 두고 시작하되, 스와이프하면 여백째 밀려나
      // 가장자리까지 넘어가도록 스크롤 콘텐츠 안쪽 패딩으로 준다.
      padding: const EdgeInsets.only(left: AppSpacing.s4),
      child: Row(
        spacing: AppSpacing.s2,
        children: [
          for (final member in members)
            _MemberAvatar(
              name: member.name,
              imageUrl: member.imageUrl,
              onReport: () => onReportMember(member),
            ),
          // 멤버 목록 끝에 항상 붙는 추가 버튼.
          _AddMemberButton(onPressed: onAddMember),
        ],
      ),
    );
  }
}

/// 원형 프로필 아바타 + 이름 라벨.
class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.name,
    required this.imageUrl,
    required this.onReport,
  });

  final String name;

  /// 프로필 이미지 URL. null·빈 값이면 기본 아이콘을 보여준다.
  final String? imageUrl;

  /// 컨텍스트 메뉴에서 '닉네임 신고'를 선택했을 때.
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return _CircleLabel(
      label: _ellipsizeName(name),
      child: _ReportableAvatar(
        name: name,
        imageUrl: imageUrl,
        onReport: onReport,
      ),
    );
  }
}

/// 롱프레스하면 아바타 위쪽에 '닉네임 신고' 메뉴(오버레이)를 띄우는 원형 아바타.
///
/// 아바타에 앵커된 작은 메뉴로, 바깥을 탭하면 닫힌다.
class _ReportableAvatar extends StatefulWidget {
  const _ReportableAvatar({
    required this.name,
    required this.imageUrl,
    required this.onReport,
  });

  /// 아바타 아래 라벨로 보여줄 멤버 이름. (오버레이에서 블러 없이 유지)
  final String name;

  final String? imageUrl;

  /// '닉네임 신고'를 선택했을 때.
  final VoidCallback onReport;

  @override
  State<_ReportableAvatar> createState() => _ReportableAvatarState();
}

class _ReportableAvatarState extends State<_ReportableAvatar> {
  /// 아바타 위치를 메뉴가 따라가게 잇는 링크.
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  bool get _isOpen => _entry != null;

  void _open() {
    if (_isOpen) return;
    _entry = OverlayEntry(builder: (_) => _buildOverlay());
    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
  }

  /// 메뉴를 닫은 뒤 신고 콜백을 실행한다.
  void _select() {
    _close();
    widget.onReport();
  }

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        // 배경을 블러 + 살짝 어둡게. 바깥 영역을 탭하면 닫힌다.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _close,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const ColoredBox(color: AppColorPrimitives.black20),
            ),
          ),
        ),
        // 대상 아바타 사본을 스크림 위로 띄워 선명하게 유지한다.
        // (원본 위치에 정확히 겹치므로 아바타만 떠오른 것처럼 보인다)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          child: IgnorePointer(
            child: ProfileAvatar(size: _circleSize, imageUrl: widget.imageUrl),
          ),
        ),
        // 아바타 아래 이름 라벨 사본도 스크림 위로 띄워 블러 없이 유지한다.
        // (원본 라벨 위치 — 아바타 아래 s2 여백, 가로 중앙 — 에 정확히 겹친다)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.topCenter,
          offset: const Offset(0, AppSpacing.s2),
          // 원본 라벨과 동일하게 줄인 이름을 써야 사본이 정확히 겹친다.
          child: IgnorePointer(
            child: AppText.caption(_ellipsizeName(widget.name)),
          ),
        ),
        // 아바타 위쪽(좌측 정렬)에 앵커. (아바타 위로 s2 만큼 띄움)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.bottomLeft,
          offset: const Offset(0, -AppSpacing.s2),
          child: _menu(),
        ),
      ],
    );
  }

  Widget _menu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColorPrimitives.black40,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        minimumSize: Size.zero,
        onPressed: _select,
        child: AppText.body(
          AppLocalizations.of(context).memberReportNickname,
          color: AppColors.statusDanger,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onLongPress: _open,
        child: ProfileAvatar(size: _circleSize, imageUrl: widget.imageUrl),
      ),
    );
  }
}

/// 멤버 목록 끝 + 버튼. 누르면 초대 공유 시트를 연다.
class _AddMemberButton extends StatelessWidget {
  const _AddMemberButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _CircleLabel(
      label: AppLocalizations.of(context).groupMembersAdd,
      onTap: onPressed,
      child: const SizedBox(
        width: _circleSize,
        height: _circleSize,
        child: Icon(
          CupertinoIcons.add,
          size: 28,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// [child](원형 콘텐츠) 아래 caption 라벨을 둔 공통 레이아웃.
///
/// [onTap] 을 주면 [child] 영역이 버튼이 된다.
class _CircleLabel extends StatelessWidget {
  const _CircleLabel({required this.child, required this.label, this.onTap});

  final Widget child;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        if (onTap != null)
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: onTap,
            child: child,
          )
        else
          child,
        AppText.caption(label),
      ],
    );
  }
}

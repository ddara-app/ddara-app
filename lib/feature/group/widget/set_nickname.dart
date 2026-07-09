import 'package:ddara/core/designsystem/component/app_text_field.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 모임에서 사용할 닉네임을 입력받는 폼.
///
/// "[groupName] 안에서 어떻게 불러드릴까요?" 제목 아래 닉네임 입력 필드와
/// 안내 문구를 보여준다. 입력값은 [onChanged] 로 부모에 전달하고, 검증 에러는
/// [errorText] 로 표시한다. (입력 컨트롤러는 내부에서 소유한다)
class SetNickname extends StatefulWidget {
  const SetNickname({
    super.key,
    required this.groupName,
    this.onChanged,
    this.errorText,
  });

  /// 닉네임을 정할 대상 모임 이름. (제목에 노출)
  final String groupName;

  /// 입력값이 바뀔 때 호출.
  final ValueChanged<String>? onChanged;

  /// 입력 박스 아래에 표시할 에러 문구. null 이면 에러 없음.
  final String? errorText;

  @override
  State<SetNickname> createState() => _SetNicknameState();
}

class _SetNicknameState extends State<SetNickname> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      // 바깥 간격 s2 → 입력 필드와 caption 사이가 s2.
      spacing: AppSpacing.s2,
      children: [
        TitleDescription(
          title: l10n.setNicknameTitle(widget.groupName),
          description: l10n.setNicknameDescription,
        ),
        // body 다음 간격 s6. (바깥 spacing s2 가 SizedBox 양옆에 붙으므로 s2+s2+s2=s6)
        const SizedBox(height: AppSpacing.s2),
        AppTextField(
          placeholder: l10n.setNicknamePlaceholder,
          controller: _controller,
          highlightWhenFilled: true,
          errorText: widget.errorText,
          onChanged: widget.onChanged,
        ),
        AppText.caption(l10n.setNicknameCaption),
      ],
    );
  }
}

/// 모임 닉네임 검증. 규칙에 어긋나면 사용자용 에러 문구(l10n)를, 유효하면 null 을
/// 반환한다. (빈 값은 입력 전으로 보고 에러를 내지 않는다)
String? validateNickname(AppLocalizations l10n, String nickname) {
  if (nickname.isEmpty) return null;
  // 한글(자모 포함)·영어·공백만 허용. 기호·숫자 등이 섞이면 에러.
  if (!RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z ]+$').hasMatch(nickname)) {
    return l10n.nicknameErrorCharset;
  }
  // 앞뒤 공백은 허용하지 않음. (내부 공백만 허용)
  if (nickname != nickname.trim()) {
    return l10n.nicknameErrorWhitespace;
  }
  if (nickname.length < 2 || nickname.length > 10) {
    return l10n.nicknameErrorLength;
  }
  return null;
}

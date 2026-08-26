import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/bottom_sheet/sheet_scaffold.dart';
import 'package:ddara/core/widget/set_nickname.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 닉네임을 수정하는 바텀시트.
///
/// '수정'으로 확정하면 입력한 닉네임을 [Navigator.pop] 으로 반환하고,
/// 취소·바깥 탭이면 null 을 반환한다. 검증은 [validateNickname] 을 재사용하고,
/// [takenNicknames] 에 있는 닉네임(멤버가 이미 쓰는 이름)은 중복 에러로 막는다.
class EditNicknameSheet extends StatefulWidget {
  const EditNicknameSheet({
    super.key,
    required this.groupName,
    this.takenNicknames = const {},
  });

  /// 제목에 노출할 모임 이름. ([SetNickname] 에 전달)
  final String groupName;

  /// 모임 멤버들이 이미 사용 중인 닉네임. (본인 현재 닉네임 포함 — 같은 값으로의
  /// 변경은 의미가 없고 서버도 중복으로 거절하므로 함께 막는다)
  final Set<String> takenNicknames;

  /// 바텀시트를 띄우고 확정한 닉네임을 받는다. 취소·바깥 탭이면 null.
  static Future<String?> show(
    BuildContext context, {
    required String groupName,
    Set<String> takenNicknames = const {},
  }) {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => EditNicknameSheet(
        groupName: groupName,
        takenNicknames: takenNicknames,
      ),
    );
  }

  @override
  State<EditNicknameSheet> createState() => _EditNicknameSheetState();
}

class _EditNicknameSheetState extends State<EditNicknameSheet> {
  String _nickname = '';
  String? _errorText;

  /// 형식 검증([validateNickname]) 후 멤버 닉네임과의 중복까지 검사한다.
  String? _validate(String value) {
    final l10n = AppLocalizations.of(context);
    final error = validateNickname(l10n, value);
    if (error != null) return error;
    if (value.isNotEmpty && widget.takenNicknames.contains(value)) {
      // 서버가 DUPLICATE_GROUP_NICKNAME 으로 돌려주는 것과 같은 상황이라
      // 모임 화면의 중복 문구를 그대로 쓴다. (GroupActionError.nicknameDuplicate)
      return l10n.groupErrorNicknameDuplicate;
    }
    return null;
  }

  void _onChanged(String value) {
    setState(() {
      _nickname = value;
      _errorText = _validate(value);
    });
  }

  void _submit() {
    if (_nickname.isEmpty) {
      setState(
        () => _errorText = AppLocalizations.of(context).editNicknameEmptyError,
      );
      return;
    }
    final error = _validate(_nickname);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }
    Navigator.of(context).pop(_nickname);
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      contentPadding: EdgeInsets.fromLTRB(
        AppSpacing.s5,
        AppSpacing.s4,
        AppSpacing.s5,
        // 키보드가 올라오면 그만큼 콘텐츠를 위로 밀어 올린다.
        AppSpacing.s6 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SetNickname(
            groupName: widget.groupName,
            onChanged: _onChanged,
            errorText: _errorText,
          ),
          const SizedBox(height: AppSpacing.s7),
          AppButton(
            label: AppLocalizations.of(context).editNicknameSubmit,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

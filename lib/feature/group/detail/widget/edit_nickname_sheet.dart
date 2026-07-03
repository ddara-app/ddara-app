import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/feature/group/widget/set_nickname.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 모임 닉네임을 수정하는 바텀시트.
///
/// '수정'으로 확정하면 입력한 닉네임을 [Navigator.pop] 으로 반환하고,
/// 취소·바깥 탭이면 null 을 반환한다. 검증은 [validateNickname] 을 재사용한다.
class EditNicknameSheet extends StatefulWidget {
  const EditNicknameSheet({super.key, required this.groupName});

  /// 제목에 노출할 모임 이름. ([SetNickname] 에 전달)
  final String groupName;

  /// 바텀시트를 띄우고 확정한 닉네임을 받는다. 취소·바깥 탭이면 null.
  static Future<String?> show(
    BuildContext context, {
    required String groupName,
  }) {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => EditNicknameSheet(groupName: groupName),
    );
  }

  @override
  State<EditNicknameSheet> createState() => _EditNicknameSheetState();
}

class _EditNicknameSheetState extends State<EditNicknameSheet> {
  String _nickname = '';
  String? _errorText;

  void _onChanged(String value) {
    setState(() {
      _nickname = value;
      _errorText = validateNickname(value);
    });
  }

  void _submit() {
    if (_nickname.isEmpty) {
      setState(
        () => _errorText = AppLocalizations.of(context).editNicknameEmptyError,
      );
      return;
    }
    final error = validateNickname(_nickname);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }
    Navigator.of(context).pop(_nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.s5,
        right: AppSpacing.s5,
        top: AppSpacing.s6,
        // 키보드가 올라오면 그만큼 콘텐츠를 위로 밀어 올린다.
        bottom: AppSpacing.s5 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SetNickname(
              groupName: widget.groupName,
              onChanged: _onChanged,
              errorText: _errorText,
            ),
            const SizedBox(height: AppSpacing.s6),
            AppButton(
              label: AppLocalizations.of(context).editNicknameSubmit,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

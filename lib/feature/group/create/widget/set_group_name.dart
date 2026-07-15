import 'package:ddara/core/designsystem/component/app_text_field.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/group/create/provider/notifier_provider.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 모임 이름·소개를 입력받는 모임 만들기 본문.
///
/// 입력 폼 상태(컨트롤러·검증)만 담당한다. 하단 '다음' 버튼과 생성 결과 처리,
/// 스캐폴드·패딩은 [GroupCreatePage] 가 들고 있다. (버튼은 스텝 간 공유)
class SetGroupName extends ConsumerStatefulWidget {
  const SetGroupName({super.key});

  @override
  ConsumerState<SetGroupName> createState() => _SetGroupNameState();
}

class _SetGroupNameState extends ConsumerState<SetGroupName> {
  final _nameController = TextEditingController();
  final _introController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 입력에 따라 에러 문구가 갱신되도록 rebuild.
    _nameController.addListener(_onTextChanged);
    _introController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  /// 모임 이름 최대 길이.
  static const _nameMaxLength = 20;

  /// 모임 소개 최대 길이.
  static const _introMaxLength = 100;

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _introController.removeListener(_onTextChanged);
    _nameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(createGroupNotifierProvider.notifier);
    final l10n = AppLocalizations.of(context);

    // 이름이 최대 길이를 초과하면 에러 문구, 아니면 null.
    final nameError = _nameController.text.length > _nameMaxLength
        ? l10n.groupCreateNameLengthError
        : null;

    // 소개가 최대 길이를 초과하면 에러 문구, 아니면 null.
    final introError = _introController.text.length > _introMaxLength
        ? l10n.groupCreateIntroLengthError
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s1,
      children: [
        TitleDescription(
          title: l10n.groupCreateTitle,
          description: l10n.groupCreateSubtitle,
        ),
        // body 다음 간격 s6. (spacing s1 이 SizedBox 양옆에 붙으므로 s1+s4+s1=s6)
        const SizedBox(height: AppSpacing.s4),
        AppTextField(
          label: l10n.groupCreateNameLabel,
          placeholder: l10n.groupCreateNamePlaceholder,
          controller: _nameController,
          highlightWhenFilled: true,
          errorText: nameError,
          onChanged: notifier.groupNameOnChanged,
        ),
        const SizedBox(height: AppSpacing.s4),
        AppTextField(
          label: l10n.groupCreateIntroLabel,
          placeholder: l10n.groupCreateIntroPlaceholder,
          controller: _introController,
          highlightWhenFilled: true,
          errorText: introError,
          onChanged: notifier.descriptionOnChanged,
        ),
      ],
    );
  }
}

import 'package:ddara/core/design_system/component/text_field/app_text_field.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/group_create/provider/notifier_provider.dart';
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
  void dispose() {
    _nameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(createGroupNotifierProvider.notifier);
    final l10n = AppLocalizations.of(context);

    // 길이 초과 여부만 구독해, 입력마다 위젯 전체를 setState 로 다시 그리지 않는다.
    // (검증 진실 원천은 notifier state — 컨트롤러 리스너 불필요)
    final (nameOverLength, introOverLength) = ref.watch(
      createGroupNotifierProvider.select(
        (s) => (s.isNameOverLength, s.isIntroOverLength),
      ),
    );

    // 이름이 최대 길이를 초과하면 에러 문구, 아니면 null.
    final nameError = nameOverLength ? l10n.groupCreateNameLengthError : null;

    // 소개가 최대 길이를 초과하면 에러 문구, 아니면 null.
    final introError = introOverLength
        ? l10n.groupCreateIntroLengthError
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleDescription(
          title: l10n.groupCreateTitle,
          description: l10n.groupCreateSubtitle,
        ),
        // body 다음 간격 s6. (spacing s1 이 SizedBox 양옆에 붙으므로 s1+s4+s1=s6)
        const SizedBox(height: AppSpacing.s7),
        AppTextField(
          label: l10n.groupCreateNameLabel,
          placeholder: l10n.groupCreateNamePlaceholder,
          controller: _nameController,
          highlightWhenFilled: true,
          errorText: nameError,
          onChanged: notifier.groupNameOnChanged,
        ),
        const SizedBox(height: AppSpacing.s7),
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

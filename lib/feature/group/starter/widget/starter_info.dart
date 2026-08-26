import 'dart:io';

import 'package:ddara/core/analytics/analytics_events.dart';
import 'package:ddara/core/design_system/component/text_field/app_text_field.dart';
import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/scrollable_page_body.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/group/detail/provider/viewmodel_provider.dart'
    as group_detail;
import 'package:ddara/feature/group/starter/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/widget/take_photo_button.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 스타터 시작 화면 본문. (촬영 카드 · 컨셉 설명 입력 · 전송 버튼)
class StarterInfo extends ConsumerStatefulWidget {
  const StarterInfo({super.key, required this.groupId});

  /// 업로드 대상 모임 식별자.
  final int groupId;

  @override
  ConsumerState<StarterInfo> createState() => _StarterInfoState();
}

class _StarterInfoState extends ConsumerState<StarterInfo> {
  late final TextEditingController _conceptController;

  @override
  void initState() {
    super.initState();
    // 단계가 바뀌었다 돌아와도 입력값이 유지되도록 state 에서 복원한다.
    _conceptController = TextEditingController(
      text: ref.read(starterViewModelProvider).concept,
    );
  }

  @override
  void dispose() {
    _conceptController.dispose();
    super.dispose();
  }

  /// 게시 확인을 받고 촬영본을 올린다. 성공하면 방금 만들어진 사이클로 이동한다.
  /// (실패 시 ViewModel 이 error 를 채우고 화면이 토스트로 안내한다)
  Future<void> _upload() async {
    final l10n = AppLocalizations.of(context);
    // 게시는 되돌릴 수 없으므로 확인을 한 번 받는다.
    final confirmed = await AppDialog.show(
      context,
      title: l10n.photoPostWarningTitle,
      confirmLabel: l10n.commonConfirm,
    );
    if (!confirmed || !mounted) return;

    final cycleId = await ref
        .read(starterViewModelProvider.notifier)
        .upload(widget.groupId);
    if (cycleId == null || !mounted) return;

    AnalyticsEvents.starterPhotoPosted(
      groupId: widget.groupId,
      cycleId: cycleId,
    );
    // 새 사이클이 생겼으므로 스택 아래 모임 상세를 무효화해, 갤러리에서
    // 돌아갔을 때 진행 중 사이클이 반영된 최신 상태로 보이게 한다.
    ref.invalidate(group_detail.groupPageViewModelProvider(widget.groupId));
    // 게시 후에는 스타터로 돌아가지 않도록 화면을 교체한다.
    context.pushReplacement(
      RoutePath.cycleGallery(groupId: widget.groupId, cycleId: cycleId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = ref.read(starterViewModelProvider.notifier);

    // 업로드 실패는 토스트로 알린다. (성공 후 이동은 _upload 가 직접 처리)
    ref.listen(starterViewModelProvider, (prev, next) {
      final error = next.error;
      if (error != null) {
        Toast.showToast(context, error.message(l10n), type: ToastType.error);
        viewModel.clearError();
      }
    });

    final photoPath = ref.watch(
      starterViewModelProvider.select((s) => s.photoPath),
    );
    final hasPhoto = photoPath != null;

    final isLoading = ref.watch(
      starterViewModelProvider.select((s) => s.isLoading),
    );

    final concept = ref.watch(
      starterViewModelProvider.select((s) => s.concept),
    );
    // 컨셉 설명은 20자 이내. 초과하면 에러 문구를 보여준다.
    final conceptError = concept.length > 20
        ? l10n.starterConceptLengthError
        : null;

    return Stack(
      children: [
        // 하단 인셋은 ScrollablePageBody 가 패딩으로 처리한다.
        SafeArea(
          bottom: false,
          // 키보드가 올라와 높이가 줄면 내용을 스크롤시켜 오버플로를 막는다.
          // 공간이 충분하면 Spacer 가 버튼을 하단에 고정한다.
          child: ScrollablePageBody(
            // 사진 프레임이 커서 상단도 하단과 같은 여백을 준다.
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s5,
              vertical: AppSpacing.s7,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.s6,
                children: [
                  // 모임 헤더·갤러리 카드와 같은 사진 프레임으로 보여준다.
                  AspectRatio(
                    aspectRatio: AppRatio.photo,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.s4),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        // 사진이 있으면 카드를 가득 채워 보여준다.
                        image: hasPhoto
                            ? DecorationImage(
                                image: FileImage(File(photoPath)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      // 사진이 없을 때만 가운데에 촬영 버튼을 표시한다.
                      child: hasPhoto
                          ? null
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TakePhotoButton(
                                  size: TakePhotoButtonSize.large,
                                  onPressed: viewModel.goToCamera,
                                ),
                              ],
                            ),
                    ),
                  ),
                  AppTextField(
                    label: l10n.starterConceptLabel,
                    placeholder: l10n.starterConceptPlaceholder,
                    controller: _conceptController,
                    highlightWhenFilled: true,
                    errorText: conceptError,
                    onChanged: viewModel.conceptChanged,
                  ),
                  const Spacer(),
                  Row(
                    spacing: AppSpacing.s3,
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          label: l10n.photoRetake,
                          onPressed: viewModel.goToCamera,
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          label: l10n.photoUpload,
                          // 사진이 없거나 컨셉이 비어 있거나(공백 포함) 20자를
                          // 넘거나, 업로드 중이면 비활성화.
                          onPressed:
                              hasPhoto &&
                                  concept.trim().isNotEmpty &&
                                  conceptError == null &&
                                  !isLoading
                              ? _upload
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // 업로드 처리 중 로딩 오버레이 (입력 차단 + 인디케이터)
        if (isLoading) const AppLoadingOverlay(),
      ],
    );
  }
}

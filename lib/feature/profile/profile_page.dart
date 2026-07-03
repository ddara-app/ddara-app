import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/image/image_picker_service.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/app_dialog.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/util/profile_state.dart';
import 'package:ddara/feature/profile/widget/profile_header.dart';
import 'package:ddara/feature/profile/widget/profile_image_source_sheet.dart';
import 'package:ddara/feature/profile/widget/profile_section.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// 프로필 화면.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(profileNotifierProvider);

    // 로그아웃 결과에 따라 분기: 성공 시 로그인 화면으로 이동, 실패 시 안내.
    ref.listen(profileNotifierProvider.select((s) => s.logoutStatus), (
      _,
      status,
    ) {
      if (!context.mounted) return;
      switch (status) {
        case LogoutStatus.success:
          context.go(RoutePath.login);
        case LogoutStatus.fail:
          Toast.showToast(context, l10n.profileLogoutFailed, type: ToastType.error);
        case LogoutStatus.idle:
        case LogoutStatus.loading:
          break;
      }
    });

    // 회원 탈퇴 결과에 따라 분기: 성공 시 로그인 화면으로 이동, 실패 시 안내.
    ref.listen(profileNotifierProvider.select((s) => s.withdrawStatus), (
      _,
      status,
    ) {
      if (!context.mounted) return;
      switch (status) {
        case WithdrawStatus.success:
          context.go(RoutePath.login);
        case WithdrawStatus.fail:
          Toast.showToast(context, l10n.profileWithdrawFailed, type: ToastType.error);
        case WithdrawStatus.idle:
        case WithdrawStatus.loading:
          break;
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(title: l10n.profileTitle, onBack: () => context.pop()),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppSpacing.s3,
            left: AppSpacing.s4,
            right: AppSpacing.s4,
            bottom: AppSpacing.s6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s5,
            children: [
              ProfileHeader(
                name: state.name,
                imageUrl: state.profileImageUrl,
                onImageSourceSelected: (source) =>
                    _onImageSourceSelected(context, ref, source),
              ),
              ProfileSection(
                label: l10n.profileSectionBasicInfo,
                children: [
                  ProfileRow(
                    label: l10n.profileJoinedAt,
                    value: _formatDate(state.joinedAt),
                  ),
                ],
              ),
              ProfileSection(
                label: l10n.profileSectionNotification,
                children: [
                  ProfileRow(
                    label: l10n.notificationSettingsTitle,
                    trailing: const ProfileChevron(),
                    onTap: () => context.push(RoutePath.notificationSettings),
                  ),
                ],
              ),
              ProfileSection(
                label: l10n.profileSectionSupport,
                children: [
                  ProfileRow(
                    label: l10n.profileTermsPolicy,
                    trailing: const ProfileChevron(),
                    onTap: () => context.push(RoutePath.termsPolicy),
                  ),
                  ProfileRow(
                    label: l10n.profileContact,
                    trailing: const ProfileChevron(),
                    onTap: () => _contact(context, state.appVersion),
                  ),
                  ProfileRow(label: l10n.profileAppVersion, value: state.appVersion),
                ],
              ),
              ProfileSection(
                label: l10n.profileSectionAccount,
                children: [
                  ProfileRow(label: l10n.profileLinkedAccount, value: state.linkedAccount),
                  ProfileRow(
                    label: l10n.profileLogout,
                    labelColor: AppColors.statusDanger,
                    onTap: () => _confirmLogout(context, ref),
                  ),
                  ProfileRow(
                    label: l10n.profileWithdraw,
                    labelColor: AppColors.statusDanger,
                    onTap: () => _confirmWithdraw(context, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 프로필 사진 소스(카메라/갤러리)를 열어 이미지를 선택한다.
  ///
  /// image_picker 로 카메라 촬영/갤러리 선택을 수행한다. 사용자가 취소하면
  /// 아무것도 하지 않는다.
  Future<void> _onImageSourceSelected(
    BuildContext context,
    WidgetRef ref,
    ProfileImageSource source,
  ) async {
    final picker = ref.read(imagePickerServiceProvider);
    final picked = switch (source) {
      ProfileImageSource.camera => await picker.pickFromCamera(),
      ProfileImageSource.gallery => await picker.pickFromGallery(),
    };
    if (picked == null) return; // 선택·촬영 취소

    // 프로필로 쓸 영역만 원형으로 잘라낸다. (아바타가 원형)
    final cropped = await picker.cropToCircle(picked.path);
    if (cropped == null) return; // 크롭 취소
    if (!context.mounted) return;

    // 리사이징·압축은 업로드 단계(UploadDataSource.compress)에서 처리한다.
    await _uploadProfileImage(context, ref, cropped.path);
  }

  /// 준비된 이미지 파일을 서버에 업로드(멀티파트)하고 프로필 이미지를 갱신한다.
  ///
  /// 성공 시 안내 토스트, 실패 시 원인별 토스트를 띄운다. (상태 갱신은 notifier)
  Future<void> _uploadProfileImage(
    BuildContext context,
    WidgetRef ref,
    String imagePath,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(profileNotifierProvider.notifier)
          .updateProfileImage(imagePath);
      if (!context.mounted) return;
      Toast.showToast(context, l10n.profileImageUpdated);
    } on InvalidImageFileException {
      if (!context.mounted) return;
      Toast.showToast(
        context,
        l10n.profileImageInvalidFormat,
        type: ToastType.error,
      );
    } catch (_) {
      // UserNotFoundException·NetworkException 등.
      if (!context.mounted) return;
      Toast.showToast(
        context,
        l10n.profileImageUploadFailed,
        type: ToastType.error,
      );
    }
  }

  /// 문의 메일 수신 주소.
  static const String _contactEmail = 'ddara.team3@gmail.com';

  /// 기본 메일 앱으로 문의 메일 작성 화면을 띄운다. (제목·본문 미리 채움)
  Future<void> _contact(BuildContext context, String appVersion) async {
    final l10n = AppLocalizations.of(context);
    // mailto 쿼리는 공백을 '+' 가 아닌 '%20' 으로 인코딩해야 메일 앱이 제대로 읽는다.
    final query =
        <String, String>{
              'subject': l10n.profileContactMailSubject,
              'body': l10n.profileContactMailBody(appVersion),
            }.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');

    final mailUri = Uri(scheme: 'mailto', path: _contactEmail, query: query);

    // 메일 앱이 없거나 실행에 실패하면 사용자에게 안내한다.
    final launched = await launchUrl(mailUri).catchError((_) => false);
    if (!launched && context.mounted) {
      Toast.showToast(
        context,
        l10n.profileContactMailFailed(_contactEmail),
        type: ToastType.error,
      );
    }
  }

  /// DateTime → 'yyyy.MM.dd'. (없으면 빈 문자열)
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }

  /// 로그아웃 확인 다이얼로그를 띄우고, 확인 시에만 로그아웃을 진행한다.
  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await AppDialog.show(
      context,
      title: l10n.profileLogoutConfirmTitle,
      confirmLabel: l10n.profileLogout,
    );
    if (ok) await ref.read(profileNotifierProvider.notifier).logout();
  }

  /// 회원 탈퇴 확인 다이얼로그를 띄우고, 확인 시에만 탈퇴를 진행한다.
  Future<void> _confirmWithdraw(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await AppDialog.show(
      context,
      title: l10n.profileWithdrawConfirmTitle,
      confirmLabel: l10n.profileWithdrawConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (ok) await ref.read(profileNotifierProvider.notifier).withdraw();
  }
}

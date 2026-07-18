import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/feature/profile/image_picker_service.dart';
import 'package:ddara/core/permission/permission_service.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/date_format.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/dialog/permission_dialog.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/widget/profile_header.dart';
import 'package:ddara/feature/profile/widget/profile_image_source_sheet.dart';
import 'package:ddara/feature/profile/widget/profile_section.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.profileTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          // 콘텐츠가 화면에 들어가면 스크롤 없음, 작은 기기·큰 글자에서는
          // 스크롤로 전환되도록 뷰포트 높이를 최소 높이로 강제한다.
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                // 패딩이 스크롤 범위에 더해져 항상 스크롤되지 않도록
                // (minHeight 초과) ConstrainedBox 안쪽에 둔다.
                padding: EdgeInsets.only(
                  top: AppSpacing.s3,
                  left: AppSpacing.s4,
                  right: AppSpacing.s4,
                  // 하단 Safe Area 까지 배경을 잇되, 마지막 항목이 홈
                  // 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
                  bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s5,
                  children: [
                    ProfileHeader(
                      name: state.name,
                      imageUrl: state.profileImageUrl,
                      // 업로드가 진행되는 동안 소스 선택(중복 업로드)을 차단한다.
                      onImageSourceSelected: tapGuard(
                        state.isImageUploading,
                        (ProfileImageSource source) =>
                            _onImageSourceSelected(context, ref, source),
                      ),
                    ),
                    ProfileSection(
                      label: l10n.profileSectionBasicInfo,
                      children: [
                        ProfileRow(
                          label: l10n.profileJoinedAt,
                          value: formatDate(state.joinedAt),
                        ),
                      ],
                    ),
                    ProfileSection(
                      label: l10n.profileSectionNotification,
                      children: [
                        ProfileRow(
                          label: l10n.notificationSettingsTitle,
                          trailing: const ProfileChevron(),
                          onTap: () =>
                              context.push(RoutePath.notificationSettings),
                        ),
                      ],
                    ),
                    ProfileSection(
                      label: l10n.profileSectionManage,
                      children: [
                        ProfileRow(
                          label: l10n.profileBlockedUsers,
                          trailing: const ProfileChevron(),
                          onTap: () => context.push(RoutePath.blockedUsers),
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
                        ProfileRow(
                          label: l10n.profileAppVersion,
                          value: state.appVersion,
                        ),
                      ],
                    ),
                    ProfileSection(
                      label: l10n.profileSectionAccount,
                      children: [
                        // 연동 계정·로그아웃·회원 탈퇴는 계정 관리 화면에 모아 둔다.
                        ProfileRow(
                          label: l10n.profileAccountManage,
                          trailing: const ProfileChevron(),
                          onTap: () => context.push(RoutePath.accountManage),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 프로필 사진 소스(카메라/갤러리/기본 이미지)를 열어 이미지를 선택한다.
  ///
  /// image_picker 로 카메라 촬영/갤러리 선택을 수행한다. 사용자가 취소하면
  /// 아무것도 하지 않는다. '기본 이미지로 변경'은 선택 즉시 서버에 반영한다.
  Future<void> _onImageSourceSelected(
    BuildContext context,
    WidgetRef ref,
    ProfileImageSource source,
  ) async {
    // 기본 이미지로 되돌리기 — 촬영/선택 없이 바로 초기화를 요청한다.
    if (source == ProfileImageSource.reset) {
      await _resetProfileImage(context, ref);
      return;
    }

    // 갤러리는 Android 에서 시스템 포토 피커가 아닌 권한 기반 갤러리로 폴백될 수
    // 있어, 진입 전 '사진' 권한을 확인·요청한다.
    // (iOS 는 PHPicker 라 권한 없이도 동작하므로 그대로 둔다)
    if (source == ProfileImageSource.gallery &&
        defaultTargetPlatform == TargetPlatform.android) {
      final ok = await _ensureAndroidPhotosPermission(context, ref);
      if (!ok || !context.mounted) return;
    }

    final picker = ref.read(imagePickerServiceProvider);
    final picked = switch (source) {
      ProfileImageSource.camera => await picker.pickFromCamera(),
      ProfileImageSource.gallery => await picker.pickFromGallery(),
      // 위에서 조기 반환하므로 도달하지 않는다.
      ProfileImageSource.reset => null,
    };
    if (picked == null) return; // 선택·촬영 취소

    // 프로필로 쓸 영역만 원형으로 잘라낸다. (아바타가 원형)
    final cropped = await picker.cropToCircle(picked.path);
    if (cropped == null) return; // 크롭 취소
    if (!context.mounted) return;

    // 리사이징·압축은 업로드 단계(UploadDataSource.compress)에서 처리한다.
    await _uploadProfileImage(context, ref, cropped.path);
  }

  /// Android 갤러리 접근 전 '사진' 권한을 확인하고, 없으면 요청한다.
  ///
  /// 허용(부분 접근 포함)되면 true, 거부면 false 를 반환한다. 영구 거부라
  /// 프롬프트가 더 뜨지 않는 경우엔 설정 이동 안내를 띄운다.
  Future<bool> _ensureAndroidPhotosPermission(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final permission = ref.read(permissionServiceProvider);
    if (await permission.isPhotosGranted()) return true;

    final result = await permission.requestPhotos();
    if (result == PermissionResult.granted) return true;

    if (result == PermissionResult.permanentlyDenied && context.mounted) {
      await showPermissionDialog(
        context,
        permission: permission,
        permissionName: AppLocalizations.of(context).permissionPhotos,
      );
    }
    return false;
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

  /// 프로필 이미지를 기본 이미지로 되돌린다.
  ///
  /// 성공 시 안내 토스트, 실패 시 실패 토스트를 띄운다. (상태 갱신은 notifier)
  Future<void> _resetProfileImage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(profileNotifierProvider.notifier).resetProfileImage();
      if (!context.mounted) return;
      Toast.showToast(context, l10n.profileImageReset);
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
}

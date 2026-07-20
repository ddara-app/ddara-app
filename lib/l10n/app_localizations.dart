import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ko')];

  /// 공용 다이얼로그 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get commonNext;

  /// No description provided for @commonStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get commonStart;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// 온보딩 1페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'한 장 찍으면 인증샷이 시작'**
  String get onboardingFirstTitle;

  /// 온보딩 1페이지 설명
  ///
  /// In ko, this message translates to:
  /// **'내가 한 포즈, 친구들이 똑같이 따라 찍어요'**
  String get onboardingFirstBody;

  /// 온보딩 2페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'나중에 보면 더 웃겨'**
  String get onboardingSecondTitle;

  /// 온보딩 2페이지 설명
  ///
  /// In ko, this message translates to:
  /// **'따라 찍은 사진들이 모여 기록이 돼요'**
  String get onboardingSecondBody;

  /// 온보딩 3페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'아는 친구끼리만, 초대로만'**
  String get onboardingThirdTitle;

  /// 온보딩 3페이지 설명
  ///
  /// In ko, this message translates to:
  /// **'초대받은 친구만 들어올 수 있어요'**
  String get onboardingThirdBody;

  /// 온보딩 하단 버튼 - 다음 페이지로
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get onboardingNext;

  /// 온보딩 마지막 페이지 하단 버튼 - 시작
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get onboardingStart;

  /// 로그인 화면 슬로건
  ///
  /// In ko, this message translates to:
  /// **'우리끼리 따라찍기'**
  String get loginSlogan;

  /// 카카오 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'카카오 로그인'**
  String get loginKakao;

  /// 구글 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'Google 로그인'**
  String get loginGoogle;

  /// 애플 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'Apple 로그인'**
  String get loginApple;

  /// 로그인 화면 약관·정책 확인 링크
  ///
  /// In ko, this message translates to:
  /// **'이용약관과 개인정보 처리방침 확인'**
  String get loginViewPolicies;

  /// 약관 동의 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'약관에 동의해 주세요'**
  String get termsTitle;

  /// 약관 동의 화면 설명
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용을 위해선 이용약관 동의가 필요해요'**
  String get termsSubtitle;

  /// No description provided for @termsAgreeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 동의'**
  String get termsAgreeAll;

  /// No description provided for @termsServiceLabel.
  ///
  /// In ko, this message translates to:
  /// **'[필수] 이용약관'**
  String get termsServiceLabel;

  /// No description provided for @termsPrivacyLabel.
  ///
  /// In ko, this message translates to:
  /// **'[필수] 개인정보 처리방침'**
  String get termsPrivacyLabel;

  /// No description provided for @termsAgeLabel.
  ///
  /// In ko, this message translates to:
  /// **'[필수] 만 14세 이상 사용자 이용동의'**
  String get termsAgeLabel;

  /// No description provided for @termsContinueButton.
  ///
  /// In ko, this message translates to:
  /// **'동의하고 계속'**
  String get termsContinueButton;

  /// No description provided for @policyServiceTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 약관'**
  String get policyServiceTitle;

  /// No description provided for @policyPrivacyTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get policyPrivacyTitle;

  /// No description provided for @policyYouthTitle.
  ///
  /// In ko, this message translates to:
  /// **'청소년 보호정책'**
  String get policyYouthTitle;

  /// No description provided for @permissionPageTitle.
  ///
  /// In ko, this message translates to:
  /// **'권한 안내'**
  String get permissionPageTitle;

  /// No description provided for @permissionHeaderTitle.
  ///
  /// In ko, this message translates to:
  /// **'ddara 권한 안내'**
  String get permissionHeaderTitle;

  /// No description provided for @permissionHeaderDescription.
  ///
  /// In ko, this message translates to:
  /// **'꼭 필요한 순간에만 권한을 요청해요.\n요청이 뜨면 허용해 주시면 돼요'**
  String get permissionHeaderDescription;

  /// No description provided for @permissionSectionRequired.
  ///
  /// In ko, this message translates to:
  /// **'필수 접근 권한'**
  String get permissionSectionRequired;

  /// No description provided for @permissionSectionOptional.
  ///
  /// In ko, this message translates to:
  /// **'선택 접근 권한'**
  String get permissionSectionOptional;

  /// No description provided for @permissionCamera.
  ///
  /// In ko, this message translates to:
  /// **'카메라'**
  String get permissionCamera;

  /// No description provided for @permissionCameraDescription.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기 사진을 촬영할 때 사용해요'**
  String get permissionCameraDescription;

  /// No description provided for @permissionNotification.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get permissionNotification;

  /// No description provided for @permissionNotificationDescription.
  ///
  /// In ko, this message translates to:
  /// **'마감·투표·초대 소식이 있을 때 알려드려요'**
  String get permissionNotificationDescription;

  /// No description provided for @permissionStorage.
  ///
  /// In ko, this message translates to:
  /// **'저장공간'**
  String get permissionStorage;

  /// No description provided for @permissionStorageDescription.
  ///
  /// In ko, this message translates to:
  /// **'앨범에서 사진을 올릴 때 사용해요'**
  String get permissionStorageDescription;

  /// No description provided for @permissionPhotos.
  ///
  /// In ko, this message translates to:
  /// **'사진'**
  String get permissionPhotos;

  /// No description provided for @requiredPermissionTitle.
  ///
  /// In ko, this message translates to:
  /// **'필수 권한을 허용해 주세요'**
  String get requiredPermissionTitle;

  /// No description provided for @requiredPermissionDescription.
  ///
  /// In ko, this message translates to:
  /// **'필수 권한을 거부하면 ddara를\n정상적으로 이용할 수 없어요.\n권한이 필요할 때 허용해 주세요.'**
  String get requiredPermissionDescription;

  /// No description provided for @permissionDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'{permissionName} 권한이 필요해요'**
  String permissionDialogTitle(String permissionName);

  /// No description provided for @permissionDialogContent.
  ///
  /// In ko, this message translates to:
  /// **'설정 > 권한에서 직접 허용해 주세요.'**
  String get permissionDialogContent;

  /// No description provided for @permissionGoToSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정으로 이동'**
  String get permissionGoToSettings;

  /// 홈 상단 첫 번째 탭 (모임 목록)
  ///
  /// In ko, this message translates to:
  /// **'따라찍기 모임'**
  String get homeTabGroups;

  /// 홈 상단 두 번째 탭
  ///
  /// In ko, this message translates to:
  /// **'최근 업데이트'**
  String get homeTabRecentUpdates;

  /// No description provided for @emptyGroupTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 참여한 모임이 없어요'**
  String get emptyGroupTitle;

  /// No description provided for @emptyGroupDescription.
  ///
  /// In ko, this message translates to:
  /// **'첫 판을 시작해 친구들에게 보내보세요'**
  String get emptyGroupDescription;

  /// No description provided for @groupCreate.
  ///
  /// In ko, this message translates to:
  /// **'모임 만들기'**
  String get groupCreate;

  /// No description provided for @groupJoin.
  ///
  /// In ko, this message translates to:
  /// **'모임 참여하기'**
  String get groupJoin;

  /// No description provided for @groupCountLabel.
  ///
  /// In ko, this message translates to:
  /// **'현재 모임 개수'**
  String get groupCountLabel;

  /// 현재/최대 모임 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}/{maxCount}개'**
  String groupCountValue(int count, int maxCount);

  /// No description provided for @groupCountCaption.
  ///
  /// In ko, this message translates to:
  /// **'모임에 속해 있어요'**
  String get groupCountCaption;

  /// No description provided for @updateCountLabel.
  ///
  /// In ko, this message translates to:
  /// **'친구들의 업데이트'**
  String get updateCountLabel;

  /// 친구들의 업데이트 개수 표시 (최근 업데이트 탭 대시보드)
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String updateCountValue(int count);

  /// No description provided for @updateCountCaption.
  ///
  /// In ko, this message translates to:
  /// **'어서 따라찍기를 시작해봐요'**
  String get updateCountCaption;

  /// No description provided for @meetingStatusInProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get meetingStatusInProgress;

  /// No description provided for @meetingStatusCompleted.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get meetingStatusCompleted;

  /// 멤버가 모임장 1명뿐일 때의 요약
  ///
  /// In ko, this message translates to:
  /// **'{name}님'**
  String meetingMemberOwner(String name);

  /// 모임장 외 여러 명일 때의 멤버 요약
  ///
  /// In ko, this message translates to:
  /// **'{name}님 외 {others}명'**
  String meetingMemberOthers(String name, int others);

  /// 마감까지 1시간 이상 남았을 때 (시간 단위)
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 남음'**
  String meetingRemainingHours(int hours);

  /// 마감까지 1시간 미만 남았을 때 (분 단위)
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 남음'**
  String meetingRemainingMinutes(int minutes);

  /// 마감 시각이 지난 사이클
  ///
  /// In ko, this message translates to:
  /// **'마감'**
  String get meetingClosed;

  /// No description provided for @groupCreateTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임 이름을 정해주세요'**
  String get groupCreateTitle;

  /// No description provided for @groupCreateSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'내가 먼저 찍으면, 친구들이 따라 찍어요'**
  String get groupCreateSubtitle;

  /// No description provided for @groupCreateNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'모임 이름'**
  String get groupCreateNameLabel;

  /// No description provided for @groupCreateNamePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'예) 마라탕 걸즈'**
  String get groupCreateNamePlaceholder;

  /// No description provided for @groupCreateIntroLabel.
  ///
  /// In ko, this message translates to:
  /// **'한 줄 소개 (선택)'**
  String get groupCreateIntroLabel;

  /// No description provided for @groupCreateIntroPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'어떤 모임인지 알려주세요'**
  String get groupCreateIntroPlaceholder;

  /// No description provided for @groupCreateSubmit.
  ///
  /// In ko, this message translates to:
  /// **'만들기'**
  String get groupCreateSubmit;

  /// No description provided for @groupCreateNameLengthError.
  ///
  /// In ko, this message translates to:
  /// **'20자 이하로 입력해주세요'**
  String get groupCreateNameLengthError;

  /// No description provided for @groupCreateIntroLengthError.
  ///
  /// In ko, this message translates to:
  /// **'100자 이하로 입력해주세요'**
  String get groupCreateIntroLengthError;

  /// No description provided for @groupJoinTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임 참여'**
  String get groupJoinTitle;

  /// No description provided for @groupJoinHeadline.
  ///
  /// In ko, this message translates to:
  /// **'받은 초대 코드를 입력해주세요'**
  String get groupJoinHeadline;

  /// No description provided for @groupJoinSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'링크로 받았다면, 링크만 눌러도 바로 들어올 수 있어요'**
  String get groupJoinSubtitle;

  /// No description provided for @groupJoinCodeLabel.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드'**
  String get groupJoinCodeLabel;

  /// No description provided for @groupJoinCodePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'예) ASKD23NSK12'**
  String get groupJoinCodePlaceholder;

  /// No description provided for @inviteLandingTitle.
  ///
  /// In ko, this message translates to:
  /// **'초대장이 도착했어요'**
  String get inviteLandingTitle;

  /// No description provided for @joinConfirmInvalid.
  ///
  /// In ko, this message translates to:
  /// **'잘못된 초대입니다'**
  String get joinConfirmInvalid;

  /// No description provided for @joinConfirmAlreadyJoined.
  ///
  /// In ko, this message translates to:
  /// **'이미 참여 중인 방입니다'**
  String get joinConfirmAlreadyJoined;

  /// No description provided for @joinConfirmFull.
  ///
  /// In ko, this message translates to:
  /// **'정원이 초과되었어요'**
  String get joinConfirmFull;

  /// 모임 참여 확인 화면의 개설일·인원 요약
  ///
  /// In ko, this message translates to:
  /// **'{date} 개설 · {count}명'**
  String joinConfirmSubtitle(String date, int count);

  /// 참여 확인 화면 - 모임장 1명만 있을 때
  ///
  /// In ko, this message translates to:
  /// **'{name}님이 함께하고 있어요'**
  String joinConfirmMemberOwner(String name);

  /// 참여 확인 화면 - 모임장 외 여러 명
  ///
  /// In ko, this message translates to:
  /// **'{name}님 외 {others}명이 함께하고 있어요'**
  String joinConfirmMemberOthers(String name, int others);

  /// 모임 닉네임 입력 폼 제목
  ///
  /// In ko, this message translates to:
  /// **'{groupName} 안에서\n어떻게 불러드릴까요?'**
  String setNicknameTitle(String groupName);

  /// No description provided for @setNicknameDescription.
  ///
  /// In ko, this message translates to:
  /// **'친구들에게 보이는 이름이에요'**
  String get setNicknameDescription;

  /// No description provided for @setNicknamePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'닉네임 (2~10자)'**
  String get setNicknamePlaceholder;

  /// No description provided for @setNicknameCaption.
  ///
  /// In ko, this message translates to:
  /// **'*한글과 영어만 사용 가능해요\n**욕설·혐오·사칭 등 부적절한 닉네임은 변경될 수 있어요(자세한 기준 → 운영정책)'**
  String get setNicknameCaption;

  /// No description provided for @nicknameErrorCharset.
  ///
  /// In ko, this message translates to:
  /// **'한글과 영어로만 지을 수 있어요'**
  String get nicknameErrorCharset;

  /// No description provided for @nicknameErrorWhitespace.
  ///
  /// In ko, this message translates to:
  /// **'앞뒤 공백은 사용할 수 없어요'**
  String get nicknameErrorWhitespace;

  /// No description provided for @nicknameErrorLength.
  ///
  /// In ko, this message translates to:
  /// **'2~10자로 입력해주세요'**
  String get nicknameErrorLength;

  /// No description provided for @editNicknameEmptyError.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력해주세요.'**
  String get editNicknameEmptyError;

  /// No description provided for @editNicknameSubmit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get editNicknameSubmit;

  /// No description provided for @groupDetailLoadError.
  ///
  /// In ko, this message translates to:
  /// **'모임 정보를 불러오지 못했어요.'**
  String get groupDetailLoadError;

  /// No description provided for @groupDetailEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 따라찍기가 없어요'**
  String get groupDetailEmptyTitle;

  /// No description provided for @groupHeaderStart.
  ///
  /// In ko, this message translates to:
  /// **'내가 먼저 시작하기'**
  String get groupHeaderStart;

  /// No description provided for @groupHeaderTakePhoto.
  ///
  /// In ko, this message translates to:
  /// **'따라찍으러 가기'**
  String get groupHeaderTakePhoto;

  /// No description provided for @groupMenuEditNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임 수정'**
  String get groupMenuEditNickname;

  /// No description provided for @groupMenuExit.
  ///
  /// In ko, this message translates to:
  /// **'모임 나가기'**
  String get groupMenuExit;

  /// No description provided for @groupExitConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'모임에서 나갈까요?'**
  String get groupExitConfirmTitle;

  /// No description provided for @groupExitConfirmAction.
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get groupExitConfirmAction;

  /// No description provided for @groupMembersTitle.
  ///
  /// In ko, this message translates to:
  /// **'친구들'**
  String get groupMembersTitle;

  /// No description provided for @groupMembersAdd.
  ///
  /// In ko, this message translates to:
  /// **'추가하기'**
  String get groupMembersAdd;

  /// No description provided for @memberReportUser.
  ///
  /// In ko, this message translates to:
  /// **'유저 신고'**
  String get memberReportUser;

  /// No description provided for @report.
  ///
  /// In ko, this message translates to:
  /// **'신고하기'**
  String get report;

  /// No description provided for @reportSheetTitle.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유를 선택해 주세요'**
  String get reportSheetTitle;

  /// No description provided for @reportSheetSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'신고 내용은 24시간 안에 확인해요'**
  String get reportSheetSubtitle;

  /// No description provided for @reportDetailPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'입력해 주세요'**
  String get reportDetailPlaceholder;

  /// No description provided for @reportSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'신고를 접수했어요. 24시간 안에 확인할게요'**
  String get reportSubmitted;

  /// No description provided for @photoReportReasonObscene.
  ///
  /// In ko, this message translates to:
  /// **'음란물'**
  String get photoReportReasonObscene;

  /// No description provided for @photoReportReasonViolence.
  ///
  /// In ko, this message translates to:
  /// **'폭력·혐오'**
  String get photoReportReasonViolence;

  /// No description provided for @photoReportReasonUnauthorizedFilming.
  ///
  /// In ko, this message translates to:
  /// **'타인 무단촬영'**
  String get photoReportReasonUnauthorizedFilming;

  /// No description provided for @photoReportReasonImpersonation.
  ///
  /// In ko, this message translates to:
  /// **'사칭·괴롭힘'**
  String get photoReportReasonImpersonation;

  /// No description provided for @photoReportReasonEtc.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get photoReportReasonEtc;

  /// No description provided for @userReportReasonNickname.
  ///
  /// In ko, this message translates to:
  /// **'부적절한 닉네임(욕설·음란·혐오)'**
  String get userReportReasonNickname;

  /// No description provided for @userReportReasonProfileImage.
  ///
  /// In ko, this message translates to:
  /// **'부적절한 프로필 사진(음란·혐오)'**
  String get userReportReasonProfileImage;

  /// No description provided for @userReportReasonHarassment.
  ///
  /// In ko, this message translates to:
  /// **'사칭·괴롭힘'**
  String get userReportReasonHarassment;

  /// No description provided for @userReportReasonEtc.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get userReportReasonEtc;

  /// No description provided for @memberBlock.
  ///
  /// In ko, this message translates to:
  /// **'차단하기'**
  String get memberBlock;

  /// 멤버 차단 확인 다이얼로그 제목. (차단 대상 닉네임 포함)
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님을 차단할까요?'**
  String memberBlockConfirmTitle(String nickname);

  /// No description provided for @memberBlockConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'차단하면 이 멤버의 사진이\n더 이상 보이지 않습니다.'**
  String get memberBlockConfirmMessage;

  /// No description provided for @memberBlockConfirmAction.
  ///
  /// In ko, this message translates to:
  /// **'차단'**
  String get memberBlockConfirmAction;

  /// 멤버 차단 완료 토스트. (차단한 닉네임 포함)
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님을 차단했어요.'**
  String memberBlockedToast(String nickname);

  /// No description provided for @recordCycleLabel.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기'**
  String get recordCycleLabel;

  /// No description provided for @recordPhotoLabel.
  ///
  /// In ko, this message translates to:
  /// **'함께한 사진'**
  String get recordPhotoLabel;

  /// No description provided for @recordSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get recordSectionTitle;

  /// No description provided for @recordMyCycleLabel.
  ///
  /// In ko, this message translates to:
  /// **'나의 따라찍기'**
  String get recordMyCycleLabel;

  /// No description provided for @recordGroupCycleLabel.
  ///
  /// In ko, this message translates to:
  /// **'모임 따라찍기'**
  String get recordGroupCycleLabel;

  /// No description provided for @groupHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'지난 따라찍기'**
  String get groupHistoryTitle;

  /// No description provided for @groupHistoryMore.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get groupHistoryMore;

  /// No description provided for @groupHistoryEmpty.
  ///
  /// In ko, this message translates to:
  /// **'지난 따라찍기가 아직 없어요'**
  String get groupHistoryEmpty;

  /// No description provided for @groupHistoryFilterAll.
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get groupHistoryFilterAll;

  /// 년·월 라벨. (필터 버튼·월 섹션 제목 공용)
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월'**
  String groupHistoryFilterYearMonth(int year, int month);

  /// 년·월 선택 카드 헤더의 연도 라벨
  ///
  /// In ko, this message translates to:
  /// **'{year}년'**
  String historyYearLabel(int year);

  /// No description provided for @historyFilterReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get historyFilterReset;

  /// 년·월 선택 카드의 월 셀 라벨
  ///
  /// In ko, this message translates to:
  /// **'{month}월'**
  String historyMonthLabel(int month);

  /// 지난 따라찍기 카드의 참여 인원 수
  ///
  /// In ko, this message translates to:
  /// **'{count}명 참여'**
  String historyParticipantCount(int count);

  /// 지난 따라찍기 카드의 날짜 라벨
  ///
  /// In ko, this message translates to:
  /// **'{month}월 {day}일'**
  String historyDate(int month, int day);

  /// 진행 중인 따라찍기의 남은 시간 안내
  ///
  /// In ko, this message translates to:
  /// **'진행 중 · {time} 남음'**
  String startedHeaderRemaining(String time);

  /// 현재 따라찍기 회차
  ///
  /// In ko, this message translates to:
  /// **'{count}번째 따라찍기'**
  String startedHeaderCycle(int count);

  /// 따라찍기를 시작한 사람 안내
  ///
  /// In ko, this message translates to:
  /// **'{name}님이 시작했어요'**
  String startedHeaderStarter(String name);

  /// 헤더 우상단에서 멤버들의 업로드 현황을 펼쳐 보는 토글 라벨
  ///
  /// In ko, this message translates to:
  /// **'업로드 친구 확인하기'**
  String get startedHeaderCheckUploads;

  /// 헤더 우상단 스타터 안내 칩 (스타터 · 닉네임)
  ///
  /// In ko, this message translates to:
  /// **'스타터 · {nickname}'**
  String startedHeaderStarterChip(String nickname);

  /// 마감 시간이 지난 경우 표시
  ///
  /// In ko, this message translates to:
  /// **'마감'**
  String get remainingDeadline;

  /// 남은 시간(시간 단위)
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간'**
  String remainingHours(int hours);

  /// 남은 시간(분 단위)
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분'**
  String remainingMinutes(int minutes);

  /// 남은 시간(일 단위)
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String remainingDays(int days);

  /// No description provided for @inviteShareTitle.
  ///
  /// In ko, this message translates to:
  /// **'함께할 친구를 초대해요'**
  String get inviteShareTitle;

  /// No description provided for @inviteMemberShortageTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 멤버가 부족해요'**
  String get inviteMemberShortageTitle;

  /// No description provided for @inviteMemberShortageDescription.
  ///
  /// In ko, this message translates to:
  /// **'3명부터 시작 가능해요'**
  String get inviteMemberShortageDescription;

  /// No description provided for @inviteShareKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오톡'**
  String get inviteShareKakao;

  /// No description provided for @inviteShareCopyCode.
  ///
  /// In ko, this message translates to:
  /// **'초대코드'**
  String get inviteShareCopyCode;

  /// No description provided for @inviteShareMore.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get inviteShareMore;

  /// No description provided for @inviteShareLater.
  ///
  /// In ko, this message translates to:
  /// **'다음에 할게요'**
  String get inviteShareLater;

  /// No description provided for @inviteShareFailed.
  ///
  /// In ko, this message translates to:
  /// **'공유하지 못했어요. 잠시 후 다시 시도하거나 초대코드를 복사해 전달해주세요.'**
  String get inviteShareFailed;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드를 복사했어요'**
  String get inviteCodeCopied;

  /// No description provided for @starterTitle.
  ///
  /// In ko, this message translates to:
  /// **'스타터 시작하기'**
  String get starterTitle;

  /// No description provided for @starterConceptLabel.
  ///
  /// In ko, this message translates to:
  /// **'컨셉 설명'**
  String get starterConceptLabel;

  /// No description provided for @starterConceptPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'예) 마라탕 또 먹기'**
  String get starterConceptPlaceholder;

  /// No description provided for @starterConceptLengthError.
  ///
  /// In ko, this message translates to:
  /// **'20자 이내로 입력해 주세요'**
  String get starterConceptLengthError;

  /// No description provided for @followerCameraTitle.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기'**
  String get followerCameraTitle;

  /// 촬영 후 다시 찍기 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 찍기'**
  String get photoRetake;

  /// 촬영한 사진 올리기 버튼
  ///
  /// In ko, this message translates to:
  /// **'올리기'**
  String get photoUpload;

  /// 게시 전 되돌릴 수 없음을 알리는 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'게시되면 수정이 불가능합니다.'**
  String get photoPostWarningTitle;

  /// 촬영 화면으로 이동하는 알약 버튼
  ///
  /// In ko, this message translates to:
  /// **'촬영하러 가기'**
  String get photoTakeAction;

  /// 사진 뷰어 댓글 입력 필드 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'댓글을 남겨보세요...'**
  String get photoViewerCommentHint;

  /// 잠긴(블러+자물쇠) 사진에서 댓글 입력이 비활성화됐을 때의 안내 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'따라찍기를 이용한 후 댓글을 남길 수 있어요'**
  String get photoViewerCommentLockedHint;

  /// 사진 뷰어 댓글이 하나도 없을 때 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'아직 댓글이 없습니다.'**
  String get photoViewerCommentEmpty;

  /// 신고 접수로 검토 중인 댓글의 내용 자리표시
  ///
  /// In ko, this message translates to:
  /// **'신고 접수되어 검토 중인 댓글입니다'**
  String get photoViewerCommentUnderReview;

  /// 내 댓글 더보기 메뉴 - 수정
  ///
  /// In ko, this message translates to:
  /// **'수정하기'**
  String get commentMenuEdit;

  /// 내 댓글 더보기 메뉴 - 삭제
  ///
  /// In ko, this message translates to:
  /// **'삭제하기'**
  String get commentMenuDelete;

  /// 상대방 댓글 더보기 메뉴 - 신고
  ///
  /// In ko, this message translates to:
  /// **'신고하기'**
  String get commentMenuReport;

  /// 댓글 수정 모드에서 입력창 위에 뜨는 라벨
  ///
  /// In ko, this message translates to:
  /// **'댓글 수정 중'**
  String get commentEditingLabel;

  /// 수정된 댓글의 시간 옆에 붙는 표시
  ///
  /// In ko, this message translates to:
  /// **'수정됨'**
  String get commentEdited;

  /// 서버 응답을 기다리는 댓글의 더보기 자리 표시 (버튼 아님)
  ///
  /// In ko, this message translates to:
  /// **'전송중'**
  String get commentSending;

  /// 전송에 실패한 댓글을 다시 보내는 버튼
  ///
  /// In ko, this message translates to:
  /// **'재전송'**
  String get commentRetry;

  /// 전송 실패 댓글의 재전송 확인창 제목
  ///
  /// In ko, this message translates to:
  /// **'댓글을 다시 전송할까요?'**
  String get commentRetryTitle;

  /// 전송 실패 댓글을 목록에서 치우는 버튼 (서버 삭제가 아님)
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get commentDiscard;

  /// 전송 실패 댓글 삭제 확인창 제목
  ///
  /// In ko, this message translates to:
  /// **'이 댓글을 삭제할까요?'**
  String get commentDiscardTitle;

  /// 전송 실패 댓글 삭제 확인창 본문
  ///
  /// In ko, this message translates to:
  /// **'전송하지 못한 댓글은 되돌릴 수 없어요.'**
  String get commentDiscardMessage;

  /// 전송에 실패한 댓글에서 작성 시각 자리에 대신 뜨는 표시
  ///
  /// In ko, this message translates to:
  /// **'실패'**
  String get commentSendFailed;

  /// 전송 실패 댓글이 남은 채 사진 뷰어를 닫으려 할 때 확인창 제목
  ///
  /// In ko, this message translates to:
  /// **'전송하지 못한 댓글이 있어요'**
  String get commentPendingLeaveTitle;

  /// 전송 실패 댓글이 남은 채 사진 뷰어를 닫으려 할 때 확인창 본문
  ///
  /// In ko, this message translates to:
  /// **'지금 나가면 작성한 댓글이 사라져요.'**
  String get commentPendingLeaveMessage;

  /// 전송 실패 댓글을 버리고 사진 뷰어를 닫는 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get commentPendingLeaveConfirm;

  /// 댓글 신고 사유 - 성적 발언
  ///
  /// In ko, this message translates to:
  /// **'성적 발언'**
  String get commentReportReasonSexual;

  /// 댓글 신고 사유 - 폭력·혐오 표현
  ///
  /// In ko, this message translates to:
  /// **'폭력·혐오 표현'**
  String get commentReportReasonViolence;

  /// 댓글 신고 사유 - 욕설·비방 표현
  ///
  /// In ko, this message translates to:
  /// **'욕설·비방 표현'**
  String get commentReportReasonAbuse;

  /// 댓글 신고 사유 - 사칭·괴롭힘
  ///
  /// In ko, this message translates to:
  /// **'사칭·괴롭힘'**
  String get commentReportReasonHarassment;

  /// 댓글 신고 사유 - 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get commentReportReasonEtc;

  /// 댓글 삭제 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'이 댓글을 삭제할까요?'**
  String get commentDeleteTitle;

  /// 댓글 삭제 확인 다이얼로그 본문
  ///
  /// In ko, this message translates to:
  /// **'삭제한 댓글은 되돌릴 수 없어요.\n친구들에게도 더 이상 보이지 않아요.'**
  String get commentDeleteMessage;

  /// No description provided for @cameraPermissionTitle.
  ///
  /// In ko, this message translates to:
  /// **'카메라 권한이 필요해요'**
  String get cameraPermissionTitle;

  /// No description provided for @cameraPermissionDescription.
  ///
  /// In ko, this message translates to:
  /// **'촬영하려면 설정에서 카메라 권한을 허용해주세요.'**
  String get cameraPermissionDescription;

  /// No description provided for @cameraModeCornerMini.
  ///
  /// In ko, this message translates to:
  /// **'코너 미니뷰'**
  String get cameraModeCornerMini;

  /// No description provided for @cameraModeGhostZoom.
  ///
  /// In ko, this message translates to:
  /// **'고스트 확대'**
  String get cameraModeGhostZoom;

  /// No description provided for @cameraOpacityLabel.
  ///
  /// In ko, this message translates to:
  /// **'원본사진 투명도'**
  String get cameraOpacityLabel;

  /// No description provided for @notificationTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationTitle;

  /// No description provided for @notificationEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림이 없어요'**
  String get notificationEmptyTitle;

  /// No description provided for @notificationEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'알림을 받으면 여기에 표시돼요'**
  String get notificationEmptyDescription;

  /// No description provided for @notificationLabelMemberJoin.
  ///
  /// In ko, this message translates to:
  /// **'모임 합류'**
  String get notificationLabelMemberJoin;

  /// No description provided for @notificationLabelNewCycle.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기 시작'**
  String get notificationLabelNewCycle;

  /// No description provided for @notificationLabelCycleCompleted.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기 종료'**
  String get notificationLabelCycleCompleted;

  /// No description provided for @notificationLabelDeadline.
  ///
  /// In ko, this message translates to:
  /// **'마감 임박'**
  String get notificationLabelDeadline;

  /// No description provided for @notificationLabelDefault.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationLabelDefault;

  /// No description provided for @notificationMessageMemberJoin.
  ///
  /// In ko, this message translates to:
  /// **'{actor}님이 ‘{groupName}’ 모임에 합류했어요'**
  String notificationMessageMemberJoin(String actor, String groupName);

  /// No description provided for @notificationMessageNewCycle.
  ///
  /// In ko, this message translates to:
  /// **'‘{groupName}’ 모임에서 새로운 따라찍기가 시작됐어요'**
  String notificationMessageNewCycle(String groupName);

  /// No description provided for @notificationMessageCycleCompleted.
  ///
  /// In ko, this message translates to:
  /// **'‘{groupName}’ 모임의 따라찍기가 종료됐어요!'**
  String notificationMessageCycleCompleted(String groupName);

  /// No description provided for @notificationMessageDeadlineRemaining.
  ///
  /// In ko, this message translates to:
  /// **'‘{groupName}’ 모임의 따라찍기 마감까지 {remaining} 남았어요. 아직 안찍었죠?'**
  String notificationMessageDeadlineRemaining(
    String groupName,
    String remaining,
  );

  /// No description provided for @notificationMessageDeadline.
  ///
  /// In ko, this message translates to:
  /// **'‘{groupName}’ 모임의 따라찍기 마감이 다가와요. 아직 안찍었죠?'**
  String notificationMessageDeadline(String groupName);

  /// No description provided for @notificationMessageDefault.
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림이 있어요'**
  String get notificationMessageDefault;

  /// No description provided for @timeAgoJustNow.
  ///
  /// In ko, this message translates to:
  /// **'방금 전'**
  String get timeAgoJustNow;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String timeAgoMinutes(int minutes);

  /// No description provided for @timeAgoHours.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String timeAgoHours(int hours);

  /// No description provided for @timeAgoDays.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String timeAgoDays(int days);

  /// No description provided for @timeAgoWeeks.
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 전'**
  String timeAgoWeeks(int weeks);

  /// No description provided for @timeAgoMonths.
  ///
  /// In ko, this message translates to:
  /// **'{months}개월 전'**
  String timeAgoMonths(int months);

  /// No description provided for @timeAgoYears.
  ///
  /// In ko, this message translates to:
  /// **'{years}년 전'**
  String timeAgoYears(int years);

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationAllow.
  ///
  /// In ko, this message translates to:
  /// **'알림 허용'**
  String get notificationAllow;

  /// No description provided for @notificationSectionActivity.
  ///
  /// In ko, this message translates to:
  /// **'활동'**
  String get notificationSectionActivity;

  /// No description provided for @notificationFollowShot.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기 차례'**
  String get notificationFollowShot;

  /// No description provided for @notificationFollowShotCaption.
  ///
  /// In ko, this message translates to:
  /// **'새 따라찍기가 열리거나 내 차례일 때'**
  String get notificationFollowShotCaption;

  /// No description provided for @notificationDeadlineVote.
  ///
  /// In ko, this message translates to:
  /// **'마감·투표 알림'**
  String get notificationDeadlineVote;

  /// No description provided for @notificationDeadlineVoteCaption.
  ///
  /// In ko, this message translates to:
  /// **'따라찍기 마감 · 베스트 투표'**
  String get notificationDeadlineVoteCaption;

  /// No description provided for @notificationSectionEtc.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get notificationSectionEtc;

  /// No description provided for @notificationMemberJoin.
  ///
  /// In ko, this message translates to:
  /// **'친구 참여 알림'**
  String get notificationMemberJoin;

  /// No description provided for @notificationMemberJoinCaption.
  ///
  /// In ko, this message translates to:
  /// **'내가 보낸 초대를 친구가 받았을 때'**
  String get notificationMemberJoinCaption;

  /// No description provided for @notificationPermissionDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한 필요'**
  String get notificationPermissionDialogTitle;

  /// No description provided for @notificationPermissionDialogBody.
  ///
  /// In ko, this message translates to:
  /// **'알림을 받으려면 설정에서 알림 권한을 허용해 주세요.'**
  String get notificationPermissionDialogBody;

  /// No description provided for @notificationOpenSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정으로 이동'**
  String get notificationOpenSettings;

  /// No description provided for @profileTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profileTitle;

  /// No description provided for @profileSectionBasicInfo.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보'**
  String get profileSectionBasicInfo;

  /// No description provided for @profileJoinedAt.
  ///
  /// In ko, this message translates to:
  /// **'가입일'**
  String get profileJoinedAt;

  /// No description provided for @profileSectionNotification.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get profileSectionNotification;

  /// No description provided for @profileSectionSupport.
  ///
  /// In ko, this message translates to:
  /// **'지원'**
  String get profileSectionSupport;

  /// No description provided for @profileTermsPolicy.
  ///
  /// In ko, this message translates to:
  /// **'약관 및 정책'**
  String get profileTermsPolicy;

  /// No description provided for @profileContact.
  ///
  /// In ko, this message translates to:
  /// **'문의하기'**
  String get profileContact;

  /// No description provided for @profileAppVersion.
  ///
  /// In ko, this message translates to:
  /// **'앱 버전'**
  String get profileAppVersion;

  /// No description provided for @profileSectionAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get profileSectionAccount;

  /// No description provided for @profileAccountManage.
  ///
  /// In ko, this message translates to:
  /// **'계정 관리'**
  String get profileAccountManage;

  /// No description provided for @profileSectionManage.
  ///
  /// In ko, this message translates to:
  /// **'관리'**
  String get profileSectionManage;

  /// No description provided for @profileBlockedUsers.
  ///
  /// In ko, this message translates to:
  /// **'차단한 유저 목록'**
  String get profileBlockedUsers;

  /// No description provided for @blockedUsersTitle.
  ///
  /// In ko, this message translates to:
  /// **'차단한 유저'**
  String get blockedUsersTitle;

  /// No description provided for @blockedUsersEmpty.
  ///
  /// In ko, this message translates to:
  /// **'차단한 유저가 없어요'**
  String get blockedUsersEmpty;

  /// No description provided for @blockedUsersUnblock.
  ///
  /// In ko, this message translates to:
  /// **'차단 해제'**
  String get blockedUsersUnblock;

  /// No description provided for @blockedUsersUnblockedToast.
  ///
  /// In ko, this message translates to:
  /// **'차단을 해제했어요.'**
  String get blockedUsersUnblockedToast;

  /// No description provided for @blockedUsersUnblockFailed.
  ///
  /// In ko, this message translates to:
  /// **'차단을 해제하지 못했어요.'**
  String get blockedUsersUnblockFailed;

  /// No description provided for @blockedPhotoPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'차단한 멤버의 사진입니다.'**
  String get blockedPhotoPlaceholder;

  /// No description provided for @photoUnderReviewPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'신고 접수되어\n검토 중인 사진입니다'**
  String get photoUnderReviewPlaceholder;

  /// No description provided for @photoUnderReviewPlaceholderShort.
  ///
  /// In ko, this message translates to:
  /// **'신고 접수\n검토중'**
  String get photoUnderReviewPlaceholderShort;

  /// No description provided for @blockedCycleTopic.
  ///
  /// In ko, this message translates to:
  /// **'차단한 멤버의 따라찍기'**
  String get blockedCycleTopic;

  /// No description provided for @profileLinkedAccount.
  ///
  /// In ko, this message translates to:
  /// **'연동 계정'**
  String get profileLinkedAccount;

  /// No description provided for @profileLogout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get profileLogout;

  /// No description provided for @profileWithdraw.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get profileWithdraw;

  /// No description provided for @profileLogoutFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃에 실패했어요.'**
  String get profileLogoutFailed;

  /// No description provided for @profileWithdrawFailed.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴에 실패했어요.'**
  String get profileWithdrawFailed;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 할까요?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileWithdrawConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'정말 탈퇴할까요?'**
  String get profileWithdrawConfirmTitle;

  /// No description provided for @profileWithdrawConfirmAction.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴'**
  String get profileWithdrawConfirmAction;

  /// No description provided for @profileContactMailSubject.
  ///
  /// In ko, this message translates to:
  /// **'[따라] 문의하기'**
  String get profileContactMailSubject;

  /// 문의 메일 본문. (앱 버전 포함)
  ///
  /// In ko, this message translates to:
  /// **'문의 내용을 작성해 주세요.\n\n------------------\n앱 버전: {appVersion}\n------------------'**
  String profileContactMailBody(String appVersion);

  /// 문의 메일 앱 실행 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'메일 앱을 열 수 없어요. ({email})'**
  String profileContactMailFailed(String email);

  /// No description provided for @profileImageSourceTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필 사진 변경'**
  String get profileImageSourceTitle;

  /// No description provided for @profileImageSourceCamera.
  ///
  /// In ko, this message translates to:
  /// **'사진 촬영'**
  String get profileImageSourceCamera;

  /// No description provided for @profileImageSourceGallery.
  ///
  /// In ko, this message translates to:
  /// **'갤러리에서 선택'**
  String get profileImageSourceGallery;

  /// No description provided for @profileImageSourceReset.
  ///
  /// In ko, this message translates to:
  /// **'기본 이미지로 변경'**
  String get profileImageSourceReset;

  /// No description provided for @profileImageUpdated.
  ///
  /// In ko, this message translates to:
  /// **'프로필 사진이 변경되었어요.'**
  String get profileImageUpdated;

  /// No description provided for @profileImageReset.
  ///
  /// In ko, this message translates to:
  /// **'기본 이미지로 변경되었어요.'**
  String get profileImageReset;

  /// No description provided for @profileImageUploadFailed.
  ///
  /// In ko, this message translates to:
  /// **'프로필 사진 변경에 실패했어요.'**
  String get profileImageUploadFailed;

  /// No description provided for @profileImageInvalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'jpg 또는 png 이미지만 사용할 수 있어요.'**
  String get profileImageInvalidFormat;

  /// No description provided for @termsPolicyTitle.
  ///
  /// In ko, this message translates to:
  /// **'약관 및 정책'**
  String get termsPolicyTitle;

  /// No description provided for @policyTermsOfService.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 약관'**
  String get policyTermsOfService;

  /// No description provided for @policyPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get policyPrivacy;

  /// No description provided for @policyCommunityGuideline.
  ///
  /// In ko, this message translates to:
  /// **'운영정책(커뮤니티 가이드)'**
  String get policyCommunityGuideline;

  /// No description provided for @policyYouthProtection.
  ///
  /// In ko, this message translates to:
  /// **'청소년 보호정책'**
  String get policyYouthProtection;

  /// No description provided for @policyLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'문서를 불러오지 못했어요.'**
  String get policyLoadFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

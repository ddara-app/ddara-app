// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get onboardingFirstTitle => '한 장 찍으면 인증샷이 시작';

  @override
  String get onboardingFirstBody => '내가 한 포즈, 친구들이 똑같이 따라 찍어요';

  @override
  String get onboardingSecondTitle => '나중에 보면 더 웃겨';

  @override
  String get onboardingSecondBody => '따라 찍은 사진들이 모여 기록이 돼요';

  @override
  String get onboardingThirdTitle => '아는 친구끼리만, 초대로만';

  @override
  String get onboardingThirdBody => '초대받은 친구만 들어올 수 있어요';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get loginSlogan => '우리끼리 따라찍기';

  @override
  String get loginKakao => '카카오 로그인';

  @override
  String get loginGoogle => 'Google 로그인';

  @override
  String get loginApple => 'Apple 로그인';

  @override
  String get loginAppleComingSoon => 'Apple 로그인은 곧 지원될 예정이에요.';

  @override
  String get loginViewPolicies => '이용약관과 개인정보 처리방침 확인';

  @override
  String get termsTitle => '약관에 동의해 주세요';

  @override
  String get termsSubtitle => '서비스 이용을 위해선 이용약관 동의가 필요해요';

  @override
  String get termsAgreeAll => '전체 동의';

  @override
  String get termsServiceLabel => '[필수] 이용약관';

  @override
  String get termsPrivacyLabel => '[필수] 개인정보 처리방침';

  @override
  String get termsAgeLabel => '[필수] 만 14세 이상 사용자 이용동의';

  @override
  String get termsContinueButton => '동의하고 계속';

  @override
  String get policyServiceTitle => '서비스 이용 약관';

  @override
  String get policyPrivacyTitle => '개인정보 처리방침';

  @override
  String get policyYouthTitle => '청소년 보호정책';

  @override
  String get emptyGroupTitle => '아직 참여한 모임이 없어요';

  @override
  String get emptyGroupDescription => '첫 판을 시작해 친구들에게 보내보세요';

  @override
  String get groupCreate => '모임 만들기';

  @override
  String get groupJoin => '모임 참여하기';

  @override
  String get groupEnter => '모임 들어가기';

  @override
  String get groupCountLabel => '현재 모임 개수';

  @override
  String groupCountValue(int count, int maxCount) {
    return '$count/$maxCount개';
  }

  @override
  String get groupCountCaption => '모임에 속해 있어요';

  @override
  String get meetingStatusInProgress => '진행 중';

  @override
  String get meetingStatusCompleted => '종료';

  @override
  String meetingMemberOwner(String name) {
    return '$name님';
  }

  @override
  String meetingMemberOthers(String name, int others) {
    return '$name님 외 $others명';
  }

  @override
  String meetingRemainingHours(int hours) {
    return '$hours시간 남음';
  }

  @override
  String meetingRemainingMinutes(int minutes) {
    return '$minutes분 남음';
  }

  @override
  String get meetingClosed => '마감';

  @override
  String get commonConfirm => '확인';

  @override
  String get photoRetake => '다시 찍기';

  @override
  String get photoUpload => '올리기';

  @override
  String get photoPostWarningTitle => '게시되면 수정이 불가능합니다.';

  @override
  String get photoTakeAction => '촬영하러 가기';

  @override
  String get groupCreateTitle => '모임 이름을 정해주세요';

  @override
  String get groupCreateSubtitle => '내가 먼저 찍으면, 친구들이 따라 찍어요';

  @override
  String get groupCreateNameLabel => '모임 이름';

  @override
  String get groupCreateNamePlaceholder => '예) 마라탕 걸즈';

  @override
  String get groupCreateIntroLabel => '한 줄 소개 (선택)';

  @override
  String get groupCreateIntroPlaceholder => '어떤 모임인지 알려주세요';

  @override
  String get groupCreateSubmit => '만들기';

  @override
  String get groupJoinTitle => '모임 참여';

  @override
  String get groupJoinHeadline => '받은 초대 코드를 입력해주세요';

  @override
  String get groupJoinSubtitle => '링크로 받았다면, 링크만 눌러도 바로 들어올 수 있어요';

  @override
  String get groupJoinCodeLabel => '초대 코드';

  @override
  String get groupJoinCodePlaceholder => '예) ASKD23NSK12';

  @override
  String get starterTitle => '스타터 시작하기';

  @override
  String get starterConceptLabel => '컨셉 설명';

  @override
  String get starterConceptPlaceholder => '예) 마라탕 또 먹기';

  @override
  String get starterConceptLengthError => '20자 이내로 입력해 주세요';

  @override
  String get followerCameraTitle => '따라찍기';

  @override
  String get groupHeaderStart => '내가 먼저 시작하기';

  @override
  String get groupHeaderTakePhoto => '따라찍으러 가기';

  @override
  String get groupDetailEmptyTitle => '아직 따라찍기가 없어요';

  @override
  String get groupDetailLoadError => '모임 정보를 불러오지 못했어요.';

  @override
  String get groupMembersTitle => '친구들';

  @override
  String get groupMembersAdd => '추가하기';

  @override
  String get memberReportNickname => '닉네임 신고';

  @override
  String get memberReportMailSubject => '[따라] 닉네임 신고';

  @override
  String memberReportMailBody(String nickname) {
    return '신고할 닉네임: $nickname\n\n신고 사유를 작성해 주세요.\n';
  }

  @override
  String memberReportMailFailed(String email) {
    return '메일 앱을 열 수 없어요. ($email)';
  }

  @override
  String get groupHistoryTitle => '지난 따라찍기';

  @override
  String get groupHistoryMore => '더보기';

  @override
  String get groupHistoryEmpty => '지난 따라찍기가 아직 없어요';

  @override
  String get recordCycleLabel => '따라찍기';

  @override
  String get recordPhotoLabel => '함께한 사진';

  @override
  String historyParticipantCount(int count) {
    return '$count명 참여';
  }

  @override
  String startedHeaderRemaining(String time) {
    return '진행 중 · $time 남음';
  }

  @override
  String startedHeaderCycle(int count) {
    return '$count번째 따라찍기';
  }

  @override
  String startedHeaderStarter(String name) {
    return '$name님이 시작했어요';
  }

  @override
  String get remainingDeadline => '마감';

  @override
  String remainingHours(int hours) {
    return '$hours시간';
  }

  @override
  String remainingMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get commonNext => '다음';

  @override
  String get commonStart => '시작하기';

  @override
  String get commonCancel => '취소';

  @override
  String get groupCreateNameLengthError => '20자 이하로 입력해주세요';

  @override
  String setNicknameTitle(String groupName) {
    return '$groupName 안에서\n어떻게 불러드릴까요?';
  }

  @override
  String get setNicknameDescription => '친구들에게 보이는 이름이에요';

  @override
  String get setNicknamePlaceholder => '닉네임 (2~10자)';

  @override
  String get setNicknameCaption =>
      '*한글과 영어만 사용 가능해요\n**욕설·혐오·사칭 등 부적절한 닉네임은 변경될 수 있어요(자세한 기준 → 운영정책)';

  @override
  String get groupMenuEditNickname => '닉네임 수정';

  @override
  String get groupMenuExit => '모임 나가기';

  @override
  String get groupExitConfirmTitle => '모임에서 나갈까요?';

  @override
  String get groupExitConfirmAction => '나가기';

  @override
  String get editNicknameEmptyError => '닉네임을 입력해주세요.';

  @override
  String get editNicknameSubmit => '수정';

  @override
  String get inviteLandingTitle => '초대장이 도착했어요';

  @override
  String get joinConfirmInvalid => '잘못된 초대입니다';

  @override
  String get joinConfirmAlreadyJoined => '이미 참여 중인 방입니다';

  @override
  String get joinConfirmFull => '정원이 초과되었어요';

  @override
  String joinConfirmSubtitle(String date, int count) {
    return '$date 개설 · $count명';
  }

  @override
  String joinConfirmMemberOwner(String name) {
    return '$name님이 함께하고 있어요';
  }

  @override
  String joinConfirmMemberOthers(String name, int others) {
    return '$name님 외 $others명이 함께하고 있어요';
  }

  @override
  String historyDate(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get profileTitle => '프로필';

  @override
  String get profileSectionBasicInfo => '기본 정보';

  @override
  String get profileJoinedAt => '가입일';

  @override
  String get profileSectionNotification => '알림';

  @override
  String get profileSectionSupport => '지원';

  @override
  String get profileTermsPolicy => '약관 및 정책';

  @override
  String get profileContact => '문의하기';

  @override
  String get profileAppVersion => '앱 버전';

  @override
  String get profileSectionAccount => '계정';

  @override
  String get profileLinkedAccount => '연동 계정';

  @override
  String get profileLogout => '로그아웃';

  @override
  String get profileWithdraw => '회원 탈퇴';

  @override
  String get profileLogoutFailed => '로그아웃에 실패했어요.';

  @override
  String get profileWithdrawFailed => '회원 탈퇴에 실패했어요.';

  @override
  String get profileNotImplemented => '아직 구현되지 않았습니다.';

  @override
  String get profileLogoutConfirmTitle => '로그아웃 할까요?';

  @override
  String get profileWithdrawConfirmTitle => '정말 탈퇴할까요?';

  @override
  String get profileWithdrawConfirmAction => '탈퇴';

  @override
  String get profileContactMailSubject => '[따라] 문의하기';

  @override
  String profileContactMailBody(String appVersion) {
    return '문의 내용을 작성해 주세요.\n\n------------------\n앱 버전: $appVersion\n------------------';
  }

  @override
  String profileContactMailFailed(String email) {
    return '메일 앱을 열 수 없어요. ($email)';
  }

  @override
  String get profileImageSourceTitle => '프로필 사진 변경';

  @override
  String get profileImageSourceCamera => '사진 촬영';

  @override
  String get profileImageSourceGallery => '갤러리에서 선택';

  @override
  String get profileImageSourceReset => '기본 이미지로 변경';

  @override
  String get profileImageUpdated => '프로필 사진이 변경되었어요.';

  @override
  String get profileImageReset => '기본 이미지로 변경되었어요.';

  @override
  String get profileImageUploadFailed => '프로필 사진 변경에 실패했어요.';

  @override
  String get profileImageInvalidFormat => 'jpg 또는 png 이미지만 사용할 수 있어요.';

  @override
  String get notificationSettingsTitle => '알림 설정';

  @override
  String get notificationAllow => '알림 허용';

  @override
  String get notificationSectionActivity => '활동';

  @override
  String get notificationFollowShot => '따라찍기 차례';

  @override
  String get notificationFollowShotCaption => '새 따라찍기가 열리거나 내 차례일 때';

  @override
  String get notificationDeadlineVote => '마감·투표 알림';

  @override
  String get notificationDeadlineVoteCaption => '따라찍기 마감 · 베스트 투표';

  @override
  String get notificationSectionEtc => '기타';

  @override
  String get notificationMemberJoin => '친구 참여 알림';

  @override
  String get notificationMemberJoinCaption => '내가 보낸 초대를 친구가 받았을 때';

  @override
  String get notificationPermissionDialogTitle => '알림 권한 필요';

  @override
  String get notificationPermissionDialogBody =>
      '알림을 받으려면 설정에서 알림 권한을 허용해 주세요.';

  @override
  String get notificationOpenSettings => '설정으로 이동';
}

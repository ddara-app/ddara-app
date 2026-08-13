// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get commonConfirm => '확인';

  @override
  String get commonNext => '다음';

  @override
  String get commonStart => '시작하기';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

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
  String get loginViewPolicies => '이용약관과 개인정보 처리방침 확인';

  @override
  String get loginErrorUnauthorized => '로그인 인증에 실패했어요. 다시 시도해 주세요.';

  @override
  String get loginErrorNetwork => '네트워크 연결을 확인해 주세요.';

  @override
  String get loginErrorUnknown => '로그인에 실패했어요. 잠시 후 다시 시도해 주세요.';

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
  String get signUpErrorInvalidInput => '입력값을 확인해 주세요.';

  @override
  String get signUpErrorInvalidToken => '소셜 토큰이 만료되었거나 유효하지 않습니다.';

  @override
  String get signUpErrorUnsupportedProvider => '지원하지 않는 로그인 방식입니다.';

  @override
  String get signUpErrorUnknown => '회원가입에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get permissionPageTitle => '권한 안내';

  @override
  String get permissionHeaderTitle => '이런 권한이 필요해요';

  @override
  String get permissionHeaderDescription =>
      '꼭 필요한 순간에만 권한을 요청해요.\n요청이 뜨면 허용해 주시면 돼요';

  @override
  String get permissionSectionRequired => '필수 접근 권한';

  @override
  String get permissionSectionOptional => '선택 접근 권한';

  @override
  String get permissionCamera => '카메라';

  @override
  String get permissionCameraDescription => '따라찍기 사진을 촬영할 때 사용해요';

  @override
  String get permissionNotification => '알림';

  @override
  String get permissionNotificationDescription => '마감·투표·초대 소식이 있을 때 알려드려요';

  @override
  String get permissionStorage => '저장공간';

  @override
  String get permissionStorageDescription => '앨범에서 사진을 올릴 때 사용해요';

  @override
  String get permissionPhotos => '사진';

  @override
  String get requiredPermissionTitle => '필수 권한을 허용해 주세요';

  @override
  String get requiredPermissionDescription => '카메라 권한이 있어야 따라찍기를 할 수 있어요';

  @override
  String permissionDialogTitle(String permissionName) {
    return '$permissionName 권한이 필요해요';
  }

  @override
  String get permissionDialogContent => '설정 > 권한에서 직접 허용해 주세요.';

  @override
  String get permissionGoToSettings => '설정으로 이동';

  @override
  String get homeTabGroups => '따라찍기 모임';

  @override
  String get homeTabRecentUpdates => '최근 업데이트';

  @override
  String get homeLoadFailed => '목록을 불러오지 못했어요.';

  @override
  String get feedLoadFailed => '최근 업데이트를 불러오지 못했어요.';

  @override
  String get emptyGroupTitle => '아직 참여한 모임이 없어요';

  @override
  String get emptyGroupDescription => '첫 판을 시작해 친구들에게 보내보세요';

  @override
  String get groupCreate => '모임 만들기';

  @override
  String get groupJoin => '모임 참여하기';

  @override
  String get groupCountLabel => '현재 모임 개수';

  @override
  String groupCountValue(int count, int maxCount) {
    return '$count/$maxCount개';
  }

  @override
  String get groupCountCaption => '모임에 속해 있어요';

  @override
  String get updateCountLabel => '친구들의 업데이트';

  @override
  String updateCountValue(int count) {
    return '$count개';
  }

  @override
  String get updateCountCaption => '어서 따라찍기를 시작해봐요';

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
    return '마감 $hours시간 전';
  }

  @override
  String meetingRemainingMinutes(int minutes) {
    return '마감 $minutes분 전';
  }

  @override
  String get meetingClosed => '진행 종료';

  @override
  String get meetingNotStarted => '스타터';

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
  String get groupCreateNameLengthError => '20자 이하로 입력해주세요';

  @override
  String get groupCreateIntroLengthError => '100자 이하로 입력해주세요';

  @override
  String get groupCreateErrorInvalidName => '모임 이름을 확인해주세요.';

  @override
  String get groupCreateErrorUnauthorized => '로그인이 만료되었어요. 다시 로그인해 주세요.';

  @override
  String get groupCreateErrorLimitExceeded => '만들 수 있는 모임 개수(최대 20개)를 초과했어요.';

  @override
  String get groupCreateErrorUnknown => '네트워크 연결이 불안정해요.';

  @override
  String get groupJoinErrorInvalidInput => '입력값이 올바르지 않아요.';

  @override
  String get groupJoinErrorInvalidCode => '유효하지 않은 초대 코드예요.';

  @override
  String get groupJoinErrorGroupNotFound => '존재하지 않는 초대 코드예요.';

  @override
  String get groupJoinErrorAlreadyJoined => '이미 참여 중인 모임이에요.';

  @override
  String get groupJoinErrorGroupFull => '이미 꽉 찬 모임이에요. 만든 친구에게 물어봐 주세요.';

  @override
  String get groupJoinErrorLimitExceeded => '참여할 수 있는 모임 개수를 초과했어요.';

  @override
  String get groupJoinErrorDuplicateNickname => '이미 누가 쓰고 있어요. 다른 이름은 어때요?';

  @override
  String get groupJoinErrorUnknown => '네트워크 연결이 불안정해요.';

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
  String get nicknameErrorCharset => '한글과 영어로만 지을 수 있어요';

  @override
  String get nicknameErrorWhitespace => '앞뒤 공백은 사용할 수 없어요';

  @override
  String get nicknameErrorLength => '2~10자로 입력해주세요';

  @override
  String get editNicknameEmptyError => '닉네임을 입력해주세요.';

  @override
  String get editNicknameSubmit => '수정';

  @override
  String get groupDetailEmptyTitle => '아직 따라찍기가 없어요';

  @override
  String get groupHeaderStart => '내가 먼저 시작하기';

  @override
  String get groupHeaderTakePhoto => '따라찍으러 가기';

  @override
  String get groupMenuEditNickname => '닉네임 수정';

  @override
  String get groupMenuReport => '모임 신고';

  @override
  String get groupMenuExit => '모임 나가기';

  @override
  String get groupExitConfirmTitle => '모임에서 나갈까요?';

  @override
  String get groupExitConfirmAction => '나가기';

  @override
  String get groupMembersTitle => '친구들';

  @override
  String get groupMembersAdd => '추가하기';

  @override
  String get groupMembersStarterBadge => '스타터';

  @override
  String get memberReportUser => '유저 신고';

  @override
  String get report => '신고하기';

  @override
  String get photoSave => '저장하기';

  @override
  String get photoSaveSuccess => '사진을 저장했어요';

  @override
  String get photoSaveFailed => '사진을 저장하지 못했어요';

  @override
  String get photoSavePermissionDenied => '사진 접근 권한이 필요해요';

  @override
  String get reportSheetTitle => '신고 사유를 선택해 주세요';

  @override
  String get reportSheetSubtitle => '신고 내용은 24시간 안에 확인해요';

  @override
  String get reportDetailPlaceholder => '입력해 주세요';

  @override
  String get reportSubmitted => '신고를 접수했어요. 24시간 안에 확인할게요';

  @override
  String get photoReportReasonObscene => '음란물';

  @override
  String get photoReportReasonViolence => '폭력·혐오';

  @override
  String get photoReportReasonUnauthorizedFilming => '타인 무단촬영';

  @override
  String get photoReportReasonImpersonation => '사칭·괴롭힘';

  @override
  String get photoReportReasonEtc => '기타';

  @override
  String get groupReportReasonInappropriate => '부적절한 모임 이름·이미지';

  @override
  String get groupReportReasonEtc => '기타';

  @override
  String get userReportReasonNickname => '부적절한 닉네임(욕설·음란·혐오)';

  @override
  String get userReportReasonProfileImage => '부적절한 프로필 사진(음란·혐오)';

  @override
  String get userReportReasonHarassment => '사칭·괴롭힘';

  @override
  String get userReportReasonEtc => '기타';

  @override
  String get memberBlock => '차단하기';

  @override
  String memberBlockConfirmTitle(String nickname) {
    return '$nickname님을 차단할까요?';
  }

  @override
  String get memberBlockConfirmMessage => '차단하면 이 멤버의 사진이\n더 이상 보이지 않습니다.';

  @override
  String get memberBlockConfirmAction => '차단';

  @override
  String memberBlockedToast(String nickname) {
    return '$nickname님을 차단했어요.';
  }

  @override
  String get memberBlockFailedToast => '차단하지 못했어요.';

  @override
  String get recordCycleLabel => '따라찍기';

  @override
  String get recordPhotoLabel => '함께한 사진';

  @override
  String get recordSectionTitle => '기록';

  @override
  String get recordMyCycleLabel => '나의 따라찍기';

  @override
  String get recordGroupCycleLabel => '모임 따라찍기';

  @override
  String get groupHistoryTitle => '지난 따라찍기';

  @override
  String get groupHistoryMore => '더보기';

  @override
  String get groupHistoryEmpty => '지난 따라찍기가 아직 없어요';

  @override
  String get groupHistoryFilterAll => '전체보기';

  @override
  String groupHistoryFilterYearMonth(int year, int month) {
    return '$year년 $month월';
  }

  @override
  String historyYearLabel(int year) {
    return '$year년';
  }

  @override
  String get historyFilterReset => '초기화';

  @override
  String historyMonthLabel(int month) {
    return '$month월';
  }

  @override
  String historyParticipantCount(int count) {
    return '$count명 참여';
  }

  @override
  String historyDate(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String startedHeaderRemaining(String time) {
    return '진행 중 · 마감 $time 전';
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
  String get startedHeaderCheckUploads => '업로드 친구 확인하기';

  @override
  String startedHeaderStarterChip(String nickname) {
    return '스타터 · $nickname';
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
  String remainingDays(int days) {
    return '$days일';
  }

  @override
  String get inviteShareTitle => '함께할 친구를 초대해요';

  @override
  String get inviteMemberShortageTitle => '아직 멤버가 부족해요';

  @override
  String get inviteMemberShortageDescription => '2명부터 시작 가능해요';

  @override
  String get inviteShareKakao => '카카오톡';

  @override
  String get inviteShareCopyCode => '초대코드';

  @override
  String get inviteShareMore => '더보기';

  @override
  String get inviteShareLater => '다음에 할게요';

  @override
  String get inviteShareFailed => '공유하지 못했어요. 잠시 후 다시 시도하거나 초대코드를 복사해 전달해주세요.';

  @override
  String get inviteCodeCopied => '초대 코드를 복사했어요';

  @override
  String get starterTitle => '스타터 시작하기';

  @override
  String get starterConceptLabel => '컨셉 설명';

  @override
  String get starterConceptPlaceholder => '예) 마라탕 또 먹기';

  @override
  String get starterConceptLengthError => '20자 이내로 입력해 주세요';

  @override
  String randomStarterResultTitle(String name) {
    return '이번 스타터는 $name님이에요!';
  }

  @override
  String get randomStarterResultSubtitle => '첫 판을 시작해 친구들에게 보내보세요';

  @override
  String get randomStarterLoadFailed => '스타터 정보를 불러오지 못했어요';

  @override
  String get followerCameraTitle => '따라찍기';

  @override
  String get photoRetake => '다시 찍기';

  @override
  String get photoUpload => '올리기';

  @override
  String get photoPostWarningTitle => '게시되면 수정이 불가능합니다.';

  @override
  String get photoTakeAction => '촬영하러 가기';

  @override
  String get photoViewerCommentHint => '댓글을 남겨보세요...';

  @override
  String get photoViewerCommentLockedHint => '따라찍기를 이용한 후 댓글을 남길 수 있어요';

  @override
  String get photoViewerCommentEmpty => '아직 댓글이 없습니다.';

  @override
  String get commentMenuEdit => '수정하기';

  @override
  String get commentMenuDelete => '삭제하기';

  @override
  String get commentMenuReport => '신고하기';

  @override
  String get commentEditingLabel => '댓글 수정 중';

  @override
  String get commentEdited => '수정됨';

  @override
  String get commentSending => '전송중';

  @override
  String get commentRetry => '재전송';

  @override
  String get commentRetryTitle => '댓글을 다시 전송할까요?';

  @override
  String get commentDiscard => '삭제';

  @override
  String get commentDiscardTitle => '이 댓글을 삭제할까요?';

  @override
  String get commentDiscardMessage => '전송하지 못한 댓글은 되돌릴 수 없어요.';

  @override
  String get commentSendFailed => '실패';

  @override
  String get commentErrorPhotoDeleted => '이미 삭제된 사진이에요.';

  @override
  String get commentErrorNotGroupMember => '해당 모임의 멤버가 아니에요.';

  @override
  String get commentErrorLoadFailed => '댓글을 불러오지 못했어요.';

  @override
  String get commentErrorInvalidInput => '댓글 내용을 확인해 주세요.';

  @override
  String get commentErrorPhotoLocked => '내 인증샷을 올려야 댓글을 달 수 있어요.';

  @override
  String get commentErrorPhotoUnderReview => '검토 중인 사진에는 댓글을 달 수 없어요.';

  @override
  String get commentErrorSubmitFailed => '댓글을 등록하지 못했어요.';

  @override
  String get commentErrorDeleteForbidden => '내가 작성한 댓글만 삭제할 수 있어요.';

  @override
  String get commentErrorAlreadyDeleted => '이미 삭제된 댓글이에요.';

  @override
  String get commentErrorDeleteFailed => '댓글을 삭제하지 못했어요.';

  @override
  String get commentErrorEditForbidden => '내가 작성한 댓글만 수정할 수 있어요.';

  @override
  String get commentErrorEditFailed => '댓글을 수정하지 못했어요.';

  @override
  String get commentErrorInvalidReport => '신고 내용이 올바르지 않아요.';

  @override
  String get commentErrorReportFailed => '신고하지 못했어요.';

  @override
  String get groupErrorNotGroupMember => '해당 모임의 멤버가 아니에요.';

  @override
  String get groupErrorGroupNotFound => '존재하지 않는 모임이에요.';

  @override
  String get groupErrorCycleNotFound => '존재하지 않는 회차예요.';

  @override
  String get groupErrorUnauthorized => '로그인이 필요해요.';

  @override
  String get groupErrorNetwork => '네트워크 연결이 불안정해요.';

  @override
  String get groupErrorGroupLoadFailed => '모임 정보를 불러오지 못했어요.';

  @override
  String get groupErrorGalleryLoadFailed => '사진을 불러오지 못했어요.';

  @override
  String get groupErrorHistoryLoadFailed => '지난 따라찍기를 불러오지 못했어요.';

  @override
  String get groupErrorExitFailed => '모임에서 나가지 못했어요.';

  @override
  String get groupErrorReportInvalidInput => '신고 내용이 올바르지 않아요.';

  @override
  String get groupErrorReportShotNotFound => '이미 삭제된 사진이에요.';

  @override
  String get groupErrorReportUserNotFound => '모임에 없는 사용자예요.';

  @override
  String get groupErrorReportFailed => '신고하지 못했어요.';

  @override
  String get groupErrorBlockSelf => '자기 자신은 차단할 수 없어요.';

  @override
  String get groupErrorBlockTargetNotFound => '존재하지 않는 사용자예요.';

  @override
  String get groupErrorBlockFailed => '차단하지 못했어요.';

  @override
  String get groupErrorNicknameInvalid => '닉네임은 2~10자로 입력해주세요.';

  @override
  String get groupErrorNicknameDuplicate => '이미 누가 쓰고 있어요. 다른 이름은 어때요?';

  @override
  String get groupErrorNicknameChangeFailed => '닉네임을 변경하지 못했어요.';

  @override
  String get groupErrorStarterInvalidInput => '컨셉 또는 이미지가 올바르지 않아요.';

  @override
  String get groupErrorImageUploadFailed => '이미지 업로드에 실패했어요.';

  @override
  String get groupErrorNotEnoughMembers => '활동 멤버가 2명 이상이어야 시작할 수 있어요.';

  @override
  String get groupErrorCycleAlreadyInProgress => '이미 진행 중인 회차가 있어요.';

  @override
  String get groupErrorStarterUploadFailed => '따라찍기를 시작하지 못했어요.';

  @override
  String get groupErrorFollowerUploadFailed => '사진을 올리지 못했어요.';

  @override
  String get commentPendingLeaveTitle => '전송하지 못한 댓글이 있어요';

  @override
  String get commentPendingLeaveMessage => '지금 나가면 작성한 댓글이 사라져요.';

  @override
  String get commentPendingLeaveConfirm => '나가기';

  @override
  String get commentReportReasonSexual => '성적 발언';

  @override
  String get commentReportReasonViolence => '폭력·혐오 표현';

  @override
  String get commentReportReasonAbuse => '욕설·비방 표현';

  @override
  String get commentReportReasonHarassment => '사칭·괴롭힘';

  @override
  String get commentReportReasonEtc => '기타';

  @override
  String get commentDeleteTitle => '이 댓글을 삭제할까요?';

  @override
  String get commentDeleteMessage => '삭제한 댓글은 되돌릴 수 없어요.\n친구들에게도 더 이상 보이지 않아요.';

  @override
  String get cameraPermissionTitle => '카메라 권한이 필요해요';

  @override
  String get cameraPermissionDescription => '촬영하려면 설정에서 카메라 권한을 허용해주세요.';

  @override
  String get cameraModeCornerMini => '코너 미니뷰';

  @override
  String get cameraModeGhostZoom => '고스트 확대';

  @override
  String get cameraOpacityLabel => '원본사진 투명도';

  @override
  String get notificationTitle => '알림';

  @override
  String get notificationEmptyTitle => '새로운 알림이 없어요';

  @override
  String get notificationEmptyDescription => '알림을 받으면 여기에 표시돼요';

  @override
  String get notificationLoadFailed => '알림을 불러오지 못했어요.';

  @override
  String get notificationLabelDefault => '알림';

  @override
  String notificationMessageMemberJoin(String actor, String groupName) {
    return '$actor님이 ‘$groupName’ 모임에 합류했어요';
  }

  @override
  String notificationMessageNewCycle(String groupName, String actor) {
    return '‘$groupName’에서 $actor님이 새 따라찍기를 올렸어요';
  }

  @override
  String notificationMessageNewCycleNoActor(String groupName) {
    return '‘$groupName’에서 새 따라찍기가 시작됐어요';
  }

  @override
  String notificationMessageCycleCompleted(String groupName) {
    return '‘$groupName’ 모임의 따라찍기가 종료됐어요!';
  }

  @override
  String notificationMessageDeadlineRemaining(
    String groupName,
    String remaining,
  ) {
    return '‘$groupName’ 모임의 따라찍기 마감까지 $remaining 남았어요. 아직 안찍었죠?';
  }

  @override
  String notificationMessageDeadline(String groupName) {
    return '‘$groupName’ 모임의 따라찍기 마감이 다가와요. 아직 안찍었죠?';
  }

  @override
  String notificationMessageStarterAssigned(String groupName) {
    return '‘$groupName’에서 랜덤 스타터를 확인해보세요';
  }

  @override
  String notificationMessageFriendShot(String actor, String groupName) {
    return '‘$groupName’에서 $actor님이 따라찍기를 올렸어요';
  }

  @override
  String notificationMessageComment(String actor, String groupName) {
    return '‘$groupName’에서 $actor님이 내 사진에 댓글을 남겼어요';
  }

  @override
  String get notificationMessageDefault => '새로운 알림이 있어요';

  @override
  String get timeAgoJustNow => '방금 전';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes분 전';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours시간 전';
  }

  @override
  String timeAgoDays(int days) {
    return '$days일 전';
  }

  @override
  String timeAgoWeeks(int weeks) {
    return '$weeks주 전';
  }

  @override
  String timeAgoMonths(int months) {
    return '$months개월 전';
  }

  @override
  String timeAgoYears(int years) {
    return '$years년 전';
  }

  @override
  String get notificationSettingsTitle => '알림 설정';

  @override
  String get notificationAllow => '알림 허용';

  @override
  String get notificationSectionActivity => '활동';

  @override
  String get notificationFollowShot => '따라찍기 알림';

  @override
  String get notificationFollowShotCaption => '새 따라찍기가 열리거나 마감될 때';

  @override
  String get notificationFriendShot => '다른 친구의 따라찍기 알림';

  @override
  String get notificationFriendShotCaption => '같은 모임의 친구가 따라찍기를 올렸을 때';

  @override
  String get notificationStarterAssigned => '랜덤 스타터 알림';

  @override
  String get notificationStarterAssignedCaption => '랜덤 스타터 지정됐을 때';

  @override
  String get notificationComment => '댓글 알림';

  @override
  String get notificationCommentCaption => '내 사진에 댓글이 달릴 때';

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
  String get profileAccountManage => '계정 관리';

  @override
  String get profileErrorUserNotFound => '사용자를 찾을 수 없어요.';

  @override
  String get profileLoadFailed => '프로필 정보를 불러오지 못했어요.';

  @override
  String get profileSectionManage => '관리';

  @override
  String get profileBlockedUsers => '차단한 유저 목록';

  @override
  String get blockedUsersTitle => '차단한 유저';

  @override
  String get blockedUsersEmpty => '차단한 유저가 없어요';

  @override
  String get blockedUsersLoadFailed => '차단 목록을 불러오지 못했어요.';

  @override
  String blockedUsersNicknameDate(String nickname, String date) {
    return '$nickname · $date 차단';
  }

  @override
  String get blockedUsersNotice =>
      '차단한 멤버의 사진은 내 화면에서만 보이지 않습니다.\n상대방에게는 차단 사실이 알려지지 않아요.';

  @override
  String get blockedUsersUnblock => '차단 해제';

  @override
  String blockedUsersUnblockConfirmTitle(String name) {
    return '$name님의 차단을 해제할까요?';
  }

  @override
  String get blockedUsersUnblockConfirmBody => '이 멤버의 사진이 다시 보이게 됩니다.';

  @override
  String get blockedUsersUnblockConfirmAction => '해제하기';

  @override
  String get blockedUsersUnblockedToast => '차단을 해제했어요.';

  @override
  String get blockedUsersUnblockFailed => '차단을 해제하지 못했어요.';

  @override
  String get blockedPhotoPlaceholder => '차단한 멤버의 사진입니다.';

  @override
  String get photoUnderReviewPlaceholder => '신고 접수되어\n검토 중인 사진입니다';

  @override
  String get photoUnderReviewPlaceholderShort => '신고 접수\n검토중';

  @override
  String get blockedCycleTopic => '차단한 멤버의 따라찍기';

  @override
  String get galleryMyCardLabel => '나';

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
  String get profileImageCropTitle => '사진 편집';

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
  String get termsPolicyTitle => '약관 및 정책';

  @override
  String get policyTermsOfService => '서비스 이용 약관';

  @override
  String get policyPrivacy => '개인정보 처리방침';

  @override
  String get policyCommunityGuideline => '운영정책(커뮤니티 가이드)';

  @override
  String get policyYouthProtection => '청소년 보호정책';

  @override
  String get policyLoadFailed => '문서를 불러오지 못했어요.';

  @override
  String get splashTagline => '우리끼리 따라찍기';
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationPayload {

 int? get groupId; String? get groupName;// MEMBER_JOIN 등 참여자 정보가 있는 알림에만 존재.
 String? get actorNickname;// NEW_CYCLE 등 사이클 관련 알림에만 존재.
 int? get cycleId;// 사이클 마감 시각. DEADLINE 알림에서 남은 시간 계산에 사용. 없으면 null.
 DateTime? get deadlineAt;// 서버가 계산한 마감까지 남은 분. DEADLINE 알림에만 존재.
 int? get remainingMinutes;// 알림 아바타에 쓸 이미지 URL. 없으면 null → 기본 아바타.
 String? get imageUrl;// 썸네일(스타터 샷)이 신고 접수로 검토 중인지 여부. (NEW_CYCLE 에만 존재)
 bool get imageUnderReview;// 썸네일을 올린 스타터의 userId. NEW_CYCLE 외에는 null.
 int? get starterUserId;
/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPayloadCopyWith<NotificationPayload> get copyWith => _$NotificationPayloadCopyWithImpl<NotificationPayload>(this as NotificationPayload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPayload&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.actorNickname, actorNickname) || other.actorNickname == actorNickname)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,actorNickname,cycleId,deadlineAt,remainingMinutes,imageUrl,imageUnderReview,starterUserId);

@override
String toString() {
  return 'NotificationPayload(groupId: $groupId, groupName: $groupName, actorNickname: $actorNickname, cycleId: $cycleId, deadlineAt: $deadlineAt, remainingMinutes: $remainingMinutes, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, starterUserId: $starterUserId)';
}


}

/// @nodoc
abstract mixin class $NotificationPayloadCopyWith<$Res>  {
  factory $NotificationPayloadCopyWith(NotificationPayload value, $Res Function(NotificationPayload) _then) = _$NotificationPayloadCopyWithImpl;
@useResult
$Res call({
 int? groupId, String? groupName, String? actorNickname, int? cycleId, DateTime? deadlineAt, int? remainingMinutes, String? imageUrl, bool imageUnderReview, int? starterUserId
});




}
/// @nodoc
class _$NotificationPayloadCopyWithImpl<$Res>
    implements $NotificationPayloadCopyWith<$Res> {
  _$NotificationPayloadCopyWithImpl(this._self, this._then);

  final NotificationPayload _self;
  final $Res Function(NotificationPayload) _then;

/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = freezed,Object? groupName = freezed,Object? actorNickname = freezed,Object? cycleId = freezed,Object? deadlineAt = freezed,Object? remainingMinutes = freezed,Object? imageUrl = freezed,Object? imageUnderReview = null,Object? starterUserId = freezed,}) {
  return _then(_self.copyWith(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,actorNickname: freezed == actorNickname ? _self.actorNickname : actorNickname // ignore: cast_nullable_to_non_nullable
as String?,cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingMinutes: freezed == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: null == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool,starterUserId: freezed == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPayload].
extension NotificationPayloadPatterns on NotificationPayload {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPayload value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPayload():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  DateTime? deadlineAt,  int? remainingMinutes,  String? imageUrl,  bool imageUnderReview,  int? starterUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.deadlineAt,_that.remainingMinutes,_that.imageUrl,_that.imageUnderReview,_that.starterUserId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  DateTime? deadlineAt,  int? remainingMinutes,  String? imageUrl,  bool imageUnderReview,  int? starterUserId)  $default,) {final _that = this;
switch (_that) {
case _NotificationPayload():
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.deadlineAt,_that.remainingMinutes,_that.imageUrl,_that.imageUnderReview,_that.starterUserId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? groupId,  String? groupName,  String? actorNickname,  int? cycleId,  DateTime? deadlineAt,  int? remainingMinutes,  String? imageUrl,  bool imageUnderReview,  int? starterUserId)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPayload() when $default != null:
return $default(_that.groupId,_that.groupName,_that.actorNickname,_that.cycleId,_that.deadlineAt,_that.remainingMinutes,_that.imageUrl,_that.imageUnderReview,_that.starterUserId);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationPayload implements NotificationPayload {
  const _NotificationPayload({required this.groupId, required this.groupName, required this.actorNickname, required this.cycleId, required this.deadlineAt, required this.remainingMinutes, required this.imageUrl, required this.imageUnderReview, required this.starterUserId});
  

@override final  int? groupId;
@override final  String? groupName;
// MEMBER_JOIN 등 참여자 정보가 있는 알림에만 존재.
@override final  String? actorNickname;
// NEW_CYCLE 등 사이클 관련 알림에만 존재.
@override final  int? cycleId;
// 사이클 마감 시각. DEADLINE 알림에서 남은 시간 계산에 사용. 없으면 null.
@override final  DateTime? deadlineAt;
// 서버가 계산한 마감까지 남은 분. DEADLINE 알림에만 존재.
@override final  int? remainingMinutes;
// 알림 아바타에 쓸 이미지 URL. 없으면 null → 기본 아바타.
@override final  String? imageUrl;
// 썸네일(스타터 샷)이 신고 접수로 검토 중인지 여부. (NEW_CYCLE 에만 존재)
@override final  bool imageUnderReview;
// 썸네일을 올린 스타터의 userId. NEW_CYCLE 외에는 null.
@override final  int? starterUserId;

/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPayloadCopyWith<_NotificationPayload> get copyWith => __$NotificationPayloadCopyWithImpl<_NotificationPayload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPayload&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.actorNickname, actorNickname) || other.actorNickname == actorNickname)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUnderReview, imageUnderReview) || other.imageUnderReview == imageUnderReview)&&(identical(other.starterUserId, starterUserId) || other.starterUserId == starterUserId));
}


@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,actorNickname,cycleId,deadlineAt,remainingMinutes,imageUrl,imageUnderReview,starterUserId);

@override
String toString() {
  return 'NotificationPayload(groupId: $groupId, groupName: $groupName, actorNickname: $actorNickname, cycleId: $cycleId, deadlineAt: $deadlineAt, remainingMinutes: $remainingMinutes, imageUrl: $imageUrl, imageUnderReview: $imageUnderReview, starterUserId: $starterUserId)';
}


}

/// @nodoc
abstract mixin class _$NotificationPayloadCopyWith<$Res> implements $NotificationPayloadCopyWith<$Res> {
  factory _$NotificationPayloadCopyWith(_NotificationPayload value, $Res Function(_NotificationPayload) _then) = __$NotificationPayloadCopyWithImpl;
@override @useResult
$Res call({
 int? groupId, String? groupName, String? actorNickname, int? cycleId, DateTime? deadlineAt, int? remainingMinutes, String? imageUrl, bool imageUnderReview, int? starterUserId
});




}
/// @nodoc
class __$NotificationPayloadCopyWithImpl<$Res>
    implements _$NotificationPayloadCopyWith<$Res> {
  __$NotificationPayloadCopyWithImpl(this._self, this._then);

  final _NotificationPayload _self;
  final $Res Function(_NotificationPayload) _then;

/// Create a copy of NotificationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = freezed,Object? groupName = freezed,Object? actorNickname = freezed,Object? cycleId = freezed,Object? deadlineAt = freezed,Object? remainingMinutes = freezed,Object? imageUrl = freezed,Object? imageUnderReview = null,Object? starterUserId = freezed,}) {
  return _then(_NotificationPayload(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,actorNickname: freezed == actorNickname ? _self.actorNickname : actorNickname // ignore: cast_nullable_to_non_nullable
as String?,cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingMinutes: freezed == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUnderReview: null == imageUnderReview ? _self.imageUnderReview : imageUnderReview // ignore: cast_nullable_to_non_nullable
as bool,starterUserId: freezed == starterUserId ? _self.starterUserId : starterUserId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationSettings {

// 전체 알림 허용 여부.
 bool get allowAll;// 따라찍기 알림. (NEW_CYCLE · CYCLE_COMPLETED · DEADLINE)
 bool get followShot;// 다른 친구의 따라찍기 알림.
 bool get friendShot;// 랜덤 스타터 알림. (STARTER_ASSIGNED)
 bool get starterAssigned;// 댓글 알림.
 bool get comment;// 멤버 참여 알림. (MEMBER_JOIN)
 bool get memberJoin;
/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsCopyWith<NotificationSettings> get copyWith => _$NotificationSettingsCopyWithImpl<NotificationSettings>(this as NotificationSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettings&&(identical(other.allowAll, allowAll) || other.allowAll == allowAll)&&(identical(other.followShot, followShot) || other.followShot == followShot)&&(identical(other.friendShot, friendShot) || other.friendShot == friendShot)&&(identical(other.starterAssigned, starterAssigned) || other.starterAssigned == starterAssigned)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.memberJoin, memberJoin) || other.memberJoin == memberJoin));
}


@override
int get hashCode => Object.hash(runtimeType,allowAll,followShot,friendShot,starterAssigned,comment,memberJoin);

@override
String toString() {
  return 'NotificationSettings(allowAll: $allowAll, followShot: $followShot, friendShot: $friendShot, starterAssigned: $starterAssigned, comment: $comment, memberJoin: $memberJoin)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsCopyWith<$Res>  {
  factory $NotificationSettingsCopyWith(NotificationSettings value, $Res Function(NotificationSettings) _then) = _$NotificationSettingsCopyWithImpl;
@useResult
$Res call({
 bool allowAll, bool followShot, bool friendShot, bool starterAssigned, bool comment, bool memberJoin
});




}
/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._self, this._then);

  final NotificationSettings _self;
  final $Res Function(NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allowAll = null,Object? followShot = null,Object? friendShot = null,Object? starterAssigned = null,Object? comment = null,Object? memberJoin = null,}) {
  return _then(_self.copyWith(
allowAll: null == allowAll ? _self.allowAll : allowAll // ignore: cast_nullable_to_non_nullable
as bool,followShot: null == followShot ? _self.followShot : followShot // ignore: cast_nullable_to_non_nullable
as bool,friendShot: null == friendShot ? _self.friendShot : friendShot // ignore: cast_nullable_to_non_nullable
as bool,starterAssigned: null == starterAssigned ? _self.starterAssigned : starterAssigned // ignore: cast_nullable_to_non_nullable
as bool,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as bool,memberJoin: null == memberJoin ? _self.memberJoin : memberJoin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSettings].
extension NotificationSettingsPatterns on NotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allowAll,  bool followShot,  bool friendShot,  bool starterAssigned,  bool comment,  bool memberJoin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.allowAll,_that.followShot,_that.friendShot,_that.starterAssigned,_that.comment,_that.memberJoin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allowAll,  bool followShot,  bool friendShot,  bool starterAssigned,  bool comment,  bool memberJoin)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings():
return $default(_that.allowAll,_that.followShot,_that.friendShot,_that.starterAssigned,_that.comment,_that.memberJoin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allowAll,  bool followShot,  bool friendShot,  bool starterAssigned,  bool comment,  bool memberJoin)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.allowAll,_that.followShot,_that.friendShot,_that.starterAssigned,_that.comment,_that.memberJoin);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationSettings implements NotificationSettings {
  const _NotificationSettings({required this.allowAll, required this.followShot, required this.friendShot, required this.starterAssigned, required this.comment, required this.memberJoin});
  

// 전체 알림 허용 여부.
@override final  bool allowAll;
// 따라찍기 알림. (NEW_CYCLE · CYCLE_COMPLETED · DEADLINE)
@override final  bool followShot;
// 다른 친구의 따라찍기 알림.
@override final  bool friendShot;
// 랜덤 스타터 알림. (STARTER_ASSIGNED)
@override final  bool starterAssigned;
// 댓글 알림.
@override final  bool comment;
// 멤버 참여 알림. (MEMBER_JOIN)
@override final  bool memberJoin;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsCopyWith<_NotificationSettings> get copyWith => __$NotificationSettingsCopyWithImpl<_NotificationSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettings&&(identical(other.allowAll, allowAll) || other.allowAll == allowAll)&&(identical(other.followShot, followShot) || other.followShot == followShot)&&(identical(other.friendShot, friendShot) || other.friendShot == friendShot)&&(identical(other.starterAssigned, starterAssigned) || other.starterAssigned == starterAssigned)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.memberJoin, memberJoin) || other.memberJoin == memberJoin));
}


@override
int get hashCode => Object.hash(runtimeType,allowAll,followShot,friendShot,starterAssigned,comment,memberJoin);

@override
String toString() {
  return 'NotificationSettings(allowAll: $allowAll, followShot: $followShot, friendShot: $friendShot, starterAssigned: $starterAssigned, comment: $comment, memberJoin: $memberJoin)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsCopyWith<$Res> implements $NotificationSettingsCopyWith<$Res> {
  factory _$NotificationSettingsCopyWith(_NotificationSettings value, $Res Function(_NotificationSettings) _then) = __$NotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool allowAll, bool followShot, bool friendShot, bool starterAssigned, bool comment, bool memberJoin
});




}
/// @nodoc
class __$NotificationSettingsCopyWithImpl<$Res>
    implements _$NotificationSettingsCopyWith<$Res> {
  __$NotificationSettingsCopyWithImpl(this._self, this._then);

  final _NotificationSettings _self;
  final $Res Function(_NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allowAll = null,Object? followShot = null,Object? friendShot = null,Object? starterAssigned = null,Object? comment = null,Object? memberJoin = null,}) {
  return _then(_NotificationSettings(
allowAll: null == allowAll ? _self.allowAll : allowAll // ignore: cast_nullable_to_non_nullable
as bool,followShot: null == followShot ? _self.followShot : followShot // ignore: cast_nullable_to_non_nullable
as bool,friendShot: null == friendShot ? _self.friendShot : friendShot // ignore: cast_nullable_to_non_nullable
as bool,starterAssigned: null == starterAssigned ? _self.starterAssigned : starterAssigned // ignore: cast_nullable_to_non_nullable
as bool,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as bool,memberJoin: null == memberJoin ? _self.memberJoin : memberJoin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

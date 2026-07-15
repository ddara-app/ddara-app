// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettingsRequest {

// 전체 알림 허용 여부.
 bool get allowAll;// 활동 관련 알림 설정.
 ActivityNotificationRequest get activity;// 기타 알림 설정.
 EtcNotificationRequest get etc;
/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsRequestCopyWith<NotificationSettingsRequest> get copyWith => _$NotificationSettingsRequestCopyWithImpl<NotificationSettingsRequest>(this as NotificationSettingsRequest, _$identity);

  /// Serializes this NotificationSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettingsRequest&&(identical(other.allowAll, allowAll) || other.allowAll == allowAll)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.etc, etc) || other.etc == etc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowAll,activity,etc);

@override
String toString() {
  return 'NotificationSettingsRequest(allowAll: $allowAll, activity: $activity, etc: $etc)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsRequestCopyWith<$Res>  {
  factory $NotificationSettingsRequestCopyWith(NotificationSettingsRequest value, $Res Function(NotificationSettingsRequest) _then) = _$NotificationSettingsRequestCopyWithImpl;
@useResult
$Res call({
 bool allowAll, ActivityNotificationRequest activity, EtcNotificationRequest etc
});


$ActivityNotificationRequestCopyWith<$Res> get activity;$EtcNotificationRequestCopyWith<$Res> get etc;

}
/// @nodoc
class _$NotificationSettingsRequestCopyWithImpl<$Res>
    implements $NotificationSettingsRequestCopyWith<$Res> {
  _$NotificationSettingsRequestCopyWithImpl(this._self, this._then);

  final NotificationSettingsRequest _self;
  final $Res Function(NotificationSettingsRequest) _then;

/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allowAll = null,Object? activity = null,Object? etc = null,}) {
  return _then(_self.copyWith(
allowAll: null == allowAll ? _self.allowAll : allowAll // ignore: cast_nullable_to_non_nullable
as bool,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityNotificationRequest,etc: null == etc ? _self.etc : etc // ignore: cast_nullable_to_non_nullable
as EtcNotificationRequest,
  ));
}
/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityNotificationRequestCopyWith<$Res> get activity {
  
  return $ActivityNotificationRequestCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EtcNotificationRequestCopyWith<$Res> get etc {
  
  return $EtcNotificationRequestCopyWith<$Res>(_self.etc, (value) {
    return _then(_self.copyWith(etc: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationSettingsRequest].
extension NotificationSettingsRequestPatterns on NotificationSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allowAll,  ActivityNotificationRequest activity,  EtcNotificationRequest etc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettingsRequest() when $default != null:
return $default(_that.allowAll,_that.activity,_that.etc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allowAll,  ActivityNotificationRequest activity,  EtcNotificationRequest etc)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettingsRequest():
return $default(_that.allowAll,_that.activity,_that.etc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allowAll,  ActivityNotificationRequest activity,  EtcNotificationRequest etc)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettingsRequest() when $default != null:
return $default(_that.allowAll,_that.activity,_that.etc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSettingsRequest implements NotificationSettingsRequest {
  const _NotificationSettingsRequest({required this.allowAll, required this.activity, required this.etc});
  factory _NotificationSettingsRequest.fromJson(Map<String, dynamic> json) => _$NotificationSettingsRequestFromJson(json);

// 전체 알림 허용 여부.
@override final  bool allowAll;
// 활동 관련 알림 설정.
@override final  ActivityNotificationRequest activity;
// 기타 알림 설정.
@override final  EtcNotificationRequest etc;

/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsRequestCopyWith<_NotificationSettingsRequest> get copyWith => __$NotificationSettingsRequestCopyWithImpl<_NotificationSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettingsRequest&&(identical(other.allowAll, allowAll) || other.allowAll == allowAll)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.etc, etc) || other.etc == etc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowAll,activity,etc);

@override
String toString() {
  return 'NotificationSettingsRequest(allowAll: $allowAll, activity: $activity, etc: $etc)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsRequestCopyWith<$Res> implements $NotificationSettingsRequestCopyWith<$Res> {
  factory _$NotificationSettingsRequestCopyWith(_NotificationSettingsRequest value, $Res Function(_NotificationSettingsRequest) _then) = __$NotificationSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
 bool allowAll, ActivityNotificationRequest activity, EtcNotificationRequest etc
});


@override $ActivityNotificationRequestCopyWith<$Res> get activity;@override $EtcNotificationRequestCopyWith<$Res> get etc;

}
/// @nodoc
class __$NotificationSettingsRequestCopyWithImpl<$Res>
    implements _$NotificationSettingsRequestCopyWith<$Res> {
  __$NotificationSettingsRequestCopyWithImpl(this._self, this._then);

  final _NotificationSettingsRequest _self;
  final $Res Function(_NotificationSettingsRequest) _then;

/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allowAll = null,Object? activity = null,Object? etc = null,}) {
  return _then(_NotificationSettingsRequest(
allowAll: null == allowAll ? _self.allowAll : allowAll // ignore: cast_nullable_to_non_nullable
as bool,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityNotificationRequest,etc: null == etc ? _self.etc : etc // ignore: cast_nullable_to_non_nullable
as EtcNotificationRequest,
  ));
}

/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityNotificationRequestCopyWith<$Res> get activity {
  
  return $ActivityNotificationRequestCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of NotificationSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EtcNotificationRequestCopyWith<$Res> get etc {
  
  return $EtcNotificationRequestCopyWith<$Res>(_self.etc, (value) {
    return _then(_self.copyWith(etc: value));
  });
}
}


/// @nodoc
mixin _$ActivityNotificationRequest {

// 따라찍기 알림.
 bool get followShot;// 마감 투표 알림.
 bool get deadlineVote;
/// Create a copy of ActivityNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityNotificationRequestCopyWith<ActivityNotificationRequest> get copyWith => _$ActivityNotificationRequestCopyWithImpl<ActivityNotificationRequest>(this as ActivityNotificationRequest, _$identity);

  /// Serializes this ActivityNotificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityNotificationRequest&&(identical(other.followShot, followShot) || other.followShot == followShot)&&(identical(other.deadlineVote, deadlineVote) || other.deadlineVote == deadlineVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followShot,deadlineVote);

@override
String toString() {
  return 'ActivityNotificationRequest(followShot: $followShot, deadlineVote: $deadlineVote)';
}


}

/// @nodoc
abstract mixin class $ActivityNotificationRequestCopyWith<$Res>  {
  factory $ActivityNotificationRequestCopyWith(ActivityNotificationRequest value, $Res Function(ActivityNotificationRequest) _then) = _$ActivityNotificationRequestCopyWithImpl;
@useResult
$Res call({
 bool followShot, bool deadlineVote
});




}
/// @nodoc
class _$ActivityNotificationRequestCopyWithImpl<$Res>
    implements $ActivityNotificationRequestCopyWith<$Res> {
  _$ActivityNotificationRequestCopyWithImpl(this._self, this._then);

  final ActivityNotificationRequest _self;
  final $Res Function(ActivityNotificationRequest) _then;

/// Create a copy of ActivityNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followShot = null,Object? deadlineVote = null,}) {
  return _then(_self.copyWith(
followShot: null == followShot ? _self.followShot : followShot // ignore: cast_nullable_to_non_nullable
as bool,deadlineVote: null == deadlineVote ? _self.deadlineVote : deadlineVote // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityNotificationRequest].
extension ActivityNotificationRequestPatterns on ActivityNotificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityNotificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityNotificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityNotificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _ActivityNotificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityNotificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityNotificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool followShot,  bool deadlineVote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityNotificationRequest() when $default != null:
return $default(_that.followShot,_that.deadlineVote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool followShot,  bool deadlineVote)  $default,) {final _that = this;
switch (_that) {
case _ActivityNotificationRequest():
return $default(_that.followShot,_that.deadlineVote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool followShot,  bool deadlineVote)?  $default,) {final _that = this;
switch (_that) {
case _ActivityNotificationRequest() when $default != null:
return $default(_that.followShot,_that.deadlineVote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityNotificationRequest implements ActivityNotificationRequest {
  const _ActivityNotificationRequest({required this.followShot, required this.deadlineVote});
  factory _ActivityNotificationRequest.fromJson(Map<String, dynamic> json) => _$ActivityNotificationRequestFromJson(json);

// 따라찍기 알림.
@override final  bool followShot;
// 마감 투표 알림.
@override final  bool deadlineVote;

/// Create a copy of ActivityNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityNotificationRequestCopyWith<_ActivityNotificationRequest> get copyWith => __$ActivityNotificationRequestCopyWithImpl<_ActivityNotificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityNotificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityNotificationRequest&&(identical(other.followShot, followShot) || other.followShot == followShot)&&(identical(other.deadlineVote, deadlineVote) || other.deadlineVote == deadlineVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followShot,deadlineVote);

@override
String toString() {
  return 'ActivityNotificationRequest(followShot: $followShot, deadlineVote: $deadlineVote)';
}


}

/// @nodoc
abstract mixin class _$ActivityNotificationRequestCopyWith<$Res> implements $ActivityNotificationRequestCopyWith<$Res> {
  factory _$ActivityNotificationRequestCopyWith(_ActivityNotificationRequest value, $Res Function(_ActivityNotificationRequest) _then) = __$ActivityNotificationRequestCopyWithImpl;
@override @useResult
$Res call({
 bool followShot, bool deadlineVote
});




}
/// @nodoc
class __$ActivityNotificationRequestCopyWithImpl<$Res>
    implements _$ActivityNotificationRequestCopyWith<$Res> {
  __$ActivityNotificationRequestCopyWithImpl(this._self, this._then);

  final _ActivityNotificationRequest _self;
  final $Res Function(_ActivityNotificationRequest) _then;

/// Create a copy of ActivityNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followShot = null,Object? deadlineVote = null,}) {
  return _then(_ActivityNotificationRequest(
followShot: null == followShot ? _self.followShot : followShot // ignore: cast_nullable_to_non_nullable
as bool,deadlineVote: null == deadlineVote ? _self.deadlineVote : deadlineVote // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EtcNotificationRequest {

// 멤버 참여 알림.
 bool get memberJoin;
/// Create a copy of EtcNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtcNotificationRequestCopyWith<EtcNotificationRequest> get copyWith => _$EtcNotificationRequestCopyWithImpl<EtcNotificationRequest>(this as EtcNotificationRequest, _$identity);

  /// Serializes this EtcNotificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtcNotificationRequest&&(identical(other.memberJoin, memberJoin) || other.memberJoin == memberJoin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberJoin);

@override
String toString() {
  return 'EtcNotificationRequest(memberJoin: $memberJoin)';
}


}

/// @nodoc
abstract mixin class $EtcNotificationRequestCopyWith<$Res>  {
  factory $EtcNotificationRequestCopyWith(EtcNotificationRequest value, $Res Function(EtcNotificationRequest) _then) = _$EtcNotificationRequestCopyWithImpl;
@useResult
$Res call({
 bool memberJoin
});




}
/// @nodoc
class _$EtcNotificationRequestCopyWithImpl<$Res>
    implements $EtcNotificationRequestCopyWith<$Res> {
  _$EtcNotificationRequestCopyWithImpl(this._self, this._then);

  final EtcNotificationRequest _self;
  final $Res Function(EtcNotificationRequest) _then;

/// Create a copy of EtcNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberJoin = null,}) {
  return _then(_self.copyWith(
memberJoin: null == memberJoin ? _self.memberJoin : memberJoin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EtcNotificationRequest].
extension EtcNotificationRequestPatterns on EtcNotificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtcNotificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtcNotificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtcNotificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _EtcNotificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtcNotificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EtcNotificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool memberJoin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtcNotificationRequest() when $default != null:
return $default(_that.memberJoin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool memberJoin)  $default,) {final _that = this;
switch (_that) {
case _EtcNotificationRequest():
return $default(_that.memberJoin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool memberJoin)?  $default,) {final _that = this;
switch (_that) {
case _EtcNotificationRequest() when $default != null:
return $default(_that.memberJoin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtcNotificationRequest implements EtcNotificationRequest {
  const _EtcNotificationRequest({required this.memberJoin});
  factory _EtcNotificationRequest.fromJson(Map<String, dynamic> json) => _$EtcNotificationRequestFromJson(json);

// 멤버 참여 알림.
@override final  bool memberJoin;

/// Create a copy of EtcNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtcNotificationRequestCopyWith<_EtcNotificationRequest> get copyWith => __$EtcNotificationRequestCopyWithImpl<_EtcNotificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtcNotificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtcNotificationRequest&&(identical(other.memberJoin, memberJoin) || other.memberJoin == memberJoin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberJoin);

@override
String toString() {
  return 'EtcNotificationRequest(memberJoin: $memberJoin)';
}


}

/// @nodoc
abstract mixin class _$EtcNotificationRequestCopyWith<$Res> implements $EtcNotificationRequestCopyWith<$Res> {
  factory _$EtcNotificationRequestCopyWith(_EtcNotificationRequest value, $Res Function(_EtcNotificationRequest) _then) = __$EtcNotificationRequestCopyWithImpl;
@override @useResult
$Res call({
 bool memberJoin
});




}
/// @nodoc
class __$EtcNotificationRequestCopyWithImpl<$Res>
    implements _$EtcNotificationRequestCopyWith<$Res> {
  __$EtcNotificationRequestCopyWithImpl(this._self, this._then);

  final _EtcNotificationRequest _self;
  final $Res Function(_EtcNotificationRequest) _then;

/// Create a copy of EtcNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberJoin = null,}) {
  return _then(_EtcNotificationRequest(
memberJoin: null == memberJoin ? _self.memberJoin : memberJoin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

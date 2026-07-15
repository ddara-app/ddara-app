// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettingsResponse {

// 전체 알림 허용 여부.
 bool get allowAll;// 활동 관련 알림 설정.
 ActivityNotificationResponse get activity;// 기타 알림 설정.
 EtcNotificationResponse get etc;
/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsResponseCopyWith<NotificationSettingsResponse> get copyWith => _$NotificationSettingsResponseCopyWithImpl<NotificationSettingsResponse>(this as NotificationSettingsResponse, _$identity);

  /// Serializes this NotificationSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettingsResponse&&(identical(other.allowAll, allowAll) || other.allowAll == allowAll)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.etc, etc) || other.etc == etc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowAll,activity,etc);

@override
String toString() {
  return 'NotificationSettingsResponse(allowAll: $allowAll, activity: $activity, etc: $etc)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsResponseCopyWith<$Res>  {
  factory $NotificationSettingsResponseCopyWith(NotificationSettingsResponse value, $Res Function(NotificationSettingsResponse) _then) = _$NotificationSettingsResponseCopyWithImpl;
@useResult
$Res call({
 bool allowAll, ActivityNotificationResponse activity, EtcNotificationResponse etc
});


$ActivityNotificationResponseCopyWith<$Res> get activity;$EtcNotificationResponseCopyWith<$Res> get etc;

}
/// @nodoc
class _$NotificationSettingsResponseCopyWithImpl<$Res>
    implements $NotificationSettingsResponseCopyWith<$Res> {
  _$NotificationSettingsResponseCopyWithImpl(this._self, this._then);

  final NotificationSettingsResponse _self;
  final $Res Function(NotificationSettingsResponse) _then;

/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allowAll = null,Object? activity = null,Object? etc = null,}) {
  return _then(_self.copyWith(
allowAll: null == allowAll ? _self.allowAll : allowAll // ignore: cast_nullable_to_non_nullable
as bool,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityNotificationResponse,etc: null == etc ? _self.etc : etc // ignore: cast_nullable_to_non_nullable
as EtcNotificationResponse,
  ));
}
/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityNotificationResponseCopyWith<$Res> get activity {
  
  return $ActivityNotificationResponseCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EtcNotificationResponseCopyWith<$Res> get etc {
  
  return $EtcNotificationResponseCopyWith<$Res>(_self.etc, (value) {
    return _then(_self.copyWith(etc: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationSettingsResponse].
extension NotificationSettingsResponsePatterns on NotificationSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allowAll,  ActivityNotificationResponse activity,  EtcNotificationResponse etc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allowAll,  ActivityNotificationResponse activity,  EtcNotificationResponse etc)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettingsResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allowAll,  ActivityNotificationResponse activity,  EtcNotificationResponse etc)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettingsResponse() when $default != null:
return $default(_that.allowAll,_that.activity,_that.etc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSettingsResponse implements NotificationSettingsResponse {
  const _NotificationSettingsResponse({required this.allowAll, required this.activity, required this.etc});
  factory _NotificationSettingsResponse.fromJson(Map<String, dynamic> json) => _$NotificationSettingsResponseFromJson(json);

// 전체 알림 허용 여부.
@override final  bool allowAll;
// 활동 관련 알림 설정.
@override final  ActivityNotificationResponse activity;
// 기타 알림 설정.
@override final  EtcNotificationResponse etc;

/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsResponseCopyWith<_NotificationSettingsResponse> get copyWith => __$NotificationSettingsResponseCopyWithImpl<_NotificationSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettingsResponse&&(identical(other.allowAll, allowAll) || other.allowAll == allowAll)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.etc, etc) || other.etc == etc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowAll,activity,etc);

@override
String toString() {
  return 'NotificationSettingsResponse(allowAll: $allowAll, activity: $activity, etc: $etc)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsResponseCopyWith<$Res> implements $NotificationSettingsResponseCopyWith<$Res> {
  factory _$NotificationSettingsResponseCopyWith(_NotificationSettingsResponse value, $Res Function(_NotificationSettingsResponse) _then) = __$NotificationSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool allowAll, ActivityNotificationResponse activity, EtcNotificationResponse etc
});


@override $ActivityNotificationResponseCopyWith<$Res> get activity;@override $EtcNotificationResponseCopyWith<$Res> get etc;

}
/// @nodoc
class __$NotificationSettingsResponseCopyWithImpl<$Res>
    implements _$NotificationSettingsResponseCopyWith<$Res> {
  __$NotificationSettingsResponseCopyWithImpl(this._self, this._then);

  final _NotificationSettingsResponse _self;
  final $Res Function(_NotificationSettingsResponse) _then;

/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allowAll = null,Object? activity = null,Object? etc = null,}) {
  return _then(_NotificationSettingsResponse(
allowAll: null == allowAll ? _self.allowAll : allowAll // ignore: cast_nullable_to_non_nullable
as bool,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityNotificationResponse,etc: null == etc ? _self.etc : etc // ignore: cast_nullable_to_non_nullable
as EtcNotificationResponse,
  ));
}

/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityNotificationResponseCopyWith<$Res> get activity {
  
  return $ActivityNotificationResponseCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of NotificationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EtcNotificationResponseCopyWith<$Res> get etc {
  
  return $EtcNotificationResponseCopyWith<$Res>(_self.etc, (value) {
    return _then(_self.copyWith(etc: value));
  });
}
}


/// @nodoc
mixin _$ActivityNotificationResponse {

// 따라찍기 알림.
 bool get followShot;// 마감 투표 알림.
 bool get deadlineVote;
/// Create a copy of ActivityNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityNotificationResponseCopyWith<ActivityNotificationResponse> get copyWith => _$ActivityNotificationResponseCopyWithImpl<ActivityNotificationResponse>(this as ActivityNotificationResponse, _$identity);

  /// Serializes this ActivityNotificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityNotificationResponse&&(identical(other.followShot, followShot) || other.followShot == followShot)&&(identical(other.deadlineVote, deadlineVote) || other.deadlineVote == deadlineVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followShot,deadlineVote);

@override
String toString() {
  return 'ActivityNotificationResponse(followShot: $followShot, deadlineVote: $deadlineVote)';
}


}

/// @nodoc
abstract mixin class $ActivityNotificationResponseCopyWith<$Res>  {
  factory $ActivityNotificationResponseCopyWith(ActivityNotificationResponse value, $Res Function(ActivityNotificationResponse) _then) = _$ActivityNotificationResponseCopyWithImpl;
@useResult
$Res call({
 bool followShot, bool deadlineVote
});




}
/// @nodoc
class _$ActivityNotificationResponseCopyWithImpl<$Res>
    implements $ActivityNotificationResponseCopyWith<$Res> {
  _$ActivityNotificationResponseCopyWithImpl(this._self, this._then);

  final ActivityNotificationResponse _self;
  final $Res Function(ActivityNotificationResponse) _then;

/// Create a copy of ActivityNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followShot = null,Object? deadlineVote = null,}) {
  return _then(_self.copyWith(
followShot: null == followShot ? _self.followShot : followShot // ignore: cast_nullable_to_non_nullable
as bool,deadlineVote: null == deadlineVote ? _self.deadlineVote : deadlineVote // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityNotificationResponse].
extension ActivityNotificationResponsePatterns on ActivityNotificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityNotificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityNotificationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityNotificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _ActivityNotificationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityNotificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityNotificationResponse() when $default != null:
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
case _ActivityNotificationResponse() when $default != null:
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
case _ActivityNotificationResponse():
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
case _ActivityNotificationResponse() when $default != null:
return $default(_that.followShot,_that.deadlineVote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityNotificationResponse implements ActivityNotificationResponse {
  const _ActivityNotificationResponse({required this.followShot, required this.deadlineVote});
  factory _ActivityNotificationResponse.fromJson(Map<String, dynamic> json) => _$ActivityNotificationResponseFromJson(json);

// 따라찍기 알림.
@override final  bool followShot;
// 마감 투표 알림.
@override final  bool deadlineVote;

/// Create a copy of ActivityNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityNotificationResponseCopyWith<_ActivityNotificationResponse> get copyWith => __$ActivityNotificationResponseCopyWithImpl<_ActivityNotificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityNotificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityNotificationResponse&&(identical(other.followShot, followShot) || other.followShot == followShot)&&(identical(other.deadlineVote, deadlineVote) || other.deadlineVote == deadlineVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followShot,deadlineVote);

@override
String toString() {
  return 'ActivityNotificationResponse(followShot: $followShot, deadlineVote: $deadlineVote)';
}


}

/// @nodoc
abstract mixin class _$ActivityNotificationResponseCopyWith<$Res> implements $ActivityNotificationResponseCopyWith<$Res> {
  factory _$ActivityNotificationResponseCopyWith(_ActivityNotificationResponse value, $Res Function(_ActivityNotificationResponse) _then) = __$ActivityNotificationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool followShot, bool deadlineVote
});




}
/// @nodoc
class __$ActivityNotificationResponseCopyWithImpl<$Res>
    implements _$ActivityNotificationResponseCopyWith<$Res> {
  __$ActivityNotificationResponseCopyWithImpl(this._self, this._then);

  final _ActivityNotificationResponse _self;
  final $Res Function(_ActivityNotificationResponse) _then;

/// Create a copy of ActivityNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followShot = null,Object? deadlineVote = null,}) {
  return _then(_ActivityNotificationResponse(
followShot: null == followShot ? _self.followShot : followShot // ignore: cast_nullable_to_non_nullable
as bool,deadlineVote: null == deadlineVote ? _self.deadlineVote : deadlineVote // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EtcNotificationResponse {

// 멤버 참여 알림.
 bool get memberJoin;
/// Create a copy of EtcNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtcNotificationResponseCopyWith<EtcNotificationResponse> get copyWith => _$EtcNotificationResponseCopyWithImpl<EtcNotificationResponse>(this as EtcNotificationResponse, _$identity);

  /// Serializes this EtcNotificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtcNotificationResponse&&(identical(other.memberJoin, memberJoin) || other.memberJoin == memberJoin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberJoin);

@override
String toString() {
  return 'EtcNotificationResponse(memberJoin: $memberJoin)';
}


}

/// @nodoc
abstract mixin class $EtcNotificationResponseCopyWith<$Res>  {
  factory $EtcNotificationResponseCopyWith(EtcNotificationResponse value, $Res Function(EtcNotificationResponse) _then) = _$EtcNotificationResponseCopyWithImpl;
@useResult
$Res call({
 bool memberJoin
});




}
/// @nodoc
class _$EtcNotificationResponseCopyWithImpl<$Res>
    implements $EtcNotificationResponseCopyWith<$Res> {
  _$EtcNotificationResponseCopyWithImpl(this._self, this._then);

  final EtcNotificationResponse _self;
  final $Res Function(EtcNotificationResponse) _then;

/// Create a copy of EtcNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberJoin = null,}) {
  return _then(_self.copyWith(
memberJoin: null == memberJoin ? _self.memberJoin : memberJoin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EtcNotificationResponse].
extension EtcNotificationResponsePatterns on EtcNotificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtcNotificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtcNotificationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtcNotificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _EtcNotificationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtcNotificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EtcNotificationResponse() when $default != null:
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
case _EtcNotificationResponse() when $default != null:
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
case _EtcNotificationResponse():
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
case _EtcNotificationResponse() when $default != null:
return $default(_that.memberJoin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtcNotificationResponse implements EtcNotificationResponse {
  const _EtcNotificationResponse({required this.memberJoin});
  factory _EtcNotificationResponse.fromJson(Map<String, dynamic> json) => _$EtcNotificationResponseFromJson(json);

// 멤버 참여 알림.
@override final  bool memberJoin;

/// Create a copy of EtcNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtcNotificationResponseCopyWith<_EtcNotificationResponse> get copyWith => __$EtcNotificationResponseCopyWithImpl<_EtcNotificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtcNotificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtcNotificationResponse&&(identical(other.memberJoin, memberJoin) || other.memberJoin == memberJoin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberJoin);

@override
String toString() {
  return 'EtcNotificationResponse(memberJoin: $memberJoin)';
}


}

/// @nodoc
abstract mixin class _$EtcNotificationResponseCopyWith<$Res> implements $EtcNotificationResponseCopyWith<$Res> {
  factory _$EtcNotificationResponseCopyWith(_EtcNotificationResponse value, $Res Function(_EtcNotificationResponse) _then) = __$EtcNotificationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool memberJoin
});




}
/// @nodoc
class __$EtcNotificationResponseCopyWithImpl<$Res>
    implements _$EtcNotificationResponseCopyWith<$Res> {
  __$EtcNotificationResponseCopyWithImpl(this._self, this._then);

  final _EtcNotificationResponse _self;
  final $Res Function(_EtcNotificationResponse) _then;

/// Create a copy of EtcNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberJoin = null,}) {
  return _then(_EtcNotificationResponse(
memberJoin: null == memberJoin ? _self.memberJoin : memberJoin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

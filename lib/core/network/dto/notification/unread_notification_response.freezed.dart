// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unread_notification_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnreadNotificationResponse {

 bool get hasUnread;
/// Create a copy of UnreadNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnreadNotificationResponseCopyWith<UnreadNotificationResponse> get copyWith => _$UnreadNotificationResponseCopyWithImpl<UnreadNotificationResponse>(this as UnreadNotificationResponse, _$identity);

  /// Serializes this UnreadNotificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnreadNotificationResponse&&(identical(other.hasUnread, hasUnread) || other.hasUnread == hasUnread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasUnread);

@override
String toString() {
  return 'UnreadNotificationResponse(hasUnread: $hasUnread)';
}


}

/// @nodoc
abstract mixin class $UnreadNotificationResponseCopyWith<$Res>  {
  factory $UnreadNotificationResponseCopyWith(UnreadNotificationResponse value, $Res Function(UnreadNotificationResponse) _then) = _$UnreadNotificationResponseCopyWithImpl;
@useResult
$Res call({
 bool hasUnread
});




}
/// @nodoc
class _$UnreadNotificationResponseCopyWithImpl<$Res>
    implements $UnreadNotificationResponseCopyWith<$Res> {
  _$UnreadNotificationResponseCopyWithImpl(this._self, this._then);

  final UnreadNotificationResponse _self;
  final $Res Function(UnreadNotificationResponse) _then;

/// Create a copy of UnreadNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasUnread = null,}) {
  return _then(_self.copyWith(
hasUnread: null == hasUnread ? _self.hasUnread : hasUnread // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UnreadNotificationResponse].
extension UnreadNotificationResponsePatterns on UnreadNotificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnreadNotificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnreadNotificationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnreadNotificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _UnreadNotificationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnreadNotificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UnreadNotificationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasUnread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnreadNotificationResponse() when $default != null:
return $default(_that.hasUnread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasUnread)  $default,) {final _that = this;
switch (_that) {
case _UnreadNotificationResponse():
return $default(_that.hasUnread);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasUnread)?  $default,) {final _that = this;
switch (_that) {
case _UnreadNotificationResponse() when $default != null:
return $default(_that.hasUnread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnreadNotificationResponse implements UnreadNotificationResponse {
  const _UnreadNotificationResponse({required this.hasUnread});
  factory _UnreadNotificationResponse.fromJson(Map<String, dynamic> json) => _$UnreadNotificationResponseFromJson(json);

@override final  bool hasUnread;

/// Create a copy of UnreadNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnreadNotificationResponseCopyWith<_UnreadNotificationResponse> get copyWith => __$UnreadNotificationResponseCopyWithImpl<_UnreadNotificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnreadNotificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnreadNotificationResponse&&(identical(other.hasUnread, hasUnread) || other.hasUnread == hasUnread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasUnread);

@override
String toString() {
  return 'UnreadNotificationResponse(hasUnread: $hasUnread)';
}


}

/// @nodoc
abstract mixin class _$UnreadNotificationResponseCopyWith<$Res> implements $UnreadNotificationResponseCopyWith<$Res> {
  factory _$UnreadNotificationResponseCopyWith(_UnreadNotificationResponse value, $Res Function(_UnreadNotificationResponse) _then) = __$UnreadNotificationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool hasUnread
});




}
/// @nodoc
class __$UnreadNotificationResponseCopyWithImpl<$Res>
    implements _$UnreadNotificationResponseCopyWith<$Res> {
  __$UnreadNotificationResponseCopyWithImpl(this._self, this._then);

  final _UnreadNotificationResponse _self;
  final $Res Function(_UnreadNotificationResponse) _then;

/// Create a copy of UnreadNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasUnread = null,}) {
  return _then(_UnreadNotificationResponse(
hasUnread: null == hasUnread ? _self.hasUnread : hasUnread // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

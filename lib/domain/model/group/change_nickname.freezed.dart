// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_nickname.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangeNickName {

 String get nickname;
/// Create a copy of ChangeNickName
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeNickNameCopyWith<ChangeNickName> get copyWith => _$ChangeNickNameCopyWithImpl<ChangeNickName>(this as ChangeNickName, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeNickName&&(identical(other.nickname, nickname) || other.nickname == nickname));
}


@override
int get hashCode => Object.hash(runtimeType,nickname);

@override
String toString() {
  return 'ChangeNickName(nickname: $nickname)';
}


}

/// @nodoc
abstract mixin class $ChangeNickNameCopyWith<$Res>  {
  factory $ChangeNickNameCopyWith(ChangeNickName value, $Res Function(ChangeNickName) _then) = _$ChangeNickNameCopyWithImpl;
@useResult
$Res call({
 String nickname
});




}
/// @nodoc
class _$ChangeNickNameCopyWithImpl<$Res>
    implements $ChangeNickNameCopyWith<$Res> {
  _$ChangeNickNameCopyWithImpl(this._self, this._then);

  final ChangeNickName _self;
  final $Res Function(ChangeNickName) _then;

/// Create a copy of ChangeNickName
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = null,}) {
  return _then(_self.copyWith(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeNickName].
extension ChangeNickNamePatterns on ChangeNickName {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeNickName value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeNickName() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeNickName value)  $default,){
final _that = this;
switch (_that) {
case _ChangeNickName():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeNickName value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeNickName() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nickname)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeNickName() when $default != null:
return $default(_that.nickname);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nickname)  $default,) {final _that = this;
switch (_that) {
case _ChangeNickName():
return $default(_that.nickname);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nickname)?  $default,) {final _that = this;
switch (_that) {
case _ChangeNickName() when $default != null:
return $default(_that.nickname);case _:
  return null;

}
}

}

/// @nodoc


class _ChangeNickName implements ChangeNickName {
  const _ChangeNickName({required this.nickname});
  

@override final  String nickname;

/// Create a copy of ChangeNickName
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeNickNameCopyWith<_ChangeNickName> get copyWith => __$ChangeNickNameCopyWithImpl<_ChangeNickName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeNickName&&(identical(other.nickname, nickname) || other.nickname == nickname));
}


@override
int get hashCode => Object.hash(runtimeType,nickname);

@override
String toString() {
  return 'ChangeNickName(nickname: $nickname)';
}


}

/// @nodoc
abstract mixin class _$ChangeNickNameCopyWith<$Res> implements $ChangeNickNameCopyWith<$Res> {
  factory _$ChangeNickNameCopyWith(_ChangeNickName value, $Res Function(_ChangeNickName) _then) = __$ChangeNickNameCopyWithImpl;
@override @useResult
$Res call({
 String nickname
});




}
/// @nodoc
class __$ChangeNickNameCopyWithImpl<$Res>
    implements _$ChangeNickNameCopyWith<$Res> {
  __$ChangeNickNameCopyWithImpl(this._self, this._then);

  final _ChangeNickName _self;
  final $Res Function(_ChangeNickName) _then;

/// Create a copy of ChangeNickName
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = null,}) {
  return _then(_ChangeNickName(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

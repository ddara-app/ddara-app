// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignUpCommand {

 String get provider; String get accessToken; bool get termsAgreed;
/// Create a copy of SignUpCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpCommandCopyWith<SignUpCommand> get copyWith => _$SignUpCommandCopyWithImpl<SignUpCommand>(this as SignUpCommand, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpCommand&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.termsAgreed, termsAgreed) || other.termsAgreed == termsAgreed));
}


@override
int get hashCode => Object.hash(runtimeType,provider,accessToken,termsAgreed);

@override
String toString() {
  return 'SignUpCommand(provider: $provider, accessToken: $accessToken, termsAgreed: $termsAgreed)';
}


}

/// @nodoc
abstract mixin class $SignUpCommandCopyWith<$Res>  {
  factory $SignUpCommandCopyWith(SignUpCommand value, $Res Function(SignUpCommand) _then) = _$SignUpCommandCopyWithImpl;
@useResult
$Res call({
 String provider, String accessToken, bool termsAgreed
});




}
/// @nodoc
class _$SignUpCommandCopyWithImpl<$Res>
    implements $SignUpCommandCopyWith<$Res> {
  _$SignUpCommandCopyWithImpl(this._self, this._then);

  final SignUpCommand _self;
  final $Res Function(SignUpCommand) _then;

/// Create a copy of SignUpCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? accessToken = null,Object? termsAgreed = null,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,termsAgreed: null == termsAgreed ? _self.termsAgreed : termsAgreed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SignUpCommand].
extension SignUpCommandPatterns on SignUpCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpCommand value)  $default,){
final _that = this;
switch (_that) {
case _SignUpCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpCommand value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String accessToken,  bool termsAgreed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpCommand() when $default != null:
return $default(_that.provider,_that.accessToken,_that.termsAgreed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String accessToken,  bool termsAgreed)  $default,) {final _that = this;
switch (_that) {
case _SignUpCommand():
return $default(_that.provider,_that.accessToken,_that.termsAgreed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String accessToken,  bool termsAgreed)?  $default,) {final _that = this;
switch (_that) {
case _SignUpCommand() when $default != null:
return $default(_that.provider,_that.accessToken,_that.termsAgreed);case _:
  return null;

}
}

}

/// @nodoc


class _SignUpCommand implements SignUpCommand {
  const _SignUpCommand({required this.provider, required this.accessToken, required this.termsAgreed});
  

@override final  String provider;
@override final  String accessToken;
@override final  bool termsAgreed;

/// Create a copy of SignUpCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpCommandCopyWith<_SignUpCommand> get copyWith => __$SignUpCommandCopyWithImpl<_SignUpCommand>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpCommand&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.termsAgreed, termsAgreed) || other.termsAgreed == termsAgreed));
}


@override
int get hashCode => Object.hash(runtimeType,provider,accessToken,termsAgreed);

@override
String toString() {
  return 'SignUpCommand(provider: $provider, accessToken: $accessToken, termsAgreed: $termsAgreed)';
}


}

/// @nodoc
abstract mixin class _$SignUpCommandCopyWith<$Res> implements $SignUpCommandCopyWith<$Res> {
  factory _$SignUpCommandCopyWith(_SignUpCommand value, $Res Function(_SignUpCommand) _then) = __$SignUpCommandCopyWithImpl;
@override @useResult
$Res call({
 String provider, String accessToken, bool termsAgreed
});




}
/// @nodoc
class __$SignUpCommandCopyWithImpl<$Res>
    implements _$SignUpCommandCopyWith<$Res> {
  __$SignUpCommandCopyWithImpl(this._self, this._then);

  final _SignUpCommand _self;
  final $Res Function(_SignUpCommand) _then;

/// Create a copy of SignUpCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? accessToken = null,Object? termsAgreed = null,}) {
  return _then(_SignUpCommand(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,termsAgreed: null == termsAgreed ? _self.termsAgreed : termsAgreed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

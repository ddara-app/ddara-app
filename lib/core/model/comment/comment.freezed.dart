// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Comment {

 int get commentId;// 작성자 userId.
 int get userId;// 작성자 닉네임. (모임 내 닉네임)
 String get nickname;// 작성자 프로필 이미지 URL. 없으면 null.
 String? get profileImageUrl; String? get content;// 신고 접수로 검토 중인 댓글인지 여부. (검토 중인 댓글은 목록에서 숨긴다)
 bool get underReview;// 내가 신고한 댓글인지 여부. (내가 신고한 댓글은 목록에서 숨긴다)
 bool get reportedByMe; DateTime get createdAt;// 수정 시각. 수정된 적 없으면 null.
 DateTime? get updatedAt;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.underReview, underReview) || other.underReview == underReview)&&(identical(other.reportedByMe, reportedByMe) || other.reportedByMe == reportedByMe)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,commentId,userId,nickname,profileImageUrl,content,underReview,reportedByMe,createdAt,updatedAt);

@override
String toString() {
  return 'Comment(commentId: $commentId, userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, content: $content, underReview: $underReview, reportedByMe: $reportedByMe, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 int commentId, int userId, String nickname, String? profileImageUrl, String? content, bool underReview, bool reportedByMe, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? commentId = null,Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? content = freezed,Object? underReview = null,Object? reportedByMe = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,underReview: null == underReview ? _self.underReview : underReview // ignore: cast_nullable_to_non_nullable
as bool,reportedByMe: null == reportedByMe ? _self.reportedByMe : reportedByMe // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int commentId,  int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.commentId,_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int commentId,  int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.commentId,_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int commentId,  int userId,  String nickname,  String? profileImageUrl,  String? content,  bool underReview,  bool reportedByMe,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.commentId,_that.userId,_that.nickname,_that.profileImageUrl,_that.content,_that.underReview,_that.reportedByMe,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Comment implements Comment {
  const _Comment({required this.commentId, required this.userId, required this.nickname, required this.profileImageUrl, required this.content, this.underReview = false, this.reportedByMe = false, required this.createdAt, this.updatedAt});
  

@override final  int commentId;
// 작성자 userId.
@override final  int userId;
// 작성자 닉네임. (모임 내 닉네임)
@override final  String nickname;
// 작성자 프로필 이미지 URL. 없으면 null.
@override final  String? profileImageUrl;
@override final  String? content;
// 신고 접수로 검토 중인 댓글인지 여부. (검토 중인 댓글은 목록에서 숨긴다)
@override@JsonKey() final  bool underReview;
// 내가 신고한 댓글인지 여부. (내가 신고한 댓글은 목록에서 숨긴다)
@override@JsonKey() final  bool reportedByMe;
@override final  DateTime createdAt;
// 수정 시각. 수정된 적 없으면 null.
@override final  DateTime? updatedAt;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.underReview, underReview) || other.underReview == underReview)&&(identical(other.reportedByMe, reportedByMe) || other.reportedByMe == reportedByMe)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,commentId,userId,nickname,profileImageUrl,content,underReview,reportedByMe,createdAt,updatedAt);

@override
String toString() {
  return 'Comment(commentId: $commentId, userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, content: $content, underReview: $underReview, reportedByMe: $reportedByMe, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 int commentId, int userId, String nickname, String? profileImageUrl, String? content, bool underReview, bool reportedByMe, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? commentId = null,Object? userId = null,Object? nickname = null,Object? profileImageUrl = freezed,Object? content = freezed,Object? underReview = null,Object? reportedByMe = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Comment(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,underReview: null == underReview ? _self.underReview : underReview // ignore: cast_nullable_to_non_nullable
as bool,reportedByMe: null == reportedByMe ? _self.reportedByMe : reportedByMe // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

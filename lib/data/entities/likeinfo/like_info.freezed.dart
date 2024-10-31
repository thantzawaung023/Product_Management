// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LikeInfo _$LikeInfoFromJson(Map<String, dynamic> json) {
  return _LikeInfo.fromJson(json);
}

/// @nodoc
mixin _$LikeInfo {
  String get userId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get likeAt => throw _privateConstructorUsedError;

  /// Serializes this LikeInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LikeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LikeInfoCopyWith<LikeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeInfoCopyWith<$Res> {
  factory $LikeInfoCopyWith(LikeInfo value, $Res Function(LikeInfo) then) =
      _$LikeInfoCopyWithImpl<$Res, LikeInfo>;
  @useResult
  $Res call({String userId, @TimestampConverter() DateTime likeAt});
}

/// @nodoc
class _$LikeInfoCopyWithImpl<$Res, $Val extends LikeInfo>
    implements $LikeInfoCopyWith<$Res> {
  _$LikeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LikeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? likeAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      likeAt: null == likeAt
          ? _value.likeAt
          : likeAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LikeInfoImplCopyWith<$Res>
    implements $LikeInfoCopyWith<$Res> {
  factory _$$LikeInfoImplCopyWith(
          _$LikeInfoImpl value, $Res Function(_$LikeInfoImpl) then) =
      __$$LikeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, @TimestampConverter() DateTime likeAt});
}

/// @nodoc
class __$$LikeInfoImplCopyWithImpl<$Res>
    extends _$LikeInfoCopyWithImpl<$Res, _$LikeInfoImpl>
    implements _$$LikeInfoImplCopyWith<$Res> {
  __$$LikeInfoImplCopyWithImpl(
      _$LikeInfoImpl _value, $Res Function(_$LikeInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LikeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? likeAt = null,
  }) {
    return _then(_$LikeInfoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      likeAt: null == likeAt
          ? _value.likeAt
          : likeAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LikeInfoImpl implements _LikeInfo {
  _$LikeInfoImpl(
      {required this.userId, @TimestampConverter() required this.likeAt});

  factory _$LikeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LikeInfoImplFromJson(json);

  @override
  final String userId;
  @override
  @TimestampConverter()
  final DateTime likeAt;

  @override
  String toString() {
    return 'LikeInfo(userId: $userId, likeAt: $likeAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikeInfoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.likeAt, likeAt) || other.likeAt == likeAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, likeAt);

  /// Create a copy of LikeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LikeInfoImplCopyWith<_$LikeInfoImpl> get copyWith =>
      __$$LikeInfoImplCopyWithImpl<_$LikeInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LikeInfoImplToJson(
      this,
    );
  }
}

abstract class _LikeInfo implements LikeInfo {
  factory _LikeInfo(
      {required final String userId,
      @TimestampConverter() required final DateTime likeAt}) = _$LikeInfoImpl;

  factory _LikeInfo.fromJson(Map<String, dynamic> json) =
      _$LikeInfoImpl.fromJson;

  @override
  String get userId;
  @override
  @TimestampConverter()
  DateTime get likeAt;

  /// Create a copy of LikeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LikeInfoImplCopyWith<_$LikeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

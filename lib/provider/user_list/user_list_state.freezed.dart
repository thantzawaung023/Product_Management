// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserListState {
  List<User> get userList => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  dynamic get errorMsg => throw _privateConstructorUsedError;

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserListStateCopyWith<UserListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserListStateCopyWith<$Res> {
  factory $UserListStateCopyWith(
          UserListState value, $Res Function(UserListState) then) =
      _$UserListStateCopyWithImpl<$Res, UserListState>;
  @useResult
  $Res call({List<User> userList, bool isLoading, dynamic errorMsg});
}

/// @nodoc
class _$UserListStateCopyWithImpl<$Res, $Val extends UserListState>
    implements $UserListStateCopyWith<$Res> {
  _$UserListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userList = null,
    Object? isLoading = null,
    Object? errorMsg = freezed,
  }) {
    return _then(_value.copyWith(
      userList: null == userList
          ? _value.userList
          : userList // ignore: cast_nullable_to_non_nullable
              as List<User>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMsg: freezed == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserListStateImplCopyWith<$Res>
    implements $UserListStateCopyWith<$Res> {
  factory _$$UserListStateImplCopyWith(
          _$UserListStateImpl value, $Res Function(_$UserListStateImpl) then) =
      __$$UserListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<User> userList, bool isLoading, dynamic errorMsg});
}

/// @nodoc
class __$$UserListStateImplCopyWithImpl<$Res>
    extends _$UserListStateCopyWithImpl<$Res, _$UserListStateImpl>
    implements _$$UserListStateImplCopyWith<$Res> {
  __$$UserListStateImplCopyWithImpl(
      _$UserListStateImpl _value, $Res Function(_$UserListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userList = null,
    Object? isLoading = null,
    Object? errorMsg = freezed,
  }) {
    return _then(_$UserListStateImpl(
      userList: null == userList
          ? _value._userList
          : userList // ignore: cast_nullable_to_non_nullable
              as List<User>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMsg: freezed == errorMsg ? _value.errorMsg! : errorMsg,
    ));
  }
}

/// @nodoc

class _$UserListStateImpl implements _UserListState {
  const _$UserListStateImpl(
      {final List<User> userList = const <User>[],
      this.isLoading = true,
      this.errorMsg = ''})
      : _userList = userList;

  final List<User> _userList;
  @override
  @JsonKey()
  List<User> get userList {
    if (_userList is EqualUnmodifiableListView) return _userList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userList);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final dynamic errorMsg;

  @override
  String toString() {
    return 'UserListState(userList: $userList, isLoading: $isLoading, errorMsg: $errorMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserListStateImpl &&
            const DeepCollectionEquality().equals(other._userList, _userList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.errorMsg, errorMsg));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_userList),
      isLoading,
      const DeepCollectionEquality().hash(errorMsg));

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserListStateImplCopyWith<_$UserListStateImpl> get copyWith =>
      __$$UserListStateImplCopyWithImpl<_$UserListStateImpl>(this, _$identity);
}

abstract class _UserListState implements UserListState {
  const factory _UserListState(
      {final List<User> userList,
      final bool isLoading,
      final dynamic errorMsg}) = _$UserListStateImpl;

  @override
  List<User> get userList;
  @override
  bool get isLoading;
  @override
  dynamic get errorMsg;

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserListStateImplCopyWith<_$UserListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

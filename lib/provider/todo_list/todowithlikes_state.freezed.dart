// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todowithlikes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TodoWithLikesState {
  Todo get todo => throw _privateConstructorUsedError;
  List<User> get likedUsers => throw _privateConstructorUsedError;

  /// Create a copy of TodoWithLikesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoWithLikesStateCopyWith<TodoWithLikesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoWithLikesStateCopyWith<$Res> {
  factory $TodoWithLikesStateCopyWith(
          TodoWithLikesState value, $Res Function(TodoWithLikesState) then) =
      _$TodoWithLikesStateCopyWithImpl<$Res, TodoWithLikesState>;
  @useResult
  $Res call({Todo todo, List<User> likedUsers});

  $TodoCopyWith<$Res> get todo;
}

/// @nodoc
class _$TodoWithLikesStateCopyWithImpl<$Res, $Val extends TodoWithLikesState>
    implements $TodoWithLikesStateCopyWith<$Res> {
  _$TodoWithLikesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoWithLikesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todo = null,
    Object? likedUsers = null,
  }) {
    return _then(_value.copyWith(
      todo: null == todo
          ? _value.todo
          : todo // ignore: cast_nullable_to_non_nullable
              as Todo,
      likedUsers: null == likedUsers
          ? _value.likedUsers
          : likedUsers // ignore: cast_nullable_to_non_nullable
              as List<User>,
    ) as $Val);
  }

  /// Create a copy of TodoWithLikesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TodoCopyWith<$Res> get todo {
    return $TodoCopyWith<$Res>(_value.todo, (value) {
      return _then(_value.copyWith(todo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TodoWithLikesStateImplCopyWith<$Res>
    implements $TodoWithLikesStateCopyWith<$Res> {
  factory _$$TodoWithLikesStateImplCopyWith(_$TodoWithLikesStateImpl value,
          $Res Function(_$TodoWithLikesStateImpl) then) =
      __$$TodoWithLikesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Todo todo, List<User> likedUsers});

  @override
  $TodoCopyWith<$Res> get todo;
}

/// @nodoc
class __$$TodoWithLikesStateImplCopyWithImpl<$Res>
    extends _$TodoWithLikesStateCopyWithImpl<$Res, _$TodoWithLikesStateImpl>
    implements _$$TodoWithLikesStateImplCopyWith<$Res> {
  __$$TodoWithLikesStateImplCopyWithImpl(_$TodoWithLikesStateImpl _value,
      $Res Function(_$TodoWithLikesStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodoWithLikesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todo = null,
    Object? likedUsers = null,
  }) {
    return _then(_$TodoWithLikesStateImpl(
      todo: null == todo
          ? _value.todo
          : todo // ignore: cast_nullable_to_non_nullable
              as Todo,
      likedUsers: null == likedUsers
          ? _value._likedUsers
          : likedUsers // ignore: cast_nullable_to_non_nullable
              as List<User>,
    ));
  }
}

/// @nodoc

class _$TodoWithLikesStateImpl implements _TodoWithLikesState {
  const _$TodoWithLikesStateImpl(
      {required this.todo, required final List<User> likedUsers})
      : _likedUsers = likedUsers;

  @override
  final Todo todo;
  final List<User> _likedUsers;
  @override
  List<User> get likedUsers {
    if (_likedUsers is EqualUnmodifiableListView) return _likedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likedUsers);
  }

  @override
  String toString() {
    return 'TodoWithLikesState(todo: $todo, likedUsers: $likedUsers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoWithLikesStateImpl &&
            (identical(other.todo, todo) || other.todo == todo) &&
            const DeepCollectionEquality()
                .equals(other._likedUsers, _likedUsers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, todo, const DeepCollectionEquality().hash(_likedUsers));

  /// Create a copy of TodoWithLikesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoWithLikesStateImplCopyWith<_$TodoWithLikesStateImpl> get copyWith =>
      __$$TodoWithLikesStateImplCopyWithImpl<_$TodoWithLikesStateImpl>(
          this, _$identity);
}

abstract class _TodoWithLikesState implements TodoWithLikesState {
  const factory _TodoWithLikesState(
      {required final Todo todo,
      required final List<User> likedUsers}) = _$TodoWithLikesStateImpl;

  @override
  Todo get todo;
  @override
  List<User> get likedUsers;

  /// Create a copy of TodoWithLikesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoWithLikesStateImplCopyWith<_$TodoWithLikesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/data/entities/user/user.dart';

part 'todowithlikes_state.freezed.dart';

@freezed
class TodoWithLikesState with _$TodoWithLikesState {
  const factory TodoWithLikesState({
    required Todo todo,
    required List<User> likedUsers,
  }) = _TodoWithLikesState;
}

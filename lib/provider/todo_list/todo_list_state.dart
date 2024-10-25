import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/data/entities/todo/todo.dart';

part 'todo_list_state.freezed.dart';

@freezed
class TodoListState with _$TodoListState {
  const factory TodoListState({
    @Default(<Todo>[]) List<Todo> todoList,
    @Default(true) bool isLoading,
    @Default('') errorMsg,
  }) = _TodoListState;
}

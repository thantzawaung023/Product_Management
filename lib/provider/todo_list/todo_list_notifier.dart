import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/provider/todo_list/todo_list_state.dart';
import 'package:product_management/repository/todo_repo.dart';

final getTopTodoProvider = StreamProvider<List<Todo?>>((ref) {
  final todoRepository = ref.watch(todoRepositoryProvider);
  return todoRepository.getTopTodo();
});

final getMyTodoProvider = StreamProvider<List<Todo?>>((ref) {
  final todoRepository = ref.watch(todoRepositoryProvider);
  return todoRepository.getMyTodoList();
});

final getRecentLikesProvider = StreamProvider<List<Todo?>>((ref) {
  final todoRepository = ref.watch(todoRepositoryProvider);
  return todoRepository.getRecentLikePostList();
});

final todoListNotifierProvider =
    StateNotifierProvider.autoDispose<TodosNotifier, TodoListState>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return TodosNotifier(repo);
});

class TodosNotifier extends StateNotifier<TodoListState> {
  TodosNotifier(this._todoRepository) : super(const TodoListState()) {
    _initialize();
  }

  final BaseTodoRepository _todoRepository;
  List<Todo>? _todoList;

  @override
  void dispose() {
    // Clean up any resources if necessary
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      state = state.copyWith(isLoading: true); // Start loading
      final todoStream = _todoRepository.fetchTodoList();

      final List<Todo> todoList = [];
      await for (final todos in todoStream) {
        _todoList = todoList;
        if (mounted) {
          todoList.clear();
          todoList.addAll(todos);
          state = state.copyWith(
            todoList: List.from(todoList),
            isLoading: false,
            errorMsg: '',
          );
        }
      }
    } on Exception catch (e) {
      logger.e(e);
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMsg: '$e',
        );
      }
      rethrow;
    }
  }

  Future<void> deleteTodoByUser(String email) async {
    try {
      state = state.copyWith(isLoading: true);
      await _todoRepository.deleteTodoListByUser(email);
      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      state = state.copyWith(isLoading: true);
      await _todoRepository.deleteTodoList(id);
      state = state.copyWith(isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  void updateLikes(
      String todoId, int newLikesCount, List<String> likedByUsers) {
    try {
      _todoRepository.updateLikes(todoId, newLikesCount, likedByUsers);
    } on Exception catch (e) {
      logger.e('Error during TodoPost Like : $e');
      rethrow;
    }
  }
}

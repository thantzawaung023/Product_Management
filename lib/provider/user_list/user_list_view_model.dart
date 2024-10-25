import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/user_list/user_list_state.dart';
import 'package:product_management/repository/user_repo.dart';

final userListViewModelNotifierProvider =
    StateNotifierProvider.autoDispose<UserListViewModel, UserListState>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserListViewModel(repo);
});

// State Notifier
class UserListViewModel extends StateNotifier<UserListState> {
  UserListViewModel(this._userRepository) : super(const UserListState()) {
    _initialize();
  }

  final BaseUserRepository _userRepository;
  List<User>? _originalUserList;

  @override
  void dispose() {
    // Clean up any resources if necessary
    super.dispose();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true); // Start loading

    try {
      // Fetch users using a stream
      final usersStream = _userRepository.fetchUserList();

      // Collect all user lists into a flat list
      final List<User> users = [];
      // Listen to the user stream
      await for (final userList in usersStream) {
        // Update state to reflect the new user list
        _originalUserList = users;
        if (mounted) {
          users.clear();
          users.addAll(userList);
          state = state.copyWith(
            userList: List.from(users),
            isLoading: false,
            errorMsg: '',
          );
        }
      }
      if (mounted) {
        state = state.copyWith(
          userList: List.from(users),
          isLoading: false,
          errorMsg: '',
        );
      }
    } on auth.FirebaseException catch (error) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMsg: '${error.message}',
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMsg: 'An unexpected error occurred: $e',
        );
      }
    }
  }

  // Search users based on query
  void searchUsers(String query) {
    final originalList = _originalUserList ?? [];

    // Filter users based on the search query
    final filteredUsers = originalList.where((user) {
      final lowerCaseQuery = query.toLowerCase();
      return user.email.toLowerCase().contains(lowerCaseQuery) ||
          user.name.toLowerCase().contains(lowerCaseQuery) ||
          user.address!.name.toLowerCase().contains(lowerCaseQuery);
    }).toList();

    state = state.copyWith(userList: filteredUsers);
  }

  Future<void> deleteUsers(Set<String> users) async {
    state = state.copyWith(isLoading: true);
    try {
      await _userRepository.deleteMultiUsers(users);
      state = state.copyWith(isLoading: false);
    } on auth.FirebaseException catch (error) {
      // Handle Firebase-specific exceptions
      state = state.copyWith(
        isLoading: false,
        errorMsg: '${error.message}',
      );
    } catch (e) {
      // Handle generic exceptions
      state = state.copyWith(
        isLoading: false,
        errorMsg: e.toString(), 
      );
    }
  }

}

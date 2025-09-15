import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/data/entities/user/user.dart';

part 'user_list_state.freezed.dart';

@freezed
class UserListState with _$UserListState {
  const factory UserListState({
    @Default(<User>[]) List<User> userList,
    @Default(true) bool isLoading,
    @Default('') errorMsg,
  }) = _UserListState;
}

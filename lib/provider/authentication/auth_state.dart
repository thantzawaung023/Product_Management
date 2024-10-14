import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/data/entities/user/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    @Default(true) bool isLoading,
    @Default('') String errorMsg,
    @Default(false) bool isSuccess,
    @Default(false) bool isEmailSent,
  }) = _AuthState;
}

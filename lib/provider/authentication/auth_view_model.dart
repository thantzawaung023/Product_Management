import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/address/address.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/authentication/auth_state.dart';
import 'package:product_management/repository/user_repo.dart';
import 'package:product_management/utils/storage/provider_setting.dart';

//Stream Provider For Auth User
final authUserStreamProvider = StreamProvider.autoDispose<auth.User?>((ref) {
  return ref.watch(userRepositoryProvider).authUserStream();
});

// State Notifier Provider
final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthStateNotifier, AuthState>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return AuthStateNotifier(repo);
});

// State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._userRepository) : super(const AuthState());

  final BaseUserRepository _userRepository;

  auth.User? user;

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepository.signIn(email, password);
      // Save provider type in local settings
      await CurrentProviderSetting().update(providerId: 'password');
      // Ensure email is verified
      if (user!.emailVerified) {
        await _userRepository.singOut();
        throw auth.FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email before signing in.',
        );
      }

      final userToSave = User(
        id: user.uid,
        name: user.displayName!,
        email: user.email!,
        password: '',
        profile: user.photoURL ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        user: userToSave,
        isLoading: false,
        isSuccess: true, // Indicate login success
      );
    } on auth.FirebaseAuthException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMsg: error.message ?? 'Error signing in',
        isSuccess: false,
      );
    } catch (e) {
      state = state.copyWith(errorMsg: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> singInWithGoogleAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepository.singInWithGoogleAccount();
      if (user != null) {
        final userToSave = User(
          id: user.uid,
          name: user.displayName!,
          email: user.email!,
          password: '',
          profile: user.photoURL ?? '',
          address: Address(name: '', location: ''),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        state = state.copyWith(
          user: userToSave,
          isLoading: false,
          isSuccess: true, // Indicate login success
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMsg: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithGitHub() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepository.signInWithGitHub();
      if (user != null) {
        final userToSave = User(
          id: user.uid,
          name: user.displayName!,
          email: user.email!,
          password: '',
          profile: user.photoURL ?? '',
          address: Address(name: '', location: ''),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        state = state.copyWith(
          user: userToSave,
          isLoading: false,
          isSuccess: true, // Indicate login success
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMsg: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _userRepository.singOut();
    state = state.copyWith(isLoading: false, errorMsg: 'Logout Success');
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final userToSave = User(
        id: _userRepository.generateNewId,
        name: name,
        email: email,
        password: password,
        profile: '',
        address: Address(name: '', location: ''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.register(userToSave);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future<void> sendVerificationEmail() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = _userRepository.getCurrentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        state = state.copyWith(isEmailSent: true);
      }
    } catch (e) {
      state = state.copyWith(errorMsg: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      auth.User? user = _userRepository.getCurrentUser;
      await user?.reload();
      user = _userRepository.getCurrentUser;
      if (user != null && user.emailVerified) {
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMsg: e.toString());
      return false;
    }
  }

  Future<void> getUserFuture({required String authUserId}) async {
    final user = await _userRepository.getUserFuture(userId: authUserId);

    if (user == null) {
      await _userRepository.create(authUserId);
      final newUser = await _userRepository.getUserFuture(userId: authUserId);
      state = state.copyWith(user: newUser);
    } else {
      await _userRepository.updateProvider(user);
      state = state.copyWith(user: user);
    }
  }
}

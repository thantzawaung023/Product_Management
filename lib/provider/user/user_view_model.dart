import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/address/address.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/user/user_state.dart';
import 'package:product_management/repository/user_repo.dart';

//Stream Provider
final userProviderStream = StreamProvider.family<User?, String>((ref, userId) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUserStream(userId: userId);
});

final getUserProvider = StreamProvider.autoDispose.family<User, String>(
  (ref, id) => ref.watch(userRepositoryProvider).getUser(userId: id),
);

// State Notifier Provider
final userViewModelNotifierProvider = StateNotifierProvider.autoDispose
    .family<UserViewModel, UserState, User?>((ref, user) {
  final repo = ref.watch(userRepositoryProvider);
  return UserViewModel(user, repo);
});

// State Notifier
class UserViewModel extends StateNotifier<UserState> {
  UserViewModel(this.user, this._userRepository)
      : super(
          UserState(
            id: user?.id ?? '',
            name: user?.name ?? '',
            email: user?.email ?? '',
            profile: user?.profile ?? '',
            address: user?.address ?? Address(name: '', location: ''),
            createdAt: user?.createdAt,
            updatedAt: user?.updatedAt,
          ),
        );

  final BaseUserRepository _userRepository;
  User? user;

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setProfileUrl(String url) {
    state = state.copyWith(profile: url);
  }

  void setAddressName(String name) {
    state = state.copyWith(address: state.address!.copyWith(name: name));
  }

  void setAddressLocation(String location) {
    state =
        state.copyWith(address: state.address!.copyWith(location: location));
  }

  void setImageData(Uint8List data) {
    state = state.copyWith(imageData: data);
  }

  // upload Profile
  Future<void> uploadProfile({required String oldProfileUrl}) async {
    try {
      if (oldProfileUrl.isNotEmpty) {
        await _userRepository.deleteFromStorage(oldProfileUrl);
      }
      final url = await _userRepository.uploadProfile(
        picture: state.imageData!,
        type: 'jpg',
      );
      setProfileUrl(url);
      if (state.profile != null || state.profile!.isNotEmpty) {
        await _userRepository.updateProfileUrl(
            userId: state.id!, profileUrl: state.profile!);
      }
    } catch (_) {
      rethrow;
    }
  }

  // delete Profile
  Future<void> deleteProfile() async {
    try {
      if (state.profile != null || state.profile!.isNotEmpty) {
        await _userRepository.deleteFromStorage(state.profile!);
        await _userRepository.deleteProfileUrl(userId: state.id!);
        if (mounted) {
          state = state.copyWith(
            profile: '',
          );
        }
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> register() async {
    try {
      final userToSave = User(
        id: state.id!.isEmpty ? _userRepository.generateNewId : state.id!,
        name: state.name.trim(),
        email: state.email.trim(),
        password: state.password,
        profile: state.profile ?? '',
        address: state.address ?? Address(name: '', location: ''),
        createdAt: state.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.register(userToSave);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateUser() async {
    if (state.imageData != null) {
      if (state.profile != null || state.profile!.isNotEmpty) {
        await _userRepository.deleteFromStorage(state.profile!);
      }
      final url = await _userRepository.uploadProfile(
          picture: state.imageData!, type: 'jpg');
      setProfileUrl(url);
    }
    try {
      final userToSave = User(
        id: state.id!.isEmpty ? _userRepository.generateNewId : state.id!,
        name: state.name.trim(),
        email: state.email.trim(),
        password: state.password,
        profile: state.profile ?? '',
        address: state.address ?? Address(name: '', location: ''),
        createdAt: state.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.updateUser(userToSave);
    } on Exception catch (error) {
      logger.e('Error during upsert: $error');
      rethrow;
    }
  }

  Future<void> deleteUsers(Set<String> users) async {
    try {
      await _userRepository.deleteUser(users);
    } catch (error) {
      logger.e('Error during delete: $error');
      throw Exception('Failed to delete user: $error');
    }
  }

  // Stream<UserEntity?> getUser(String id) {
  //   try {
  //     return _userRepository.getUser(id);
  //   } on Exception catch (error) {
  //     logger.e('Error during delete: $error');
  //     throw Exception('Failed to delete user: $error');
  //   }
  // }

  Future<Uint8List?> imageData() async {
    try {
      // Pick image from gallery
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      // Check if an image was picked
      if (image == null) {
        return null; // User canceled the picker
      }

      // Determine the MIME type of the image
      final mimeType = lookupMimeType(image.name);

      // Ensure it's an image file
      if (mimeType == null || mimeType.split('/')[0] != 'image') {
        return null;
      }

      // Read image as bytes
      return await image.readAsBytes();
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null; // Return null in case of an error
    }
  }

  Future<void> updateUsername() async {
    if (state.id!.isEmpty || state.name.isEmpty) return;
    try {
      await _userRepository.updateUsername(
          userId: state.id!, newUsername: state.name.trim());
      if (mounted) {
        state = state.copyWith(
          name: state.name,
        );
        logger.d('Username updated successfully');
      }
    } catch (error) {
      logger.e('Error updating username: $error');
      rethrow;
    }
  }

  Future<void> updateAddress() async {
    if (state.id!.isEmpty || state.address == null) return;
    try {
      final updatedAddress = state.address!;
      await _userRepository.updateUserAddress(
        userId: state.id!,
        addressName: updatedAddress.name.trim(),
        addressLocation: updatedAddress.location.trim(),
      );
      if (mounted) {
        state = state.copyWith(
          address: updatedAddress,
        );
        logger.d('Address updated successfully');
      }
    } catch (error) {
      logger.e('Error updating address: $error');
      rethrow;
    }
  }
}

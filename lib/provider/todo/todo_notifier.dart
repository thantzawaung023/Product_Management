import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:product_management/provider/todo/todo_state.dart';
import 'package:product_management/repository/todo_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:geocoding/geocoding.dart';

final todoNotifierProvider = StateNotifierProvider.autoDispose
    .family<TodoNotifier, TodoState, Todo?>((ref, todo) {
  final repo = ref.watch(todoRepositoryProvider);
  return TodoNotifier(todo, repo);
});

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier(this.todo, this._todoRepository)
      : super(TodoState(
          id: todo?.id ?? '',
          title: todo?.title ?? '',
          description: todo?.description ?? '',
          image: todo?.image ?? '',
          isPublish: todo?.isPublish ?? true,
          createdAt: todo?.createdAt,
          updatedAt: todo?.updatedAt,
          location: todo?.location,
          latitude: todo?.latitude,
          longitude: todo?.longitude,
        ));

  final BaseTodoRepository _todoRepository;
  Todo? todo;

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setIsPublish(bool isPublish) {
    state = state.copyWith(isPublish: isPublish);
  }

  void setImageUrl(String url) {
    state = state.copyWith(image: url);
  }

  void setImageData(Uint8List data) {
    state = state.copyWith(imageData: data);
  }

  void setLatitude(String latitude) {
    state = state.copyWith(latitude: latitude);
  }

  void setLongitude(String longitude) {
    state = state.copyWith(longitude: longitude);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

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

  Future<void> createToDoPost() async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (state.imageData != null) {
        final url = await _todoRepository.uploadImage(
            picture: state.imageData!, type: 'jpg');
        setImageUrl(url);
      }

      final todo = Todo(
        id: state.id!.isEmpty ? _todoRepository.generateNewId : state.id!,
        title: state.title,
        description: state.description,
        isPublish: state.isPublish,
        image: state.image ?? '',
        likesCount: state.likesCount,
        likedByUsers: state.likedByUsers,
        createdBy: user?.email ?? 'Unknown',
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        latitude: state.latitude ?? '',
        longitude: state.longitude ?? '',
        location: state.location ?? '',
      );
      await _todoRepository.createToDoPost(todo);
    } on Exception catch (e) {
      logger.e('Error during TodoPost Create : $e');
      rethrow;
    }
  }

  Future<void> updateToDoPost() async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (state.imageData != null) {
        if (state.image != null) {
          // await _todoRepository.deleteFromStorage(state.image!);
        }
        final url = await _todoRepository.uploadImage(
            picture: state.imageData!, type: 'jpg');
        setImageUrl(url);
      }

      final todo = Todo(
        id: state.id!.isEmpty ? _todoRepository.generateNewId : state.id!,
        title: state.title.trim(),
        description: state.description.trim(),
        isPublish: state.isPublish,
        image: state.image ?? '',
        likesCount: state.likesCount,
        likedByUsers: state.likedByUsers,
        createdBy: user?.email ?? 'Unknown',
        updatedAt: DateTime.now(),
        createdAt: state.createdAt ?? DateTime.now(),
        latitude: state.latitude ?? '',
        longitude: state.longitude ?? '',
        location: state.location ?? '',
      );
      await _todoRepository.updateTodo(todo);
    } on Exception catch (e) {
      logger.e('Error during TodoPost Create : $e');
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

  Future<String?> getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            (place.thoroughfare != null && place.thoroughfare != '')
                ? '${place.name}, ${place.thoroughfare}'
                : '${place.name}';
        address +=
            (place.subLocality != null && place.subLocality != '') != null
                ? ', ${place.subLocality}'
                : '';
        address += (place.street != null && place.street != '')
            ? ', ${place.street}'
            : '';
        address += (place.locality != null && place.locality != '')
            ? ', ${place.locality}'
            : '';
        address +=
            (place.administrativeArea != null && place.administrativeArea != '')
                ? ', ${place.administrativeArea}'
                : '';
        address += (place.country != null && place.country != '')
            ? ', ${place.country}'
            : '';

        return address;
      }
    } catch (e) {
      logger.e("Error during reverse geocoding: $e");
    }
    return null;
  }
}

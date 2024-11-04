import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/todo/todo.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseTodoRepository {
  String get generateNewId;
  Future<String> uploadImage(
      {required Uint8List picture, required String type});
  Future<void> createToDoPost(Todo todo);
  Stream<List<Todo>> fetchTodoList();
  Future<void> deleteTodoListByUser(String email);
  Future<void> deleteTodoList(String id);
  Future<void> updateTodo(Todo todo);
  Future<void> updateLikes(id, newLikesCount, likedByUsers);
  Stream<List<Todo?>> getTopTodo();
  Stream<List<Todo?>> getMyTodoList();
  Stream<List<Todo?>> getRecentLikePostList();
  Future<void> deleteFromStorage(String url);
}

// Provider
final todoRepositoryProvider = Provider<TodoRepositoryImpl>(
  (ref) => TodoRepositoryImpl(),
);

class TodoRepositoryImpl implements BaseTodoRepository {
  final _dbTodo = FirebaseFirestore.instance.collection('todo');
  final _storage = FirebaseStorage.instance;

  @override
  String get generateNewId => _dbTodo.doc().id;

  @override
  Future<String> uploadImage(
      {required Uint8List picture, required String type}) async {
    try {
      final pictureId = const Uuid().v4();
      final storageRef = _storage.ref().child('todoImages/$pictureId.$type');
      await storageRef.putData(picture);
      return storageRef.getDownloadURL();
    } on Exception catch (e) {
      throw 'Image Upload Error: $e';
    }
  }

  @override
  Future<void> createToDoPost(Todo todo) async {
    try {
      await _dbTodo.doc(todo.id).set(todo.toJson());
    } on Exception catch (e) {
      logger.e('Error creating todo post: $e');
      throw Exception('Failed to create todo post: $e');
    }
  }

  @override
  Stream<List<Todo>> fetchTodoList() {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;

      final snapshotData = _dbTodo
          .where(
            Filter.or(
              Filter("createdBy", isEqualTo: user!.email),
              Filter("isPublish", isEqualTo: true),
            ),
          )
          .orderBy('createdAt', descending: true)
          .snapshots();

      return snapshotData.map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Todo.fromJson(data);
        }).toList();
      });
    } on Exception catch (e) {
      logger.e('Error fetching user list: $e');
      return Stream.error('$e');
    }
  }

  @override
  Future<void> deleteTodoListByUser(String email) async {
    try {
      // Query to find all todo items created by the user with the specified email
      final todoItemsSnapshot =
          await _dbTodo.where('createdBy', isEqualTo: email).get();

      // Check if any todo items were found
      if (todoItemsSnapshot.docs.isEmpty) {
        logger.i('No Todo items found for email: $email');
        return; // No items to delete, exit the method
      }

      // Loop through the documents and delete each one
      for (final doc in todoItemsSnapshot.docs) {
        // Assuming 'doc' is a DocumentSnapshot, you can get the data directly
        var todo = Todo.fromJson(doc.data()); // Get the data from the snapshot
        // Check if the image URL is not empty before attempting deletion
        if (todo.image != null && todo.image!.isNotEmpty) {
          await deleteFromStorage(todo.image!);
          logger.i('Deleted image for Todo item: ${doc.id} for email: $email');
        }

        await doc.reference.delete(); // Delete the document
        logger.i('Deleted Todo item: ${doc.id} for email: $email');
      }

      logger.i(
          'Successfully deleted ${todoItemsSnapshot.docs.length} Todo items for email: $email');
    } catch (error) {
      logger.e('Error deleting TodoList for email $email: $error');
      rethrow; // Rethrow the error for further handling if needed
    }
  }

  @override
  Future<void> deleteTodoList(String id) async {
    try {
      // Fetch the document snapshot
      final doc = await _dbTodo.doc(id).get();

      // Check if the document exists
      if (!doc.exists) {
        logger.i('Todo item with id: $id does not exist.');
        return; // Exit the method if the document does not exist
      }

      // Convert the document data to a Todo object
      var todo = Todo.fromJson(
          doc.data()!); // Assuming doc.data() is not null due to exists check

      // Check if there is an image to delete
      if (todo.image != null && todo.image!.isNotEmpty) {
        await deleteFromStorage(todo.image!); // Delete the image from storage
        logger.i('Deleted image for Todo item: ${doc.id}'); // Corrected logging
      }

      // Delete the document itself
      await _dbTodo.doc(id).delete();
      logger.i('Deleted Todo item: ${doc.id}');
    } catch (error) {
      logger.e('Error deleting TodoList: $error');
      rethrow; // Rethrow the error for further handling if needed
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      await _dbTodo.doc(todo.id).set(todo.toJson());
    } catch (error) {
      logger.e('Error updating todo: $error');
      throw Exception('Failed to update todo: $error');
    }
  }

  @override
  Future<void> updateLikes(id, newLikesCount, likedByUsers) async {
    try {
      await _dbTodo.doc(id).update({
        'likesCount': newLikesCount,
        'likedByUsers': likedByUsers,
      });
    } on Exception catch (e) {
      logger.e('Error updating todo: $e');
      throw Exception('Failed to Like todo: $e');
    }
  }

  @override
  Stream<List<Todo?>> getTopTodo() {
    try {
      final snapshotData = _dbTodo // Use your collection name
          .where('isPublish', isEqualTo: true) // Filter where isPublish is true
          .orderBy('likesCount',
              descending: true) // Order by likesCount descending
          .limit(5) // Limit the result to 5
          .snapshots();

      return snapshotData.map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Todo.fromJson(data);
        }).toList();
      });
    } on Exception catch (e) {
      logger.e('Error get Top Todo List: $e');
      return Stream.error('$e');
    }
  }

  @override
  Stream<List<Todo?>> getMyTodoList() {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      final snapshotData = _dbTodo // Use your collection name
          .where('createdBy',
              isEqualTo: user!.email) // Filter where isPublish is true
          .orderBy('createdAt',
              descending: true) // Order by likesCount descending
          .limit(5) // Limit the result to 5
          .snapshots();

      return snapshotData.map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Todo.fromJson(data);
        }).toList();
      });
    } on Exception catch (e) {
      logger.e('Error get My Todo List: $e');
      return Stream.error('$e');
    }
  }

  @override
  Future<void> deleteFromStorage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } on Exception catch (e) {
      logger.e('Error delete todo image: $e');
      throw Exception('Failed to delete todo image: $e');
    }
  }

  @override
  Stream<List<Todo?>> getRecentLikePostList() {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      final snapshotData = _dbTodo // Use your collection name
          .where('likedByUsers', arrayContains: user!.uid)
          .orderBy('createdAt',
              descending: true) // Order by likesCount descending
          .limit(10) // Limit the result to 5
          .snapshots();

      return snapshotData.map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Todo.fromJson(data);
        }).toList();
      });
    } on Exception catch (e) {
      logger.e('Error get My Todo List: $e');
      return Stream.error('$e');
    }
  }
}

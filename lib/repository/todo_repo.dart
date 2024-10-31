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
  Future<void> deleteTodoList(String id) async {
    try {
      await _dbTodo.doc(id).delete();
    } catch (error) {
      logger.e('Error deleting TodoList: $error');
      rethrow;
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

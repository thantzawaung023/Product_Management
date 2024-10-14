import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/address/address.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/data/entities/user_provider_data/user_provider_data.dart';
import 'package:product_management/utils/storage/provider_setting.dart';
import 'package:uuid/uuid.dart';

// User Base Class
abstract class BaseUserRepository {
  Stream<auth.User?> authUserStream();
  Future<User?> getUserFuture({required String userId});
  Stream<User?> getUserStream({required String userId});
  Future<void> updateProvider(User user);
  Future<void> create(String authUserId);
  String get generateNewId;
  auth.User? get getCurrentUser;
  Future<auth.User?> signIn(String email, String password);
  Future<auth.User?> singInWithGoogleAccount();
  Future<auth.User?> signInWithGitHub();
  Future<void> register(User user);
  Future<void> sendEmailVerification();
  Stream<List<User>> fetchUserList();
  Future<void> singOut();
  Future<void> deleteUser(Set<String> users);
  Stream<User> getUser({required String userId});
  Future<void> updateUser(User user);
  Future<String> uploadProfile(
      {required Uint8List picture, required String type});
  Future<void> updateProfileUrl({
    required String userId,
    required String profileUrl,
  });
  Future<void> deleteProfileUrl({
    required String userId,
  });
  Future<void> deleteFromStorage(String url);
  Future<void> updateUsername(
      {required String userId, required String newUsername});
  Future<void> updateUserAddress({
    required String userId,
    required String addressName,
    required String addressLocation,
  });
}

// Provider
final userRepositoryProvider = Provider<UserRepositoryImpl>(
  (ref) => UserRepositoryImpl(),
);

// User Repository
class UserRepositoryImpl implements BaseUserRepository {
  final _auth = auth.FirebaseAuth.instance;
  final _dbUser = FirebaseFirestore.instance.collection('user');
  final _storage = FirebaseStorage.instance;
  final _googleSingIn = GoogleSignIn();

  @override
  String get generateNewId => _dbUser.doc().id;

  @override
  auth.User? get getCurrentUser => _auth.currentUser;

  @override
  Stream<User?> getUserStream({required String userId}) {
    return _dbUser.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return User.fromJson(doc.data()!);
      } else {
        return null;
      }
    });
  }

  @override
  Future<auth.User?> signIn(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on auth.FirebaseAuthException catch (error) {
      String customMessage;
      switch (error.code) {
        case 'invalid-email':
          customMessage =
              'The email address is not valid. Please enter a valid email.';
          break;
        case 'user-not-found':
          customMessage =
              'No user found with this email. Please sign up first.';
          break;
        case 'wrong-password':
          customMessage = 'The password is incorrect. Please try again.';
          break;
        default:
          customMessage = error.message ?? 'Error signing in';
          break;
      }
      logger.e('Error fetching users: $error');
      return Future.error(customMessage);
    }
  }

  @override
  Future<void> register(User user) async {
    try {
      // Create a new user in Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      await userCredential.user!.updateDisplayName(user.name);

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Save provider type in local settings
      await CurrentProviderSetting().update(providerId: 'password');
      // Sign out after successful sign-up(to email verification)
      // await singOut();

      // Check if user creation was successful
      // if (userCredential.user != null) {
      //   // Store the user data in Firestore using the UID as the document ID
      //   User updatedUserEntity =
      //       userEntity.copyWith(id: userCredential.user!.uid);

      //   try {
      //     // Add user data to Firestore
      //     await _dbUser
      //         .doc(userCredential.user!.uid)
      //         .set(updatedUserEntity.toJson());
      //   } catch (firestoreError) {
      //     // Rollback if Firestore transaction fails
      //     await userCredential.user!
      //         .delete(); // Delete user from Firebase Authentication
      //     return Future.error(
      //         'Failed to store user data in Firestore. Rolling back registration.');
      //   }
      // }
    } on auth.FirebaseAuthException catch (error) {
      // Step 6: Handle FirebaseAuth-specific errors
      logger.e('Error registering user: $error');
      if (error.code == 'email-already-in-use') {
        return Future.error('This email is already in use.');
      } else if (error.code == 'weak-password') {
        return Future.error('The password provided is too weak.');
      }
      return Future.error('Registration failed: ${error.message}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    auth.User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _dbUser.doc(user.id).set(user.toJson());
    } on auth.FirebaseAuthException catch (error) {
      logger.e('Error updating user: $error');
      throw Exception('Failed to update user: ${error.message}');
    }
  }

  @override
  Future<void> singOut() async {
    try {
      final providerId = await CurrentProviderSetting().get() ?? '';
      if (providerId.contains('google')) {
        await GoogleSignIn().signOut();
      }
      await _auth.signOut();
    } catch (e) {
      logger.e('⚡ ERROR in signOut: $e');
      rethrow;
    }
  }

  @override
  Stream<List<User>> fetchUserList() {
    try {
      final snapshotData =
          _dbUser.orderBy('createdAt', descending: true).snapshots();

      return snapshotData.map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return User.fromJson(data);
        }).toList();
      });
    } on FirebaseException catch (error) {
      logger.e('Error fetching user list: $error');
      return Stream.error('${error.message}');
    }
  }

  @override
  Future<void> deleteUser(Set<String> users) async {
    if (users.isEmpty) {
      logger.e('No user IDs provided for deletion');
      throw Exception('No user IDs provided for deletion');
    }

    // Start a transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // First, read all documents to check if they exist
      List<DocumentReference> existingUserRefs = [];
      for (String userId in users) {
        DocumentReference userRef = _dbUser.doc(userId);
        final userDocSnapshot = await transaction.get(userRef); // Read first
        if (userDocSnapshot.exists) {
          existingUserRefs
              .add(userRef); // Collect the references of existing users
        } else {
          logger.e('User document with ID $userId does not exist.');
          throw Exception('User document with ID $userId does not exist.');
        }
      }

      // Then, perform all the delete operations
      for (var userRef in existingUserRefs) {
        transaction.delete(userRef); // Write (delete) after all reads are done
      }
    }).then((_) {
      logger.e('Selected users deleted successfully');
    }).catchError((error) {
      logger.e('Failed to delete selected users: $error');
      throw error;
    });
  }

  @override
  Stream<User> getUser({required String userId}) {
    return _dbUser.doc(userId).snapshots().handleError((dynamic error) {
      if (error is FirebaseException) {
        throw Exception('Error retrieving user data from Firebase.');
      } else {
        throw Exception('An unknown error occurred.');
      }
    }).map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return User.fromJson(snapshot.data()!);
      } else {
        throw Exception('User with ID "$userId" not found.');
      }
    });
  }

  @override
  Future<String> uploadProfile(
      {required Uint8List picture, required String type}) async {
    try {
      final pictureId = const Uuid().v4();
      final storageRef = _storage.ref().child('profiles/$pictureId.$type');
      await storageRef.putData(picture);
      return storageRef.getDownloadURL();
    } on Exception catch (error) {
      throw 'Profile Update Error : $error';
    }
  }

  @override
  Future<void> updateProfileUrl({
    required String userId,
    required String profileUrl,
  }) async {
    try {
      await _dbUser.doc(userId).update({
        'profile': profileUrl,
        'updatedAt': DateTime.now(),
      });
      logger.d('Profile URL updated successfully');
    } catch (e) {
      logger.e('⚡ ERROR updating profile URL: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProfileUrl({
    required String userId,
  }) async {
    try {
      await _dbUser.doc(userId).update({
        'profile': '',
        'updatedAt': DateTime.now(),
      });
      logger.d('Profile URL updated successfully');
    } catch (e) {
      logger.e('⚡ ERROR updating profile URL: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFromStorage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {
      return;
    }
  }

  @override
  Future<auth.User?> singInWithGoogleAccount() async {
    try {
      //interactive singin process
      GoogleSignInAccount? googleUser = await _googleSingIn.signIn();
      //obtain auth detail form request
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      //Create new Credentail for user
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      auth.UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      auth.User? user = userCredential.user;
      if (user != null) {
        // final userToSave = User(
        //   id: generateNewId,
        //   name: user.displayName!,
        //   email: user.email!,
        //   password: '',
        //   profile: user.photoURL,
        //   address: Address(name: '', location: ''),
        //   createdAt: DateTime.now(),
        //   updatedAt: DateTime.now(),
        // );
        await CurrentProviderSetting().update(
          providerId: 'google.com',
        );
        // try {
        //   // Add user data to Firestore
        //   await _dbUser.doc(userCredential.user!.uid).set(userToSave.toJson());
        // } catch (firestoreError) {
        //   // Rollback if Firestore transaction fails
        //   await userCredential.user!
        //       .delete(); // Delete user from Firebase Authentication
        //   return Future.error(
        //       'Failed to store user data in Firestore. Rolling back registration.');
        // }
      }

      return user;
    } catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  @override
  Future<auth.User?> signInWithGitHub() async {
    try {
      auth.GithubAuthProvider githubProvider = auth.GithubAuthProvider();
      auth.UserCredential userCredential =
          await _auth.signInWithProvider(githubProvider);
      auth.User? user = userCredential.user;
      if (user != null) {
        // final userToSave = User(
        //   id: generateNewId,
        //   name: user.displayName!,
        //   email: user.email!,
        //   password: '',
        //   profile: user.photoURL,
        //   address: Address(name: '', location: ''),
        //   createdAt: DateTime.now(),
        //   updatedAt: DateTime.now(),
        // );
        await CurrentProviderSetting().update(
          providerId: 'github.com',
        );
        // try {
        //   // Add user data to Firestore
        //   await _dbUser.doc(userCredential.user!.uid).set(userToSave.toJson());
        // } catch (firestoreError) {
        //   // Rollback if Firestore transaction fails
        //   await userCredential.user!
        //       .delete(); // Delete user from Firebase Authentication
        //   return Future.error(
        //       'Failed to store user data in Firestore. Rolling back registration.');
        // }
      }

      return user;
    } catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  @override
  Stream<auth.User?> authUserStream() => _auth.authStateChanges();

  @override
  Future<User?> getUserFuture({required String userId}) async {
    final doc = await _dbUser.doc(userId).get();
    if (doc.exists) {
      return User.fromJson(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<void> create(String authUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;
    final userProviderData = UserProviderData(
      userName: currentUser.displayName ?? '',
      email: currentUser.email!,
      providerType: currentUser.providerData.first.providerId == 'password'
          ? 'email/password'
          : currentUser.providerData.first.providerId,
      uid: currentUser.providerData.first.uid!,
    );

    final newUser = User(
      id: authUserId,
      name: currentUser.displayName!,
      email: currentUser.email!,
      password: '',
      profile: '',
      address: Address(name: '', location: ''),
      providerData: [userProviderData],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbUser.doc(authUserId).set(newUser.toJson());
  }

  @override
  Future<void> updateProvider(User user) async {
    final currentUser = _auth.currentUser!;
    final providerType = currentUser.providerData.first.providerId;
    final providerList = user.providerData ?? [];

    final providerExists = providerList.any((provider) =>
        provider.providerType ==
        (providerType == 'password' ? 'email/password' : providerType));

    if (!providerExists) {
      final newProviderData = UserProviderData(
          userName: currentUser.displayName ?? '',
          email: currentUser.email!,
          providerType:
              providerType == 'password' ? 'email/password' : providerType,
          uid: currentUser.providerData.first.uid!,
          photoUrl: currentUser.photoURL ?? '');

      final updatedUser = user.copyWith(
        providerData: [...providerList, newProviderData],
        updatedAt: DateTime.now(),
      );
      await _dbUser.doc(user.id).set(updatedUser.toJson());
    }
  }

  @override
  Future<void> updateUsername({
    required String userId,
    required String newUsername,
  }) async {
    try {
      final userDoc = await _dbUser.doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> providerDataList = userData['providerData'] ?? [];

      if (providerDataList.isNotEmpty) {
        providerDataList[0]['userName'] = newUsername;
      }

      await _dbUser.doc(userId).update({
        'name': newUsername,
        'providerData': providerDataList,
        'updatedAt': DateTime.now(),
      });
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(newUsername);
      }
    } catch (e) {
      logger.e('⚡ ERROR updating username: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserAddress({
    required String userId,
    required String addressName,
    required String addressLocation,
  }) async {
    try {
      await _dbUser.doc(userId).update({
        'address.name': addressName,
        'address.location': addressLocation,
        'updatedAt': DateTime.now(),
      });
      logger.d('Address updated successfully');
    } catch (e) {
      logger.e('⚡ ERROR updating address: $e');
      rethrow;
    }
  }
}

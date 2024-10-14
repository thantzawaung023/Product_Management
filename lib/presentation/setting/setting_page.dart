import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/presentation/login/login_page.dart';
import 'package:product_management/presentation/setting/widgets/change_password.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/widgets/common_dialog.dart';


class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProviderStream(userId));
    final currentUser = auth.FirebaseAuth.instance.currentUser;

    // Function for logging out the user
    Future<void> logOut() async {
      try {
        final authNotifier = ref.watch(authNotifierProvider.notifier);
        authNotifier.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        showSnackBar(context, 'Logout failed: ${e.toString()}');
      }
    }

    // Function for changing password
    Future<void> changePassword() async {
      // final userNotifier = ref.read(userViewModelNotifierProvider(user).notifier);
      // await showChangePasswordDialog(context, userNotifier);
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.grey.shade400,
        actions: const [],
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null || currentUser == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text('Change Password'),
                  onTap: (){}
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: logOut,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}

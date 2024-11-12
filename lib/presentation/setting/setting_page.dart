import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/presentation/login/login_page.dart';
import 'package:product_management/presentation/setting/widgets/change_password.dart';
import 'package:product_management/presentation/setting/widgets/language_dropdwon.dart';
import 'package:product_management/provider/Them/them_provider.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/todo_list/todo_list_notifier.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/utils/storage/provider_setting.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref
        .watch(userProviderStream(userId)); // Watch user data based on userId
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    final passwordInputController = useTextEditingController();
    final isLightMode = ref.watch(themeProvider) == ThemeMode.light;
    final providerId = useState<String?>('');
    final supportedLocales = {
      const Locale('en'): AppLocalizations.of(context)!.languageEnglish,
      const Locale('my'): AppLocalizations.of(context)!.languageMyanmar,
    };

    // Fetch the providerId when the widget builds
    useEffect(() {
      Future<void> fetchProviderId() async {
        providerId.value = await CurrentProviderSetting().get();
      }

      fetchProviderId();
      return null;
    }, []);

    Future<void> accountDelete(User user) async {
      final authStateNotifier = ref.watch(authNotifierProvider.notifier);
      final todoListStateNotifier = ref.watch(todoListNotifierProvider.notifier);
      await accountDeleteConfirmationDialog(
        context: context,
        title: AppLocalizations.of(context)!.deleteAccount,
        message: AppLocalizations.of(context)!.deleteAccountMessage,
        password: providerId.value == 'password',
        passwordController: passwordInputController,
        okFunction: () async {
          try {
            ref.watch(loadingProvider.notifier).update((state) => true);

            // Perform Todo Post Deletion
            await todoListStateNotifier.deleteTodoByUser(user.email);
            // Perform account deletion
            await authStateNotifier.deleteAccount(
                password: passwordInputController.text,
                profileUrl: user.profile ?? '');

            // After successful deletion, navigate to login
            if (!context.mounted) return;

            // Use addPostFrameCallback to navigate after the build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Remove all previous routes from the stack
              );
            });
          } on Exception catch (e) {
            logger.e("Delete Error: $e");
            if (!context.mounted) return;
            showSnackBar(context, e.getMessage, Colors.red);
          }
        },
        okButton: AppLocalizations.of(context)!.deleteNow,
        cancelButton: AppLocalizations.of(context)!.cancel,
      );
    }

    // Function for logging out the user
    Future<void> logOut() async {
      // Show confirmation dialog
      final shouldDelete = await showConfirmDialog(
        context: context,
        message: AppLocalizations.of(context)!.confirmLogout,
      );
      if (shouldDelete == true) {
        try {
          final authNotifier = ref.watch(authNotifierProvider.notifier);
          await authNotifier.signOut();
          if (context.mounted) {
            // Ensure you await the sign out
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        } catch (e) {
          if (context.mounted) {
            showSnackBar(context, 'Logout failed: ${e.toString()}', Colors.red);
          }
        }
      }
    }

    // Function for changing password
    Future<void> changePassword(User user) async {
      final userNotifier = ref.read(userViewModelNotifierProvider(user)
          .notifier); // Use the user parameter
      await showChangePasswordDialog(context, userNotifier);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
        actions: const [],
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null || currentUser == null) {
            // Redirect to login if user is null or currentUser is null
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
            return const SizedBox
                .shrink(); // Return an empty widget while waiting
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.password),
                    title: Text(AppLocalizations.of(context)!.changePassword),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                    iconColor: Colors.white,
                    onTap: () =>
                        changePassword(user), // Call changePassword with user
                  ),
                ),
                const Divider(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor),
                  child: SwitchListTile(
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey[600],
                    secondary: const SizedBox(
                      width: 40,
                      height: 80,
                      child: Icon(
                        Icons.light_mode,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Light Mode',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                    value: isLightMode,
                    onChanged: (value) {
                      ref.watch(themeProvider.notifier).state =
                          value ? ThemeMode.light : ThemeMode.dark;
                    },
                    // Call changePassword with user
                  ),
                ),
                const Divider(),
                LanguageDropdownTile(
                  supportedLocales: supportedLocales,
                  ref: ref,
                ),
                const Divider(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor),
                  child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: Text(AppLocalizations.of(context)!.deleteAccount),
                      titleTextStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      iconColor: Colors.red,
                      onTap: () {
                        accountDelete(user);
                      }),
                ),
                const Divider(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(AppLocalizations.of(context)!.logout),
                    titleTextStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    iconColor: Colors.red,
                    onTap: logOut,
                  ),
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

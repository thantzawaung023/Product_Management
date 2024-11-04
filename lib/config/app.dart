import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/navigator.dart';
import 'package:product_management/l10n/l10n.dart';
import 'package:product_management/presentation/login/login_page.dart';
import 'package:product_management/provider/Them/them_provider.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/language/language_provider.dart';
import 'package:product_management/them/them.dart';
import 'package:product_management/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserStream = ref.watch(authUserStreamProvider);
    final authStateNotifier = ref.watch(authNotifierProvider.notifier);
    final selectedLocale = ref.watch(languageProvider);
    final themeMode = ref.watch(themeProvider);

    // Add a loading state to track the async call status
    final isUserDataLoaded = useState(false);

    return MaterialApp(
      title: Messages.titleMsg,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: selectedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: authUserStream.when(
        data: (user) {
          if (user != null && user.emailVerified) {
            // Using useEffect to fetch user data asynchronously
            useEffect(() {
              // Define an async function inside the effect
              Future<void> fetchUserData() async {
                await authStateNotifier.getUserFuture(authUserId: user.uid);
                isUserDataLoaded.value = true; // Update loading state when done
              }

              // Call fetchUserData and don't await to keep it non-blocking
              fetchUserData();
              return null;
            }, [user]); // Re-run if the user changes

            // Render AppNavigator only when user data is loaded
            return isUserDataLoaded.value
                ? AppNavigator(userId: user.uid)
                : const Center(child: CircularProgressIndicator());
          } else {
            return const LoginPage();
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Something went wrong!')),
      ),
    );
  }
}

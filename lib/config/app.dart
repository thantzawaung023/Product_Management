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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserStream = ref.watch(authUserStreamProvider);
    final authStateNotifier = ref.watch(authNotifierProvider.notifier);
    final selectedLocale = ref.watch(languageProvider);
    final themeMode = ref.watch(themeProvider);

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
            useEffect(() {
              authStateNotifier.getUserFuture(authUserId: user.uid);
              return null;
            }, [user]);
            return HomePage(
              userId: user.uid,
            );
          } else {
            return const LoginPage();
          }
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) =>
            const Center(child: Text('Something is Wrong!')),
      ),
    );
  }
}

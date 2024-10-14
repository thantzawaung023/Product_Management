import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/navigator.dart';
import 'package:product_management/presentation/login/login_page.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/utils/utils.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserStream = ref.watch(authUserStreamProvider);
    final authStateNotifier = ref.watch(authNotifierProvider.notifier);

    return MaterialApp(
      title: Messages.titleMsg,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
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

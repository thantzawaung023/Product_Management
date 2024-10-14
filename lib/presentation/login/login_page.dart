import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/navigator.dart';
import 'package:product_management/presentation/login/widgets/square_tile.dart';
import 'package:product_management/presentation/register/register_page.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/widgets/widgets.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModelNotifier = ref.watch(authNotifierProvider.notifier);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    login() async {
      if (formKey.currentState!.validate()) {
        ref.watch(loadingProvider.notifier).update((state) => true);
        try {
          await authViewModelNotifier.signIn(
            emailController.text,
            passwordController.text,
          );
          if (!context.mounted) return;

          final authUser = FirebaseAuth.instance.currentUser;
          // bool isVerified = await authViewModelNotifier.checkEmailVerified();
          if (authUser != null) {
            Navigator.of(context).pushAndRemoveUntil<void>(
              MaterialPageRoute(
                builder: (context) => HomePage(userId: authUser.uid),
              ),
              (route) => false,
            );
          }
          ref.watch(loadingProvider.notifier).update((state) => false);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.lock,
                    size: 150,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Email Text Box
                  CustomTextField(controller: emailController, label: 'Email'),
                  const SizedBox(
                    height: 20,
                  ),

                  // Password Text Box
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    obscured: true,
                  ),
                  const SizedBox(height: 20),

                  // Login Btn
                  CustomButton(
                    label: 'Login',
                    onPressed: login,
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.6,
                        color: Colors.grey[400],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.6,
                        color: Colors.grey[400],
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        onTap: () async {
                          try {
                            await authViewModelNotifier
                                .singInWithGoogleAccount()
                                .whenComplete(() {
                              if (!context.mounted) return;

                              final authUser =
                                  FirebaseAuth.instance.currentUser;

                              if (authUser != null) {
                                Navigator.of(context).pushAndRemoveUntil<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(userId: authUser.uid),
                                  ),
                                  (route) => false,
                                );
                              }
                            });
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        imagePath: 'assets/images/google.png',
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SquareTile(
                        onTap: () async {
                          try {
                            await authViewModelNotifier
                                .signInWithGitHub()
                                .whenComplete(() {
                              if (!context.mounted) return;

                              final authUser =
                                  FirebaseAuth.instance.currentUser;

                              if (authUser != null) {
                                Navigator.of(context).pushAndRemoveUntil<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(userId: authUser.uid),
                                  ),
                                  (route) => false,
                                );
                              }
                            });
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        imagePath: 'assets/images/github-black.png',
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      }
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

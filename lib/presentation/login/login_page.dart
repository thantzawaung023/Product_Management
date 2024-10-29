import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/navigator.dart';
import 'package:product_management/presentation/forget_password/forget_password_page.dart';
import 'package:product_management/presentation/login/widgets/square_tile.dart';
import 'package:product_management/presentation/register/register_page.dart';
import 'package:product_management/presentation/varification/verification_page.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizaton = AppLocalizations.of(context)!;
    final authViewModelNotifier = ref.watch(authNotifierProvider.notifier);
    final emailController =
        useTextEditingController(); // Using hook for controller
    final passwordController =
        useTextEditingController(); // Using hook for controller
    final formKey = useMemoized(() => GlobalKey<FormState>());

    login() async {
      if (formKey.currentState!.validate()) {
        ref.read(loadingProvider.notifier).update((state) => true);
        try {
          await authViewModelNotifier.signIn(
            emailController.text,
            passwordController.text,
          );
          if (!context.mounted) return;

          final authUser = FirebaseAuth.instance.currentUser;
          if (authUser != null) {
            Navigator.of(context).pushAndRemoveUntil<void>(
              MaterialPageRoute(
                builder: (context) => AppNavigator(userId: authUser.uid),
              ),
              (route) => false,
            );
          }
        } on FirebaseAuthException catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message.toString())),
          );
          if (error.code == 'email-not-verified') {
            Navigator.of(context).pushAndRemoveUntil<void>(
              MaterialPageRoute(
                builder: (context) => const EmailVerificationPage(),
              ),
              (route) => false,
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        } finally {
          ref
              .read(loadingProvider.notifier)
              .update((state) => false); // Move this to finally
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.lock, size: 150),
                  const SizedBox(height: 20),

                  // Email Text Box
                  CustomTextField(
                      controller: emailController,
                      label: localizaton.email,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizaton.emailRequired;
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),

                  // Password Text Box
                  CustomTextField(
                      controller: passwordController,
                      label: localizaton.password,
                      obscured: true,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizaton.passwordRequired;
                        }
                        return null;
                      }),
                  const SizedBox(height: 15),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordPage(),
                          ),
                        );
                        formKey.currentState?.reset();
                      },
                      child: Text(
                        localizaton.forgetPassword,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Btn
                  CustomButton(label: localizaton.login, onPressed: login),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.6, color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(localizaton.or,
                            style: TextStyle(color: Colors.grey[700])),
                      ),
                      Expanded(
                          child:
                              Divider(thickness: 0.6, color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        onTap: () async {
                          try {
                            await authViewModelNotifier
                                .singInWithGoogleAccount();
                            if (!context.mounted) return;

                            final authUser = FirebaseAuth.instance.currentUser;
                            if (authUser != null) {
                              Navigator.of(context).pushAndRemoveUntil<void>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AppNavigator(userId: authUser.uid),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }
                        },
                        imagePath: 'assets/images/google.png',
                      ),
                      const SizedBox(width: 50),
                      SquareTile(
                        onTap: () async {
                          try {
                            await authViewModelNotifier.signInWithGitHub();
                            if (!context.mounted) return;

                            final authUser = FirebaseAuth.instance.currentUser;
                            if (authUser != null) {
                              Navigator.of(context).pushAndRemoveUntil<void>(
                                MaterialPageRoute(
                                  builder: (context) => !authUser.emailVerified
                                      ? const EmailVerificationPage()
                                      : AppNavigator(userId: authUser.uid),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }
                        },
                        imagePath: 'assets/images/github-black.png',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      }
                    },
                    child: Text(localizaton.doseNotHaveAcc,
                        style: const TextStyle(fontSize: 16)),
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

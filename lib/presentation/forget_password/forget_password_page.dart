import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/navigator.dart';
import 'package:product_management/presentation/login/widgets/square_tile.dart';
import 'package:product_management/presentation/register/register_page.dart';
import 'package:product_management/presentation/varification/verification_page.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/widgets/widgets.dart';

class ForgetPasswordPage extends HookConsumerWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModelNotifier = ref.watch(authNotifierProvider.notifier);
    final emailController =
        useTextEditingController(); // Using hook for controller
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final successMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.lock_reset, size: 150),
                  const Text('Forget Password'),
                  const SizedBox(height: 20),

                  if (successMessage.value != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        successMessage.value!,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Email Text Box
                  CustomTextField(
                      controller: emailController,
                      label: 'Email',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required.';
                        }
                        return null;
                      }),
                  const SizedBox(height: 30),

                  // Login Btn
                  CustomButton(
                      label: 'Send',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          ref
                              .watch(loadingProvider.notifier)
                              .update((state) => true);
                          FocusScope.of(context).unfocus();
                          try {
                            await authViewModelNotifier.forgotPassword(
                              emailController.text,
                            );
                            if (!context.mounted) return;
                            ref
                                .watch(loadingProvider.notifier)
                                .update((state) => false);

                            formKey.currentState?.reset();
                            successMessage.value =
                                'Password reset link has been sent to your email  ${emailController.text}';
                            emailController.text = '';
                          } on Exception catch (e) {
                            if (!context.mounted) return;
                            ref
                                .watch(loadingProvider.notifier)
                                .update((state) => false);
                            showSnackBar(context, e.getMessage);
                          }
                        }
                      }),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.6, color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or continue with',
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
                                      HomePage(userId: authUser.uid),
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
                                      : HomePage(userId: authUser.uid),
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
                    child: const Text("Don't have an account? Register",
                        style: TextStyle(fontSize: 16)),
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

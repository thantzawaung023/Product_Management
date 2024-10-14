import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/navigator.dart';
import 'package:product_management/presentation/varification/verification_page.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/widgets.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free resources
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModelNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Icon(
                  Icons.person,
                  size: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Email input
                CustomTextField(
                  controller: _emailController, // Add controller
                  label: 'Email',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                // Name input
                CustomTextField(
                  controller: _nameController, // Add controller
                  label: 'Name',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                // Password input
                CustomTextField(
                  controller: _passwordController, // Add controller
                  label: 'Password',
                  isRequired: true,
                  obscured: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),

                // Register button
                CustomButton(
                  label: 'Save',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .watch(loadingProvider.notifier)
                          .update((state) => true);
                      try {
                        // Register user using the form input
                        await authViewModelNotifier.register(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          name: _nameController.text.trim(),
                        );

                        // Navigate to HomeScreen on successful registration
                        if (context.mounted) {
                          ref
                              .watch(loadingProvider.notifier)
                              .update((state) => false);
                          showSnackBar(context, Messages.userSaveSuccess);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EmailVerificationPage()),
                          );
                        }
                      } catch (e) {
                        // Show error message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      } finally {
                        ref
                            .watch(loadingProvider.notifier)
                            .update((state) => false);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

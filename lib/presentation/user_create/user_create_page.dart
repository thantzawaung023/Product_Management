import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/widgets/widgets.dart';

class UserCreatePage extends ConsumerWidget {
  UserCreatePage({super.key, this.user});

  final _formKey = GlobalKey<FormState>();
  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userViewModelNotifier =
        ref.watch(userViewModelNotifierProvider(user).notifier);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.person,
                  size: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  label: 'Email',
                  onChanged: userViewModelNotifier.setEmail,
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
                CustomTextField(
                  label: 'Name',
                  onChanged: userViewModelNotifier.setName,
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
                CustomTextField(
                  label: 'Address Name',
                  onChanged: userViewModelNotifier.setAddressName,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: 'Address Location',
                  onChanged: userViewModelNotifier.setAddressLocation,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address Location is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: 'Password',
                  onChanged: userViewModelNotifier.setPassword,
                  isRequired: true,
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
                CustomButton(
                  label: 'Save',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .watch(loadingProvider.notifier)
                          .update((state) => true);
                      try {
                        await userViewModelNotifier.register();
                        // Navigate to HomeScreen on successful registration

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        // Show error message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

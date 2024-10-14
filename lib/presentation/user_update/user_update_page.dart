import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/presentation/user_update/widgets/profile_image.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/widgets.dart';

class UserUpdatePage extends ConsumerWidget {
  UserUpdatePage({super.key, required this.user});

  final _formKey = GlobalKey<FormState>();
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userViewModelState = ref.watch(userViewModelNotifierProvider(user));
    final userViewModelNotifier =
        ref.watch(userViewModelNotifierProvider(user).notifier);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Update User'),
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
                ProfileImageSection(
                  state: userViewModelState,
                  viewModel: userViewModelNotifier,
                  context: context,
                ),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   label: 'Email',
                //   initialValue: userViewModelState.email,
                //   onChanged: userViewModelNotifier.setEmail,
                //   isRequired: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Email is required.';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: 'Name',
                  initialValue: userViewModelState.name,
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
                  initialValue: userViewModelState.address?.name ?? '',
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
                  initialValue: userViewModelState.address?.location ?? '',
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
                
                const SizedBox(height: 20),
                CustomButton(
                  label: 'Save',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .watch(loadingProvider.notifier)
                          .update((state) => true);
                      try {
                        await userViewModelNotifier.updateUser();
                        if (context.mounted) {
                          showSnackBar(context, Messages.userSaveSuccess);
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
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

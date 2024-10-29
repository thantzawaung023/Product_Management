import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/app.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserCreatePage extends ConsumerWidget {
  UserCreatePage({super.key, this.user});

  final _formKey = GlobalKey<FormState>();
  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isLoading = ref.watch(loadingProvider);
    final userViewModelNotifier =
        ref.watch(userViewModelNotifierProvider(user).notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                  label: localizations.email,
                  onChanged: userViewModelNotifier.setEmail,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.emailRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localizations.name,
                  onChanged: userViewModelNotifier.setName,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localizations.addressName,
                  onChanged: userViewModelNotifier.setAddressName,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.addressNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localizations.addressLocation,
                  onChanged: userViewModelNotifier.setAddressLocation,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.addressLocationRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localizations.password,
                  onChanged: userViewModelNotifier.setPassword,
                  isRequired: true,
                  obscured: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.passwordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: isLoading ? '' : localizations.save,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref.read(loadingProvider.notifier).state = true;
                      try {
                        await userViewModelNotifier.register();

                        if (context.mounted) {
                          showCustomDialogForm(
                            context: context,
                            title: localizations.success,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_outlined,
                                    color: Colors.amber, size: 100),
                                const SizedBox(height: 16),
                                Text(
                                  localizations.successUserCreate,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(localizations.verifyEmail),
                              ],
                            ),
                            onSave: () =>
                                Navigator.of(context).pushAndRemoveUntil<void>(
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()),
                              (route) => false,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      } finally {
                        ref.read(loadingProvider.notifier).state = false;
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

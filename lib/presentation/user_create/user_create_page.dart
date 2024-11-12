import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/app.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:product_management/provider/loading/loading_provider.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserCreatePage extends ConsumerWidget {
  UserCreatePage({super.key, this.user});

  final _formKey = GlobalKey<FormState>();
  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final isLoading = ref.watch(loadingProvider);
    final userViewModelNotifier =
        ref.watch(userViewModelNotifierProvider(user).notifier);
    final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

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
                  label: localization.email,
                  onChanged: userViewModelNotifier.setEmail,
                  isRequired: true,
                  validator: (value) => Validators.validateEmail(
                    value: value,
                    labelText: localization.email,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  label: localization.name,
                  onChanged: userViewModelNotifier.setName,
                  isRequired: true,
                  validator: (value) => Validators.validateRequiredField(
                    value: value,
                    labelText: localization.name,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isPasswordVisible,
                  builder: (context, value, child) {
                    return CustomTextField(
                      label: localization.password,
                      onChanged: userViewModelNotifier.setPassword,
                      isRequired: true,
                      obscured: !value,
                      validator: (value) => Validators.validatePassword(
                        value: value,
                        labelText: localization.password,
                        context: context,
                      ),
                      onTogglePassword: (value) =>
                          isPasswordVisible.value = !value,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: isLoading ? '' : localization.save,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ref.read(loadingProvider.notifier).state = true;
                      try {
                        await userViewModelNotifier.register();

                        if (context.mounted) {
                          showCustomDialogForm(
                            context: context,
                            title: localization.success,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_outlined,
                                    color: Colors.amber, size: 100),
                                const SizedBox(height: 16),
                                Text(
                                  localization.successUserCreate,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(localization.verifyEmail),
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

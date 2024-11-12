import 'package:flutter/material.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

Future<void> showChangePasswordDialog(
    BuildContext context, UserViewModel userNotifier) {
  final formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';
  final ValueNotifier<bool> isOldPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> isNewPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier(false);

  return showCustomDialogForm(
    context: context,
    title: AppLocalizations.of(context)!.changePassword,
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isOldPasswordVisible,
            builder: (context, value, child) {
              return CustomTextField(
                maxLength: 26,
                label: AppLocalizations.of(context)!.oldPassword,
                initialValue: '',
                onChanged: (value) => oldPassword = value,
                obscured: !value,
                isRequired: true,
                onTogglePassword: (isVisible) {
                  isOldPasswordVisible.value = !isVisible;
                },
                validator: (value) => Validators.validatePassword(
                    value: value,
                    labelText: AppLocalizations.of(context)!.oldPassword,
                    context: context),
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: isNewPasswordVisible,
            builder: (context, value, child) {
              return CustomTextField(
                maxLength: 26,
                label: AppLocalizations.of(context)!.newPassword,
                initialValue: '',
                onChanged: (value) => newPassword = value,
                obscured: !value,
                isRequired: true,
                onTogglePassword: (isVisible) {
                  isNewPasswordVisible.value = !isVisible;
                },
                validator: (value) => Validators.validatePassword(
                    value: value,
                    labelText: AppLocalizations.of(context)!.newPassword,
                    context: context),
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: isConfirmPasswordVisible,
            builder: (context, value, child) {
              return CustomTextField(
                maxLength: 26,
                label: AppLocalizations.of(context)!.confirmPassword,
                initialValue: '',
                obscured: !value,
                isRequired: true,
                validator: (value) {
                  if (value != newPassword) {
                    return AppLocalizations.of(context)!.passwordsNotMatch;
                  }
                  return null;
                },
                onTogglePassword: (isVisible) {
                  isConfirmPasswordVisible.value = !isVisible;
                },
              );
            },
          ),
        ],
      ),
    ),
    onSave: () async {
      if (formKey.currentState?.validate() ?? false) {
        try {
          await userNotifier.changePassword(
              oldPassword: oldPassword, newPassword: newPassword);
          if (!context.mounted) return;
          Navigator.of(context).pop();
          showSnackBar(context, Messages.passChangeSuccessMsg, Colors.green);
        } on Exception catch (e) {
          showSnackBar(context, e.getMessage, Colors.red);
        }
      }
    },
  );
}

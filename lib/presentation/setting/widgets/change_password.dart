import 'package:flutter/material.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/constants/messages.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

Future<void> showChangePasswordDialog(
    BuildContext context, UserViewModel userNotifier) {
  final formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';

  return showCustomDialogForm(
    context: context,
    title: AppLocalizations.of(context)!.changePassword,
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            maxLength: 26,
            label: AppLocalizations.of(context)!.oldPassword,
            initialValue: '',
            onChanged: (value) => oldPassword = value,
            obscured: true,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            maxLength: 26,
            label: AppLocalizations.of(context)!.newPassword,
            initialValue: '',
            onChanged: (value) => newPassword = value,
            obscured: true,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            maxLength: 26,
            label: AppLocalizations.of(context)!.confirmPassword,
            initialValue: '',
            obscured: true,
            isRequired: true,
            validator: (value) {
              if (value != newPassword) {
                return AppLocalizations.of(context)!.passwordsNotMatch;
              }
              return null;
            },
            onChanged: (String value) {},
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
          showSnackBar(context, Messages.passChangeSuccessMsg,Colors.green);
        } on Exception catch (e) {
          showSnackBar(context, e.getMessage,Colors.red);
        }
      }
    },
  );
}
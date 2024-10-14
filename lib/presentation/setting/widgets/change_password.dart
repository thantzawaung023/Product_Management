import 'package:flutter/material.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/utils/constants/messages.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:product_management/widgets/widgets.dart';

Future<void> showChangePasswordDialog(
    BuildContext context, UserViewModel userNotifier) {
  final formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';

  return showCustomDialogForm(
    context: context,
    title: 'Change Password',
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            maxLength: 26,
            label: 'Old Password',
            initialValue: '',
            onChanged: (value) => oldPassword = value,
            obscured: true,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            maxLength: 26,
            label: 'New Password',
            initialValue: '',
            onChanged: (value) => newPassword = value,
            obscured: true,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            maxLength: 26,
            label: 'Confirm Password',
            initialValue: '',
            obscured: true,
            isRequired: true,
            validator: (value) {
              if (value != newPassword) {
                return 'Passwords do not match.';
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
          // await userNotifier.changePassword(
          //     oldPassword: oldPassword, newPassword: newPassword);
          if (!context.mounted) return;
          Navigator.of(context).pop();
          showSnackBar(context, Messages.passChangeSuccessMsg);
        } on Exception catch (e) {
          showSnackBar(context, e.getMessage);
        }
      }
    },
  );
}
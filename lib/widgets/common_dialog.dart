import 'package:flutter/material.dart';
import 'package:product_management/utils/extensions/exception_msg.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String message,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00BBEF),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false on CANCEL
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(true); // Return true on OK
                },
                child: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ) ??
      false; // Ensure it returns false if dialog is dismissed
}

void showSnackBar(BuildContext context, String msg, MaterialColor? color) {
  final Widget toastWithButton = Container(
    padding: const EdgeInsets.only(left: 19),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: color ?? const Color(0xFF1E1A1A),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            msg,
            softWrap: true,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const ColoredBox(
          color: Color(0xFFF4F4F4),
          child: SizedBox(
            width: 1,
            height: 23,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 20,
          ),
          color: const Color(0xFFF61202),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ],
    ),
  );
  final snackBar = SnackBar(
    content: toastWithButton,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.zero,
    elevation: 0,
    duration: const Duration(milliseconds: 5000),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> showCustomDialogForm({
  required BuildContext context,
  required String title,
  required Widget content,
  required Future<void> Function() onSave,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: SizedBox(
                width: 120,
                child: content,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00BBEF),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF017256),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          try {
                            await onSave();
                          } on Exception catch (e) {
                            if (context.mounted) {
                              showSnackBar(context, e.getMessage, Colors.red);
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() => isLoading = false);
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF017256),
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.save,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      });
}

Future<void> showEmailVerifiedDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required Future<void> Function() onSave,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: content,
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF017256),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          try {
                            await onSave();
                          } on Exception catch (e) {
                            if (context.mounted) {
                              showSnackBar(context, e.toString(),
                                  Colors.red); // Handle error
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() => isLoading = false);
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Go to Login Page',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> accountDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback? okFunction,
  String? okButton,
  bool password = false,
  TextEditingController? passwordController,
  required String cancelButton,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
      final formKey = GlobalKey<FormState>();

      return Form(
        key: formKey,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (password)
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .enterPassword, // Replace with localized string if needed
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        ValueListenableBuilder<bool>(
                          valueListenable: isPasswordVisible,
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: passwordController,
                              obscureText: !value,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .password, // Replace with localized string if needed
                                suffixIcon: IconButton(
                                  icon: Icon(value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    isPasswordVisible.value = !value;
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .passwordRequired;
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white30),
                        right: BorderSide(color: Colors.white30),
                      ),
                    ),
                    child: TextButton(
                      child: Text(
                        cancelButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.lightGreen,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                if (okButton != null && okButton.isNotEmpty)
                  Expanded(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white30),
                        ),
                      ),
                      child: TextButton(
                        child: Text(
                          okButton,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            Navigator.of(context).pop();
                            if (okFunction != null) okFunction();
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

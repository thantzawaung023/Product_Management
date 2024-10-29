import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/app.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/utils/constants/messages.dart';
import 'package:product_management/widgets/common_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  EmailVerificationPageState createState() => EmailVerificationPageState();
}

class EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  Timer? _verificationCheckTimer;

  @override
  void initState() {
    super.initState();
    // Automatically trigger email verification when page is opened
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).sendVerificationEmail();
      _startEmailVerificationCheck();
    });
  }

  void _startEmailVerificationCheck() {
    _verificationCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      final authViewModel = ref.read(authNotifierProvider.notifier);
      bool isVerified = await authViewModel.checkEmailVerified();
      if (isVerified) {
        timer.cancel();
        await authViewModel.signOut();
        if (mounted) {
          showEmailVerifiedDialog(
            context: context,
            title: 'You Have Been Verified',
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user,
                  color: Colors.green,
                  size: 100,
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Your Email verification is successful!',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text('Now you can login with your account.'),
                ),
              ],
            ),
            onSave: () => Navigator.of(context).pushAndRemoveUntil<void>(
              MaterialPageRoute(builder: (context) => const MyApp()),
              (route) => false,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _verificationCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authViewModel = ref.read(authNotifierProvider.notifier);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localization.verifyTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localization.verify,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (authState.isLoading) const CircularProgressIndicator(),
            if (!authState.isLoading && authState.isEmailSent)
              Column(
                children: [
                  const Icon(
                    Icons.mark_email_unread,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    localization.verifySend,
                    textAlign: TextAlign.center,
                  ),
                  Text(localization.verifyCheckLable),
                ],
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null // Disable button while loading
                  : () async {
                      await authViewModel.sendVerificationEmail();
                      showSnackBar(context, localization.verifyHasBeenReSend,
                          Colors.green);
                    },
              child: Text(localization.verifyReSend),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isVerified = await authViewModel.checkEmailVerified();
                if (isVerified && context.mounted) {
                  showSnackBar(
                      context, Messages.verificationSuccess, Colors.green);
                  Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
                  );
                } else if (authState.errorMsg.isNotEmpty && context.mounted) {
                  showSnackBar(context, authState.errorMsg, Colors.red);
                  authViewModel
                      .clearErrorMessage(); // Clear error after showing it
                }
              },
              child: Text(localization.verifyCheck),
            ),
          ],
        ),
      ),
    );
  }
}

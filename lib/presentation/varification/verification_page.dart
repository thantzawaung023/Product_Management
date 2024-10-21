import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/app.dart';
import 'package:product_management/presentation/login/login_page.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/utils/constants/messages.dart';
import 'package:product_management/widgets/common_dialog.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please verify Your Email Address',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (authState.isLoading) const CircularProgressIndicator(),
            if (!authState.isLoading && authState.isEmailSent)
              const Column(
                children: [
                  Icon(
                    Icons.mark_email_unread,
                    size: 50,
                    color: Colors.red,
                  ),
                  Text(
                    'A verification email has been sent to your email address.',
                    textAlign: TextAlign.center,
                  ),
                  Text('Please check your inbox.'),
                ],
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null // Disable button while loading
                  : () async {
                      await authViewModel.sendVerificationEmail();
                      showSnackBar(context, 'Verification email sent.');
                    },
              child: const Text('Resend Verification Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isVerified = await authViewModel.checkEmailVerified();
                if (isVerified && context.mounted) {
                  showSnackBar(context, Messages.verificationSuccess);
                  Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
                  );
                } else if (authState.errorMsg.isNotEmpty && context.mounted) {
                  showSnackBar(context, authState.errorMsg);
                  authViewModel
                      .clearErrorMessage(); // Clear error after showing it
                }
              },
              child: const Text('Check Verification Status'),
            ),
          ],
        ),
      ),
    );
  }
}

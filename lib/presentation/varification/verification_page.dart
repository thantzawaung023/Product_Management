import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/provider/authentication/auth_view_model.dart';
import 'package:product_management/utils/utils.dart';
import 'package:product_management/widgets/widgets.dart';

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
      bool isverified = await authViewModel.checkEmailVerified();
      if (isverified) {
        timer.cancel();
        if (mounted) {
          final authUser = FirebaseAuth.instance.currentUser!;

          Navigator.of(context).pushAndRemoveUntil<void>(
            MaterialPageRoute(
              builder: (context) => HomePage(userId: authUser.uid),
            ),
            (route) => false,
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
              onPressed: () {
                authViewModel.sendVerificationEmail();
                showSnackBar(context, 'Verification email sent.');
              },
              child: const Text('Resend Verification Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isverified = await authViewModel.checkEmailVerified();
                if (isverified && context.mounted) {
                  showSnackBar(context, Messages.verificationSuccess);
                  final authUser = FirebaseAuth.instance.currentUser!;
                  Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (context) => HomePage(userId: authUser.uid),
                    ),
                    (route) => false,
                  );
                } else if (authState.errorMsg.isNotEmpty && context.mounted) {
                  showSnackBar(context, authState.errorMsg);
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

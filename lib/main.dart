import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  // ignore: constant_identifier_names
  const google_api_key = String.fromEnvironment('GOOGLE_API_KEY');
  logger.i('🎯 GOOGLE_API_KEY : $google_api_key');
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

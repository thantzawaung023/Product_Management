import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final languageProvider = StateProvider<Locale>((ref) => const Locale('en'));

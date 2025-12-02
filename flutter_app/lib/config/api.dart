import 'package:flutter/foundation.dart'; // <-- perbaikan import
import 'dart:io' show Platform;

class ApiConfig {
  static const String baseWeb = 'http://localhost:3000/api';
  static const String baseAndroidEmulator = 'http://10.0.2.2:3000/api';

  static String get baseUrl {
    if (kIsWeb) return baseWeb;

    try {
      if (Platform.isAndroid) return baseAndroidEmulator;
    } catch (e) {
      // ignore, happens on web
    }

    return baseWeb;
  }
}

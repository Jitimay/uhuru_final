import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String? get fileName {
    if (kDebugMode) {
      return '.env.development';
    } else if (kReleaseMode) {
      return '.env.production';
    }
  }

  static String get host {
    return dotenv.env['API_URL'] ?? 'API_URL NOT FOUND';
  }

  static String get urlHost {
    return dotenv.env['URL'] ?? 'URL NOT FOUND';
  }

  static String get adUnitID {
    return dotenv.env['AD_UNIT_ID'] ?? 'AD UNIT ID NOT FOUND';
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API base URL for backend
final String apiBaseUrl = kIsWeb
    ? const String.fromEnvironment('API_BASE_URL',
        defaultValue: 'https://minglea.onrender.com')
    : (dotenv.env['API_BASE_URL'] ?? 'https://minglea.onrender.com');

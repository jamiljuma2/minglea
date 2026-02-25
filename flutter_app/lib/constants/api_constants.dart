import 'package:flutter_dotenv/flutter_dotenv.dart';

// API base URL for backend
final String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'https://minglea.onrender.com';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // Private variables to store database configuration
  static String? _dbHost;
  static int? _dbPort;
  static String? _dbUser;
  static String? _dbPassword;
  static String? _dbName;

  // Public getters to access the configuration variables
  static String get dbHost => _dbHost ?? '';
  static int get dbPort => _dbPort ?? 3306;
  static String get dbUser => _dbUser ?? '';
  static String get dbPassword => _dbPassword ?? '';
  static String get dbName => _dbName ?? '';

  // Method to load the environment variables from the .env file
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');

      // Initialize variables from the .env file
      _dbHost = dotenv.env['DB_HOST'];
      _dbPort = int.tryParse(dotenv.env['DB_PORT'] ?? '3306') ?? 3306;
      _dbUser = dotenv.env['DB_USER'];
      _dbPassword = dotenv.env['DB_PASSWORD'];
      _dbName = dotenv.env['DB_NAME'];
    } catch (e) {
      if (kDebugMode) {
        print('Error loading .env file: $e');
      }
      // Error handling
    }
  }
}

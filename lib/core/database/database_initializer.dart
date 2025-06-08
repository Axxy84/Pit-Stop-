import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseInitializer {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check if running on desktop
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Initialize FFI for desktop
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        _isInitialized = true;
        // Database initialized for desktop platform
      } else {
        // Mobile platforms don't need special initialization
        _isInitialized = true;
        // Database initialized for mobile platform
      }
    } catch (e) {
      // Error initializing database
      // Try alternative initialization
      try {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        _isInitialized = true;
        // Database initialized with FFI fallback
      } catch (fallbackError) {
        // Fallback initialization also failed
        throw Exception('Failed to initialize database: $e');
      }
    }
  }

  static bool get isInitialized => _isInitialized;
}
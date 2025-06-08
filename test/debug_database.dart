// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:pit_stop/core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔧 Starting database debug...');
  print('Platform: ${Platform.operatingSystem}');
  
  try {
    // Initialize SQLite FFI for desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      print('📱 Initializing SQLite FFI for desktop...');
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      print('✅ SQLite FFI initialized successfully');
    }
    
    // Test database connection
    print('🗄️ Testing database connection...');
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    
    print('✅ Database connected successfully');
    print('📍 Database path: ${db.path}');
    print('📊 Database version: ${await db.getVersion()}');
    
    // Test query
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );
    print('📋 Tables in database:');
    for (final table in tables) {
      print('   - ${table['name']}');
    }
    
    // Test users table
    final users = await db.query('users');
    print('👥 Users in database: ${users.length}');
    for (final user in users) {
      print('   - ${user['username']} (${user['role']})');
    }
    
    print('\n✅ Database debug completed successfully!');
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('📋 Stack trace:');
    print(stackTrace);
  }
  
  // Keep console open
  print('\nPress Enter to exit...');
  stdin.readLineSync();
}
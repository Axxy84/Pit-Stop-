import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database_helper.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/clients/data/repositories/client_repository_impl.dart';
import '../../features/clients/domain/repositories/client_repository.dart';

// Database Helper Provider
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final databaseHelper = ref.watch(databaseHelperProvider);
  return AuthRepositoryImpl(databaseHelper);
});

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final databaseHelper = ref.watch(databaseHelperProvider);
  return ClientRepositoryImpl(databaseHelper);
});

// Database Initialization Provider
final databaseInitializationProvider = FutureProvider<bool>((ref) async {
  try {
    final databaseHelper = ref.watch(databaseHelperProvider);
    await databaseHelper.database; // Triggers database initialization
    return true;
  } catch (e) {
    throw Exception('Failed to initialize database: $e');
  }
});
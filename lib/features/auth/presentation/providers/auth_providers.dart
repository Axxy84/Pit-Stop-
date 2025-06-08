import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/database_providers.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Current User State
final currentUserProvider = StateProvider<UserEntity?>((ref) => null);

// Authentication State
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

// Login Provider
final loginProvider = FutureProvider.family<UserEntity?, LoginCredentials>((ref, credentials) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.login(credentials.username, credentials.password);
});

// Users List Provider
final usersListProvider = FutureProvider<List<UserEntity>>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.getAllUsers();
});

// Login Credentials Data Class
class LoginCredentials {
  final String username;
  final String password;

  const LoginCredentials({
    required this.username,
    required this.password,
  });
}

// Auth Notifier for complex auth operations
class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.login(username, password);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(null);
  }

  Future<void> createUser(UserEntity user, String password) async {
    try {
      await _authRepository.createUser(user, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(int userId, String newPassword) async {
    try {
      await _authRepository.changePassword(userId, newPassword);
    } catch (e) {
      rethrow;
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
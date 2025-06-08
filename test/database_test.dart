import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:pit_stop/core/database/database_helper.dart';
import 'package:pit_stop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pit_stop/features/auth/domain/entities/user_entity.dart';

void main() {
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  group('Database Tests', () {
    late DatabaseHelper databaseHelper;
    late AuthRepositoryImpl authRepository;

    setUp(() async {
      databaseHelper = DatabaseHelper();
      authRepository = AuthRepositoryImpl(databaseHelper);
    });

    tearDown(() async {
      await databaseHelper.close();
    });

    test('Should initialize database successfully', () async {
      final db = await databaseHelper.database;
      expect(db, isNotNull);
      expect(db.isOpen, isTrue);
    });

    test('Should have initial admin user', () async {
      final user = await authRepository.getUserByUsername('admin');
      expect(user, isNotNull);
      expect(user!.username, equals('admin'));
      expect(user.role, equals(UserRole.admin));
    });

    test('Should authenticate admin user', () async {
      final user = await authRepository.login('admin', 'admin123');
      expect(user, isNotNull);
      expect(user!.username, equals('admin'));
      expect(user.role, equals(UserRole.admin));
    });

    test('Should not authenticate with wrong password', () async {
      final user = await authRepository.login('admin', 'wrongpassword');
      expect(user, isNull);
    });

    test('Should create new user', () async {
      final newUser = UserEntity(
        username: 'testuser',
        role: UserRole.operator,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdUser = await authRepository.createUser(newUser, 'testpass');
      expect(createdUser.id, isNotNull);
      expect(createdUser.username, equals('testuser'));
      expect(createdUser.role, equals(UserRole.operator));
    });

    test('Should authenticate created user', () async {
      final newUser = UserEntity(
        username: 'testuser2',
        role: UserRole.operator,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await authRepository.createUser(newUser, 'testpass2');
      final authenticatedUser = await authRepository.login('testuser2', 'testpass2');
      
      expect(authenticatedUser, isNotNull);
      expect(authenticatedUser!.username, equals('testuser2'));
    });

    test('Should get all users', () async {
      final users = await authRepository.getAllUsers();
      expect(users.length, greaterThanOrEqualTo(1)); // At least admin user
    });

    test('Should change user password', () async {
      // Create test user
      final testUser = UserEntity(
        username: 'passwordtest',
        role: UserRole.operator,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdUser = await authRepository.createUser(testUser, 'oldpass');
      
      // Change password
      await authRepository.changePassword(createdUser.id!, 'newpass');
      
      // Test old password (should fail)
      final oldAuth = await authRepository.login('passwordtest', 'oldpass');
      expect(oldAuth, isNull);
      
      // Test new password (should work)
      final newAuth = await authRepository.login('passwordtest', 'newpass');
      expect(newAuth, isNotNull);
    });
  });
}
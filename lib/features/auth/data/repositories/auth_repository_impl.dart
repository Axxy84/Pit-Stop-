import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/database_exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper _databaseHelper;

  AuthRepositoryImpl(this._databaseHelper);

  @override
  Future<UserEntity?> login(String username, String password) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'users',
        where: 'username = ? AND active = 1',
        whereArgs: [username],
        limit: 1,
      );

      if (result.isEmpty) return null;

      final userModel = UserModel.fromJson(result.first);
      final isValidPassword = await verifyPassword(password, userModel.passwordHash);
      
      return isValidPassword ? userModel.toEntity() : null;
    } catch (e) {
      throw DatabaseOperationException('login', e.toString());
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user, String password) async {
    try {
      final db = await _databaseHelper.database;
      final hashedPassword = _hashPassword(password);
      final now = DateTime.now();
      
      final userModel = UserModel.fromEntity(user, hashedPassword).copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await db.insert('users', userModel.toInsertJson());
      return userModel.copyWith(id: id).toEntity();
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw DatabaseDuplicateException('username');
      }
      throw DatabaseOperationException('create user', e.toString());
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    try {
      final db = await _databaseHelper.database;
      
      if (user.id == null) {
        throw DatabaseValidationException('id', 'User ID is required for update');
      }

      final userModel = UserModel.fromEntity(user, '').copyWith(
        updatedAt: DateTime.now(),
      );

      final updateData = userModel.toJson();
      updateData.remove('password_hash'); // Don't update password here
      updateData.remove('created_at'); // Don't update creation date

      final updatedRows = await db.update(
        'users',
        updateData,
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (updatedRows == 0) {
        throw DatabaseNotFoundException('User');
      }

      return userModel.toEntity();
    } catch (e) {
      throw DatabaseOperationException('update user', e.toString());
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      final db = await _databaseHelper.database;
      final deletedRows = await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (deletedRows == 0) {
        throw DatabaseNotFoundException('User');
      }
    } catch (e) {
      throw DatabaseOperationException('delete user', e.toString());
    }
  }

  @override
  Future<UserEntity?> getUserById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) return null;
      
      return UserModel.fromJson(result.first).toEntity();
    } catch (e) {
      throw DatabaseOperationException('get user by id', e.toString());
    }
  }

  @override
  Future<UserEntity?> getUserByUsername(String username) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
        limit: 1,
      );

      if (result.isEmpty) return null;
      
      return UserModel.fromJson(result.first).toEntity();
    } catch (e) {
      throw DatabaseOperationException('get user by username', e.toString());
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'users',
        orderBy: 'username ASC',
      );

      return result
          .map((json) => UserModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw DatabaseOperationException('get all users', e.toString());
    }
  }

  @override
  Future<bool> verifyPassword(String password, String hash) async {
    return _hashPassword(password) == hash;
  }

  @override
  Future<void> changePassword(int userId, String newPassword) async {
    try {
      final db = await _databaseHelper.database;
      final hashedPassword = _hashPassword(newPassword);

      final updatedRows = await db.update(
        'users',
        {
          'password_hash': hashedPassword,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (updatedRows == 0) {
        throw DatabaseNotFoundException('User');
      }
    } catch (e) {
      throw DatabaseOperationException('change password', e.toString());
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
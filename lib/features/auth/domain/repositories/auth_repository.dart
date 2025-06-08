import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String username, String password);
  Future<UserEntity> createUser(UserEntity user, String password);
  Future<UserEntity> updateUser(UserEntity user);
  Future<void> deleteUser(int id);
  Future<UserEntity?> getUserById(int id);
  Future<UserEntity?> getUserByUsername(String username);
  Future<List<UserEntity>> getAllUsers();
  Future<bool> verifyPassword(String password, String hash);
  Future<void> changePassword(int userId, String newPassword);
}
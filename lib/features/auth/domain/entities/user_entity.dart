import 'package:equatable/equatable.dart';

enum UserRole { admin, operator }

class UserEntity extends Equatable {
  final int? id;
  final String username;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    this.id,
    required this.username,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    int? id,
    String? username,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, username, role, isActive, createdAt, updatedAt];
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.operator:
        return 'operator';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'operator':
        return UserRole.operator;
      default:
        throw ArgumentError('Invalid user role: $value');
    }
  }
}
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String passwordHash;

  const UserModel({
    super.id,
    required super.username,
    required this.passwordHash,
    required super.role,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String,
      passwordHash: json['password_hash'] as String,
      role: UserRoleExtension.fromString(json['role'] as String),
      isActive: (json['active'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'role': role.value,
      'active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id'); // Remove ID for insert operations
    return json;
  }

  @override
  UserModel copyWith({
    int? id,
    String? username,
    String? passwordHash,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserModel.fromEntity(UserEntity entity, String passwordHash) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      passwordHash: passwordHash,
      role: entity.role,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

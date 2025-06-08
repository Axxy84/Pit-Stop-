import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    super.id,
    required super.name,
    required super.phone,
    super.address,
    super.neighborhood,
    super.reference,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
      neighborhood: json['neighborhood'] as String?,
      reference: json['reference'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'neighborhood': neighborhood,
      'reference': reference,
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
  ClientModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? neighborhood,
    String? reference,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ClientModel.fromEntity(ClientEntity entity) {
    return ClientModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      address: entity.address,
      neighborhood: entity.neighborhood,
      reference: entity.reference,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ClientEntity toEntity() {
    return ClientEntity(
      id: id,
      name: name,
      phone: phone,
      address: address,
      neighborhood: neighborhood,
      reference: reference,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final int? id;
  final String name;
  final String phone;
  final String? address;
  final String? neighborhood;
  final String? reference;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClientEntity({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.neighborhood,
    this.reference,
    required this.createdAt,
    required this.updatedAt,
  });

  ClientEntity copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? neighborhood,
    String? reference,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientEntity(
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

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (neighborhood != null && neighborhood!.isNotEmpty) parts.add(neighborhood!);
    if (reference != null && reference!.isNotEmpty) parts.add('Ref: ${reference!}');
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        address,
        neighborhood,
        reference,
        createdAt,
        updatedAt,
      ];
}
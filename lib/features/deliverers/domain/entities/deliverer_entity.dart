import 'package:equatable/equatable.dart';

enum VehicleType { moto, carro, bicicleta }

class DelivererEntity extends Equatable {
  final int? id;
  final String name;
  final String phone;
  final VehicleType? vehicleType;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DelivererEntity({
    this.id,
    required this.name,
    required this.phone,
    this.vehicleType,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  DelivererEntity copyWith({
    int? id,
    String? name,
    String? phone,
    VehicleType? vehicleType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DelivererEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      vehicleType: vehicleType ?? this.vehicleType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        vehicleType,
        isActive,
        createdAt,
        updatedAt,
      ];
}

extension VehicleTypeExtension on VehicleType {
  String get value {
    switch (this) {
      case VehicleType.moto:
        return 'moto';
      case VehicleType.carro:
        return 'carro';
      case VehicleType.bicicleta:
        return 'bicicleta';
    }
  }

  String get displayName {
    switch (this) {
      case VehicleType.moto:
        return 'Moto';
      case VehicleType.carro:
        return 'Carro';
      case VehicleType.bicicleta:
        return 'Bicicleta';
    }
  }

  static VehicleType fromString(String value) {
    switch (value) {
      case 'moto':
        return VehicleType.moto;
      case 'carro':
        return VehicleType.carro;
      case 'bicicleta':
        return VehicleType.bicicleta;
      default:
        throw ArgumentError('Invalid vehicle type: $value');
    }
  }
}
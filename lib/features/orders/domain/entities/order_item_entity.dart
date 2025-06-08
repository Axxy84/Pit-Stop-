import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';

class OrderItemEntity extends Equatable {
  final int? id;
  final int orderId;
  final ProductEntity product;
  final PizzaSize? size;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final DateTime createdAt;

  const OrderItemEntity({
    this.id,
    required this.orderId,
    required this.product,
    this.size,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.createdAt,
  });

  OrderItemEntity copyWith({
    int? id,
    int? orderId,
    ProductEntity? product,
    PizzaSize? size,
    int? quantity,
    double? unitPrice,
    double? subtotal,
    DateTime? createdAt,
  }) {
    return OrderItemEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get displayName {
    if (size != null) {
      return '${product.name} (${size!.displayName})';
    }
    return product.name;
  }

  double get calculatedSubtotal => unitPrice * quantity;

  @override
  List<Object?> get props => [
        id,
        orderId,
        product,
        size,
        quantity,
        unitPrice,
        subtotal,
        createdAt,
      ];
}
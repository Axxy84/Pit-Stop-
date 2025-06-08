import 'package:equatable/equatable.dart';
import '../../../clients/domain/entities/client_entity.dart';
import '../../../deliverers/domain/entities/deliverer_entity.dart';
import 'order_item_entity.dart';

enum OrderStatus {
  pending,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

enum PaymentMethod { dinheiro, pix, cartao }

class OrderEntity extends Equatable {
  final int? id;
  final ClientEntity client;
  final DelivererEntity? deliverer;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final double totalAmount;
  final double? paymentAmount;
  final double changeAmount;
  final double deliveryFee;
  final String? notes;
  final List<OrderItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  const OrderEntity({
    this.id,
    required this.client,
    this.deliverer,
    this.status = OrderStatus.pending,
    required this.paymentMethod,
    required this.totalAmount,
    this.paymentAmount,
    this.changeAmount = 0.0,
    this.deliveryFee = 0.0,
    this.notes,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });

  OrderEntity copyWith({
    int? id,
    ClientEntity? client,
    DelivererEntity? deliverer,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    double? totalAmount,
    double? paymentAmount,
    double? changeAmount,
    double? deliveryFee,
    String? notes,
    List<OrderItemEntity>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      client: client ?? this.client,
      deliverer: deliverer ?? this.deliverer,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  double get itemsTotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get finalTotal => itemsTotal + deliveryFee;
  
  bool get isDelivered => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isActive => !isCancelled;
  bool get needsDeliverer => status == OrderStatus.outForDelivery && deliverer == null;

  @override
  List<Object?> get props => [
        id,
        client,
        deliverer,
        status,
        paymentMethod,
        totalAmount,
        paymentAmount,
        changeAmount,
        deliveryFee,
        notes,
        items,
        createdAt,
        updatedAt,
        deliveredAt,
      ];
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.outForDelivery:
        return 'outForDelivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendente';
      case OrderStatus.preparing:
        return 'Preparando';
      case OrderStatus.outForDelivery:
        return 'Saiu para Entrega';
      case OrderStatus.delivered:
        return 'Entregue';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return OrderStatus.pending;
      case 'preparing':
        return OrderStatus.preparing;
      case 'outForDelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw ArgumentError('Invalid order status: $value');
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.dinheiro:
        return 'dinheiro';
      case PaymentMethod.pix:
        return 'pix';
      case PaymentMethod.cartao:
        return 'cartao';
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.dinheiro:
        return 'Dinheiro';
      case PaymentMethod.pix:
        return 'PIX';
      case PaymentMethod.cartao:
        return 'Cartão';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'dinheiro':
        return PaymentMethod.dinheiro;
      case 'pix':
        return PaymentMethod.pix;
      case 'cartao':
        return PaymentMethod.cartao;
      default:
        throw ArgumentError('Invalid payment method: $value');
    }
  }
}
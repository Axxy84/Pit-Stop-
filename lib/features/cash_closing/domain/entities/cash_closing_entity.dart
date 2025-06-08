import 'package:equatable/equatable.dart';

class CashClosingEntity extends Equatable {
  final int? id;
  final DateTime date;
  final int totalOrders;
  final double totalRevenue;
  final double cashRevenue;
  final double pixRevenue;
  final double cardRevenue;
  final double deliveryFees;
  final String? notes;
  final int closedBy;
  final DateTime createdAt;

  const CashClosingEntity({
    this.id,
    required this.date,
    required this.totalOrders,
    required this.totalRevenue,
    required this.cashRevenue,
    required this.pixRevenue,
    required this.cardRevenue,
    required this.deliveryFees,
    this.notes,
    required this.closedBy,
    required this.createdAt,
  });

  CashClosingEntity copyWith({
    int? id,
    DateTime? date,
    int? totalOrders,
    double? totalRevenue,
    double? cashRevenue,
    double? pixRevenue,
    double? cardRevenue,
    double? deliveryFees,
    String? notes,
    int? closedBy,
    DateTime? createdAt,
  }) {
    return CashClosingEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      cashRevenue: cashRevenue ?? this.cashRevenue,
      pixRevenue: pixRevenue ?? this.pixRevenue,
      cardRevenue: cardRevenue ?? this.cardRevenue,
      deliveryFees: deliveryFees ?? this.deliveryFees,
      notes: notes ?? this.notes,
      closedBy: closedBy ?? this.closedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get averageOrderValue => totalOrders > 0 ? totalRevenue / totalOrders : 0.0;
  
  double get totalWithFees => totalRevenue + deliveryFees;

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  List<Object?> get props => [
        id,
        date,
        totalOrders,
        totalRevenue,
        cashRevenue,
        pixRevenue,
        cardRevenue,
        deliveryFees,
        notes,
        closedBy,
        createdAt,
      ];
}
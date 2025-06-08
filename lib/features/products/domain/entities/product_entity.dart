import 'package:equatable/equatable.dart';

enum ProductCategory { pizza, bebida, sobremesa, outros }

enum PizzaSize { pequena, media, grande }

class ProductEntity extends Equatable {
  final int? id;
  final String name;
  final ProductCategory category;
  final double? priceSmall;
  final double? priceMedium;
  final double? priceLarge;
  final double? priceFixed;
  final bool hasSizes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    this.id,
    required this.name,
    required this.category,
    this.priceSmall,
    this.priceMedium,
    this.priceLarge,
    this.priceFixed,
    required this.hasSizes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  ProductEntity copyWith({
    int? id,
    String? name,
    ProductCategory? category,
    double? priceSmall,
    double? priceMedium,
    double? priceLarge,
    double? priceFixed,
    bool? hasSizes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      priceSmall: priceSmall ?? this.priceSmall,
      priceMedium: priceMedium ?? this.priceMedium,
      priceLarge: priceLarge ?? this.priceLarge,
      priceFixed: priceFixed ?? this.priceFixed,
      hasSizes: hasSizes ?? this.hasSizes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double getPriceForSize(PizzaSize? size) {
    if (!hasSizes) return priceFixed ?? 0.0;
    
    switch (size) {
      case PizzaSize.pequena:
        return priceSmall ?? 0.0;
      case PizzaSize.media:
        return priceMedium ?? 0.0;
      case PizzaSize.grande:
        return priceLarge ?? 0.0;
      case null:
        return priceFixed ?? 0.0;
    }
  }

  List<PizzaSize> get availableSizes {
    if (!hasSizes) return [];
    return PizzaSize.values;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        priceSmall,
        priceMedium,
        priceLarge,
        priceFixed,
        hasSizes,
        isActive,
        createdAt,
        updatedAt,
      ];
}

extension ProductCategoryExtension on ProductCategory {
  String get value {
    switch (this) {
      case ProductCategory.pizza:
        return 'pizza';
      case ProductCategory.bebida:
        return 'bebida';
      case ProductCategory.sobremesa:
        return 'sobremesa';
      case ProductCategory.outros:
        return 'outros';
    }
  }

  String get displayName {
    switch (this) {
      case ProductCategory.pizza:
        return 'Pizzas';
      case ProductCategory.bebida:
        return 'Bebidas';
      case ProductCategory.sobremesa:
        return 'Sobremesas';
      case ProductCategory.outros:
        return 'Outros';
    }
  }

  static ProductCategory fromString(String value) {
    switch (value) {
      case 'pizza':
        return ProductCategory.pizza;
      case 'bebida':
        return ProductCategory.bebida;
      case 'sobremesa':
        return ProductCategory.sobremesa;
      case 'outros':
        return ProductCategory.outros;
      default:
        throw ArgumentError('Invalid product category: $value');
    }
  }
}

extension PizzaSizeExtension on PizzaSize {
  String get value {
    switch (this) {
      case PizzaSize.pequena:
        return 'pequena';
      case PizzaSize.media:
        return 'media';
      case PizzaSize.grande:
        return 'grande';
    }
  }

  String get displayName {
    switch (this) {
      case PizzaSize.pequena:
        return 'Pequena';
      case PizzaSize.media:
        return 'Média';
      case PizzaSize.grande:
        return 'Grande';
    }
  }

  static PizzaSize fromString(String value) {
    switch (value) {
      case 'pequena':
        return PizzaSize.pequena;
      case 'media':
        return PizzaSize.media;
      case 'grande':
        return PizzaSize.grande;
      default:
        throw ArgumentError('Invalid pizza size: $value');
    }
  }
}
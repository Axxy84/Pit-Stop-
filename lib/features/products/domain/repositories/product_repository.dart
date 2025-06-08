import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ProductEntity> createProduct(ProductEntity product);
  Future<ProductEntity> updateProduct(ProductEntity product);
  Future<void> deleteProduct(int id);
  Future<ProductEntity?> getProductById(int id);
  Future<List<ProductEntity>> getAllProducts();
  Future<List<ProductEntity>> getActiveProducts();
  Future<List<ProductEntity>> getProductsByCategory(ProductCategory category);
  Future<void> toggleProductStatus(int id, bool isActive);
}
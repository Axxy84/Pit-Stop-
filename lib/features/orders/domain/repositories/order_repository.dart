import '../entities/order_entity.dart';
import '../entities/order_item_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> createOrder(OrderEntity order);
  Future<OrderEntity> updateOrder(OrderEntity order);
  Future<void> deleteOrder(int id);
  Future<OrderEntity?> getOrderById(int id);
  Future<List<OrderEntity>> getAllOrders();
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status);
  Future<List<OrderEntity>> getOrdersByClient(int clientId);
  Future<List<OrderEntity>> getOrdersByDate(DateTime date);
  Future<List<OrderEntity>> getTodayOrders();
  Future<OrderEntity> updateOrderStatus(int orderId, OrderStatus status);
  Future<OrderEntity> assignDeliverer(int orderId, int delivererId);
  
  // Order Items
  Future<OrderItemEntity> addOrderItem(OrderItemEntity item);
  Future<OrderItemEntity> updateOrderItem(OrderItemEntity item);
  Future<void> removeOrderItem(int itemId);
  Future<List<OrderItemEntity>> getOrderItems(int orderId);
  
  // Statistics
  Future<Map<String, dynamic>> getDashboardMetrics();
  Future<Map<String, dynamic>> getOrdersStatistics(DateTime from, DateTime to);
}
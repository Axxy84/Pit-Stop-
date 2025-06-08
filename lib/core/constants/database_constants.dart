class DatabaseConstants {
  static const String databaseName = 'pit_stop_pizzaria.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String usersTable = 'users';
  static const String clientsTable = 'clients';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String deliverersTable = 'deliverers';
  static const String cashClosingsTable = 'cash_closings';

  // Common Columns
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Users Table
  static const String columnUsername = 'username';
  static const String columnPasswordHash = 'password_hash';
  static const String columnRole = 'role';
  static const String columnActive = 'active';

  // Clients Table
  static const String columnName = 'name';
  static const String columnPhone = 'phone';
  static const String columnAddress = 'address';
  static const String columnEmail = 'email';

  // Products Table
  static const String columnCategory = 'category';
  static const String columnDescription = 'description';
  static const String columnPriceSmall = 'price_small';
  static const String columnPriceMedium = 'price_medium';
  static const String columnPriceLarge = 'price_large';
  static const String columnFixedPrice = 'fixed_price';

  // Orders Table
  static const String columnClientId = 'client_id';
  static const String columnTotal = 'total';
  static const String columnStatus = 'status';
  static const String columnPaymentMethod = 'payment_method';
  static const String columnDelivererId = 'deliverer_id';
  static const String columnObservations = 'observations';

  // Order Items Table
  static const String columnOrderId = 'order_id';
  static const String columnProductId = 'product_id';
  static const String columnQuantity = 'quantity';
  static const String columnSize = 'size';
  static const String columnUnitPrice = 'unit_price';
  static const String columnSubtotal = 'subtotal';

  // Deliverers Table
  static const String columnVehicle = 'vehicle';
  static const String columnLicensePlate = 'license_plate';

  // Cash Closings Table
  static const String columnDate = 'date';
  static const String columnTotalOrders = 'total_orders';
  static const String columnTotalRevenue = 'total_revenue';
  static const String columnMoneyAmount = 'money_amount';
  static const String columnCardAmount = 'card_amount';
  static const String columnPixAmount = 'pix_amount';

  // Enums
  static const List<String> userRoles = ['admin', 'employee', 'deliverer'];
  static const List<String> orderStatuses = [
    'pending',
    'preparing',
    'ready',
    'out_for_delivery',
    'delivered',
    'cancelled'
  ];
  static const List<String> paymentMethods = ['money', 'card', 'pix'];
  static const List<String> productCategories = [
    'pizza',
    'bebida',
    'sobremesa',
    'entrada'
  ];
  static const List<String> pizzaSizes = ['pequena', 'media', 'grande'];
}
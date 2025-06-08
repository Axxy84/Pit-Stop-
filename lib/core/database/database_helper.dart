import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  factory DatabaseHelper() => _instance;
  
  DatabaseHelper._internal();

  static const String _databaseName = 'pit_stop.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
  }

  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('PRAGMA journal_mode = WAL');
    await db.execute('PRAGMA synchronous = NORMAL');
    await db.execute('PRAGMA cache_size = 10000');
    await db.execute('PRAGMA temp_store = MEMORY');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL CHECK (role IN ('admin', 'operator')),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    batch.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL CHECK (category IN ('pizza', 'bebida', 'sobremesa', 'outros')),
        price_small REAL,
        price_medium REAL,
        price_large REAL,
        price_fixed REAL,
        has_sizes INTEGER NOT NULL DEFAULT 0 CHECK (has_sizes IN (0, 1)),
        active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    batch.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT UNIQUE NOT NULL,
        address TEXT,
        neighborhood TEXT,
        reference TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    batch.execute('''
      CREATE TABLE deliverers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT UNIQUE NOT NULL,
        vehicle_type TEXT CHECK (vehicle_type IN ('moto', 'carro', 'bicicleta')),
        active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    batch.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        deliverer_id INTEGER,
        status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'preparing', 'outForDelivery', 'delivered', 'cancelled')),
        payment_method TEXT NOT NULL CHECK (payment_method IN ('dinheiro', 'pix', 'cartao')),
        total_amount REAL NOT NULL,
        payment_amount REAL,
        change_amount REAL DEFAULT 0,
        delivery_fee REAL DEFAULT 0,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        delivered_at TEXT,
        FOREIGN KEY (client_id) REFERENCES clients (id),
        FOREIGN KEY (deliverer_id) REFERENCES deliverers (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        size TEXT CHECK (size IN ('pequena', 'media', 'grande')),
        quantity INTEGER NOT NULL DEFAULT 1,
        unit_price REAL NOT NULL,
        subtotal REAL NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE cash_closings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT UNIQUE NOT NULL,
        total_orders INTEGER NOT NULL DEFAULT 0,
        total_revenue REAL NOT NULL DEFAULT 0,
        cash_revenue REAL NOT NULL DEFAULT 0,
        pix_revenue REAL NOT NULL DEFAULT 0,
        card_revenue REAL NOT NULL DEFAULT 0,
        delivery_fees REAL NOT NULL DEFAULT 0,
        notes TEXT,
        closed_by INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (closed_by) REFERENCES users (id)
      )
    ''');

    batch.execute('CREATE INDEX idx_orders_status ON orders(status)');
    batch.execute('CREATE INDEX idx_orders_created_at ON orders(created_at)');
    batch.execute('CREATE INDEX idx_orders_client_id ON orders(client_id)');
    batch.execute('CREATE INDEX idx_clients_phone ON clients(phone)');
    batch.execute('CREATE INDEX idx_products_category ON products(category)');
    batch.execute('CREATE INDEX idx_cash_closings_date ON cash_closings(date)');

    await batch.commit(noResult: true);

    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    
  }

  Future<void> _insertInitialData(Database db) async {
    final adminPasswordHash = _hashPassword('admin123');
    
    await db.insert('users', {
      'username': 'admin',
      'password_hash': adminPasswordHash,
      'role': 'admin',
    });

    await db.insert('users', {
      'username': 'operador',
      'password_hash': _hashPassword('op123'),
      'role': 'operator',
    });

    final pizzaProducts = [
      {'name': 'Pizza Margherita', 'category': 'pizza', 'price_small': 25.00, 'price_medium': 35.00, 'price_large': 45.00, 'has_sizes': 1},
      {'name': 'Pizza Calabresa', 'category': 'pizza', 'price_small': 27.00, 'price_medium': 37.00, 'price_large': 47.00, 'has_sizes': 1},
      {'name': 'Pizza Portuguesa', 'category': 'pizza', 'price_small': 30.00, 'price_medium': 40.00, 'price_large': 50.00, 'has_sizes': 1},
      {'name': 'Pizza Frango c/ Catupiry', 'category': 'pizza', 'price_small': 32.00, 'price_medium': 42.00, 'price_large': 52.00, 'has_sizes': 1},
    ];

    final otherProducts = [
      {'name': 'Coca-Cola 2L', 'category': 'bebida', 'price_fixed': 8.00, 'has_sizes': 0},
      {'name': 'Coca-Cola Lata', 'category': 'bebida', 'price_fixed': 5.00, 'has_sizes': 0},
      {'name': 'Água 500ml', 'category': 'bebida', 'price_fixed': 3.00, 'has_sizes': 0},
      {'name': 'Brigadeiro', 'category': 'sobremesa', 'price_fixed': 4.00, 'has_sizes': 0},
      {'name': 'Pudim', 'category': 'sobremesa', 'price_fixed': 6.00, 'has_sizes': 0},
    ];

    for (final product in [...pizzaProducts, ...otherProducts]) {
      await db.insert('products', product);
    }

    await db.insert('deliverers', {
      'name': 'João Silva',
      'phone': '(11) 99999-1111',
      'vehicle_type': 'moto',
    });

    await db.insert('deliverers', {
      'name': 'Maria Santos',
      'phone': '(11) 99999-2222',
      'vehicle_type': 'carro',
    });
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> verifyPassword(String password, String hash) async {
    return _hashPassword(password) == hash;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> reset() async {
    await close();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    await File(path).delete();
    _database = await _initDatabase();
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }

  Future<List<Map<String, dynamic>>> getActiveProducts() async {
    final db = await database;
    return await db.query(
      'products',
      where: 'active = 1',
      orderBy: 'category, name',
    );
  }

  Future<Map<String, dynamic>?> getClientByPhone(String phone) async {
    final db = await database;
    final result = await db.query(
      'clients',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }

  Future<List<Map<String, dynamic>>> getActiveDeliverers() async {
    final db = await database;
    return await db.query(
      'deliverers',
      where: 'active = 1',
      orderBy: 'name',
    );
  }

  Future<List<Map<String, dynamic>>> getTodayOrders() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await db.rawQuery('''
      SELECT o.*, c.name as client_name, c.phone as client_phone,
             d.name as deliverer_name
      FROM orders o
      LEFT JOIN clients c ON o.client_id = c.id
      LEFT JOIN deliverers d ON o.deliverer_id = d.id
      WHERE DATE(o.created_at) = ?
      ORDER BY o.created_at DESC
    ''', [today]);
  }

  Future<Map<String, dynamic>> getDashboardMetrics() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT 
        COUNT(*) as total_orders,
        COALESCE(SUM(CASE WHEN status = 'delivered' THEN total_amount ELSE 0 END), 0) as revenue,
        COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_orders,
        COUNT(CASE WHEN status = 'preparing' THEN 1 END) as preparing_orders,
        COUNT(CASE WHEN status = 'outForDelivery' THEN 1 END) as out_for_delivery
      FROM orders
      WHERE DATE(created_at) = ?
    ''', [today]);
    
    return result.first;
  }
}
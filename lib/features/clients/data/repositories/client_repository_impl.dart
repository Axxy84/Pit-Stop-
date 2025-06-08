import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/database_exceptions.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/repositories/client_repository.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final DatabaseHelper _databaseHelper;

  ClientRepositoryImpl(this._databaseHelper);

  @override
  Future<ClientEntity> createClient(ClientEntity client) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now();
      
      final clientModel = ClientModel.fromEntity(client).copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await db.insert('clients', clientModel.toInsertJson());
      return clientModel.copyWith(id: id).toEntity();
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw DatabaseDuplicateException('phone');
      }
      throw DatabaseOperationException('create client', e.toString());
    }
  }

  @override
  Future<ClientEntity> updateClient(ClientEntity client) async {
    try {
      final db = await _databaseHelper.database;
      
      if (client.id == null) {
        throw DatabaseValidationException('id', 'Client ID is required for update');
      }

      final clientModel = ClientModel.fromEntity(client).copyWith(
        updatedAt: DateTime.now(),
      );

      final updateData = clientModel.toJson();
      updateData.remove('created_at'); // Don't update creation date

      final updatedRows = await db.update(
        'clients',
        updateData,
        where: 'id = ?',
        whereArgs: [client.id],
      );

      if (updatedRows == 0) {
        throw DatabaseNotFoundException('Client');
      }

      return clientModel.toEntity();
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw DatabaseDuplicateException('phone');
      }
      throw DatabaseOperationException('update client', e.toString());
    }
  }

  @override
  Future<void> deleteClient(int id) async {
    try {
      final db = await _databaseHelper.database;
      final deletedRows = await db.delete(
        'clients',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (deletedRows == 0) {
        throw DatabaseNotFoundException('Client');
      }
    } catch (e) {
      throw DatabaseOperationException('delete client', e.toString());
    }
  }

  @override
  Future<ClientEntity?> getClientById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'clients',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) return null;
      
      return ClientModel.fromJson(result.first).toEntity();
    } catch (e) {
      throw DatabaseOperationException('get client by id', e.toString());
    }
  }

  @override
  Future<ClientEntity?> getClientByPhone(String phone) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'clients',
        where: 'phone = ?',
        whereArgs: [phone],
        limit: 1,
      );

      if (result.isEmpty) return null;
      
      return ClientModel.fromJson(result.first).toEntity();
    } catch (e) {
      throw DatabaseOperationException('get client by phone', e.toString());
    }
  }

  @override
  Future<List<ClientEntity>> getAllClients() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'clients',
        orderBy: 'name ASC',
      );

      return result
          .map((json) => ClientModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw DatabaseOperationException('get all clients', e.toString());
    }
  }

  @override
  Future<List<ClientEntity>> searchClients(String query) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'clients',
        where: 'name LIKE ? OR phone LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'name ASC',
      );

      return result
          .map((json) => ClientModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw DatabaseOperationException('search clients', e.toString());
    }
  }

  @override
  Future<ClientEntity> findOrCreateClient(
    String name, 
    String phone, {
    String? address,
  }) async {
    try {
      // Primeiro tenta encontrar o cliente pelo telefone
      final existingClient = await getClientByPhone(phone);
      if (existingClient != null) {
        return existingClient;
      }

      // Se não encontrar, cria um novo cliente
      final now = DateTime.now();
      final newClient = ClientEntity(
        name: name,
        phone: phone,
        address: address,
        createdAt: now,
        updatedAt: now,
      );

      return await createClient(newClient);
    } catch (e) {
      throw DatabaseOperationException('find or create client', e.toString());
    }
  }
}
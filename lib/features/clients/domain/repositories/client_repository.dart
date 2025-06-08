import '../entities/client_entity.dart';

abstract class ClientRepository {
  Future<ClientEntity> createClient(ClientEntity client);
  Future<ClientEntity> updateClient(ClientEntity client);
  Future<void> deleteClient(int id);
  Future<ClientEntity?> getClientById(int id);
  Future<ClientEntity?> getClientByPhone(String phone);
  Future<List<ClientEntity>> getAllClients();
  Future<List<ClientEntity>> searchClients(String query);
  Future<ClientEntity> findOrCreateClient(String name, String phone, {String? address});
}
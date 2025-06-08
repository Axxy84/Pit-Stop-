abstract class DatabaseException implements Exception {
  final String message;
  final String? details;
  
  const DatabaseException(this.message, [this.details]);
  
  @override
  String toString() => 'DatabaseException: $message${details != null ? ' - $details' : ''}';
}

class DatabaseConnectionException extends DatabaseException {
  const DatabaseConnectionException([String? details]) 
      : super('Falha na conexão com o banco de dados', details);
}

class DatabaseOperationException extends DatabaseException {
  const DatabaseOperationException(String operation, [String? details]) 
      : super('Falha na operação: $operation', details);
}

class DatabaseConstraintException extends DatabaseException {
  const DatabaseConstraintException(String constraint, [String? details]) 
      : super('Violação de restrição: $constraint', details);
}

class DatabaseNotFoundException extends DatabaseException {
  const DatabaseNotFoundException(String entity, [String? details]) 
      : super('$entity não encontrado', details);
}

class DatabaseDuplicateException extends DatabaseException {
  const DatabaseDuplicateException(String field, [String? details]) 
      : super('Registro duplicado para: $field', details);
}

class DatabaseValidationException extends DatabaseException {
  const DatabaseValidationException(String field, [String? details]) 
      : super('Dados inválidos para: $field', details);
}

class DatabaseMigrationException extends DatabaseException {
  const DatabaseMigrationException(int version, [String? details]) 
      : super('Falha na migração para versão: $version', details);
}
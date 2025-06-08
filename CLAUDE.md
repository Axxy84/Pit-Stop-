# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Pit Stop** é um ecossistema completo de gestão de pizzaria desenvolvido em Flutter, seguindo Clean Architecture com Riverpod para gerenciamento de estado e SQLite como banco de dados local.

## Current Implementation Status (v2.0.0-database)

### ✅ Completed Features
1. **SQLite Database**: Full implementation with 7 tables
2. **Clean Architecture**: Complete structure with domain/data/presentation layers
3. **Authentication System**: Login page with SHA256 encryption
4. **Entities & Models**: All 7 core entities implemented
5. **Repositories**: Auth, Client, Product, Order repositories
6. **Riverpod Providers**: State management configured
7. **Error Handling**: Custom exceptions for all scenarios
8. **Database Seeds**: Initial data for testing

### 🚧 Next Implementation Phase
1. **Dashboard**: Operational metrics and KPIs
2. **Product CRUD**: Complete product management
3. **Order System**: Order creation and tracking
4. **Client Management**: Search and registration
5. **Delivery Control**: Deliverer assignment
6. **Cash Closing**: Daily financial reports

### Escopo do Sistema
- **App Principal (Desktop/Tablet)**: Sistema completo de gestão interna
- **App Entregador (Mobile)**: Recebimento e gestão de entregas  
- **App Dono (Mobile)**: Monitoramento e fechamento de caixa remoto

### Stack Tecnológica
- **Frontend**: Flutter com Clean Architecture
- **Estado**: Riverpod com code generation
- **Navegação**: GoRouter
- **Database**: SQLite local
- **Autenticação**: Local simples (sem JWT)

## Essential Commands

### Development
- `flutter run` - Executar app em modo debug
- `flutter run -d windows` - Executar no Windows (desktop)
- `flutter run -d chrome` - Executar no navegador
- `dart run build_runner build` - Gerar código Riverpod
- `dart run build_runner watch` - Observar mudanças para code generation

### Build & Analysis
- `flutter build windows` - Build para Windows
- `flutter build apk` - Build Android APK
- `flutter analyze` - Análise estática
- `flutter pub get` - Instalar dependências

### Database
- `flutter packages pub run sqflite:setup` - Setup SQLite
- Migrations são executadas automaticamente no DatabaseHelper

## Code Architecture

### Estrutura Clean Architecture
```
lib/
├── core/
│   ├── constants/        # Constantes da aplicação
│   ├── database/        # DatabaseHelper e configurações SQLite
│   ├── errors/          # Classes de erro customizadas
│   └── utils/           # Utilitários compartilhados
├── features/            # Funcionalidades por domínio
│   ├── auth/           # Autenticação local
│   ├── dashboard/      # Dashboard operacional
│   ├── orders/         # Gestão de pedidos (CORE)
│   ├── products/       # Gestão de produtos
│   ├── clients/        # Gestão de clientes
│   ├── deliverers/     # Gestão de entregadores
│   └── cash_closing/   # Fechamento de caixa (CRÍTICO)
└── shared/
    ├── widgets/        # Widgets reutilizáveis
    └── theme/          # Tema da aplicação
```

### Padrões Obrigatórios

#### State Management (Riverpod)
```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();
  // Implementação...
}
```

#### Database (SQLite)
- Singleton pattern no DatabaseHelper
- Repositories para cada entidade
- Transactions para operações críticas
- Schema versionado com migrations

#### Navegação (GoRouter)
- Rotas protegidas por autenticação
- Estados de loading/error globais
- Navegação type-safe

### Funcionalidades Críticas (Prioridade 1)

1. **Autenticação Local**: Login simples com hash de senha
2. **Gestão de Pedidos**: Busca cliente, criação automática, cálculos
3. **Fechamento de Caixa**: Resumos precisos, validações financeiras
4. **Dashboard Operacional**: KPIs em tempo real, auto-refresh

### Database Schema Principal
```sql
-- Core tables: users, products, clients, orders, deliverers, cash_closings
-- Relacionamentos: orders -> clients, deliverers
-- Constraints: unique phones, date validations
```

### Code Quality
- Riverpod code generation obrigatório
- Clean Architecture rigorosa
- Error handling com Either pattern
- Testes unitários para repositories
- Lint rules configuradas

### Comandos Específicos do Projeto
```bash
# Gerar código Riverpod (obrigatório após mudanças)
dart run build_runner build --delete-conflicting-outputs

# Reset database (desenvolvimento)
flutter clean && flutter pub get && flutter run

# Build para produção
flutter build windows --release
```

## Business Rules

### Regras de Negócio Críticas
- Fechamento de caixa: apenas pedidos "delivered" contam
- Cliente: criação automática se telefone não existir
- Pedidos: status flow obrigatório (pending -> preparing -> outForDelivery -> delivered)
- Pagamento: cálculo automático de troco para "dinheiro"

### Validações Essenciais
- Telefone único por cliente
- Uma data por fechamento de caixa
- Preços por tamanho (pizzas) vs preço fixo (outros)
- Total do pedido = soma dos subtotais dos itens

## Database Implementation Details (v2.0.0)

### Database Structure
- **7 Tables**: users, clients, products, orders, order_items, deliverers, cash_closings
- **Foreign Keys**: Enabled with CASCADE delete on order_items
- **Indexes**: Optimized for phone, status, date searches
- **Constraints**: UNIQUE on phones, CHECK on status/payment methods

### Available Users
- **admin / admin123** - Administrator role
- **operador / op123** - Operator role

### Key Files Created
- `lib/core/database/database_helper.dart` - Main database singleton
- `lib/core/database/database_initializer.dart` - Desktop FFI support
- `lib/features/auth/presentation/pages/login_page.dart` - Login UI
- All entities, models, repositories in respective feature folders
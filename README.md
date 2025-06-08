# 🍕 Pit Stop Pizzaria

Sistema completo de gestão de pizzaria desenvolvido em Flutter com Clean Architecture.

## 📋 Sobre o Projeto

O **Pit Stop Pizzaria** é um ecossistema integrado para gestão completa de pizzarias, oferecendo controle total desde o pedido até a entrega.

### 🎯 Funcionalidades Principais

- ✅ **Gestão de Pedidos**: Criação, acompanhamento e controle de status
- ✅ **Cadastro de Clientes**: Busca automática e criação de perfis
- ✅ **Controle de Produtos**: Cardápio com preços por tamanho
- ✅ **Gestão de Entregadores**: Controle de rotas e entregas
- ✅ **Fechamento de Caixa**: Relatórios financeiros diários
- ✅ **Dashboard Operacional**: KPIs em tempo real

### 🏗️ Arquitetura

O sistema segue os princípios da **Clean Architecture** garantindo:

- **Separação de Responsabilidades**
- **Facilidade de Manutenção**
- **Testabilidade**
- **Escalabilidade**

## 🛠️ Stack Tecnológica

### Frontend
- **Flutter 3.8+**: Framework multiplataforma
- **Dart**: Linguagem de programação
- **Material 3**: Design system moderno

### State Management
- **Riverpod 2.5+**: Gerenciamento de estado reativo
- **Code Generation**: Geração automática de providers

### Database
- **SQLite**: Banco de dados local
- **sqflite**: Plugin oficial para Flutter

### Navegação
- **GoRouter**: Roteamento type-safe
- **Context-based Navigation**: Navegação responsiva

### Utilitários
- **crypto**: Criptografia para senhas
- **path_provider**: Acesso ao sistema de arquivos

## 📱 Tipos de Aplicação

### 🖥️ App Principal (Desktop/Tablet)
- **Finalidade**: Gestão completa interna
- **Usuários**: Funcionários da pizzaria
- **Funcionalidades**: Todas as operações do sistema

### 📱 App Entregador (Mobile)
- **Finalidade**: Gestão de entregas
- **Usuários**: Entregadores
- **Funcionalidades**: Recebimento e acompanhamento de entregas

### 📱 App Dono (Mobile)
- **Finalidade**: Monitoramento remoto
- **Usuários**: Proprietários
- **Funcionalidades**: Fechamento de caixa e relatórios

## 🚀 Como Executar

### Pré-requisitos

- **Flutter SDK 3.8+**
- **Dart SDK 3.0+**
- **Git**

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/Axxy84/Pit-Stop-.git
cd Pit-Stop-
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o code generation**
```bash
dart run build_runner build
```

4. **Execute o aplicativo**
```bash
# Desktop (Windows)
flutter run -d windows

# Web
flutter run -d chrome

# Debug geral
flutter run
```

## 🗃️ Banco de Dados

### Schema Principal

```sql
-- Usuários do sistema
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL,
  created_at TEXT NOT NULL
);

-- Clientes da pizzaria
CREATE TABLE clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  address TEXT,
  created_at TEXT NOT NULL
);

-- Produtos do cardápio
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  price_small REAL,
  price_medium REAL,
  price_large REAL,
  fixed_price REAL,
  active BOOLEAN DEFAULT 1
);

-- Pedidos
CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER NOT NULL,
  total REAL NOT NULL,
  status TEXT NOT NULL,
  payment_method TEXT NOT NULL,
  deliverer_id INTEGER,
  created_at TEXT NOT NULL,
  FOREIGN KEY (client_id) REFERENCES clients (id),
  FOREIGN KEY (deliverer_id) REFERENCES deliverers (id)
);
```

## 📁 Estrutura do Projeto

```
lib/
├── core/                    # Núcleo da aplicação
│   ├── constants/          # Constantes globais
│   ├── database/           # DatabaseHelper e configurações
│   ├── errors/             # Classes de erro customizadas
│   └── utils/              # Utilitários compartilhados
├── features/               # Funcionalidades por domínio
│   ├── auth/              # Autenticação local
│   ├── dashboard/         # Dashboard operacional
│   ├── orders/            # Gestão de pedidos (CORE)
│   ├── products/          # Gestão de produtos
│   ├── clients/           # Gestão de clientes
│   ├── deliverers/        # Gestão de entregadores
│   └── cash_closing/      # Fechamento de caixa
└── shared/
    ├── widgets/           # Widgets reutilizáveis
    └── theme/             # Tema da aplicação
```

## 🧪 Testes

### Executar testes
```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/widget_test.dart

# Cobertura
flutter test --coverage
```

### Tipos de Teste
- **Unit Tests**: Lógica de negócio
- **Widget Tests**: Interface do usuário
- **Integration Tests**: Fluxos completos

## 📊 Comandos Essenciais

### Development
```bash
# Executar em modo debug
flutter run

# Executar em modo release
flutter run --release

# Executar no Windows
flutter run -d windows

# Hot reload automático
flutter run --hot
```

### Code Generation
```bash
# Gerar código Riverpod
dart run build_runner build

# Watch para mudanças
dart run build_runner watch

# Limpar e regenerar
dart run build_runner build --delete-conflicting-outputs
```

### Build & Deploy
```bash
# Build para Windows
flutter build windows --release

# Build APK Android
flutter build apk --release

# Build Web
flutter build web --release
```

### Análise e Qualidade
```bash
# Análise estática
flutter analyze

# Formatação de código
dart format .

# Verificar dependências
flutter pub deps
```

## 🔐 Autenticação

### Sistema Local
- **Sem JWT**: Autenticação simples baseada em hash
- **Criptografia**: Senhas protegidas com crypto
- **Roles**: Diferentes níveis de acesso

### Tipos de Usuário
- **Admin**: Acesso total ao sistema
- **Funcionário**: Operações básicas
- **Entregador**: Apenas entregas

## 💰 Regras de Negócio

### Pedidos
- Status obrigatório: `pending → preparing → outForDelivery → delivered`
- Cálculo automático de troco para pagamento em dinheiro
- Total = soma dos subtotais dos itens

### Clientes
- Criação automática se telefone não existir
- Telefone único por cliente
- Histórico de pedidos

### Fechamento de Caixa
- Apenas pedidos "delivered" contam no faturamento
- Uma data por fechamento
- Validações financeiras obrigatórias

### Produtos
- Preços por tamanho (pizzas) vs preço fixo (bebidas)
- Categorização automática
- Controle de estoque opcional

## 🎨 Design System

### Cores Principais
- **Vermelho Primary**: `#D32F2F`
- **Cinza Escuro**: `#212121`
- **Dourado**: `#FFD700`
- **Verde Sucesso**: `#4CAF50`

### Tipografia
- **Fonte Principal**: Poppins
- **Header**: 24px Bold
- **Body**: 16px Regular
- **Caption**: 14px Medium

## 📈 Roadmap

### v1.0 - Interface ✅
- [x] Layout responsivo
- [x] Menu lateral
- [x] Tema personalizado
- [x] Logo integrada

### v2.0 - Banco de Dados 🚧
- [ ] SQLite configurado
- [ ] Migrations automáticas
- [ ] Repositories implementados
- [ ] Testes de database

### v3.0 - CRUD Básico 📋
- [ ] Gestão de produtos
- [ ] Cadastro de clientes
- [ ] Criação de pedidos
- [ ] Sistema de autenticação

### v4.0 - Operações Avançadas 🚀
- [ ] Dashboard com métricas
- [ ] Fechamento de caixa
- [ ] Relatórios financeiros
- [ ] Sistema de entregas

## 🤝 Contribuição

### Como Contribuir
1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit suas mudanças: `git commit -m 'feat: adiciona nova funcionalidade'`
4. Push para a branch: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

### Padrões de Commit
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação
- `refactor:` Refatoração
- `test:` Testes

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Contato

- **Projeto**: Pit Stop Pizzaria
- **Repositório**: https://github.com/Axxy84/Pit-Stop-
- **Issues**: https://github.com/Axxy84/Pit-Stop-/issues

---

**🍕 Desenvolvido com ❤️ para revolucionar a gestão de pizzarias!**
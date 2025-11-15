# MongoDB Only Setup - NUDGE App

## ✅ Migração Completa do Firebase para MongoDB

O app NUDGE agora usa **apenas MongoDB** para autenticação e armazenamento de dados. O Firebase Auth foi removido completamente.

## 🎯 O que foi feito

### 1. Backend (Node.js/Express)
- ✅ Criado sistema de autenticação com MongoDB
- ✅ Modelo `Auth` para gerenciar tokens e senhas
- ✅ Rotas de autenticação (`/api/auth/login`, `/api/auth/register`, `/api/auth/logout`, `/api/auth/verify`)
- ✅ Rotas de usuários com métodos admin
- ✅ Conexão com MongoDB Atlas configurada
- ✅ Scripts de inicialização do banco de dados

### 2. Frontend (Flutter)
- ✅ Criado `ApiService` para substituir `FirebaseService`
- ✅ Atualizado `AppProvider` para usar `ApiService`
- ✅ Atualizado `SubscriptionProvider` para usar `ApiService`
- ✅ Removida inicialização do Firebase do `main.dart`
- ✅ Atualizadas todas as telas para usar `ApiService`

### 3. Banco de Dados (MongoDB)
- ✅ Coleção `auths` - autenticação e tokens
- ✅ Coleção `users` - perfis de usuários
- ✅ Coleção `subscriptions` - assinaturas
- ✅ Coleção `meals` - refeições
- ✅ Coleção `bodymetrics` - métricas corporais
- ✅ Coleção `waterintakes` - consumo de água

## 📋 Usuários de Teste

### Admin
- **Email**: `admin@test.com`
- **Senha**: `admin123`
- **Role**: `admin`

### User
- **Email**: `user@test.com`
- **Senha**: `user123`
- **Role**: `user`

## 🚀 Como usar

### 1. Inicializar Banco de Dados
```bash
cd backend
npm run init-db
```

### 2. Criar Usuários de Teste
```bash
cd backend
npm run create-test-users
```

### 3. Iniciar Backend
```bash
cd backend
npm start
# ou
npm run dev
```

### 4. Configurar Backend URL no App
Edite `lib/config/payment_config.dart`:
```dart
static const String backendApiUrl = 'http://localhost:3000';
// Para produção, use: 'https://seu-backend.com'
```

### 5. Executar App Flutter
```bash
flutter run
```

## 🔐 Autenticação

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "admin@test.com",
  "password": "admin123"
}
```

**Resposta:**
```json
{
  "success": true,
  "token": "abc123...",
  "user": {
    "id": "...",
    "name": "Admin Test",
    "email": "admin@test.com",
    "role": "admin",
    "currentPlan": "free",
    ...
  }
}
```

### Registrar
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "senha123",
  "name": "Nome do Usuário",
  "birthDate": "1990-01-01T00:00:00.000Z",
  "height": 175,
  "weight": 70,
  "bodyType": "mesomorfo",
  "goal": "manutenção",
  "targetWeight": 70,
  "dailyCalorieGoal": 2000,
  "macroGoals": {
    "protein": 150,
    "carbs": 200,
    "fat": 65
  }
}
```

### Verificar Token
```http
GET /api/auth/verify
Authorization: Bearer abc123...
```

### Logout
```http
POST /api/auth/logout
Authorization: Bearer abc123...
```

## 📡 Endpoints da API

### Autenticação
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Registrar
- `POST /api/auth/logout` - Logout
- `GET /api/auth/verify` - Verificar token

### Usuários
- `GET /api/users` - Listar todos os usuários (admin)
- `GET /api/users/:userId` - Obter usuário por ID
- `POST /api/users` - Criar/atualizar usuário
- `PUT /api/users/:userId` - Atualizar usuário
- `DELETE /api/users/:userId` - Deletar usuário (admin)
- `PUT /api/users/:userId/role` - Atualizar role (admin)

### Estatísticas (Admin)
- `GET /api/users/stats/count` - Contar usuários
- `GET /api/users/stats/active` - Contar usuários ativos
- `GET /api/users/stats/meals-today` - Contar refeições hoje

### Assinaturas
- `GET /api/subscriptions/user/:userId` - Listar assinaturas do usuário
- `GET /api/subscriptions/user/:userId/active` - Obter assinatura ativa
- `POST /api/subscriptions` - Criar assinatura

## 🔒 Segurança

### Tokens
- Tokens são gerados usando `crypto.randomBytes(32)`
- Tokens expiram em 30 dias
- Tokens são armazenados no MongoDB
- Tokens são removidos no logout

### Senhas
- Senhas são hasheadas usando SHA-256
- ⚠️ **Nota**: Em produção, use `bcrypt` para hash de senhas
- Senhas nunca são retornadas nas respostas da API

### Autenticação
- Todas as rotas protegidas requerem token no header `Authorization: Bearer <token>`
- Token é verificado em cada requisição
- Token expirado retorna erro 401

## 📝 Próximos Passos

1. **Implementar bcrypt para hash de senhas** (mais seguro que SHA-256)
2. **Implementar refresh tokens** (para renovação automática)
3. **Implementar rate limiting** (para prevenir ataques)
4. **Implementar CORS adequado** (para produção)
5. **Implementar validação de dados** (usando Joi ou similar)
6. **Implementar logs de auditoria** (para rastreamento)
7. **Implementar testes** (unitários e de integração)

## 🐛 Problemas Conhecidos

1. **Índices duplicados**: Aviso no modelo `Auth` sobre índices duplicados (não afeta funcionalidade)
2. **SHA-256 para senhas**: Deve ser substituído por `bcrypt` em produção
3. **Tokens não expiram automaticamente**: Implementar limpeza periódica
4. **CORS amplo**: Deve ser restrito em produção

## 📚 Documentação Adicional

- `backend/INSTRUCOES.md` - Instruções detalhadas do backend
- `backend/README.md` - README do backend
- `STRIPE_CONFIGURACAO.md` - Configuração do Stripe
- `MERCADOPAGO_CONFIGURACAO.md` - Configuração do Mercado Pago

## ✅ Status

- ✅ Autenticação funcionando
- ✅ Usuários de teste criados
- ✅ Banco de dados inicializado
- ✅ API endpoints funcionando
- ✅ App Flutter atualizado
- ⚠️ Firebase completamente removido

## 🎉 Conclusão

O app NUDGE agora está completamente migrado para MongoDB, sem dependência do Firebase Auth. Todos os dados são armazenados no MongoDB Atlas e a autenticação é gerenciada pelo backend Node.js.


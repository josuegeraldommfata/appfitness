# Backend Setup Completo - NUDGE

## ✅ O que foi criado

### 1. Estrutura do Backend
- **Configuração MongoDB**: `backend/config/mongodb.js`
- **Modelos**: User, Subscription, Meal, BodyMetrics, WaterIntake
- **Rotas**: Stripe, Mercado Pago, Users, Subscriptions
- **Scripts**: Inicialização do banco de dados
- **Servidor**: Express.js com todas as rotas configuradas

### 2. MongoDB Atlas
- **String de conexão configurada**: `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge`
- **Script de inicialização**: `backend/scripts/initDatabase.js`
- **Coleções criadas automaticamente**: users, subscriptions, meals, bodymetrics, waterintakes

### 3. Integração Stripe
- **Chave secreta configurada**: `sk_live_...` (configure no arquivo .env)
- **Endpoints criados**: 
  - `POST /api/stripe/create-payment-intent`
  - `POST /api/stripe/create-subscription`
  - `POST /api/stripe/webhook`

### 4. Integração Mercado Pago
- **Endpoints criados**:
  - `POST /api/mercado-pago/create-preference`
  - `GET /api/mercado-pago/verify-payment`
  - `POST /api/mercado-pago/webhook`

## 🚀 Como Executar

### 1. Instalar Dependências
```bash
cd backend
npm install
```

### 2. Configurar Variáveis de Ambiente
Crie um arquivo `.env` na pasta `backend/`:

```env
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
PORT=3000
NODE_ENV=development
STRIPE_SECRET_KEY=sk_live_... (substitua pela sua chave)
MERCADOPAGO_ACCESS_TOKEN=APP_USR-... (substitua pelo seu token)
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
```

### 3. Inicializar Banco de Dados
```bash
npm run init-db
```

### 4. Iniciar Servidor
```bash
npm start
```

Ou para desenvolvimento:
```bash
npm run dev
```

## 📋 Coleções Criadas

### 1. users
- Armazena informações dos usuários
- Índices: email, id, currentPlan

### 2. subscriptions
- Armazena assinaturas dos usuários
- Índices: userId, status, paymentId, transactionId

### 3. meals
- Armazena refeições registradas
- Índices: userId, dateTime

### 4. bodymetrics
- Armazena métricas corporais
- Índices: userId, date

### 5. waterintakes
- Armazena ingestão de água
- Índices: userId, date (único)

## 🔌 Endpoints da API

### Stripe
- `POST /api/stripe/create-payment-intent` - Criar payment intent
- `POST /api/stripe/create-subscription` - Criar assinatura
- `POST /api/stripe/webhook` - Webhook do Stripe

### Mercado Pago
- `POST /api/mercado-pago/create-preference` - Criar preferência
- `GET /api/mercado-pago/verify-payment` - Verificar pagamento
- `POST /api/mercado-pago/webhook` - Webhook do Mercado Pago

### Usuários
- `GET /api/users/:userId` - Obter usuário
- `POST /api/users` - Criar/atualizar usuário
- `PUT /api/users/:userId` - Atualizar usuário

### Assinaturas
- `GET /api/subscriptions/user/:userId` - Obter assinaturas
- `GET /api/subscriptions/user/:userId/active` - Obter assinatura ativa
- `POST /api/subscriptions` - Criar assinatura
- `PUT /api/subscriptions/:subscriptionId` - Atualizar assinatura
- `DELETE /api/subscriptions/:subscriptionId` - Cancelar assinatura

## 🔧 Configuração do App Mobile

No arquivo `lib/config/payment_config.dart`, a URL do backend já está configurada:

```dart
static const String backendApiUrl = 'http://localhost:3000';
```

**Para desenvolvimento:**
- Android Emulator: `http://10.0.2.2:3000`
- iOS Simulator: `http://localhost:3000`
- Dispositivo físico: `http://SEU_IP_LOCAL:3000`

**Para produção:**
- Atualize para: `https://seu-backend.com`

## 📱 Testar Integração

### 1. Verificar Backend
```bash
curl http://localhost:3000
```

### 2. Verificar Health
```bash
curl http://localhost:3000/health
```

### 3. Testar Payment Intent
```bash
curl -X POST http://localhost:3000/api/stripe/create-payment-intent \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 19.90,
    "currency": "BRL",
    "userId": "test-user-id",
    "planType": "personal",
    "billingPeriod": "monthly"
  }'
```

## 🔒 Segurança

### ⚠️ IMPORTANTE
- **NUNCA** commite o arquivo `.env` no repositório
- Use variáveis de ambiente para credenciais
- Mantenha o arquivo `.env` no `.gitignore`
- Use HTTPS em produção
- Configure CORS adequadamente

## 🐛 Troubleshooting

### Erro: "Cannot find module"
```bash
npm install
```

### Erro: "MongoDB connection error"
1. Verifique se a string de conexão está correta
2. Verifique se seu IP está na whitelist do MongoDB Atlas
3. Verifique se as credenciais estão corretas

### Erro: "Port 3000 already in use"
Altere a porta no arquivo `.env`:
```env
PORT=3001
```

## 📚 Próximos Passos

1. ✅ Configurar variáveis de ambiente
2. ✅ Inicializar banco de dados
3. ✅ Iniciar servidor
4. ⏳ Configurar webhooks do Stripe
5. ⏳ Configurar webhooks do Mercado Pago
6. ⏳ Testar integração com o app mobile
7. ⏳ Deploy em produção

## 🆘 Suporte

Em caso de problemas:
1. Verifique os logs do servidor
2. Verifique a conexão com o MongoDB Atlas
3. Verifique as variáveis de ambiente
4. Consulte a documentação

---

**Status**: ✅ Backend configurado | ✅ MongoDB Atlas configurado | ✅ Scripts criados | ✅ Pronto para uso


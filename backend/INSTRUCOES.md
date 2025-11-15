# Instruções de Instalação e Execução - Backend NUDGE

## 🚀 Passo a Passo

### 1. Instalar Node.js
Certifique-se de ter o Node.js 18+ instalado:
```bash
node --version
```

Se não tiver, baixe em: https://nodejs.org/

### 2. Instalar Dependências
```bash
cd backend
npm install
```

### 3. Configurar Variáveis de Ambiente
Crie um arquivo `.env` na pasta `backend/` com o seguinte conteúdo:

```env
# MongoDB Atlas Configuration
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority

# Server Configuration
PORT=3000
NODE_ENV=development

# Stripe Configuration
STRIPE_SECRET_KEY=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
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

# Mercado Pago Configuration
MERCADOPAGO_ACCESS_TOKEN=APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
MERCADOPAGO_SUCCESS_URL=https://your-app.com/success
MERCADOPAGO_FAILURE_URL=https://your-app.com/failure
MERCADOPAGO_PENDING_URL=https://your-app.com/pending
```

### 4. Inicializar Banco de Dados
Execute o script para criar as coleções e índices:

```bash
npm run init-db
```

Você verá uma saída similar a:
```
🔄 Connecting to MongoDB...
✅ MongoDB connected successfully
📍 Database: nudge
🌐 Host: nudge-shard-00-02.ixd6wep.mongodb.net
📦 Creating collections and indexes...
👤 Creating Users collection...
✅ Users collection ready
💳 Creating Subscriptions collection...
✅ Subscriptions collection ready
🍽️ Creating Meals collection...
✅ Meals collection ready
📊 Creating Body Metrics collection...
✅ Body Metrics collection ready
💧 Creating Water Intake collection...
✅ Water Intake collection ready
✅ Database initialization completed successfully!
```

### 5. Iniciar o Servidor
```bash
npm start
```

Ou para desenvolvimento com auto-reload:
```bash
npm run dev
```

O servidor estará rodando em `http://localhost:3000`

### 6. Verificar se está Funcionando
Abra o navegador e acesse:
```
http://localhost:3000
```

Você deve ver:
```json
{
  "message": "NUDGE Backend API",
  "version": "1.0.0",
  "status": "running"
}
```

## 📋 Comandos Disponíveis

### Inicializar Banco de Dados
```bash
npm run init-db
```

### Iniciar Servidor
```bash
npm start
```

### Modo Desenvolvimento (com auto-reload)
```bash
npm run dev
```

## 🔍 Verificar Conexão com MongoDB

### Via MongoDB Compass
1. Abra o MongoDB Compass
2. Cole a string de conexão:
   ```
   mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge
   ```
3. Clique em "Connect"
4. Você deve ver as coleções criadas

### Via Script Node.js
```bash
node -e "const mongoose = require('mongoose'); mongoose.connect('mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge').then(() => console.log('✅ Connected')).catch(err => console.error('❌ Error:', err))"
```

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

### Erro: "Stripe secret key is invalid"
1. Verifique se a chave secreta está correta
2. Verifique se a chave não expirou
3. Verifique se está usando a chave de produção (sk_live_...)

## 📱 Configurar App Mobile

No arquivo `lib/config/payment_config.dart`, atualize a URL do backend:

```dart
static const String backendApiUrl = 'http://localhost:3000';
```

**Para desenvolvimento local:**
- Android Emulator: `http://10.0.2.2:3000`
- iOS Simulator: `http://localhost:3000`
- Dispositivo físico: `http://SEU_IP_LOCAL:3000`

**Para produção:**
- Atualize para a URL do seu servidor: `https://seu-backend.com`

## 🔒 Segurança

### ⚠️ IMPORTANTE
- **NUNCA** commite o arquivo `.env` no repositório
- Use variáveis de ambiente para credenciais
- Mantenha o arquivo `.env` no `.gitignore`
- Use HTTPS em produção
- Configure CORS adequadamente

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

**Última atualização**: Instruções completas de instalação
**Status**: ✅ Backend configurado | ✅ Scripts criados | ✅ Pronto para uso


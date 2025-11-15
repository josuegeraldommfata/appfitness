# Configuração MongoDB Atlas - NUDGE

## 📋 Informações de Conexão

### String de Conexão
```
mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
```

### Detalhes
- **Usuário**: Nudge
- **Senha**: 320809eu
- **Cluster**: nudge.ixd6wep.mongodb.net
- **Database**: nudge

## 🚀 Configuração Rápida

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
STRIPE_SECRET_KEY=sk_live_YOUR_SECRET_KEY_HERE
```

### 3. Inicializar Banco de Dados
```bash
npm run init-db
```

Este comando irá:
- Conectar ao MongoDB Atlas
- Criar todas as coleções necessárias
- Criar todos os índices
- Verificar a conexão

## 📦 Coleções Criadas

### 1. users
Armazena informações dos usuários:
- id, name, email
- Informações corporais (peso, altura, etc.)
- Metas e objetivos
- Plano atual

### 2. subscriptions
Armazena assinaturas dos usuários:
- userId, planType, status
- Informações de pagamento
- Datas de início e término
- Próxima data de cobrança

### 3. meals
Armazena refeições registradas:
- userId, dateTime, type
- Alimentos e quantidades
- Calorias e macronutrientes

### 4. bodymetrics
Armazena métricas corporais:
- userId, date
- Peso, gordura corporal, massa muscular
- Notas

### 5. waterintakes
Armazena ingestão de água:
- userId, date
- Quantidade de água

## 🔍 Verificar Conexão

### Via MongoDB Compass
1. Abra o MongoDB Compass
2. Cole a string de conexão:
   ```
   mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge
   ```
3. Clique em "Connect"

### Via Node.js
```javascript
const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge')
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Error:', err));
```

## 🛠️ Scripts Disponíveis

### Inicializar Banco de Dados
```bash
npm run init-db
```

### Iniciar Servidor
```bash
npm start
```

### Modo Desenvolvimento
```bash
npm run dev
```

## 📊 Estrutura das Coleções

### users
```javascript
{
  id: String,
  name: String,
  email: String,
  photoUrl: String,
  birthDate: Date,
  height: Number,
  weight: Number,
  bodyType: String,
  goal: String,
  targetWeight: Number,
  dailyCalorieGoal: Number,
  macroGoals: {
    protein: Number,
    carbs: Number,
    fat: Number
  },
  role: String,
  herbalifeId: String,
  currentPlan: String,
  createdAt: Date,
  updatedAt: Date
}
```

### subscriptions
```javascript
{
  id: String,
  userId: String,
  planType: String,
  status: String,
  startDate: Date,
  endDate: Date,
  nextBillingDate: Date,
  billingPeriod: String,
  paymentProvider: String,
  paymentId: String,
  transactionId: String,
  amount: Number,
  herbalifeId: String,
  isLeaderPlan: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

## 🔒 Segurança

### ⚠️ IMPORTANTE
- **NUNCA** commite a string de conexão no repositório público
- Use variáveis de ambiente para credenciais
- Mantenha o arquivo `.env` no `.gitignore`
- Use IP whitelist no MongoDB Atlas
- Configure autenticação adequada

### Configurar IP Whitelist no MongoDB Atlas
1. Acesse o MongoDB Atlas Dashboard
2. Vá em "Network Access"
3. Adicione seu IP ou use `0.0.0.0/0` para desenvolvimento (não recomendado para produção)

## 🐛 Troubleshooting

### Erro de Conexão
- Verifique se o IP está na whitelist do MongoDB Atlas
- Verifique se as credenciais estão corretas
- Verifique se o cluster está ativo

### Erro de Autenticação
- Verifique se o usuário e senha estão corretos
- Verifique se o usuário tem permissões adequadas

### Erro de Timeout
- Verifique sua conexão com a internet
- Verifique se o cluster está acessível
- Tente aumentar o timeout na configuração

## 📚 Documentação

- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Mongoose Documentation](https://mongoosejs.com/docs/)
- [MongoDB Connection String](https://docs.mongodb.com/manual/reference/connection-string/)

## 🆘 Suporte

Em caso de problemas:
1. Verifique os logs do servidor
2. Verifique a conexão com o MongoDB Atlas
3. Consulte a documentação do MongoDB
4. Entre em contato com o suporte do MongoDB Atlas

---

**Última atualização**: Configuração completa com MongoDB Atlas
**Status**: ✅ String de conexão configurada | ✅ Scripts de inicialização criados


# Resumo - Usuários de Teste e Planos

## ✅ Usuários de Teste Criados

### 1. Admin
- **Email**: `admin@test.com`
- **Senha**: `admin123`
- **Role**: `admin`
- **Plan**: `free`
- **Status no MongoDB**: ✅ Criado
- **Status no Firebase Auth**: ⚠️ Precisa ser criado

### 2. User
- **Email**: `user@test.com`
- **Senha**: `user123`
- **Role**: `user`
- **Plan**: `free`
- **Status no MongoDB**: ✅ Criado
- **Status no Firebase Auth**: ⚠️ Precisa ser criado

## 📍 Onde os Usuários Estão

### MongoDB Atlas ✅
- **Coleção**: `users`
- **Status**: ✅ 2 usuários criados
- **IDs**: Placeholders (precisam ser atualizados com Firebase UIDs após criar no Firebase Auth)

### Firebase Auth ⚠️
- **Status**: ⚠️ Precisam ser criados
- **Como criar**: 
  - Use o script `create_users.js` (requer `firebase-service-account.json`)
  - Ou crie manualmente no Firebase Console
  - Ou crie através do app de registro

### Firestore ⚠️
- **Status**: ⚠️ Precisam ser criados
- **Como criar**: Automático quando criar no Firebase Auth usando `create_users.js`

## 📦 Sobre os Planos

### Onde os Planos Estão?
Os planos **NÃO estão no banco de dados**. Eles estão definidos como **dados estáticos no código Flutter**.

### Localização
- **Arquivo**: `lib/models/plan.dart`
- **Classe**: `Plans`
- **Tipo**: Dados estáticos (lista estática)

### Por que no Código?
1. **Performance**: Não precisa buscar do banco
2. **Simplicidade**: Fácil de atualizar
3. **Controle**: Mudanças ficam no Git
4. **Segurança**: Não podem ser modificados por usuários

### Estrutura dos Planos
```dart
class Plans {
  static final List<Plan> allPlans = [
    Plan(type: PlanType.free, ...),
    Plan(type: PlanType.fit, ...),
    Plan(type: PlanType.personal, ...),
    Plan(type: PlanType.personalPlus, ...),
    Plan(type: PlanType.leader, ...),
  ];
}
```

### Planos Disponíveis
1. **🩵 FREE** - R$ 0/mês
2. **🟢 FIT** - R$ 0/mês (requer ID Herbalife)
3. **🔵 PERSONAL** - R$ 19,90/mês ou R$ 199/ano
4. **🟣 PERSONAL PLUS** - R$ 49,90/mês ou R$ 499/ano
5. **🟠 LÍDER** - R$ 99/mês ou R$ 999/ano (adicional)

### O que ESTÁ no Banco de Dados?

#### MongoDB (Backend)
- **Users**: Informações dos usuários (incluindo `currentPlan`)
- **Subscriptions**: Assinaturas ativas dos usuários
  - `planType`: Tipo de plano (free, fit, personal, personalPlus, leader)
  - `status`: Status da assinatura (active, cancelled, expired)
  - `billingPeriod`: Período de cobrança (monthly, yearly)
  - `paymentProvider`: Provedor de pagamento (stripe, mercadoPago, none)
  - `amount`: Valor pago
  - `startDate`, `endDate`, `nextBillingDate`: Datas importantes

#### Firestore (Mobile)
- **Users**: Informações dos usuários (sincronizado com MongoDB)
- **Meals**: Refeições registradas
- **Body Metrics**: Métricas corporais
- **Water Intake**: Ingestão de água
- **Subscriptions**: Assinaturas (opcional, pode usar apenas MongoDB)

## 🔄 Como Funciona?

1. **Planos**: Definidos no código Flutter (`lib/models/plan.dart`)
2. **Assinaturas**: Armazenadas no MongoDB (backend)
3. **Usuário**: Tem um campo `currentPlan` que indica o plano atual
4. **Verificação**: O app verifica o plano do usuário para liberar funcionalidades

## 🚀 Próximos Passos

### 1. Criar Usuários no Firebase Auth
```bash
# Opção 1: Usar script (requer firebase-service-account.json)
node create_users.js

# Opção 2: Criar manualmente no Firebase Console
# Acesse: https://console.firebase.google.com/
# Vá em: Authentication → Users → Add user
```

### 2. Sincronizar Firebase UIDs com MongoDB
Após criar no Firebase Auth:
1. Obter Firebase UIDs do Firebase Console
2. Atualizar `backend/scripts/syncFirebaseUsers.js` com os UIDs
3. Executar: `npm run sync-firebase-users`

### 3. Testar Login
1. Abrir o app
2. Fazer login com:
   - Admin: `admin@test.com` / `admin123`
   - User: `user@test.com` / `user123`

## 📝 Comandos Disponíveis

### Backend
```bash
# Inicializar banco de dados
npm run init-db

# Criar usuários de teste no MongoDB
npm run create-test-users

# Sincronizar Firebase UIDs com MongoDB
npm run sync-firebase-users
```

### Root
```bash
# Criar usuários no Firebase Auth e Firestore
node create_users.js
```

## ✅ Status

### Usuários
- ✅ MongoDB: 2 usuários criados
- ⚠️ Firebase Auth: Precisam ser criados
- ⚠️ Firestore: Precisam ser criados

### Planos
- ✅ Definidos no código Flutter
- ✅ Não estão no banco de dados (como esperado)
- ✅ Assinaturas serão armazenadas no MongoDB

### Banco de Dados
- ✅ MongoDB Atlas: Conectado
- ✅ Coleções criadas: users, subscriptions, meals, bodymetrics, waterintakes
- ✅ Índices criados: Todos os índices necessários

---

**Última atualização**: Usuários criados no MongoDB
**Status**: ✅ MongoDB pronto | ⚠️ Firebase Auth precisa ser configurado


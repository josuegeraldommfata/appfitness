# Resumo Completo - Usuários e Planos

## ✅ Status Atual

### Usuários de Teste
- ✅ **MongoDB**: 2 usuários criados
  - Admin: `admin@test.com` (senha: `admin123`)
  - User: `user@test.com` (senha: `user123`)
- ⚠️ **Firebase Auth**: Precisam ser criados
- ⚠️ **Firestore**: Precisam ser criados

### Planos
- ✅ **Definidos no código Flutter**: `lib/models/plan.dart`
- ✅ **NÃO estão no banco de dados** (como esperado)
- ✅ **Assinaturas serão armazenadas no MongoDB**

## 📍 Onde os Planos Estão?

### Resposta: No Código Flutter ✅

Os planos **NÃO estão no banco de dados**. Eles estão definidos como **dados estáticos no código Flutter**.

**Arquivo**: `lib/models/plan.dart`

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

### Por que no Código?

1. **Performance**: Não precisa buscar do banco
2. **Simplicidade**: Fácil de atualizar
3. **Controle**: Mudanças ficam no Git
4. **Segurança**: Não podem ser modificados por usuários

### O que ESTÁ no Banco de Dados?

#### MongoDB (Backend)
- **Users**: Informações dos usuários (incluindo `currentPlan`)
- **Subscriptions**: Assinaturas ativas dos usuários
  - `planType`: Tipo de plano (free, fit, personal, personalPlus, leader)
  - `status`: Status da assinatura (active, cancelled, expired)
  - `billingPeriod`: Período de cobrança (monthly, yearly)
  - `paymentProvider`: Provedor de pagamento (stripe, mercadoPago, none)
  - `amount`: Valor pago

#### Firestore (Mobile)
- **Users**: Informações dos usuários (sincronizado com MongoDB)
- **Meals**: Refeições registradas
- **Body Metrics**: Métricas corporais
- **Water Intake**: Ingestão de água

## 🚀 Próximos Passos

### 1. Criar Usuários no Firebase Auth

**Opção A: Firebase Console (Mais Fácil)** ⭐
1. Acesse: https://console.firebase.google.com/
2. Vá em "Authentication" → "Users"
3. Crie os usuários:
   - Admin: `admin@test.com` / `admin123`
   - User: `user@test.com` / `user123`
4. Copie os Firebase UIDs
5. Atualize o MongoDB com os UIDs

**Opção B: Script create_users.js**
1. Baixe o `firebase-service-account.json` do Firebase Console
2. Execute: `node create_users.js`
3. Os usuários serão criados no Firebase Auth e Firestore

### 2. Sincronizar Firebase UIDs com MongoDB

Após criar no Firebase Auth:
1. Obter Firebase UIDs do Firebase Console
2. Atualizar `backend/scripts/syncFirebaseUsers.js` com os UIDs
3. Executar: `cd backend && npm run sync-firebase-users`

### 3. Testar Login

1. Abrir o app
2. Fazer login com:
   - Admin: `admin@test.com` / `admin123`
   - User: `user@test.com` / `user123`

## 📋 Comandos Disponíveis

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

## 📊 Estrutura dos Dados

### Planos (Código Flutter)
- FREE: R$ 0/mês
- FIT: R$ 0/mês (requer ID Herbalife)
- PERSONAL: R$ 19,90/mês ou R$ 199/ano
- PERSONAL PLUS: R$ 49,90/mês ou R$ 499/ano
- LÍDER: R$ 99/mês ou R$ 999/ano (adicional)

### Usuários (MongoDB)
- Admin: `admin@test.com` (senha: `admin123`)
- User: `user@test.com` (senha: `user123`)

### Assinaturas (MongoDB)
- Armazenadas na coleção `subscriptions`
- Vinculadas ao usuário através do `userId`
- Contêm informações de pagamento e plano

## ✅ Checklist

- [x] Planos definidos no código Flutter
- [x] Usuários criados no MongoDB
- [x] Coleções criadas no MongoDB
- [x] Índices criados no MongoDB
- [ ] Usuários criados no Firebase Auth
- [ ] Usuários criados no Firestore
- [ ] Firebase UIDs sincronizados com MongoDB
- [ ] Login testado no app

## 📚 Documentação

- **Planos**: `PLANOS_EXPLICACAO.md`
- **Usuários**: `USUARIOS_TESTE.md`
- **Firebase**: `CRIAR_USUARIOS_FIREBASE.md`
- **Backend**: `BACKEND_SETUP_COMPLETO.md`
- **Pagamentos**: `PAYMENT_SETUP_COMPLETO.md`

---

**Status**: ✅ MongoDB pronto | ✅ Planos no código | ⚠️ Firebase Auth precisa ser criado
**Última atualização**: Usuários criados no MongoDB com sucesso


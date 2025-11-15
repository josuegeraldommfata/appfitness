# Usuários de Teste - NUDGE

## ✅ Usuários Criados

### 1. Admin
- **Email**: `admin@test.com`
- **Senha**: `admin123`
- **Role**: `admin`
- **Plan**: `free`

### 2. User
- **Email**: `user@test.com`
- **Senha**: `user123`
- **Role**: `user`
- **Plan**: `free`

## 📍 Onde os Usuários Estão

### MongoDB Atlas ✅
- **Coleção**: `users`
- **Status**: ✅ Criados
- **IDs**: Placeholders (precisam ser atualizados com Firebase UIDs)

### Firebase Auth ⚠️
- **Status**: ⚠️ Precisam ser criados
- **Como criar**: 
  1. Use o script `create_users.js` (requer Firebase Admin SDK)
  2. Ou crie manualmente no Firebase Console
  3. Ou crie através do app de registro

### Firestore ⚠️
- **Status**: ⚠️ Precisam ser criados
- **Como criar**: Automático quando criar no Firebase Auth usando `create_users.js`

## 🚀 Como Criar os Usuários

### Opção 1: Usar o Script (Recomendado)

#### 1. Criar no Firebase Auth e Firestore
```bash
# Na raiz do projeto
node create_users.js
```

**Requisitos:**
- Arquivo `firebase-service-account.json` na raiz do projeto
- Firebase Admin SDK configurado

#### 2. Criar no MongoDB
```bash
# Na pasta backend
cd backend
npm run create-test-users
```

#### 3. Sincronizar Firebase UIDs com MongoDB
Após criar no Firebase Auth, atualize o script `backend/scripts/syncFirebaseUsers.js` com os Firebase UIDs e execute:
```bash
cd backend
npm run sync-firebase-users
```

### Opção 2: Criar Manualmente no Firebase Console

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Vá em "Authentication" → "Users"
3. Clique em "Add user"
4. Crie os usuários:
   - **Admin**: `admin@test.com` / `admin123`
   - **User**: `user@test.com` / `user123`
5. Copie os Firebase UIDs
6. Atualize o MongoDB com os UIDs

### Opção 3: Criar através do App

1. Abra o app
2. Vá para a tela de registro
3. Crie os usuários:
   - **Admin**: `admin@test.com` / `admin123`
   - **User**: `user@test.com` / `user123`
4. Após criar, os dados serão sincronizados automaticamente

## 📋 Verificar Usuários

### MongoDB
```bash
cd backend
npm run create-test-users
# Isso listará todos os usuários no MongoDB
```

### Firebase Auth
1. Acesse o Firebase Console
2. Vá em "Authentication" → "Users"
3. Verifique os usuários criados

### Firestore
1. Acesse o Firebase Console
2. Vá em "Firestore Database"
3. Verifique a coleção `users`

## 🔄 Sincronizar Firebase UIDs

Após criar os usuários no Firebase Auth, você precisa atualizar o MongoDB com os Firebase UIDs:

1. **Obter Firebase UIDs**:
   - Acesse o Firebase Console
   - Vá em "Authentication" → "Users"
   - Copie os UIDs dos usuários

2. **Atualizar o script**:
   - Edite `backend/scripts/syncFirebaseUsers.js`
   - Adicione os Firebase UIDs:
   ```javascript
   const usersToSync = [
     {
       email: 'admin@test.com',
       firebaseUid: 'actual-firebase-uid-here', // Cole o UID aqui
     },
     {
       email: 'user@test.com',
       firebaseUid: 'actual-firebase-uid-here', // Cole o UID aqui
     },
   ];
   ```

3. **Executar o script**:
   ```bash
   cd backend
   npm run sync-firebase-users
   ```

## 📝 Estrutura dos Usuários

### Admin
```json
{
  "id": "firebase-uid-here",
  "name": "Admin Test",
  "email": "admin@test.com",
  "role": "admin",
  "currentPlan": "free",
  "birthDate": "1990-01-01",
  "height": 175,
  "weight": 75,
  "bodyType": "mesomorfo",
  "goal": "manutenção",
  "targetWeight": 75,
  "dailyCalorieGoal": 2000,
  "macroGoals": {
    "protein": 150,
    "carbs": 200,
    "fat": 65
  }
}
```

### User
```json
{
  "id": "firebase-uid-here",
  "name": "User Test",
  "email": "user@test.com",
  "role": "user",
  "currentPlan": "free",
  "birthDate": "1995-05-15",
  "height": 170,
  "weight": 70,
  "bodyType": "ectomorfo",
  "goal": "perda de peso",
  "targetWeight": 65,
  "dailyCalorieGoal": 1800,
  "macroGoals": {
    "protein": 120,
    "carbs": 180,
    "fat": 50
  }
}
```

## 🔒 Segurança

### ⚠️ IMPORTANTE
- **NUNCA** commite senhas no repositório
- Use apenas para testes em desenvolvimento
- Altere as senhas em produção
- Use senhas fortes em produção

## 🧪 Testar Login

### No App
1. Abra o app
2. Vá para a tela de login
3. Use:
   - **Admin**: `admin@test.com` / `admin123`
   - **User**: `user@test.com` / `user123`

### Verificar no Backend
```bash
# Verificar usuários no MongoDB
cd backend
npm run create-test-users
```

## 📚 Próximos Passos

1. ✅ Criar usuários no MongoDB (feito)
2. ⏳ Criar usuários no Firebase Auth
3. ⏳ Sincronizar Firebase UIDs com MongoDB
4. ⏳ Testar login no app
5. ⏳ Verificar permissões de admin

---

**Status**: ✅ Usuários criados no MongoDB | ⚠️ Precisam ser criados no Firebase Auth
**Última atualização**: Usuários de teste criados no MongoDB


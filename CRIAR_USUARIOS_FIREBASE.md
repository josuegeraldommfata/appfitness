# Como Criar Usuários no Firebase Auth

## 📋 Usuários de Teste

### 1. Admin
- **Email**: `admin@test.com`
- **Senha**: `admin123`
- **Role**: `admin`

### 2. User
- **Email**: `user@test.com`
- **Senha**: `user123`
- **Role**: `user`

## 🚀 Opções para Criar Usuários

### Opção 1: Firebase Console (Mais Fácil) ⭐

1. **Acesse o Firebase Console**:
   - https://console.firebase.google.com/
   - Selecione seu projeto: `nudge-88445`

2. **Criar Usuário Admin**:
   - Vá em "Authentication" → "Users"
   - Clique em "Add user"
   - Email: `admin@test.com`
   - Senha: `admin123`
   - Clique em "Add user"
   - **Copie o UID gerado**

3. **Criar Usuário User**:
   - Clique em "Add user"
   - Email: `user@test.com`
   - Senha: `user123`
   - Clique em "Add user"
   - **Copie o UID gerado**

4. **Atualizar MongoDB com UIDs**:
   - Edite `backend/scripts/syncFirebaseUsers.js`
   - Adicione os Firebase UIDs:
   ```javascript
   const usersToSync = [
     {
       email: 'admin@test.com',
       firebaseUid: 'COLE_O_UID_AQUI', // UID do Firebase
     },
     {
       email: 'user@test.com',
       firebaseUid: 'COLE_O_UID_AQUI', // UID do Firebase
     },
   ];
   ```
   - Execute: `cd backend && npm run sync-firebase-users`

5. **Criar Documentos no Firestore**:
   - Vá em "Firestore Database"
   - Clique em "Start collection"
   - Collection ID: `users`
   - Document ID: Use o Firebase UID
   - Adicione os campos do usuário:
   ```json
   {
     "id": "firebase-uid",
     "name": "Admin Test",
     "email": "admin@test.com",
     "role": "admin",
     "currentPlan": "free",
     "birthDate": "1990-01-01T00:00:00Z",
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
     },
     "herbalifeId": null,
     "createdAt": "2024-01-01T00:00:00Z",
     "updatedAt": "2024-01-01T00:00:00Z"
   }
   ```

### Opção 2: Script create_users.js

1. **Baixar Firebase Service Account**:
   - Acesse o Firebase Console
   - Vá em "Project Settings" → "Service Accounts"
   - Clique em "Generate new private key"
   - Salve o arquivo como `firebase-service-account.json` na raiz do projeto

2. **Instalar Dependências**:
   ```bash
   npm install firebase-admin
   ```

3. **Executar Script**:
   ```bash
   node create_users.js
   ```

4. **Sincronizar com MongoDB**:
   ```bash
   cd backend
   npm run sync-firebase-users
   ```

### Opção 3: Criar através do App

1. **Abrir o app**
2. **Ir para a tela de registro**
3. **Criar usuários**:
   - Admin: `admin@test.com` / `admin123`
   - User: `user@test.com` / `user123`
4. **Os dados serão sincronizados automaticamente**

## 🔄 Sincronizar Firebase UIDs com MongoDB

Após criar os usuários no Firebase Auth:

1. **Obter Firebase UIDs**:
   - Firebase Console → Authentication → Users
   - Copie os UIDs

2. **Atualizar Script**:
   - Edite `backend/scripts/syncFirebaseUsers.js`
   - Adicione os Firebase UIDs

3. **Executar Script**:
   ```bash
   cd backend
   npm run sync-firebase-users
   ```

## ✅ Verificar Usuários

### Firebase Auth
1. Acesse o Firebase Console
2. Vá em "Authentication" → "Users"
3. Verifique os usuários criados

### Firestore
1. Acesse o Firebase Console
2. Vá em "Firestore Database"
3. Verifique a coleção `users`

### MongoDB
```bash
cd backend
npm run create-test-users
# Isso listará todos os usuários no MongoDB
```

## 📝 Estrutura dos Usuários

### Admin (Firestore)
```json
{
  "id": "firebase-uid-here",
  "name": "Admin Test",
  "email": "admin@test.com",
  "role": "admin",
  "currentPlan": "free",
  "birthDate": "1990-01-01T00:00:00Z",
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
  },
  "herbalifeId": null,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### User (Firestore)
```json
{
  "id": "firebase-uid-here",
  "name": "User Test",
  "email": "user@test.com",
  "role": "user",
  "currentPlan": "free",
  "birthDate": "1995-05-15T00:00:00Z",
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
  },
  "herbalifeId": null,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

## 🧪 Testar Login

### No App
1. Abra o app
2. Vá para a tela de login
3. Use:
   - **Admin**: `admin@test.com` / `admin123`
   - **User**: `user@test.com` / `user123`

## 🔒 Segurança

### ⚠️ IMPORTANTE
- **NUNCA** commite senhas no repositório
- Use apenas para testes em desenvolvimento
- Altere as senhas em produção
- Use senhas fortes em produção

## 📚 Próximos Passos

1. ✅ Criar usuários no MongoDB (feito)
2. ⏳ Criar usuários no Firebase Auth
3. ⏳ Criar documentos no Firestore
4. ⏳ Sincronizar Firebase UIDs com MongoDB
5. ⏳ Testar login no app
6. ⏳ Verificar permissões de admin

---

**Status**: ✅ MongoDB pronto | ⚠️ Firebase Auth precisa ser criado
**Recomendação**: Use o Firebase Console para criar os usuários (mais fácil)


# 🔐 Credenciais dos Usuários de Teste

## 📋 **Usuários Criados no MongoDB:**

### **1. Admin (Original):**
- **Email:** `admin@test.com`
- **Senha:** `admin123`
- **Role:** admin

### **2. User (Original):**
- **Email:** `user@test.com`
- **Senha:** `user123`
- **Role:** user

---

## 📋 **Usuários Demo (Criados Agora):**

### **1. Demo Admin:**
- **Email:** `demoadmin@email.com`
- **Senha:** `admin123`
- **Role:** admin

### **2. Demo User:**
- **Email:** `demouser@email.com`
- **Senha:** `user123`
- **Role:** user

---

## ✅ **Como Criar os Usuários Demo:**

Execute este comando na pasta `backend`:

```bash
cd backend
node scripts/createDemoUsers.js
```

Ou via npm:

```bash
cd backend
npm run create-demo-users
```

**(Você precisa adicionar o script no package.json primeiro)**

---

## 🔍 **Verificar Usuários no Banco:**

Para ver todos os usuários no MongoDB, você pode:

1. **Via MongoDB Compass:**
   - Conecte com: `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge`
   - Veja a collection `users` e `auths`

2. **Via Script Node.js:**
   ```bash
   cd backend
   node -e "const mongoose = require('mongoose'); mongoose.connect('mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge').then(async () => { const User = require('./models/User'); const users = await User.find({}); console.log(users.map(u => ({email: u.email, role: u.role}))); process.exit(0); });"
   ```

---

## ⚠️ **Se Login Não Funcionar:**

1. **Verifique se o backend está rodando:**
   ```bash
   cd backend
   npm start
   ```

2. **Verifique se os usuários foram criados:**
   - Execute o script de criação novamente

3. **Verifique a URL do backend:**
   - No app: `lib/config/payment_config.dart`
   - Deve estar apontando para o backend correto

4. **Teste o login via Postman/curl:**
   ```bash
   curl -X POST http://localhost:3000/api/auth/login \
     -H "Content-Type: application/json" \
     -d "{\"email\":\"demoadmin@email.com\",\"password\":\"admin123\"}"
   ```

---

## 📝 **Todas as Credenciais:**

| Email | Senha | Role |
|-------|-------|------|
| `admin@test.com` | `admin123` | admin |
| `user@test.com` | `user123` | user |
| `demoadmin@email.com` | `admin123` | admin |
| `demouser@email.com` | `user123` | user |

---

**🚀 Execute o script para criar os usuários demo agora!**


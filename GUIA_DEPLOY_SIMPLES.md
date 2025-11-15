# 🚀 Deploy Simples - 5 Passos

## ⚡ **Deploy Rápido no Railway**

### **1️⃣ Preparar GitHub (5 min)**
- Crie conta em: https://github.com
- Crie repositório: `nudge-app`
- Faça upload do código (via GitHub Desktop ou Git)

### **2️⃣ Railway (5 min)**
- Acesse: https://railway.app
- Login com GitHub
- "New Project" → "Deploy from GitHub repo"
- Selecione seu repositório
- Configure "Root Directory" = `backend`

### **3️⃣ Variáveis (2 min)**
No Railway → Variables → Adicionar:
```
NODE_ENV=production
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
```

### **4️⃣ Copiar URL (1 min)**
Railway → Settings → Domains → Copiar URL

### **5️⃣ Atualizar App (2 min)**
Edite `lib/config/payment_config.dart`:
```dart
static const String backendApiUrl = 'https://SUA-URL.railway.app';
```

### **✅ Pronto!**
Backend rodando 24/7! 🎉

---

## 📝 **Inicializar Banco:**
```bash
cd backend
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-test-users
```

---

**🚀 Veja `COMO_FAZER_DEPLOY.md` para guia completo passo a passo!**


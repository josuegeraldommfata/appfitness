# ⚡ Início Rápido - Deploy em 10 Minutos

## 🎯 **Deploy Rápido no Railway**

### **1. Criar Conta Railway (2 min)**
1. Acesse: https://railway.app
2. Login com GitHub

### **2. Criar Projeto (3 min)**
1. "New Project" → "Deploy from GitHub repo"
2. Selecione repositório
3. Configure "Root Directory" = `backend`
4. Deploy automático

### **3. Configurar Variáveis (2 min)**
No Railway → Variables → Adicionar:
```
NODE_ENV=production
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
```

### **4. Copiar URL (1 min)**
Railway → Settings → Domains → Copiar URL

### **5. Atualizar App (2 min)**
Edite `lib/config/payment_config.dart`:
```dart
static const String backendApiUrl = 'https://SUA-URL.railway.app';
```

### **6. Pronto! ✅**
Backend rodando 24/7!

---

## 📋 **Comandos Úteis:**

```bash
# Inicializar banco (rode localmente)
cd backend
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-test-users

# Testar backend
curl https://SUA-URL.railway.app/health

# Build app
flutter build appbundle --release
```

---

**🚀 Pronto para começar? Siga os passos acima!**


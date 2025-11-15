# 📱 Resumo: Preparar App para Cliente

## 🎯 **O Que Fazer (Resumo):**

1. ✅ **Deploy do Backend no Render** (30 min) - **GRÁTIS**
2. ✅ **Atualizar URL no app** (1 min)
3. ✅ **Gerar novo APK** (5 min)
4. ✅ **Enviar APK para cliente** (1 min)
5. ✅ **Enviar credenciais para cliente** (1 min)

**Tempo total: ~40 minutos**

---

## 📋 **PASSO A PASSO RÁPIDO:**

### **1. Deploy no Render (30 min)**
- Criar conta: https://render.com
- "New Web Service" → GitHub repo
- Root Directory: `backend`
- Build: `cd backend && npm install`
- Start: `cd backend && npm start`
- Variáveis:
  - `NODE_ENV=production`
  - `MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`
- Plan: **Free** 🆓
- Copiar URL gerada (ex: `https://nudge-backend.onrender.com`)

### **2. Inicializar Banco (5 min)**
```bash
cd backend
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-demo-users
```

### **3. Atualizar URL no App (1 min)**
Edite `lib/config/payment_config.dart`:
```dart
static const String backendApiUrl = 'https://SUA-URL-RENDER.onrender.com';
```

### **4. Gerar APK (5 min)**
```bash
flutter clean
flutter pub get
flutter build apk --release
```
APK em: `build\app\outputs\flutter-apk\app-release.apk`

### **5. Criar Usuário para Cliente (2 min)**
Execute:
```bash
node SCRIPT_CRIAR_USUARIO_CLIENTE.js
```
**⚠️ Edite o script primeiro com dados do cliente!**

### **6. Enviar para Cliente**
- APK: `app-release.apk`
- Credenciais: Email e senha
- Instruções: Como instalar APK

---

## 💰 **Custo:**

- **$0/mês** - Tudo grátis! ✅

---

## ✅ **CHECKLIST:**

- [ ] Backend deployado no Render
- [ ] URL do Render copiada
- [ ] Banco inicializado
- [ ] URL atualizada no app
- [ ] APK gerado
- [ ] Usuário criado para cliente
- [ ] APK enviado para cliente
- [ ] Credenciais enviadas para cliente

---

**🚀 Veja `PREPARAR_PARA_CLIENTE.md` para guia completo detalhado!**


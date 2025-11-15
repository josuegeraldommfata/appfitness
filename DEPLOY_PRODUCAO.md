# 🚀 Deploy para Produção - NUDGE App

## 📋 **Como Funciona na Play Store**

### ✅ **MongoDB Atlas - Já está 24/7 na nuvem!**
O MongoDB Atlas **já está rodando 24/7** na nuvem (servidores da MongoDB). Você **não precisa fazer nada** - ele já está disponível!

**URI atual:** `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge`

### ⚠️ **Backend - Precisa estar hospedado 24/7**
O backend Node.js **precisa estar rodando em um servidor na nuvem 24/7** para funcionar quando o app estiver na Play Store.

**Problema atual:** O app está configurado para `http://localhost:3000` - isso **NÃO funciona** quando o app está na Play Store!

---

## 🎯 **O Que Fazer:**

### **1. Escolher um Serviço de Hospedagem para o Backend**

Você precisa hospedar o backend Node.js em algum lugar. Opções populares:

#### **Opção 1: Railway (Recomendado - Fácil e Grátis)**
- ✅ **Grátis:** $5 grátis/mês
- ✅ **Fácil:** Conecta com GitHub
- ✅ **24/7:** Servidor sempre ligado
- ✅ **Domínio:** URL automática (ex: `seu-app.railway.app`)

#### **Opção 2: Render**
- ✅ **Grátis:** Tier grátis disponível
- ✅ **Fácil:** Deploy automático
- ✅ **24/7:** Servidor sempre ligado
- ✅ **URL:** `seu-app.onrender.com`

#### **Opção 3: Heroku**
- ⚠️ **Pago:** Não tem mais tier grátis
- ✅ **Popular:** Muito usado
- ✅ **Estável:** Muito confiável

#### **Opção 4: AWS / Google Cloud / Azure**
- ✅ **Poderoso:** Infinitas opções
- ⚠️ **Complexo:** Requer mais configuração
- 💰 **Custo:** Pode ser barato ou caro dependendo do uso

#### **Opção 5: DigitalOcean / Vultr / Linode**
- ✅ **Barato:** A partir de $5/mês
- ✅ **Controle total:** VPS completo
- ⚠️ **Requer conhecimento:** Precisa configurar tudo

---

## 📝 **Guia Passo a Passo - Deploy no Railway (Mais Fácil)**

### **1. Preparar o Backend**

#### **A. Criar arquivo `.env` para produção:**
```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
```

#### **B. Atualizar `package.json` com script de start:**
```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "init-db": "node scripts/initDatabase.js",
    "create-test-users": "node scripts/createTestUsers.js"
  }
}
```

#### **C. Criar arquivo `Procfile` (para Railway/Heroku):**
```
web: node server.js
```

### **2. Criar Conta no Railway**

1. Acesse: https://railway.app
2. Faça login com GitHub
3. Clique em "New Project"
4. Selecione "Deploy from GitHub repo"
5. Conecte seu repositório
6. Selecione a pasta `backend`

### **3. Configurar Variáveis de Ambiente**

No Railway:
1. Vá em "Variables"
2. Adicione:
   - `NODE_ENV=production`
   - `PORT=3000` (Railway define automaticamente, mas adicione mesmo assim)
   - `MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`

### **4. Deploy Automático**

O Railway vai:
- ✅ Detectar automaticamente que é um projeto Node.js
- ✅ Instalar dependências (`npm install`)
- ✅ Rodar `npm start`
- ✅ Gerar URL pública (ex: `https://seu-app.railway.app`)

### **5. Inicializar Banco de Dados**

Após o deploy, rode os scripts via terminal Railway ou localmente:

```bash
# Via Railway CLI
railway run npm run init-db
railway run npm run create-test-users

# Ou localmente (apontando para MongoDB Atlas)
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
```

### **6. Atualizar o App Flutter**

Edite `lib/config/payment_config.dart`:

```dart
static const String backendApiUrl = 'https://seu-app.railway.app'; // URL do Railway
```

### **7. Recompilar o App**

```bash
flutter build apk --release  # Para Android
# ou
flutter build appbundle --release  # Para Play Store
```

---

## 📋 **Checklist de Deploy**

### ✅ **Backend:**
- [ ] Criar conta no serviço de hospedagem (Railway/Render/etc)
- [ ] Fazer deploy do backend
- [ ] Configurar variáveis de ambiente
- [ ] Verificar se o servidor está rodando
- [ ] Testar endpoints da API

### ✅ **MongoDB:**
- [x] MongoDB Atlas já está configurado e rodando 24/7 ✅
- [ ] Verificar conexão do backend com MongoDB
- [ ] Rodar scripts de inicialização
- [ ] Criar usuários de teste

### ✅ **App Flutter:**
- [ ] Atualizar URL do backend no código
- [ ] Testar todas as funcionalidades
- [ ] Build para produção
- [ ] Testar em dispositivo real
- [ ] Upload para Play Store

---

## 🔧 **Configuração Detalhada - Railway**

### **1. Estrutura do Projeto no GitHub**

Certifique-se que o backend está em uma pasta separada:
```
seu-repo/
├── backend/
│   ├── server.js
│   ├── package.json
│   ├── .env.example
│   └── ...
└── lib/  # Flutter app
```

### **2. Railway.toml (Opcional)**

Crie `backend/railway.toml`:
```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "node server.js"
healthcheckPath = "/health"
healthcheckTimeout = 100
```

### **3. Scripts Úteis**

No Railway, você pode rodar comandos:
```bash
# Inicializar banco
railway run npm run init-db

# Criar usuários de teste
railway run npm run create-test-users

# Ver logs
railway logs
```

---

## 🔐 **Segurança para Produção**

### **1. Variáveis de Ambiente**

**NUNCA commite:**
- ❌ Chaves secretas do Stripe
- ❌ Access token do Mercado Pago
- ❌ Senhas do MongoDB
- ❌ Tokens de API

**Configure tudo via variáveis de ambiente no Railway/Render!**

### **2. MongoDB Atlas - Whitelist IPs**

1. Acesse MongoDB Atlas
2. Vá em "Network Access"
3. Adicione o IP do Railway (ou use `0.0.0.0/0` para permitir todos - apenas para desenvolvimento)

### **3. HTTPS**

O Railway/Render já fornece HTTPS automaticamente! ✅

### **4. CORS**

O backend já tem CORS configurado, mas pode precisar ajustar:

```javascript
// backend/server.js
app.use(cors({
  origin: [
    'http://localhost:3000', // Desenvolvimento
    'https://seu-app.railway.app', // Produção
    // Adicione outras URLs se necessário
  ],
  credentials: true,
}));
```

---

## 💰 **Custos Estimados**

### **MongoDB Atlas:**
- ✅ **Grátis:** Tier M0 (512MB) - suficiente para começar
- 💰 **Pago:** A partir de $9/mês para mais recursos

### **Railway:**
- ✅ **Grátis:** $5 créditos/mês (suficiente para testar)
- 💰 **Pago:** A partir de $5/mês para uso contínuo

### **Render:**
- ✅ **Grátis:** Tier grátis disponível (pode hibernar após inatividade)
- 💰 **Pago:** A partir de $7/mês para sempre ligado

### **Total Estimado:**
- **Gratuito:** MongoDB Atlas Free + Railway/Render Free = **$0/mês**
- **Básico:** MongoDB Atlas Free + Railway/Render Pago = **$5-7/mês**
- **Produção:** MongoDB Atlas Pago + Servidor Pago = **$14-20/mês**

---

## 🎯 **Fluxo Completo:**

```
┌─────────────────┐
│  App na Play    │
│     Store       │
└────────┬────────┘
         │ HTTPS
         │
         ▼
┌─────────────────┐
│   Backend API   │  ← Railway/Render (24/7)
│  (Node.js/      │
│   Express)      │
└────────┬────────┘
         │
         │ MongoDB URI
         │
         ▼
┌─────────────────┐
│  MongoDB Atlas  │  ← Servidor MongoDB (24/7)
│   (Cloud)       │     (Já está rodando!)
└─────────────────┘
```

---

## 📝 **Resumo Rápido:**

1. **MongoDB Atlas:** ✅ Já está 24/7 na nuvem - **não precisa fazer nada!**

2. **Backend:** ⚠️ Precisa hospedar em Railway/Render/etc - **precisa fazer deploy!**

3. **App Flutter:** ⚠️ Precisa atualizar URL do backend para a URL do servidor (não pode ser `localhost`) - **precisa atualizar código!**

---

## 🚀 **Passo a Passo Simplificado:**

1. **Criar conta no Railway** (5 min)
2. **Fazer deploy do backend** (10 min)
3. **Copiar URL do Railway** (ex: `https://nudge-backend.railway.app`)
4. **Atualizar `lib/config/payment_config.dart`** (1 min)
5. **Testar o app** (5 min)
6. **Build para produção** (10 min)
7. **Upload para Play Store** (30 min)

**Tempo total: ~1 hora para ter tudo funcionando!**

---

## ⚠️ **IMPORTANTE:**

### **Nunca use `localhost` na produção!**
- ❌ `http://localhost:3000` - **NÃO funciona** na Play Store
- ✅ `https://seu-backend.railway.app` - **Funciona** em qualquer lugar

### **MongoDB Atlas já está 24/7!**
- ✅ Não precisa fazer nada
- ✅ Já está configurado
- ✅ Já está na nuvem

### **Backend precisa estar 24/7!**
- ⚠️ Precisa hospedar em algum lugar
- ⚠️ Precisa estar sempre rodando
- ⚠️ Se parar, o app não funciona

---

## 💡 **Recomendação:**

Para começar rápido, use:
1. **Railway** para backend (mais fácil)
2. **MongoDB Atlas** (já está configurado)
3. Teste tudo funcionando
4. Depois pode migrar para serviços mais robustos se necessário

**Custo inicial: $0-5/mês para começar!**

---

## 🔗 **Links Úteis:**

- Railway: https://railway.app
- Render: https://render.com
- MongoDB Atlas: https://cloud.mongodb.com
- Heroku: https://heroku.com

---

## ✅ **Próximos Passos:**

1. Criar conta no Railway
2. Fazer deploy do backend
3. Atualizar URL no app Flutter
4. Testar tudo funcionando
5. Build e publicar na Play Store

**Quer ajuda com o deploy? Posso criar os arquivos necessários!**


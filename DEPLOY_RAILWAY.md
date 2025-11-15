# 🚂 Deploy do Backend no Railway - Guia Completo

## 🎯 **O Que é o Railway?**

Railway é uma plataforma de hospedagem que permite fazer deploy do seu backend Node.js **em 5 minutos** e ele fica **24/7 rodando** automaticamente!

**Preço:** $5 créditos grátis/mês (suficiente para testar) ou $5/mês para uso contínuo.

---

## 📋 **Pré-requisitos:**

1. Conta no GitHub (grátis)
2. Backend já configurado localmente
3. MongoDB Atlas já configurado (você já tem! ✅)

---

## 🚀 **Passo a Passo - Deploy no Railway:**

### **1. Preparar o Backend**

#### **A. Verificar arquivos:**

Certifique-se que estes arquivos existem:
- ✅ `backend/package.json`
- ✅ `backend/server.js`
- ✅ `backend/Procfile` (já criado ✅)
- ✅ `backend/.env.example` ou documentação das variáveis

#### **B. Criar `.env` para produção (localmente para referência):**

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
```

### **2. Criar Conta no Railway**

1. Acesse: **https://railway.app**
2. Clique em "**Start a New Project**"
3. Selecione "**Login with GitHub**"
4. Autorize o Railway a acessar seu GitHub

### **3. Criar Novo Projeto**

1. No dashboard do Railway, clique em "**New Project**"
2. Selecione "**Deploy from GitHub repo**"
3. Selecione seu repositório do GitHub
4. Se o backend estiver na pasta `backend`, selecione a pasta `backend`
5. Ou configure o "**Root Directory**" como `backend`

### **4. Configurar Variáveis de Ambiente**

1. No projeto Railway, clique em "**Variables**"
2. Adicione as seguintes variáveis:

```
NODE_ENV=production
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
PORT=3000
```

⚠️ **Importante:** A Railway define `PORT` automaticamente, mas você pode adicionar mesmo assim.

### **5. Aguardar Deploy Automático**

O Railway vai:
- ✅ Detectar automaticamente que é Node.js
- ✅ Rodar `npm install`
- ✅ Rodar `npm start` (ou o comando no Procfile)
- ✅ Gerar URL pública automaticamente

### **6. Obter URL do Backend**

1. Após o deploy, vá em "**Settings**"
2. Procure por "**Domains**" ou "**Generate Domain**"
3. Copie a URL gerada (ex: `https://nudge-backend-production.up.railway.app`)

### **7. Inicializar Banco de Dados**

#### **Opção A: Via Terminal Railway (Recomendado)**

1. Instale Railway CLI:
   ```bash
   npm install -g @railway/cli
   ```

2. Faça login:
   ```bash
   railway login
   ```

3. Conecte ao projeto:
   ```bash
   railway link
   ```

4. Rode os scripts:
   ```bash
   railway run npm run init-db
   railway run npm run create-test-users
   ```

#### **Opção B: Via Railway Dashboard**

1. No projeto, vá em "**Deployments**"
2. Clique em "**View Logs**"
3. Use o terminal integrado (se disponível)

#### **Opção C: Localmente (conectado ao MongoDB Atlas)**

```bash
cd backend
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-test-users
```

### **8. Testar o Backend**

1. Acesse a URL do Railway no navegador
2. Você deve ver: `{"message":"NUDGE Backend API","version":"1.0.0","status":"running"}`
3. Teste o endpoint de health: `https://seu-backend.railway.app/health`

### **9. Atualizar o App Flutter**

Edite `lib/config/payment_config.dart`:

```dart
// Comente a linha de desenvolvimento:
// static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO

// Descomente e atualize a URL de produção:
static const String backendApiUrl = 'https://seu-backend.railway.app'; // PRODUÇÃO
```

⚠️ **Substitua `seu-backend.railway.app` pela URL real do Railway!**

### **10. Recompilar o App**

```bash
# Para Android
flutter build apk --release

# Para Play Store
flutter build appbundle --release
```

---

## ✅ **Verificação Pós-Deploy:**

### **1. Testar Endpoints:**

```bash
# Health check
curl https://seu-backend.railway.app/health

# Login
curl -X POST https://seu-backend.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@test.com","password":"admin123"}'
```

### **2. Verificar Logs:**

No Railway:
1. Vá em "**Deployments**"
2. Clique no deploy mais recente
3. Veja os logs em tempo real

### **3. Testar no App:**

1. Atualize o app com a nova URL
2. Teste login
3. Teste todas as funcionalidades
4. Verifique se os dados estão salvando no MongoDB Atlas

---

## 🔧 **Configurações Avançadas (Opcional):**

### **1. Domínio Customizado**

1. No Railway, vá em "**Settings**" → "**Domains**"
2. Adicione seu domínio customizado
3. Configure DNS conforme instruções

### **2. Variáveis de Ambiente Adicionais**

Se precisar de mais variáveis (ex: Stripe keys):
1. Vá em "**Variables**"
2. Adicione:
   ```
   STRIPE_SECRET_KEY=sk_live_...
   MERCADO_PAGO_ACCESS_TOKEN=APP_USR-...
   ```

### **3. Logs e Monitoramento**

- Railway fornece logs em tempo real
- Pode configurar alertas
- Pode ver métricas de uso

---

## 💰 **Custos:**

### **Plano Grátis:**
- $5 créditos grátis/mês
- Suficiente para desenvolvimento/testes
- Servidor pode dormir após inatividade

### **Plano Pago:**
- $5/mês (Starter)
- Servidor sempre ligado 24/7
- Sem limites de uso

### **Estimativa de Uso:**
- Backend Node.js pequeno: ~$1-2/mês
- Com uso moderado: ~$3-5/mês
- Alta demanda: ~$10-20/mês

---

## 🎯 **Checklist de Deploy:**

- [ ] Conta no Railway criada
- [ ] Repositório GitHub conectado
- [ ] Projeto criado no Railway
- [ ] Variáveis de ambiente configuradas
- [ ] Deploy concluído com sucesso
- [ ] URL pública obtida
- [ ] Banco de dados inicializado
- [ ] Endpoints testados
- [ ] URL atualizada no app Flutter
- [ ] App testado com backend em produção
- [ ] Logs verificados

---

## ⚠️ **Problemas Comuns:**

### **1. Build Falha**
- Verifique se `package.json` tem o script `start`
- Verifique se todas as dependências estão listadas
- Veja os logs do Railway

### **2. Port Erro**
- Railway define `PORT` automaticamente via variável `PORT`
- Seu código já usa `process.env.PORT || 3000` ✅

### **3. CORS Erro**
- Atualize `allowedOrigins` no `server.js` com a URL do Railway
- Ou use `*` para desenvolvimento (não recomendado para produção)

### **4. MongoDB Connection Error**
- Verifique se o IP do Railway está na whitelist do MongoDB Atlas
- Ou configure para aceitar de qualquer IP (apenas para desenvolvimento)

---

## 📝 **Resumo:**

1. ✅ **MongoDB Atlas:** Já está 24/7 - não precisa fazer nada
2. ⚠️ **Backend:** Precisa fazer deploy no Railway (30 min)
3. ⚠️ **App:** Precisa atualizar URL (1 min)
4. ✅ **Pronto:** App funciona na Play Store!

---

## 🔗 **Links:**

- Railway: https://railway.app
- Railway Docs: https://docs.railway.app
- MongoDB Atlas: https://cloud.mongodb.com

---

**🎉 Após fazer o deploy, seu app estará 100% funcional na Play Store!**


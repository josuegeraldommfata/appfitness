# 🚀 COMECE AQUI - Deploy no Railway

## ⚡ **INÍCIO RÁPIDO - 5 Passos Simples**

### **1️⃣ Preparar GitHub (5 min)**

**Opção A: Via GitHub Desktop (Mais Fácil)**

1. Baixe: https://desktop.github.com
2. Login com GitHub
3. "File" → "Add Local Repository"
4. Selecione: `C:\Users\FIREWALL\Pictures\niudge\nudge-main`
5. "Publish repository" → Nome: `nudge-app`
6. ✅ Pronto!

**Opção B: Via Terminal (Git)**

```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main"
git init
git add .
git commit -m "NUDGE app completo"

# Depois, crie repositório no github.com e:
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git
git branch -M main
git push -u origin main
```

---

### **2️⃣ Criar Conta Railway (2 min)**

1. Acesse: **https://railway.app**
2. Clique em "**Start a New Project**"
3. Login com **GitHub**
4. ✅ Pronto!

---

### **3️⃣ Deploy Automático (5 min)**

1. No Railway, clique "**+ New Project**"
2. Selecione "**Deploy from GitHub repo**"
3. Se pedir, instale "**GitHub App**" e selecione seu repositório
4. Selecione repositório `nudge-app`
5. Em "**Settings**", configure "**Root Directory**" = `backend`
6. Aguarde deploy (2-5 min)
7. ✅ Pronto!

---

### **4️⃣ Configurar Variáveis (2 min)**

No Railway → "**Variables**" → "**+ New Variable**":

**Variável 1:**
- Name: `NODE_ENV`
- Value: `production`

**Variável 2:**
- Name: `MONGODB_URI`
- Value: `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`

✅ Pronto!

---

### **5️⃣ Copiar URL e Atualizar App (2 min)**

1. Railway → "**Settings**" → "**Domains**" → Copiar URL
2. Exemplo: `https://nudge-backend-production.up.railway.app`

3. Edite `lib/config/payment_config.dart`:
   ```dart
   // Comente esta linha:
   // static const String backendApiUrl = 'http://localhost:3000';
   
   // Adicione esta (substitua pela URL real):
   static const String backendApiUrl = 'https://SUA-URL.railway.app';
   ```

4. ✅ Pronto!

---

## ✅ **INICIALIZAR BANCO DE DADOS:**

Abra terminal na pasta `backend` e rode:

```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main\backend"
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-test-users
```

---

## ✅ **TESTAR:**

1. Acesse URL do Railway no navegador
2. Deve aparecer: `{"message":"NUDGE Backend API",...}`
3. Teste no app Flutter
4. ✅ Funcionando!

---

## 🎉 **PRONTO!**

**Backend rodando 24/7 na nuvem!** 🚀

---

## 📚 **Guia Completo:**

- **Guia Simples:** `GUIA_DEPLOY_SIMPLES.md`
- **Passo a Passo:** `COMO_FAZER_DEPLOY.md`
- **Detalhes Técnicos:** `DEPLOY_RAILWAY.md`

---

**🚀 Comece pelo PASSO 1 acima!**


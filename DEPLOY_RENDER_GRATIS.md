# 🆓 Deploy GRÁTIS no Render - Sem Gastar Nada!

## 🎯 **Render: 100% Grátis Para Sempre!**

Render oferece tier grátis que **nunca expira** e **não precisa de cartão de crédito**!

**Única limitação:** Servidor pode "dormir" após 15 min de inatividade, mas **sempre acorda** quando alguém usa.

---

## 🚀 **Deploy no Render - Passo a Passo (100% Grátis)**

### **1️⃣ Criar Conta no Render (2 min)**

1. Acesse: **https://render.com**
2. Clique em "**Sign Up**"
3. Selecione "**Sign up with GitHub**" (recomendado)
4. **NÃO precisa de cartão de crédito!** ✅
5. ✅ Conta criada!

---

### **2️⃣ Preparar Código no GitHub (5 min)**

Se ainda não tem código no GitHub:

**Opção A: GitHub Desktop (Mais Fácil)**
1. Baixe: https://desktop.github.com
2. Login
3. "File" → "Add Local Repository"
4. Selecione: `C:\Users\FIREWALL\Pictures\niudge\nudge-main`
5. "Publish repository" → Nome: `nudge-app`
6. ✅ Pronto!

**Opção B: Git (Terminal)**
```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main"
git init
git add .
git commit -m "NUDGE app - deploy grátis"
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git
git push -u origin main
```

---

### **3️⃣ Criar Novo Serviço Web no Render (5 min)**

1. No dashboard do Render, clique em "**+ New +**" (canto superior direito)
2. Selecione "**Web Service**"
3. Conecte seu repositório GitHub (se ainda não conectou)
4. Selecione repositório `nudge-app`

---

### **4️⃣ Configurar Serviço (10 min)**

Preencha os campos:

**Name:**
- `nudge-backend` (ou outro nome)

**Region:**
- Escolha mais próximo (ex: `Oregon (US West)`)

**Branch:**
- `main` (ou `master`)

**Root Directory:**
- **IMPORTANTE:** Digite `backend` (isso diz que o código está na pasta backend)

**Runtime:**
- `Node` (deve detectar automaticamente)

**Build Command:**
- `cd backend && npm install`

**Start Command:**
- `cd backend && npm start`

**Plan:**
- **Selecione: "Free"** 🆓 (100% grátis!)

---

### **5️⃣ Configurar Variáveis de Ambiente (3 min)**

Role para baixo até "**Environment Variables**" e adicione:

**Variável 1:**
- Key: `NODE_ENV`
- Value: `production`
- Clique em "**Add**"

**Variável 2:**
- Key: `MONGODB_URI`
- Value: `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`
- Clique em "**Add**"

**Variável 3:**
- Key: `PORT`
- Value: `3000`
- Clique em "**Add**"

✅ Variáveis configuradas!

---

### **6️⃣ Criar Serviço (5 min)**

1. Role para baixo
2. Clique em "**Create Web Service**"
3. Render vai começar o deploy automaticamente!
4. Aguarde ~5-10 minutos (primeira vez leva mais tempo)
5. Você verá logs em tempo real
6. Quando aparecer "**Your service is live**" ✅ **Pronto!**

---

### **7️⃣ Obter URL do Backend (1 min)**

1. Após deploy, você verá uma URL como:
   ```
   https://nudge-backend.onrender.com
   ```
2. **COPIE ESSA URL!** 📋
3. ✅ Pronto!

---

### **8️⃣ Atualizar App Flutter (2 min)**

1. Edite: `lib/config/payment_config.dart`

2. Encontre:
   ```dart
   static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   ```

3. Comente e adicione:
   ```dart
   // static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   static const String backendApiUrl = 'https://nudge-backend.onrender.com'; // PRODUÇÃO - GRÁTIS!
   ```
   
   ⚠️ **Substitua pela URL real do Render!**

4. Salve o arquivo

---

### **9️⃣ Inicializar Banco de Dados (5 min)**

Abra terminal na pasta `backend` e rode:

```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main\backend"
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-test-users
```

✅ Banco inicializado!

---

### **🔟 Testar (2 min)**

1. Acesse a URL do Render no navegador
2. Deve aparecer: `{"message":"NUDGE Backend API",...}`
3. Teste login no app: `admin@test.com` / `admin123`
4. ✅ Funcionando!

---

## ✅ **PRONTO! Backend 100% Grátis Rodando 24/7!** 🎉

---

## 💡 **Sobre o Servidor "Dormir":**

### **O Que Significa:**
- Após **15 minutos sem uso**, o servidor "dorme"
- Quando alguém usa o app, ele "acorda" (leva ~30 segundos)
- Depois disso, funciona normalmente

### **Impacto:**
- ⚠️ Primeira requisição após dormir pode levar ~30 segundos
- ✅ Depois disso, funciona normalmente
- ✅ Para apps pequenos/começando, isso é **perfeitamente aceitável**!

### **Como Evitar (Opcional):**
- Render tem um serviço pago ($7/mês) que mantém sempre ligado
- **MAS:** Para começar, o grátis funciona muito bem!

---

## 💰 **Custo Real:**

- **MongoDB Atlas:** $0/mês (tier grátis) ✅
- **Render Backend:** $0/mês (tier grátis) ✅
- **Total:** **$0/mês para sempre!** 💰

---

## 📋 **Checklist:**

- [ ] Conta Render criada (sem cartão de crédito)
- [ ] Código no GitHub
- [ ] Serviço Web criado no Render
- [ ] Root Directory = `backend` configurado
- [ ] Variáveis de ambiente adicionadas
- [ ] Deploy concluído
- [ ] URL copiada
- [ ] URL atualizada no app Flutter
- [ ] Banco inicializado
- [ ] Testado e funcionando

---

## 🎯 **Resumo:**

1. ✅ **Render é 100% grátis para sempre!**
2. ✅ **Não precisa de cartão de crédito!**
3. ✅ **Servidor pode "dormir", mas sempre acorda**
4. ✅ **Perfeito para apps pequenos/começando!**
5. ✅ **Custo: $0/mês!**

---

## 🆘 **Problemas?**

- **Deploy falhou?** Veja os logs no Render
- **URL não funciona?** Verifique se o deploy terminou
- **Primeira requisição lenta?** Normal! Servidor estava "dormindo"

---

**🚀 Pronto para fazer deploy GRÁTIS? Siga os passos acima!**


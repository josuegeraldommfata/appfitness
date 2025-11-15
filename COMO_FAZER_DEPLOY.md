# 🚀 Como Fazer Deploy no Railway - GUIA COMPLETO

## 🎯 **Resumo: O Que Precisa Fazer**

1. **MongoDB Atlas:** ✅ Já está 24/7 - **NÃO precisa fazer nada!**
2. **Backend:** ⚠️ Precisa fazer deploy no Railway (~30 min)
3. **App:** ⚠️ Precisa atualizar URL após deploy (1 min)

---

## 📋 **PASSO A PASSO COMPLETO**

### **PASSO 1: Preparar Código para GitHub**

Você precisa colocar o código no GitHub para o Railway poder acessar.

#### **Opção A: Via GitHub Desktop (Mais Fácil)**

1. Baixe GitHub Desktop: https://desktop.github.com
2. Faça login
3. "File" → "Add Local Repository"
4. Selecione a pasta do projeto: `C:\Users\FIREWALL\Pictures\niudge\nudge-main`
5. "Publish repository" → Escolha nome: `nudge-app`
6. ✅ Código no GitHub!

#### **Opção B: Via Terminal/Git**

Execute estes comandos no terminal na pasta do projeto:

```bash
# 1. Ir para pasta do projeto
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main"

# 2. Inicializar Git (se não tiver)
git init

# 3. Adicionar todos os arquivos
git add .

# 4. Primeiro commit
git commit -m "NUDGE app completo - pronto para deploy"

# 5. Criar repositório no GitHub (acesse github.com e crie um repositório vazio)

# 6. Conectar e fazer push (substitua SEU_USUARIO pelo seu usuário do GitHub)
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git
git branch -M main
git push -u origin main
```

✅ Código no GitHub!

---

### **PASSO 2: Criar Conta no Railway**

1. Acesse: **https://railway.app**
2. Clique em "**Start a New Project**" ou "**Login**"
3. Selecione "**Login with GitHub**"
4. Autorize o Railway a acessar seu GitHub
5. ✅ Conta criada!

---

### **PASSO 3: Criar Projeto e Fazer Deploy**

1. No dashboard do Railway, clique em "**+ New Project**" (canto superior direito)

2. Selecione "**Deploy from GitHub repo**"

3. Se aparecer para instalar "GitHub App":
   - Clique em "**Configure GitHub App**"
   - Selecione "**Only select repositories**"
   - Escolha o repositório `nudge-app` (ou o nome que você deu)
   - Clique em "**Install**"

4. Selecione seu repositório `nudge-app`

5. **IMPORTANTE - Configurar Root Directory:**
   - No projeto Railway, vá em "**Settings**"
   - Procure por "**Root Directory**"
   - Digite: `backend` (isso diz que o código Node.js está na pasta backend)
   - Clique em "**Save**"

6. O Railway vai automaticamente:
   - ✅ Detectar que é Node.js
   - ✅ Rodar `npm install`
   - ✅ Rodar `npm start`
   - ✅ Gerar URL pública

7. Aguarde ~2-5 minutos até aparecer "**Deployed**" (verde)

---

### **PASSO 4: Configurar Variáveis de Ambiente**

1. No projeto Railway, clique em "**Variables**" (aba lateral esquerda)

2. Clique em "**+ New Variable**" e adicione:

   **Variável 1:**
   - **Name:** `NODE_ENV`
   - **Value:** `production`
   - Clique em "**Add**"

   **Variável 2:**
   - **Name:** `MONGODB_URI`
   - **Value:** `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`
   - Clique em "**Add**"

3. ✅ Variáveis configuradas!

4. O Railway vai reiniciar automaticamente com as novas variáveis

---

### **PASSO 5: Obter URL do Backend**

1. No projeto Railway, clique em "**Settings**"

2. Procure por "**Domains**" ou "**Generate Domain**"

3. Clique em "**Generate Domain**" (se não aparecer automaticamente)

4. Você verá uma URL como:
   ```
   https://nudge-backend-production-xxxx.up.railway.app
   ```

5. **COPIE ESSA URL COMPLETA!** 📋

6. Teste no navegador:
   - Cole a URL
   - Deve aparecer: `{"message":"NUDGE Backend API","version":"1.0.0","status":"running"}`

---

### **PASSO 6: Inicializar Banco de Dados**

Abra um terminal na pasta `backend` e rode:

```bash
# Navegar para backend
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main\backend"

# Inicializar banco de dados
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority npm run init-db

# Criar usuários de teste
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority npm run create-test-users
```

✅ Banco inicializado!

---

### **PASSO 7: Testar o Backend**

1. **Health Check:**
   ```
   https://SUA-URL-RAILWAY.app/health
   ```
   Deve retornar: `{"status":"healthy",...}`

2. **Testar Login:**
   - Use Postman ou curl:
   ```bash
   curl -X POST https://SUA-URL-RAILWAY.app/api/auth/login \
     -H "Content-Type: application/json" \
     -d "{\"email\":\"admin@test.com\",\"password\":\"admin123\"}"
   ```
   Deve retornar token e dados do usuário!

---

### **PASSO 8: Atualizar App Flutter**

1. Edite: `lib/config/payment_config.dart`

2. Encontre a linha:
   ```dart
   static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   ```

3. Comente essa linha e adicione a URL do Railway:
   ```dart
   // static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   static const String backendApiUrl = 'https://SUA-URL-RAILWAY.app'; // PRODUÇÃO
   ```
   
   ⚠️ **Substitua `SUA-URL-RAILWAY.app` pela URL real que você copiou!**

4. Salve o arquivo

---

### **PASSO 9: Testar App Completo**

1. Execute o app:
   ```bash
   flutter run
   ```

2. Teste login:
   - Email: `admin@test.com`
   - Senha: `admin123`

3. Teste funcionalidades:
   - ✅ Adicionar refeição
   - ✅ Ver refeições
   - ✅ Registrar métricas
   - ✅ Adicionar água
   - ✅ Tudo deve funcionar!

4. Se tudo funcionar: ✅ **SUCESSO!**

---

## ✅ **CHECKLIST RÁPIDO:**

- [ ] Código no GitHub
- [ ] Conta Railway criada
- [ ] Projeto criado no Railway
- [ ] Root Directory = `backend` configurado
- [ ] Variáveis de ambiente adicionadas
- [ ] Deploy concluído
- [ ] URL copiada
- [ ] Banco inicializado
- [ ] Backend testado
- [ ] URL atualizada no app
- [ ] App testado

---

## 🎉 **PRONTO!**

**Seu aplicativo está funcionando 24/7 na nuvem!**

- ✅ MongoDB Atlas: 24/7 ✅
- ✅ Backend Railway: 24/7 ✅
- ✅ App: Funciona de qualquer lugar ✅

---

## 💰 **Custo:**

- **MongoDB Atlas:** Grátis (tier M0)
- **Railway:** Grátis ($5 créditos/mês) ou $5/mês
- **Total:** $0-5/mês

---

## 🆘 **Ajuda:**

- **Problemas?** Veja `DEPLOY_RAILWAY.md` para solução de problemas
- **Dúvidas?** Veja `DEPLOY_PRODUCAO.md` para explicações detalhadas

---

**🚀 Comece pelo PASSO 1 e siga na ordem!**


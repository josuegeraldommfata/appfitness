# 📱 Preparar App para Cliente - Guia Completo

## 🎯 **O Que Precisa Fazer:**

Para o cliente poder fazer login e usar o app, você precisa:

1. ✅ **Fazer deploy do backend na nuvem** (Render grátis)
2. ✅ **Atualizar URL no app Flutter**
3. ✅ **Gerar novo APK**
4. ✅ **Enviar APK para o cliente**

---

## 🚀 **PASSO A PASSO COMPLETO:**

### **PASSO 1: Fazer Deploy do Backend no Render (30 min)**

#### **1.1. Preparar Código no GitHub**

Se ainda não tem o código no GitHub:

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
git commit -m "NUDGE app - pronto para cliente"
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git
git push -u origin main
```

---

#### **1.2. Criar Conta no Render**

1. Acesse: **https://render.com**
2. Clique em "**Sign Up**"
3. Selecione "**Sign up with GitHub**" (recomendado)
4. **NÃO precisa de cartão de crédito!** ✅
5. ✅ Conta criada!

---

#### **1.3. Criar Novo Serviço Web**

1. No dashboard do Render, clique em "**+ New +**" (canto superior direito)
2. Selecione "**Web Service**"
3. Conecte seu repositório GitHub (se ainda não conectou)
4. Selecione repositório `nudge-app`

---

#### **1.4. Configurar Serviço**

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

#### **1.5. Configurar Variáveis de Ambiente**

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

#### **1.6. Criar Serviço e Aguardar Deploy**

1. Role para baixo
2. Clique em "**Create Web Service**"
3. Render vai começar o deploy automaticamente!
4. Aguarde ~5-10 minutos (primeira vez leva mais tempo)
5. Você verá logs em tempo real
6. Quando aparecer "**Your service is live**" ✅ **Pronto!**

---

#### **1.7. Obter URL do Backend**

1. Após deploy, você verá uma URL como:
   ```
   https://nudge-backend.onrender.com
   ```
2. **COPIE ESSA URL!** 📋
3. ✅ Pronto!

---

### **PASSO 2: Inicializar Banco de Dados**

Abra terminal na pasta `backend` e rode:

```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main\backend"
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-demo-users
```

✅ Banco inicializado!

---

### **PASSO 3: Atualizar URL no App Flutter**

1. Edite: `lib/config/payment_config.dart`

2. Encontre:
   ```dart
   static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   ```

3. Comente essa linha e adicione a URL do Render:
   ```dart
   // static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   static const String backendApiUrl = 'https://nudge-backend.onrender.com'; // PRODUÇÃO
   ```
   
   ⚠️ **Substitua `nudge-backend.onrender.com` pela URL real do Render!**

4. Salve o arquivo

---

### **PASSO 4: Gerar Novo APK**

1. Limpe o build anterior:
   ```bash
   flutter clean
   ```

2. Obtenha dependências:
   ```bash
   flutter pub get
   ```

3. Gere o APK:
   ```bash
   flutter build apk --release
   ```

4. ✅ APK gerado!

O APK estará em:
```
build\app\outputs\flutter-apk\app-release.apk
```

---

### **PASSO 5: Enviar APK para Cliente**

#### **Opção 1: Enviar por Email**
1. Anexe o arquivo `app-release.apk` ao email
2. Envie para o cliente

#### **Opção 2: Enviar por WhatsApp/Telegram**
1. Envie o arquivo `app-release.apk` via WhatsApp/Telegram
2. Cliente pode instalar direto do WhatsApp

#### **Opção 3: Upload em Servidor**
1. Faça upload do APK para um servidor
2. Compartilhe o link de download

#### **Opção 4: Google Drive/Dropbox**
1. Faça upload para Google Drive ou Dropbox
2. Compartilhe o link com o cliente

---

### **PASSO 6: Instruções para Cliente Instalar APK**

Envie estas instruções para o cliente:

```
📱 COMO INSTALAR O APK:

1. Baixe o arquivo app-release.apk no seu celular
2. Vá em Configurações → Segurança
3. Ative "Fontes desconhecidas" ou "Instalar apps de fontes desconhecidas"
4. Abra o arquivo .apk baixado
5. Clique em "Instalar"
6. Aguarde a instalação
7. Clique em "Abrir" ou procure o app NUDGE na lista de apps

⚠️ IMPORTANTE:
- Se aparecer aviso de segurança, clique em "Instalar mesmo assim"
- Alguns celulares pedem para permitir instalação via "Arquivos" ou "Downloads"

✅ PRONTO!
```

---

## ✅ **CREDENCIAIS PARA CLIENTE:**

Crie uma conta para o cliente ou envie as credenciais:

### **Opção 1: Criar Conta Específica para Cliente**

Execute no terminal (pasta backend):

```bash
cd backend
node -e "
const mongoose = require('mongoose');
const crypto = require('crypto');
const { connectDB } = require('./config/mongodb');
const Auth = require('./models/Auth');
const User = require('./models/User');

(async () => {
  await connectDB();
  const userId = new mongoose.Types.ObjectId().toString();
  const email = 'cliente@email.com'; // MUDE PARA EMAIL DO CLIENTE
  const password = 'Senha123'; // MUDE PARA SENHA DESEJADA
  
  // Criar auth
  const auth = new Auth({
    userId,
    email: email.toLowerCase(),
    passwordHash: crypto.createHash('sha256').update(password).digest('hex'),
  });
  await auth.save();
  
  // Criar user
  const user = new User({
    id: userId,
    name: 'Nome do Cliente', // MUDE PARA NOME DO CLIENTE
    email: email.toLowerCase(),
    birthDate: new Date('1990-01-01'),
    height: 170,
    weight: 70,
    bodyType: 'mesomorfo',
    goal: 'manutenção',
    targetWeight: 70,
    dailyCalorieGoal: 2000,
    macroGoals: { protein: 150, carbs: 200, fat: 65 },
    role: 'user',
    currentPlan: 'free',
  });
  await user.save();
  
  console.log('✅ Usuário criado!');
  console.log('Email:', email);
  console.log('Senha:', password);
  process.exit(0);
})();
"
```

### **Opção 2: Enviar Credenciais de Teste**

Envie para o cliente:

```
📧 Email: demouser@email.com
🔐 Senha: user123

OU

📧 Email: demoadmin@email.com
🔐 Senha: admin123
```

---

## 📋 **CHECKLIST FINAL:**

- [ ] Código no GitHub
- [ ] Conta Render criada
- [ ] Backend deployado no Render
- [ ] URL do Render copiada
- [ ] Banco de dados inicializado
- [ ] URL atualizada no app Flutter
- [ ] Novo APK gerado
- [ ] APK enviado para cliente
- [ ] Instruções de instalação enviadas
- [ ] Credenciais enviadas ao cliente

---

## 💰 **Custo:**

- **MongoDB Atlas:** $0/mês (tier grátis) ✅
- **Render Backend:** $0/mês (tier grátis) ✅
- **Total:** **$0/mês para sempre!** 💰

---

## 🎉 **PRONTO!**

Depois de seguir todos os passos:

1. ✅ Backend rodando 24/7 na nuvem
2. ✅ App funciona de qualquer lugar
3. ✅ Cliente pode fazer login
4. ✅ Dados salvos no MongoDB
5. ✅ Tudo funcionando! 🚀

---

**🚀 Siga os passos acima e seu app estará pronto para o cliente!**


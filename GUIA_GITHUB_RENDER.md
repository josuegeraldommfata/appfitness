# 🚀 Guia: Conectar GitHub ao Render

## 📋 **Passo a Passo Completo:**

### **PASSO 1: Criar Repositório no GitHub (5 min)**

#### **Opção A: Via GitHub Desktop (Mais Fácil)** ⭐ **RECOMENDADO**

1. **Baixe GitHub Desktop** (se não tiver):
   - Acesse: https://desktop.github.com
   - Baixe e instale

2. **Faça Login:**
   - Abra GitHub Desktop
   - Login com sua conta GitHub

3. **Adicionar Repositório Local:**
   - No GitHub Desktop: "File" → "Add Local Repository"
   - Navegue até: `C:\Users\FIREWALL\Pictures\niudge\nudge-main`
   - Clique em "Add repository"

4. **Publicar no GitHub:**
   - No GitHub Desktop: "Repository" → "Publish repository"
   - Nome do repositório: `nudge-app` (ou outro nome)
   - Escolha: **Público** ou **Privado**
   - **NÃO marque** "Keep this code private" (deixe desmarcado se quiser privado)
   - Clique em "Publish Repository"

5. ✅ **Pronto!** Código está no GitHub!

---

#### **Opção B: Via Site do GitHub**

1. **Acesse GitHub:**
   - Acesse: https://github.com
   - Faça login

2. **Criar Novo Repositório:**
   - Clique no **"+"** (canto superior direito) → **"New repository"**
   - Nome: `nudge-app` (ou outro nome)
   - Descrição: `NUDGE - App de Saúde e Fitness`
   - Escolha: **Público** ou **Privado**
   - **NÃO marque** "Add a README file"
   - **NÃO marque** "Add .gitignore"
   - **NÃO marque** "Choose a license"
   - Clique em **"Create repository"**

3. **Conectar Repositório Local ao GitHub:**

Abra terminal na pasta do projeto e execute:

```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main"

# Inicializar Git (se ainda não tiver)
git init

# Adicionar todos os arquivos
git add .

# Primeiro commit
git commit -m "NUDGE app completo - backend e frontend"

# Conectar ao GitHub (substitua SEU_USUARIO pelo seu usuário do GitHub)
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git

# Renomear branch para main (se necessário)
git branch -M main

# Fazer upload
git push -u origin main
```

✅ **Pronto!** Código está no GitHub!

---

### **PASSO 2: Conectar GitHub ao Render (2 min)**

1. **No Render Dashboard:**
   - Você já está na tela "Create a new Service"
   - Clique em **"New Web Service →"**

2. **Conectar GitHub:**
   - Vai aparecer uma tela pedindo para conectar ao GitHub
   - Clique em **"Connect GitHub"** ou **"Configure GitHub App"**

3. **Autorizar Render:**
   - Se pedir para autorizar:
     - Clique em **"Only select repositories"** (recomendado)
     - Selecione o repositório `nudge-app`
     - Clique em **"Install"** ou **"Authorize"**

4. **Selecionar Repositório:**
   - Depois de autorizar, selecione o repositório `nudge-app`
   - Clique em **"Connect"**

✅ **GitHub conectado ao Render!**

---

## ⚠️ **Se Não Tiver Conta no GitHub:**

### **Criar Conta GitHub (5 min):**

1. **Acesse:** https://github.com/signup
2. **Crie conta:**
   - Username (escolha um nome)
   - Email
   - Senha
   - Verificar email
3. ✅ **Conta criada!**

---

## 🎯 **Resumo Rápido:**

1. ✅ **Criar repositório no GitHub** (via GitHub Desktop ou site)
2. ✅ **Fazer upload do código** (via GitHub Desktop ou Git)
3. ✅ **No Render:** "New Web Service →"
4. ✅ **Conectar GitHub** (autorizar e selecionar repositório)
5. ✅ **Continuar configuração no Render**

---

## 📝 **Próximos Passos Após Conectar:**

Depois de conectar o GitHub, você vai:

1. **Configurar o Serviço:**
   - Name: `nudge-backend`
   - Root Directory: `backend` ⚠️ **IMPORTANTE!**
   - Branch: `main` (ou `master`)
   - Build Command: `cd backend && npm install`
   - Start Command: `cd backend && npm start`
   - Plan: **Free** 🆓

2. **Adicionar Variáveis de Ambiente:**
   - `NODE_ENV=production`
   - `MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`
   - `PORT=3000`

3. **Criar Serviço:**
   - Clique em "Create Web Service"
   - Aguarde deploy (5-10 min)

---

**🚀 Siga os passos acima e me diga quando conectar o GitHub!**


# 🚀 Passo a Passo: Conectar ao GitHub e Render

## 📋 **VOCÊ PRECISA FAZER 2 COISAS:**

1. ✅ **Criar repositório no GitHub e fazer upload do código** (5 min)
2. ✅ **Conectar GitHub ao Render** (2 min)

---

## 🎯 **PASSO 1: Criar Repositório no GitHub (5 min)**

### **Opção A: Via GitHub Desktop** ⭐ **MAIS FÁCIL**

1. **Baixe GitHub Desktop:**
   - Acesse: https://desktop.github.com
   - Baixe e instale

2. **Login:**
   - Abra GitHub Desktop
   - Login com sua conta GitHub

3. **Adicionar Repositório:**
   - No GitHub Desktop: **"File"** → **"Add Local Repository"**
   - Clique em **"Choose..."**
   - Selecione: `C:\Users\FIREWALL\Pictures\niudge\nudge-main`
   - Clique em **"Add repository"**

4. **Publicar no GitHub:**
   - No GitHub Desktop: **"Repository"** → **"Publish repository"**
   - Nome: `nudge-app` (ou outro nome)
   - Escolha: **Público** ou **Privado**
   - **NÃO marque** "Keep this code private"
   - Clique em **"Publish Repository"**

5. ✅ **PRONTO!** Código está no GitHub!

---

### **Opção B: Via Site do GitHub + Terminal**

1. **Criar Repositório no Site:**
   - Acesse: https://github.com/new
   - Nome: `nudge-app`
   - Descrição: `NUDGE - App de Saúde e Fitness`
   - Escolha: **Público** ou **Privado**
   - **NÃO marque** "Add a README file"
   - **NÃO marque** "Add .gitignore"
   - **NÃO marque** "Choose a license"
   - Clique em **"Create repository"**

2. **Copiar URL do Repositório:**
   - Você verá uma URL como: `https://github.com/SEU_USUARIO/nudge-app.git`
   - **COPIE ESSA URL!**

3. **Abrir Terminal na Pasta do Projeto:**
   - Abra PowerShell ou Git Bash
   - Execute:

```bash
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main"

git init

git add .

git commit -m "NUDGE app completo - backend e frontend"

git remote add origin https://github.com/SEU_USUARIO/nudge-app.git

git branch -M main

git push -u origin main
```

⚠️ **Substitua `SEU_USUARIO` pelo seu usuário do GitHub!**

4. ✅ **PRONTO!** Código está no GitHub!

---

## 🎯 **PASSO 2: Conectar GitHub ao Render (2 min)**

Depois que o código estiver no GitHub:

1. **No Render Dashboard:**
   - Você já está na tela "Create a new Service"
   - Clique em **"New Web Service →"**

2. **Vai aparecer tela pedindo para conectar GitHub:**
   - Clique em **"Connect GitHub"** ou **"Configure GitHub App"**

3. **Autorizar Render:**
   - Se pedir para autorizar:
     - Clique em **"Only select repositories"**
     - Selecione o repositório `nudge-app`
     - Clique em **"Install"** ou **"Authorize"**

4. **Selecionar Repositório:**
   - Depois de autorizar, selecione o repositório `nudge-app`
   - Clique em **"Connect"**

5. ✅ **GitHub conectado ao Render!**

---

## ⚠️ **Se Não Tiver Conta no GitHub:**

1. **Acesse:** https://github.com/signup
2. **Crie conta:**
   - Username
   - Email
   - Senha
   - Verificar email
3. ✅ **Conta criada!**

---

## 📝 **Resumo:**

1. ✅ **Criar repositório no GitHub** (GitHub Desktop ou site)
2. ✅ **Fazer upload do código**
3. ✅ **No Render:** "New Web Service →"
4. ✅ **Conectar GitHub**
5. ✅ **Continuar configuração**

---

**🚀 Comece pelo PASSO 1 e me diga quando terminar!**


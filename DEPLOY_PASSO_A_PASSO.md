# 🚀 Deploy no Railway - Passo a Passo COMPLETO

## 🎯 **Vamos fazer o deploy juntos!**

Siga estes passos na ordem. O processo todo leva cerca de **30 minutos**.

---

## ✅ **PASSO 1: Verificar Arquivos do Backend**

Antes de começar, certifique-se que você tem estes arquivos:

- ✅ `backend/package.json` ✅
- ✅ `backend/server.js` ✅
- ✅ `backend/Procfile` ✅ (já criado)
- ✅ `backend/railway.toml` ✅ (já criado)
- ✅ `backend/.gitignore` ✅ (já criado)

**Status:** ✅ Todos os arquivos necessários estão prontos!

---

## ✅ **PASSO 2: Criar Repositório no GitHub (SE AINDA NÃO TEM)**

### **Opção A: Você já tem GitHub?**
Se já tem o código no GitHub, pule para o **PASSO 3**.

### **Opção B: Criar novo repositório:**

1. Acesse: **https://github.com**
2. Faça login (ou crie conta se não tiver)
3. Clique no **+** (canto superior direito) → **New repository**
4. Nome: `nudge-app` (ou outro nome)
5. Descrição: `NUDGE - App de Saúde e Fitness`
6. **Público** ou **Privado** (sua escolha)
7. **NÃO** marque "Initialize with README"
8. Clique em **Create repository**

### **Opção C: Fazer upload via Git (Terminal):**

```bash
# 1. Inicializar Git (se ainda não fez)
git init

# 2. Adicionar todos os arquivos
git add .

# 3. Primeiro commit
git commit -m "Initial commit - NUDGE app completo"

# 4. Conectar ao GitHub (substitua pelo seu repositório)
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git

# 5. Fazer push
git branch -M main
git push -u origin main
```

---

## ✅ **PASSO 3: Criar Conta no Railway**

1. Acesse: **https://railway.app**
2. Clique em "**Start a New Project**" ou "**Login**"
3. Selecione "**Login with GitHub**"
4. Autorize o Railway a acessar seu GitHub
5. ✅ Conta criada!

---

## ✅ **PASSO 4: Criar Projeto no Railway**

1. No dashboard do Railway, clique em "**+ New Project**"
2. Selecione "**Deploy from GitHub repo**"
3. Se aparecer lista de repositórios:
   - Selecione seu repositório `nudge-app` (ou o nome que você usou)
4. Se pedir para conectar GitHub:
   - Clique em "**Configure GitHub App**"
   - Selecione "**Only select repositories**"
   - Escolha seu repositório
   - Clique em "**Install**"
5. Selecione novamente o repositório
6. **IMPORTANTE:** Configure o "**Root Directory**":
   - Clique em "**Settings**" ou "**Configure**"
   - Em "**Root Directory**", digite: `backend`
   - Isso diz ao Railway que o código está na pasta `backend`
7. Clique em "**Deploy**" ou aguarde deploy automático

---

## ✅ **PASSO 5: Configurar Variáveis de Ambiente**

1. No projeto Railway, clique em "**Variables**" (aba lateral)
2. Clique em "**+ New Variable**"
3. Adicione estas variáveis **uma por uma**:

   **Variável 1:**
   - Name: `NODE_ENV`
   - Value: `production`
   - Clique em "**Add**"

   **Variável 2:**
   - Name: `MONGODB_URI`
   - Value: `mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority`
   - Clique em "**Add**"

   **Variável 3 (opcional):**
   - Name: `PORT`
   - Value: `3000`
   - Clique em "**Add**"
   - ⚠️ Nota: Railway define PORT automaticamente, mas adicione mesmo assim

4. ✅ Variáveis configuradas!

---

## ✅ **PASSO 6: Aguardar Deploy**

1. O Railway vai:
   - ✅ Instalar dependências (`npm install`)
   - ✅ Rodar `npm start`
   - ✅ Gerar URL pública

2. Acompanhe o progresso:
   - Vá em "**Deployments**"
   - Veja os logs em tempo real
   - Aguarde aparecer "**Success**" (verde) ✅

3. Tempo estimado: **2-5 minutos**

---

## ✅ **PASSO 7: Obter URL do Backend**

1. No projeto Railway, clique em "**Settings**"
2. Procure por "**Domains**" ou "**Generate Domain**"
3. Você verá algo como:
   ```
   https://nudge-backend-production.up.railway.app
   ```
4. **Copie essa URL completa!** 📋
5. Teste no navegador:
   - Cole a URL no navegador
   - Deve aparecer: `{"message":"NUDGE Backend API","version":"1.0.0","status":"running"}`

---

## ✅ **PASSO 8: Inicializar Banco de Dados**

### **Método 1: Via Terminal Local (Mais Fácil)**

Abra o terminal na pasta `backend` e rode:

```bash
# 1. Inicializar banco de dados
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run init-db

# 2. Criar usuários de teste
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge npm run create-test-users
```

✅ Banco inicializado!

### **Método 2: Via Railway CLI (Opcional)**

Se quiser rodar direto no Railway:

1. Instalar Railway CLI:
   ```bash
   npm install -g @railway/cli
   ```

2. Login:
   ```bash
   railway login
   ```

3. Conectar ao projeto:
   ```bash
   railway link
   ```

4. Rodar scripts:
   ```bash
   railway run npm run init-db
   railway run npm run create-test-users
   ```

---

## ✅ **PASSO 9: Testar o Backend**

### **1. Teste no Navegador:**

Acesse sua URL do Railway (ex: `https://nudge-backend.railway.app`)

Deve aparecer:
```json
{
  "message": "NUDGE Backend API",
  "version": "1.0.0",
  "status": "running"
}
```

### **2. Teste Health Check:**

Acesse: `https://seu-backend.railway.app/health`

Deve aparecer:
```json
{
  "status": "healthy",
  "timestamp": "2024-..."
}
```

### **3. Teste Login (via Postman ou curl):**

```bash
curl -X POST https://seu-backend.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@test.com","password":"admin123"}'
```

Deve retornar token e dados do usuário! ✅

---

## ✅ **PASSO 10: Atualizar App Flutter**

1. Edite o arquivo: `lib/config/payment_config.dart`

2. Encontre a linha:
   ```dart
   static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   ```

3. Comente essa linha e descomente/adicione a URL do Railway:
   ```dart
   // static const String backendApiUrl = 'http://localhost:3000'; // DESENVOLVIMENTO
   static const String backendApiUrl = 'https://SEU-BACKEND.railway.app'; // PRODUÇÃO
   ```

   ⚠️ **Substitua `SEU-BACKEND.railway.app` pela URL real do Railway!**

4. Salve o arquivo

---

## ✅ **PASSO 11: Testar App com Backend em Produção**

1. Execute o app:
   ```bash
   flutter run
   ```

2. Teste login:
   - Email: `admin@test.com`
   - Senha: `admin123`

3. Teste funcionalidades:
   - ✅ Adicionar refeição
   - ✅ Registrar métricas
   - ✅ Adicionar água
   - ✅ Ver dados salvos

4. Se tudo funcionar: ✅ **SUCESSO!**

---

## ✅ **PASSO 12: Configurar CORS (Se Necessário)**

Se der erro de CORS:

1. Edite `backend/server.js`
2. Encontre `allowedOrigins`
3. Adicione a URL do Railway:
   ```javascript
   const allowedOrigins = [
     'http://localhost:3000',
     'http://localhost:8080',
     'https://SEU-BACKEND.railway.app', // ADICIONE AQUI!
     // ...
   ];
   ```

4. Faça commit e push (Railway atualiza automaticamente)

---

## ✅ **PASSO 13: Build para Produção**

Quando tudo estiver funcionando:

```bash
# Para Android
flutter build apk --release

# Para Play Store (recomendado)
flutter build appbundle --release
```

O arquivo estará em:
- `build/app/outputs/flutter-apk/app-release.apk` (APK)
- `build/app/outputs/bundle/release/app-release.aab` (AAB)

---

## ✅ **PASSO 14: Publicar na Play Store**

1. Acesse Google Play Console: https://play.google.com/console
2. Crie um novo app
3. Faça upload do arquivo `.aab`
4. Preencha informações do app
5. Publique!

---

## 📋 **Checklist Final:**

- [ ] Backend deployado no Railway
- [ ] URL do Railway copiada
- [ ] Variáveis de ambiente configuradas
- [ ] Banco de dados inicializado
- [ ] Backend testado e funcionando
- [ ] URL atualizada no app Flutter
- [ ] App testado com backend em produção
- [ ] Build de produção criado
- [ ] Upload para Play Store

---

## 🎉 **PRONTO!**

**Seu aplicativo está funcionando 24/7 na nuvem!**

- ✅ MongoDB Atlas: 24/7 ✅
- ✅ Backend Railway: 24/7 ✅
- ✅ App: Funciona de qualquer lugar ✅

---

## 🆘 **Problemas? Veja `DEPLOY_RAILWAY.md` para solução de problemas!**

---

## 💡 **Dica:**

Mantenha duas versões da URL:
- **Desenvolvimento:** `http://localhost:3000` (para testes locais)
- **Produção:** `https://seu-backend.railway.app` (para Play Store)

Você pode usar variáveis de ambiente no Flutter ou ter dois arquivos de config!

---

**🚀 Pronto para fazer o deploy? Siga os passos acima!**


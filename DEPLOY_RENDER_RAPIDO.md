# 🚀 Deploy Rápido no Render

## ✅ **Código já está no GitHub!**

O código foi enviado para: `https://github.com/robsonmmfata/nudge.git`

---

## 📋 **Passo a Passo para Deploy no Render:**

### 1. **Criar Conta no Render** (5 min)

1. Acesse: https://render.com
2. Clique em "Sign Up"
3. Selecione "Sign up with GitHub"
4. Autorize o Render a acessar seu GitHub
5. ✅ Conta criada!

### 2. **Criar Novo Web Service** (10 min)

1. No dashboard do Render, clique em "**+ New +**" (canto superior direito)
2. Selecione "**Web Service**"
3. Conecte seu repositório GitHub (se ainda não conectou)
4. Selecione o repositório: `robsonmmfata/nudge`

### 3. **Configurar o Serviço**

Preencha os campos:

**Name:**
- `nudge-backend` (ou outro nome)

**Region:**
- Escolha mais próximo (ex: `Oregon (US West)`)

**Branch:**
- `main`

**Root Directory:**
- **IMPORTANTE:** Digite `backend` (isso diz que o código está na pasta backend)

**Runtime:**
- `Node` (deve detectar automaticamente)

**Build Command:**
- `npm install`

**Start Command:**
- `npm start`

**Plan:**
- **Selecione: "Free"** 🆓 (100% grátis!)

### 4. **Configurar Variáveis de Ambiente**

Role para baixo até "**Environment Variables**" e adicione:

#### Variáveis Obrigatórias:

**1. MongoDB:**
```
Key: MONGODB_URI
Value: mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority
```

**2. Port:**
```
Key: PORT
Value: 3000
```

**3. Node Environment:**
```
Key: NODE_ENV
Value: production
```

#### Variáveis de Pagamento (Opcional - para pagamentos funcionarem):

**4. Stripe:**
```
Key: STRIPE_SECRET_KEY
Value: sk_live_YOUR_STRIPE_SECRET_KEY_HERE
```

**5. Mercado Pago:**
```
Key: MERCADOPAGO_ACCESS_TOKEN
Value: APP_USR-YOUR_MERCADOPAGO_ACCESS_TOKEN_HERE
```

#### Variável ChatGPT (Opcional - para chat funcionar):

**6. OpenAI:**
```
Key: OPENAI_API_KEY
Value: sk-YOUR_OPENAI_API_KEY_HERE
```

**⚠️ IMPORTANTE:** Substitua os valores `YOUR_..._HERE` pelas suas chaves reais!

### 5. **Criar Serviço e Aguardar Deploy**

1. Role para baixo
2. Clique em "**Create Web Service**"
3. Render vai começar o deploy automaticamente!
4. Aguarde ~5-10 minutos (primeira vez leva mais tempo)
5. Você verá logs em tempo real
6. Quando aparecer "**Your service is live**" ✅ **Pronto!**

### 6. **Obter URL do Backend**

1. Após deploy, você verá uma URL como:
   ```
   https://nudge-backend.onrender.com
   ```
2. **COPIE ESSA URL!** 📋
3. ✅ Pronto!

---

## 🔧 **Atualizar App Flutter com URL do Render**

### 1. Editar `lib/config/payment_config.dart`

Encontre a linha:
```dart
static const String backendApiUrl = 'http://192.168.131.2:3000';
```

Substitua por:
```dart
static const String backendApiUrl = 'https://nudge-backend.onrender.com';
```

**⚠️ Substitua `nudge-backend.onrender.com` pela URL real do Render!**

### 2. Rebuild do App

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## ✅ **Checklist Final:**

- [ ] Conta Render criada
- [ ] Web Service criado
- [ ] Root Directory configurado como `backend`
- [ ] Variáveis de ambiente configuradas
- [ ] Deploy concluído com sucesso
- [ ] URL do backend copiada
- [ ] URL atualizada no app Flutter
- [ ] App testado com backend em produção

---

## 🎯 **URLs Importantes:**

- **GitHub:** https://github.com/robsonmmfata/nudge
- **Render Dashboard:** https://dashboard.render.com
- **Backend URL:** `https://seu-backend.onrender.com` (será gerado após deploy)

---

## ⚠️ **Notas Importantes:**

1. **Render Free Tier:**
   - App "dorme" após 15 min de inatividade
   - Primeira requisição após dormir pode levar ~30 segundos
   - Para produção, considere upgrade para plano pago

2. **Variáveis de Ambiente:**
   - NUNCA commite chaves secretas no GitHub
   - Use variáveis de ambiente no Render
   - Mantenha `.env` local apenas

3. **Logs:**
   - Acesse logs em tempo real no dashboard do Render
   - Útil para debug

---

## 🚀 **Pronto!**

Agora seu backend está rodando na nuvem e pode ser acessado de qualquer lugar!

**Próximo passo:** Atualizar URL no app Flutter e testar!


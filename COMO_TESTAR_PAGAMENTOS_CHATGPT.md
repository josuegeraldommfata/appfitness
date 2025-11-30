# 🧪 Como Testar Pagamentos e ChatGPT

## 📋 Pré-requisitos

1. **Backend rodando:**
   ```bash
   cd backend
   npm start
   ```

2. **Variáveis de ambiente configuradas** (`backend/.env`):
   ```env
   # Stripe
   STRIPE_SECRET_KEY=sk_live_sua_chave_aqui
   
   # Mercado Pago
   MERCADOPAGO_ACCESS_TOKEN=APP_USR-sua_chave_aqui
   
   # OpenAI ChatGPT
   OPENAI_API_KEY=sk-sua_chave_aqui
   ```

---

## 🚀 Testar Tudo de Uma Vez

Execute o script de teste:

```bash
cd backend
npm run test-payment-chat
```

Este script testa:
- ✅ Health Check do backend
- ✅ ChatGPT (envia mensagem de teste)
- ✅ Stripe Payment Intent (cria checkout)
- ✅ Mercado Pago PIX (cria preferência)

---

## 🧪 Testar Individualmente

### 1. Testar ChatGPT

**Via Script:**
```bash
cd backend
node scripts/testPaymentAndChat.js
```

**Via cURL:**
```bash
curl -X POST http://localhost:3000/api/chatgpt/message \
  -H "Content-Type: application/json" \
  -d '{"message": "Olá, como posso perder peso?"}'
```

**Resposta esperada:**
```json
{
  "success": true,
  "response": "Para perder peso de forma saudável..."
}
```

---

### 2. Testar Stripe (Checkout)

**Via cURL:**
```bash
curl -X POST http://localhost:3000/api/stripe/create-payment-intent \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 10.00,
    "currency": "brl",
    "userId": "test-user-123",
    "planType": "personal",
    "billingPeriod": "monthly"
  }'
```

**Resposta esperada:**
```json
{
  "clientSecret": "pi_xxx_secret_xxx",
  "paymentIntentId": "pi_xxx"
}
```

---

### 3. Testar Mercado Pago PIX

**Via cURL:**
```bash
curl -X POST http://localhost:3000/api/mercado-pago/create-preference \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 10.00,
    "userId": "test-user-123",
    "planType": "personal",
    "billingPeriod": "monthly"
  }'
```

**Resposta esperada:**
```json
{
  "preferenceId": "xxx",
  "initPoint": "https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=xxx"
}
```

---

## 📱 Testar no App Flutter

### 1. ChatGPT
1. Abra o app
2. Vá para a tela de Chat IA
3. Digite uma mensagem
4. Verifique se recebe resposta

### 2. Stripe Checkout
1. Vá para Planos e Assinaturas
2. Selecione um plano pago
3. Escolha Stripe como método de pagamento
4. Verifique se o checkout abre

### 3. Mercado Pago PIX
1. Vá para Planos e Assinaturas
2. Selecione um plano pago
3. Escolha Mercado Pago como método de pagamento
4. Verifique se aparece opção PIX
5. Verifique se o QR Code PIX é gerado

---

## ⚠️ Problemas Comuns

### Backend não responde
- Verifique se está rodando: `npm start`
- Verifique se a porta 3000 está livre

### ChatGPT retorna erro
- Verifique se `OPENAI_API_KEY` está configurada no `.env`
- Verifique se a chave é válida

### Stripe retorna erro
- Verifique se `STRIPE_SECRET_KEY` está configurada no `.env`
- Use chave de teste durante desenvolvimento: `sk_test_...`

### Mercado Pago retorna erro
- Verifique se `MERCADOPAGO_ACCESS_TOKEN` está configurada no `.env`
- Verifique se a chave é válida

---

## ✅ Checklist de Teste

- [ ] Backend rodando (`npm start`)
- [ ] Health Check OK (`/health`)
- [ ] ChatGPT responde (`/api/chatgpt/message`)
- [ ] Stripe cria Payment Intent (`/api/stripe/create-payment-intent`)
- [ ] Mercado Pago cria Preference (`/api/mercado-pago/create-preference`)
- [ ] App Flutter conecta ao backend
- [ ] Chat IA funciona no app
- [ ] Checkout Stripe abre no app
- [ ] PIX Mercado Pago funciona no app

---

## 🎯 Resultado Esperado

Todos os testes devem passar:
```
✅ Health Check: OK
✅ ChatGPT: OK
✅ Stripe Payment: OK
✅ Mercado Pago PIX: OK
```


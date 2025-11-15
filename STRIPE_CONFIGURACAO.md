# Configuração do Stripe - NUDGE

## ✅ Chaves Configuradas

### Chave Pública (Publishable Key)
```
pk_live_51STRZXEYtTHdCbedqp9M4oOaHH0Bt7HFBQdQkoRFxvkkgc78AfaD85p08BlcsuJxdO0tBRu0jlzPsJNp6HhNJEEA00wg0NJVT7
```
- ✅ **Segura para uso no app mobile**
- ✅ **Pode ser exposta publicamente**
- ✅ **Já configurada em `lib/config/payment_config.dart`**

### Chave Secreta (Secret Key)
```
sk_live_YOUR_SECRET_KEY_HERE
```
- ⚠️ **NUNCA usar no app mobile**
- ⚠️ **Usar APENAS no backend server**
- ⚠️ **Configurar como variável de ambiente no backend**

## 📦 Planos Configurados

### 1. Plano Personal
- **Produto ID**: `prod_TQIoHJdf1Mn967`
- **Mensal**: `price_1STSDLEYtTHdCbedsIDi3Sxh` (R$ 19,90)
- **Anual**: `price_1STSEGEYtTHdCbedwqkL8Fwb` (R$ 199,00)

### 2. Plano Personal Plus
- **Produto ID**: `prod_TQIzygDRhqOEZ3`
- **Mensal**: `price_1STSNREYtTHdCbedeA8EcOY5` (R$ 49,90)
- **Anual**: `price_1STSNtEYtTHdCbediOeGqJ5i` (R$ 499,00)

### 3. Plano Líder
- **Produto ID**: `prod_TQJ2mm7H9wQJdU`
- **Mensal**: `price_1STSQUEYtTHdCbed8wktVd1G` (R$ 99,00)
- **Anual**: `price_1STSRFEYtTHdCbed6UFpx484` (R$ 999,00)

## 🔧 Configuração no Backend

### Variáveis de Ambiente
Configure no seu backend server:
```bash
STRIPE_SECRET_KEY=sk_live_YOUR_SECRET_KEY_HERE
```

### Exemplo de Backend (Node.js)
```javascript
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// Criar Payment Intent
app.post('/create-payment-intent', async (req, res) => {
  const { amount, currency, userId, planType, billingPeriod } = req.body;
  
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount * 100, // Convert to cents
    currency: currency.toLowerCase(),
    metadata: {
      userId: userId,
      planType: planType,
      billingPeriod: billingPeriod,
    },
  });
  
  res.json({
    clientSecret: paymentIntent.client_secret,
    paymentIntentId: paymentIntent.id,
  });
});

// Criar Subscription
app.post('/create-subscription', async (req, res) => {
  const { customerId, priceId } = req.body;
  
  const subscription = await stripe.subscriptions.create({
    customer: customerId,
    items: [{ price: priceId }],
  });
  
  res.json({
    subscriptionId: subscription.id,
    status: subscription.status,
  });
});
```

## 📝 Price IDs para Uso no Backend

### Personal
- Mensal: `price_1STSDLEYtTHdCbedsIDi3Sxh`
- Anual: `price_1STSEGEYtTHdCbedwqkL8Fwb`

### Personal Plus
- Mensal: `price_1STSNREYtTHdCbedeA8EcOY5`
- Anual: `price_1STSNtEYtTHdCbediOeGqJ5i`

### Leader
- Mensal: `price_1STSQUEYtTHdCbed8wktVd1G`
- Anual: `price_1STSRFEYtTHdCbed6UFpx484`

## 🔒 Segurança

### ✅ O que fazer:
1. Use a chave pública no app mobile
2. Use a chave secreta apenas no backend
3. Configure a chave secreta como variável de ambiente
4. Nunca commite a chave secreta no repositório

### ❌ O que NÃO fazer:
1. ❌ Nunca use a chave secreta no app mobile
2. ❌ Nunca commite a chave secreta no código
3. ❌ Nunca exponha a chave secreta publicamente
4. ❌ Nunca envie a chave secreta em requisições HTTP do app

## 🧪 Testes

### Cartões de Teste (Modo Test)
Se você precisar testar, use os cartões de teste do Stripe:
- **Sucesso**: `4242 4242 4242 4242`
- **Falha**: `4000 0000 0000 0002`
- **3D Secure**: `4000 0025 0000 3155`

### Modo Live
⚠️ **ATENÇÃO**: As chaves fornecidas são **LIVE** (produção). Qualquer pagamento será real!

## 📚 Documentação

- [Stripe Dashboard](https://dashboard.stripe.com/)
- [Stripe API Documentation](https://stripe.com/docs/api)
- [Stripe Subscriptions](https://stripe.com/docs/billing/subscriptions/overview)
- [Stripe Security Best Practices](https://stripe.com/docs/security/guide)

## 🆘 Suporte

Em caso de problemas:
1. Verifique se as chaves estão corretas
2. Verifique se o backend está configurado corretamente
3. Verifique os logs do Stripe Dashboard
4. Consulte a documentação do Stripe

---

**Última atualização**: Configuração completa com chaves LIVE
**Status**: ✅ Chave pública configurada no app | ⚠️ Chave secreta deve ser configurada no backend


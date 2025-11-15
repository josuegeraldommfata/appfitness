# Configuração de Pagamentos - NUDGE

Este documento descreve como configurar os sistemas de pagamento (Stripe e Mercado Pago) no aplicativo NUDGE.

## 📋 Pré-requisitos

1. Conta no Stripe (https://stripe.com/br)
2. Conta no Mercado Pago (https://www.mercadopago.com.br/)
3. Backend API para processar pagamentos com segurança

## 🔑 Configuração das Chaves de API

### 1. Stripe

1. Acesse o [Dashboard do Stripe](https://dashboard.stripe.com/apikeys)
2. Copie sua **Chave Pública** (Publishable Key)
3. Copie sua **Chave Secreta** (Secret Key) - **NUNCA exponha esta chave no app mobile!**
4. Atualize o arquivo `lib/config/payment_config.dart`:
   ```dart
   static const String stripePublishableKey = 'pk_test_...'; // Sua chave pública
   static const String stripeSecretKey = 'sk_test_...'; // Use apenas no backend!
   ```

### 2. Mercado Pago

1. Acesse o [Painel do Mercado Pago](https://www.mercadopago.com.br/developers/panel/credentials)
2. Copie sua **Chave Pública** (Public Key)
3. Copie seu **Token de Acesso** (Access Token) - **NUNCA exponha este token no app mobile!**
4. Atualize o arquivo `lib/config/payment_config.dart`:
   ```dart
   static const String mercadoPagoPublicKey = 'TEST-...'; // Sua chave pública
   static const String mercadoPagoAccessToken = 'TEST-...'; // Use apenas no backend!
   ```

## 🏗️ Configuração do Backend

### Importante: Segurança

**NUNCA** coloque as chaves secretas (Stripe Secret Key ou Mercado Pago Access Token) no código do aplicativo mobile. Essas chaves devem ser usadas apenas no seu backend.

### Endpoints do Backend Necessários

Seu backend precisa implementar os seguintes endpoints:

1. **POST /create-payment-intent** (Stripe)
   - Cria um Payment Intent no Stripe
   - Retorna `clientSecret` e `paymentIntentId`

2. **POST /create-subscription** (Stripe)
   - Cria uma assinatura no Stripe
   - Retorna `subscriptionId`

3. **POST /create-mercadopago-preference** (Mercado Pago)
   - Cria uma preferência de pagamento no Mercado Pago
   - Retorna `preferenceId` e `initPoint`

4. **GET /verify-mercadopago-payment** (Mercado Pago)
   - Verifica o status de um pagamento no Mercado Pago
   - Retorna o status do pagamento

### Exemplo de Backend (Node.js)

```javascript
// Exemplo usando Express.js
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const mercadopago = require('mercadopago');

// Configurar Mercado Pago
mercadopago.configure({
  access_token: process.env.MERCADOPAGO_ACCESS_TOKEN
});

// Criar Payment Intent (Stripe)
app.post('/create-payment-intent', async (req, res) => {
  const { amount, currency, userId, planType, billingPeriod } = req.body;
  
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount,
    currency: currency,
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

// Criar Preferência (Mercado Pago)
app.post('/create-mercadopago-preference', async (req, res) => {
  const { amount, userId, planType, billingPeriod } = req.body;
  
  const preference = await mercadopago.preferences.create({
    items: [
      {
        title: `Plano ${planType}`,
        quantity: 1,
        unit_price: amount,
      },
    ],
    metadata: {
      userId: userId,
      planType: planType,
      billingPeriod: billingPeriod,
    },
  });
  
  res.json({
    preferenceId: preference.body.id,
    initPoint: preference.body.init_point,
  });
});
```

## 📦 Configuração dos Planos

### Stripe

1. Acesse o [Dashboard do Stripe](https://dashboard.stripe.com/products)
2. Crie produtos para cada plano:
   - Personal (Mensal)
   - Personal (Anual)
   - Personal Plus (Mensal)
   - Personal Plus (Anual)
   - Leader (Mensal)
   - Leader (Anual)
3. Copie os **Price IDs** de cada plano
4. Atualize o arquivo `lib/config/payment_config.dart`:
   ```dart
   static const Map<String, Map<String, String>> stripePriceIds = {
     'personal': {
       'monthly': 'price_xxxxx', // Seu Price ID mensal
       'yearly': 'price_xxxxx',  // Seu Price ID anual
     },
     // ...
   };
   ```

### Mercado Pago

1. Acesse o [Painel do Mercado Pago](https://www.mercadopago.com.br/subscriptions)
2. Crie planos de assinatura para cada plano
3. Copie os **Plan IDs** de cada plano
4. Atualize o arquivo `lib/config/payment_config.dart`:
   ```dart
   static const Map<String, Map<String, String>> mercadoPagoPlanIds = {
     'personal': {
       'monthly': 'plan_xxxxx', // Seu Plan ID mensal
       'yearly': 'plan_xxxxx',  // Seu Plan ID anual
     },
     // ...
   };
   ```

## 🧪 Testes

### Stripe

Use os cartões de teste do Stripe:
- **Sucesso**: `4242 4242 4242 4242`
- **Falha**: `4000 0000 0000 0002`
- **3D Secure**: `4000 0025 0000 3155`

### Mercado Pago

Use os cartões de teste do Mercado Pago:
- **Sucesso**: `5031 7557 3453 0604`
- **Falha**: `5031 4332 1540 6351`

## 📝 Próximos Passos

1. Configure as chaves de API no arquivo `lib/config/payment_config.dart`
2. Configure seu backend para processar os pagamentos
3. Crie os planos no Stripe e Mercado Pago
4. Teste os pagamentos em ambiente de desenvolvimento
5. Configure webhooks para receber notificações de pagamento
6. Implemente a lógica de verificação de assinaturas no app

## 🔒 Segurança

- **NUNCA** exponha chaves secretas no código do aplicativo
- Use HTTPS para todas as comunicações
- Valide todos os pagamentos no backend
- Implemente webhooks para receber notificações de pagamento
- Use ambiente de teste durante o desenvolvimento
- Monitore os pagamentos regularmente

## 📚 Documentação

- [Stripe Documentation](https://stripe.com/docs)
- [Mercado Pago Documentation](https://www.mercadopago.com.br/developers/pt/docs)
- [Flutter Stripe Plugin](https://pub.dev/packages/flutter_stripe)

## ❓ Suporte

Em caso de dúvidas, consulte a documentação oficial ou entre em contato com o suporte técnico.


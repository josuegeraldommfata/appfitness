# Configuração do Mercado Pago - NUDGE

## ✅ Chaves Configuradas

### Chave Pública (Public Key)
```
APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
```
- ✅ **Segura para uso no app mobile**
- ✅ **Pode ser exposta publicamente**
- ✅ **Já configurada em `lib/config/payment_config.dart`**

### Token de Acesso (Access Token)
```
APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520
```
- ⚠️ **NUNCA usar no app mobile**
- ⚠️ **Usar APENAS no backend server**
- ⚠️ **Configurar como variável de ambiente no backend**

## 🔧 Configuração no Backend

### Variáveis de Ambiente
Configure no seu backend server:
```bash
MERCADOPAGO_ACCESS_TOKEN=APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
```

### Arquivo .env
Crie um arquivo `.env` na pasta `backend/`:

```env
# Mercado Pago Configuration
MERCADOPAGO_ACCESS_TOKEN=APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
MERCADOPAGO_SUCCESS_URL=https://your-app.com/success
MERCADOPAGO_FAILURE_URL=https://your-app.com/failure
MERCADOPAGO_PENDING_URL=https://your-app.com/pending
```

### Exemplo de Backend (Node.js)
```javascript
const mercadopago = require('mercadopago');

// Configure Mercado Pago
mercadopago.configurations.setAccessToken(process.env.MERCADOPAGO_ACCESS_TOKEN);

// Criar Preferência
app.post('/create-preference', async (req, res) => {
  const { amount, userId, planType, billingPeriod } = req.body;
  
  const preference = {
    items: [
      {
        title: `Plano ${planType} - ${billingPeriod}`,
        quantity: 1,
        unit_price: amount,
        currency_id: 'BRL',
      },
    ],
    payer: {
      email: userId, // You should get user email from database
    },
    metadata: {
      userId: userId,
      planType: planType,
      billingPeriod: billingPeriod,
    },
    back_urls: {
      success: process.env.MERCADOPAGO_SUCCESS_URL,
      failure: process.env.MERCADOPAGO_FAILURE_URL,
      pending: process.env.MERCADOPAGO_PENDING_URL,
    },
    auto_return: 'approved',
  };

  const response = await mercadopago.preferences.create(preference);
  
  res.json({
    preferenceId: response.body.id,
    initPoint: response.body.init_point,
  });
});
```

## 📱 Configuração no App Mobile

### Arquivo `lib/config/payment_config.dart`
A chave pública já está configurada:

```dart
static const String mercadoPagoPublicKey = 'APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f';
```

### ⚠️ IMPORTANTE
- **NUNCA** use o Access Token no app mobile
- Use apenas a Public Key no app mobile
- O Access Token deve ser usado apenas no backend

## 🔌 Endpoints da API

### Criar Preferência de Pagamento
```
POST /api/mercado-pago/create-preference
```

**Request:**
```json
{
  "amount": 19.90,
  "userId": "user-id",
  "planType": "personal",
  "billingPeriod": "monthly"
}
```

**Response:**
```json
{
  "preferenceId": "1234567890-abcdef-123456",
  "initPoint": "https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=1234567890-abcdef-123456",
  "sandboxInitPoint": "https://sandbox.mercadopago.com.br/checkout/v1/redirect?pref_id=1234567890-abcdef-123456"
}
```

### Verificar Pagamento
```
GET /api/mercado-pago/verify-payment?payment_id=1234567890
```

**Response:**
```json
{
  "paymentId": "1234567890",
  "status": "approved",
  "statusDetail": "accredited",
  "transactionAmount": 19.90,
  "currencyId": "BRL"
}
```

### Webhook
```
POST /api/mercado-pago/webhook
```

## 🧪 Testes

### Modo Sandbox
Para testes, use o modo sandbox do Mercado Pago. As chaves fornecidas são de produção (APP_USR-...), mas você pode criar chaves de teste no painel do Mercado Pago.

### Cartões de Teste
Para testes, use os cartões de teste do Mercado Pago:
- **Sucesso**: `5031 7557 3453 0604`
- **Falha**: `5031 4332 1540 6351`
- **Pendente**: `5031 4332 1540 6351`

### Modo Produção
⚠️ **ATENÇÃO**: As chaves fornecidas são de **PRODUÇÃO**. Qualquer pagamento será real!

## 🔒 Segurança

### ✅ O que fazer:
1. Use a chave pública no app mobile
2. Use o access token apenas no backend
3. Configure o access token como variável de ambiente
4. Nunca commite o access token no repositório

### ❌ O que NÃO fazer:
1. ❌ Nunca use o access token no app mobile
2. ❌ Nunca commite o access token no código
3. ❌ Nunca exponha o access token publicamente
4. ❌ Nunca envie o access token em requisições HTTP do app

## 📚 Documentação

- [Mercado Pago Dashboard](https://www.mercadopago.com.br/developers/panel)
- [Mercado Pago API Documentation](https://www.mercadopago.com.br/developers/pt/docs)
- [Mercado Pago Preferences](https://www.mercadopago.com.br/developers/pt/docs/checkout-pro/integration-configuration/preferences)
- [Mercado Pago Webhooks](https://www.mercadopago.com.br/developers/pt/docs/your-integrations/notifications/webhooks)

## 🆘 Suporte

Em caso de problemas:
1. Verifique se as chaves estão corretas
2. Verifique se o backend está configurado corretamente
3. Verifique os logs do Mercado Pago Dashboard
4. Consulte a documentação do Mercado Pago

## 🔄 Configurar Webhooks

### 1. Acesse o Dashboard do Mercado Pago
https://www.mercadopago.com.br/developers/panel

### 2. Configure Webhooks
1. Vá em "Webhooks"
2. Adicione a URL do seu backend: `https://your-backend.com/api/mercado-pago/webhook`
3. Selecione os eventos que deseja receber:
   - `payment`
   - `merchant_order`
   - `subscription`

### 3. Testar Webhook
Use o modo sandbox para testar os webhooks antes de ir para produção.

## 📝 Próximos Passos

1. ✅ Configurar chaves no backend
2. ✅ Configurar chave pública no app mobile
3. ⏳ Configurar webhooks do Mercado Pago
4. ⏳ Testar integração com o app mobile
5. ⏳ Implementar fluxo de pagamento completo
6. ⏳ Testar em ambiente de produção

---

**Última atualização**: Configuração completa com chaves de PRODUÇÃO
**Status**: ✅ Chave pública configurada no app | ⚠️ Access token deve ser configurado no backend


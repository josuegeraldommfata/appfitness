# Configuração Completa de Pagamentos - NUDGE

## ✅ Status da Configuração

### Stripe
- ✅ **Chave pública configurada**: `pk_live_51STRZXEYtTHdCbedqp9M4oOaHH0Bt7HFBQdQkoRFxvkkgc78AfaD85p08BlcsuJxdO0tBRu0jlzPsJNp6HhNJEEA00wg0NJVT7`
- ✅ **Chave secreta configurada no backend**: `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`
- ✅ **Price IDs configurados**: Personal, Personal Plus, Leader (Mensal e Anual)

### Mercado Pago
- ✅ **Chave pública configurada**: `APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f`
- ✅ **Access token configurado no backend**: `APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520`
- ⚠️ **Planos precisam ser criados no Mercado Pago Dashboard**

## 🔧 Configuração do Backend

### Arquivo `.env`
Crie um arquivo `.env` na pasta `backend/`:

```env
# MongoDB Atlas Configuration
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority

# Server Configuration
PORT=3000
NODE_ENV=development

# Stripe Configuration
STRIPE_SECRET_KEY=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
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

# Mercado Pago Configuration
MERCADOPAGO_ACCESS_TOKEN=APP_USR-962011830720089-111415-bcffcdf3b9ab0b8982cd406d845391f0-2991374520
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
MERCADOPAGO_SUCCESS_URL=https://your-app.com/success
MERCADOPAGO_FAILURE_URL=https://your-app.com/failure
MERCADOPAGO_PENDING_URL=https://your-app.com/pending
```

## 📱 Configuração do App Mobile

### Arquivo `lib/config/payment_config.dart`
Já está configurado com:

```dart
// Stripe
static const String stripePublishableKey = 'pk_live_51STRZXEYtTHdCbedqp9M4oOaHH0Bt7HFBQdQkoRFxvkkgc78AfaD85p08BlcsuJxdO0tBRu0jlzPsJNp6HhNJEEA00wg0NJVT7';

// Mercado Pago
static const String mercadoPagoPublicKey = 'APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f';

// Backend URL
static const String backendApiUrl = 'http://localhost:3000';
```

## 🔌 Endpoints Disponíveis

### Stripe
- `POST /api/stripe/create-payment-intent` - Criar payment intent
- `POST /api/stripe/create-subscription` - Criar assinatura
- `POST /api/stripe/webhook` - Webhook do Stripe

### Mercado Pago
- `POST /api/mercado-pago/create-preference` - Criar preferência de pagamento
- `GET /api/mercado-pago/verify-payment` - Verificar pagamento
- `POST /api/mercado-pago/webhook` - Webhook do Mercado Pago

## 📋 Planos Configurados

### Stripe
1. **Personal**
   - Mensal: `price_1STSDLEYtTHdCbedsIDi3Sxh` (R$ 19,90)
   - Anual: `price_1STSEGEYtTHdCbedwqkL8Fwb` (R$ 199,00)

2. **Personal Plus**
   - Mensal: `price_1STSNREYtTHdCbedeA8EcOY5` (R$ 49,90)
   - Anual: `price_1STSNtEYtTHdCbediOeGqJ5i` (R$ 499,00)

3. **Leader**
   - Mensal: `price_1STSQUEYtTHdCbed8wktVd1G` (R$ 99,00)
   - Anual: `price_1STSRFEYtTHdCbed6UFpx484` (R$ 999,00)

### Mercado Pago
⚠️ **Planos precisam ser criados no Mercado Pago Dashboard**

1. Acesse: https://www.mercadopago.com.br/subscriptions
2. Crie planos para:
   - Personal (Mensal e Anual)
   - Personal Plus (Mensal e Anual)
   - Leader (Mensal e Anual)
3. Copie os Plan IDs e atualize `lib/config/payment_config.dart`

## 🚀 Como Executar

### 1. Configurar Backend
```bash
cd backend
npm install
cp .env.example .env
# Edite o arquivo .env com suas credenciais
npm run init-db
npm start
```

### 2. Configurar App Mobile
- As chaves já estão configuradas no app
- Atualize a URL do backend em `lib/config/payment_config.dart`:
  - Desenvolvimento: `http://localhost:3000`
  - Produção: `https://your-backend.com`

### 3. Testar Integração
1. Inicie o backend
2. Inicie o app mobile
3. Teste os planos gratuitos (FREE e FIT)
4. Teste os pagamentos com Stripe
5. Teste os pagamentos com Mercado Pago

## 🔒 Segurança

### ⚠️ IMPORTANTE
- **NUNCA** exponha chaves secretas no código do app mobile
- Use variáveis de ambiente no backend
- Mantenha o arquivo `.env` no `.gitignore`
- Use HTTPS em produção
- Configure webhooks adequadamente

## 📚 Documentação

### Stripe
- [Stripe Dashboard](https://dashboard.stripe.com/)
- [Stripe API Documentation](https://stripe.com/docs/api)
- [Stripe Webhooks](https://stripe.com/docs/webhooks)

### Mercado Pago
- [Mercado Pago Dashboard](https://www.mercadopago.com.br/developers/panel)
- [Mercado Pago API Documentation](https://www.mercadopago.com.br/developers/pt/docs)
- [Mercado Pago Webhooks](https://www.mercadopago.com.br/developers/pt/docs/your-integrations/notifications/webhooks)

## 🧪 Testes

### Stripe
Use os cartões de teste:
- **Sucesso**: `4242 4242 4242 4242`
- **Falha**: `4000 0000 0000 0002`

### Mercado Pago
Use os cartões de teste:
- **Sucesso**: `5031 7557 3453 0604`
- **Falha**: `5031 4332 1540 6351`

## 🆘 Suporte

Em caso de problemas:
1. Verifique se as chaves estão corretas
2. Verifique se o backend está rodando
3. Verifique os logs do servidor
4. Consulte a documentação

## ✅ Checklist

- [x] Chaves Stripe configuradas
- [x] Chaves Mercado Pago configuradas
- [x] Backend configurado
- [x] App mobile configurado
- [x] Price IDs Stripe configurados
- [ ] Plan IDs Mercado Pago configurados (precisa criar no dashboard)
- [ ] Webhooks Stripe configurados
- [ ] Webhooks Mercado Pago configurados
- [ ] Testes realizados
- [ ] Deploy em produção

---

**Última atualização**: Configuração completa com Stripe e Mercado Pago
**Status**: ✅ Stripe configurado | ✅ Mercado Pago configurado | ⚠️ Planos Mercado Pago precisam ser criados


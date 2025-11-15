# NUDGE Backend API

Backend API para o aplicativo NUDGE com integração MongoDB Atlas, Stripe e Mercado Pago.

## 📋 Pré-requisitos

- Node.js 18+ instalado
- MongoDB Atlas account
- Stripe account
- Mercado Pago account (opcional)

## 🚀 Instalação

1. **Instalar dependências:**
```bash
npm install
```

2. **Configurar variáveis de ambiente:**
```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas credenciais:
- MongoDB Atlas connection string
- Stripe secret key
- Mercado Pago access token (opcional)

3. **Inicializar banco de dados:**
```bash
npm run init-db
```

Este comando criará todas as coleções e índices necessários no MongoDB Atlas.

## 🏃 Executar

**Desenvolvimento:**
```bash
npm run dev
```

**Produção:**
```bash
npm start
```

O servidor estará rodando em `http://localhost:3000`

## 📁 Estrutura do Projeto

```
backend/
├── config/
│   └── mongodb.js          # Configuração MongoDB
├── models/
│   ├── User.js             # Modelo de usuário
│   ├── Subscription.js     # Modelo de assinatura
│   ├── Meal.js             # Modelo de refeição
│   ├── BodyMetrics.js      # Modelo de métricas corporais
│   └── WaterIntake.js      # Modelo de ingestão de água
├── routes/
│   ├── stripe.js           # Rotas Stripe
│   ├── mercadoPago.js      # Rotas Mercado Pago
│   ├── users.js            # Rotas de usuários
│   └── subscriptions.js    # Rotas de assinaturas
├── scripts/
│   └── initDatabase.js     # Script de inicialização do banco
├── server.js               # Servidor principal
├── package.json            # Dependências
└── .env.example            # Exemplo de variáveis de ambiente
```

## 🔌 Endpoints da API

### Stripe
- `POST /api/stripe/create-payment-intent` - Criar payment intent
- `POST /api/stripe/create-subscription` - Criar assinatura
- `POST /api/stripe/webhook` - Webhook do Stripe

### Mercado Pago
- `POST /api/mercado-pago/create-preference` - Criar preferência de pagamento
- `GET /api/mercado-pago/verify-payment` - Verificar pagamento
- `POST /api/mercado-pago/webhook` - Webhook do Mercado Pago

### Usuários
- `GET /api/users/:userId` - Obter usuário
- `POST /api/users` - Criar/atualizar usuário
- `PUT /api/users/:userId` - Atualizar usuário

### Assinaturas
- `GET /api/subscriptions/user/:userId` - Obter assinaturas do usuário
- `GET /api/subscriptions/user/:userId/active` - Obter assinatura ativa
- `POST /api/subscriptions` - Criar assinatura
- `PUT /api/subscriptions/:subscriptionId` - Atualizar assinatura
- `DELETE /api/subscriptions/:subscriptionId` - Cancelar assinatura

## 🗄️ Banco de Dados

### Coleções

1. **users** - Usuários do aplicativo
2. **subscriptions** - Assinaturas dos usuários
3. **meals** - Refeições registradas
4. **bodymetrics** - Métricas corporais
5. **waterintakes** - Ingestão de água

### Índices

Todos os índices necessários são criados automaticamente pelo script de inicialização.

## 🔒 Segurança

- Use variáveis de ambiente para credenciais sensíveis
- Nunca commite o arquivo `.env` no repositório
- Use HTTPS em produção
- Configure CORS adequadamente
- Valide todas as requisições

## 📚 Documentação

Para mais informações sobre:
- MongoDB Atlas: https://docs.atlas.mongodb.com/
- Stripe API: https://stripe.com/docs/api
- Mercado Pago API: https://www.mercadopago.com.br/developers/pt/docs

## 🆘 Suporte

Em caso de problemas:
1. Verifique se as variáveis de ambiente estão configuradas corretamente
2. Verifique se o MongoDB Atlas está acessível
3. Verifique os logs do servidor
4. Consulte a documentação das APIs

## 📝 Licença

ISC


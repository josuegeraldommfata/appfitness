# Implementação de Planos - NUDGE

## ✅ O que foi implementado

### 1. Modelos de Dados
- **Plan** (`lib/models/plan.dart`): Modelo para definir os planos disponíveis
- **Subscription** (`lib/models/subscription.dart`): Modelo para gerenciar assinaturas dos usuários
- **User** (atualizado): Adicionados campos `herbalifeId` e `currentPlan`

### 2. Planos Disponíveis
- **🩵 FREE**: R$ 0/mês
  - Registro de hidratação
  - Registro manual de refeições
  - Progresso corporal básico (peso)
  - Ranking da comunidade

- **🟢 FIT**: R$ 0/mês (requer ID Herbalife)
  - Tudo do plano Free
  - Progresso corporal completo (peso, gordura, massa muscular)
  - Gráficos detalhados da evolução
  - Acesso aos desafios da comunidade

- **🔵 PERSONAL**: R$ 19,90/mês ou R$ 199/ano
  - Todas as vantagens do plano Fit
  - 200 mensagens/mês com o Personal IA
  - Metas baseadas no seu estilo de vida

- **🟣 PERSONAL PLUS**: R$ 49,90/mês ou R$ 499/ano
  - Todas as vantagens do Plano Personal
  - Mensagens ilimitadas com o Coach IA

- **🟠 LÍDER**: R$ 99/mês ou R$ 999/ano (adicional)
  - Área exclusiva do Líder
  - Crie sua própria equipe
  - Gere links de afiliação
  - Marketing inteligente
  - Relatórios de desempenho

### 3. Serviços
- **PaymentService** (`lib/services/payment_service.dart`): Serviço para processar pagamentos com Stripe e Mercado Pago
- **FirebaseService** (atualizado): Métodos para gerenciar assinaturas no Firestore

### 4. Providers
- **SubscriptionProvider** (`lib/providers/subscription_provider.dart`): Provider para gerenciar assinaturas e acesso a funcionalidades

### 5. Telas
- **PlansScreen** (`lib/screens/plans_screen.dart`): Tela para exibir e selecionar planos
- **SettingsScreen** (atualizado): Adicionado link para acessar os planos

### 6. Configuração
- **PaymentConfig** (`lib/config/payment_config.dart`): Configuração centralizada para chaves de API

## 📝 Próximos Passos

### 1. Configurar Chaves de API
1. Abra o arquivo `lib/config/payment_config.dart`
2. Substitua `YOUR_STRIPE_PUBLISHABLE_KEY` pela sua chave pública do Stripe
3. Substitua `YOUR_MERCADOPAGO_PUBLIC_KEY` pela sua chave pública do Mercado Pago
4. **IMPORTANTE**: As chaves secretas devem ser usadas apenas no backend!

### 2. Configurar Backend
Você precisa criar um backend para processar os pagamentos com segurança. Veja o arquivo `PAYMENT_SETUP.md` para mais detalhes.

### 3. Criar Planos no Stripe e Mercado Pago
1. Crie os planos no Stripe Dashboard
2. Crie os planos no Mercado Pago Dashboard
3. Copie os Price IDs e Plan IDs
4. Atualize o arquivo `lib/config/payment_config.dart` com os IDs

### 4. Testar
1. Teste os planos gratuitos (FREE e FIT)
2. Teste os pagamentos em ambiente de desenvolvimento
3. Verifique se as assinaturas estão sendo salvas no Firestore
4. Teste a verificação de acesso a funcionalidades baseadas no plano

## 🔧 Como usar

### Acessar a tela de planos
1. Abra o app
2. Vá para Configurações
3. Toque em "Planos e Assinaturas"

### Assinar um plano
1. Selecione o plano desejado
2. Escolha o período (Mensal ou Anual)
3. Para planos pagos, escolha o método de pagamento (Stripe ou Mercado Pago)
4. Complete o pagamento
5. A assinatura será ativada automaticamente

### Verificar acesso a funcionalidades
```dart
final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
if (subscriptionProvider.hasAccessToFeature('ai_chat')) {
  // Usuário tem acesso ao chat IA
}
```

## 🚨 Importante

- **NUNCA** exponha chaves secretas no código do aplicativo
- Use HTTPS para todas as comunicações
- Valide todos os pagamentos no backend
- Implemente webhooks para receber notificações de pagamento
- Use ambiente de teste durante o desenvolvimento

## 📚 Documentação

- Veja `PAYMENT_SETUP.md` para instruções detalhadas de configuração
- Veja a documentação do Stripe: https://stripe.com/docs
- Veja a documentação do Mercado Pago: https://www.mercadopago.com.br/developers/pt/docs

## 🐛 Problemas Conhecidos

- O pacote `mercadopago_sdk` não foi incluído no `pubspec.yaml` - use chamadas HTTP diretas para a API do Mercado Pago
- As chaves de API precisam ser configuradas antes de usar os pagamentos
- O backend precisa ser implementado para processar os pagamentos com segurança

## 💡 Dicas

- Use ambiente de teste durante o desenvolvimento
- Teste todos os fluxos de pagamento antes de ir para produção
- Implemente logs para facilitar o debug
- Monitore os pagamentos regularmente
- Configure alertas para falhas de pagamento


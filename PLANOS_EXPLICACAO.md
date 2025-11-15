# Onde os Planos Estão Armazenados?

## 📍 Localização dos Planos

Os planos **NÃO estão armazenados no banco de dados**. Eles estão definidos como **dados estáticos no código Flutter**.

### Arquivo: `lib/models/plan.dart`

Os planos são definidos na classe `Plans` como uma lista estática:

```dart
class Plans {
  static final List<Plan> allPlans = [
    Plan(
      type: PlanType.free,
      name: 'FREE',
      monthlyPrice: 0.0,
      emoji: '🩵',
      color: const Color(0xFF87CEEB),
      features: [
        'Registro de hidratação',
        'Registro manual de refeições',
        'Progresso corporal básico (peso)',
        'Ranking da comunidade',
      ],
    ),
    // ... outros planos
  ];
}
```

## 🤔 Por que os Planos Estão no Código?

### Vantagens:
1. **Performance**: Não precisa buscar do banco de dados
2. **Simplicidade**: Fácil de atualizar no código
3. **Controle de Versão**: Mudanças nos planos ficam no Git
4. **Segurança**: Não podem ser modificados por usuários

### Desvantagens:
1. **Atualização**: Precisa atualizar o código e fazer deploy
2. **Flexibilidade**: Não pode mudar preços sem deploy
3. **Multi-idioma**: Dificulta traduções dinâmicas

## 📊 O que ESTÁ no Banco de Dados?

### MongoDB (backend)
- **Users**: Informações dos usuários (incluindo `currentPlan`)
- **Subscriptions**: Assinaturas ativas dos usuários
  - `planType`: Tipo de plano (free, fit, personal, personalPlus, leader)
  - `status`: Status da assinatura (active, cancelled, expired)
  - `billingPeriod`: Período de cobrança (monthly, yearly)
  - `paymentProvider`: Provedor de pagamento (stripe, mercadoPago, none)
  - `amount`: Valor pago
  - `startDate`, `endDate`, `nextBillingDate`: Datas importantes

### Firestore (mobile)
- **Users**: Informações dos usuários (sincronizado com MongoDB)
- **Meals**: Refeições registradas
- **Body Metrics**: Métricas corporais
- **Water Intake**: Ingestão de água
- **Subscriptions**: Assinaturas (opcional, pode usar apenas MongoDB)

## 🔄 Como Funciona?

1. **Planos**: Definidos no código Flutter (`lib/models/plan.dart`)
2. **Assinaturas**: Armazenadas no MongoDB (backend)
3. **Usuário**: Tem um campo `currentPlan` que indica o plano atual
4. **Verificação**: O app verifica o plano do usuário para liberar funcionalidades

## 💡 Como Atualizar os Planos?

### Opção 1: Atualizar no Código (Atual)
1. Edite `lib/models/plan.dart`
2. Atualize os planos conforme necessário
3. Faça deploy do app

### Opção 2: Mover para o Banco de Dados (Futuro)
1. Criar coleção `plans` no MongoDB
2. Criar endpoint `/api/plans` no backend
3. Buscar planos do backend no app
4. Cachear planos localmente

## 📝 Estrutura dos Planos

### Plan Type (Enum)
```dart
enum PlanType {
  free,        // Plano gratuito
  fit,         // Plano Fit (requer ID Herbalife)
  personal,    // Plano Personal (R$ 19,90/mês)
  personalPlus,// Plano Personal Plus (R$ 49,90/mês)
  leader,      // Plano Líder (R$ 99/mês - adicional)
}
```

### Plan (Class)
```dart
class Plan {
  final PlanType type;
  final String name;
  final String description;
  final double monthlyPrice;
  final double? yearlyPrice;
  final String? yearlySavings;
  final String emoji;
  final Color color;
  final List<String> features;
  final String? herbalifeIdRequired;
  final bool isAddOn;
}
```

## 🎯 Próximos Passos

### Se quiser mover os planos para o banco de dados:

1. **Criar modelo no MongoDB**:
   ```javascript
   // backend/models/Plan.js
   const planSchema = new Schema({
     type: { type: String, enum: ['free', 'fit', 'personal', 'personalPlus', 'leader'] },
     name: String,
     description: String,
     monthlyPrice: Number,
     yearlyPrice: Number,
     // ...
   });
   ```

2. **Criar endpoint no backend**:
   ```javascript
   // backend/routes/plans.js
   router.get('/plans', async (req, res) => {
     const plans = await Plan.find({});
     res.json(plans);
   });
   ```

3. **Atualizar o app Flutter**:
   - Buscar planos do backend
   - Cachear localmente
   - Atualizar quando necessário

## ✅ Resumo

- **Planos**: No código Flutter (`lib/models/plan.dart`) ✅
- **Assinaturas**: No MongoDB (backend) ✅
- **Usuários**: No MongoDB e Firestore ✅
- **Funcionalidades**: Liberadas baseadas no `currentPlan` do usuário ✅

---

**Status**: Planos estão no código Flutter (dados estáticos)
**Recomendação**: Manter no código por enquanto, mover para banco de dados se precisar de flexibilidade


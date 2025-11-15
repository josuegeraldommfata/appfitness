import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plan.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  BillingPeriod _selectedPeriod = BillingPeriod.monthly;
  PaymentProvider _selectedPaymentProvider = PaymentProvider.stripe;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planos NUDGE'),
        centerTitle: true,
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        '💎 Planos NUDGE',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seu Coach Pessoal de Bem-Estar',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'O Nudge é gratuito para todos os usuários.\n'
                        'Os planos abaixo desbloqueiam recursos avançados de\n'
                        'acompanhamento e expansão profissional.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Billing Period Toggle
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _BillingPeriodButton(
                          label: 'Mensal',
                          period: BillingPeriod.monthly,
                          selected: _selectedPeriod == BillingPeriod.monthly,
                          onTap: () {
                            setState(() {
                              _selectedPeriod = BillingPeriod.monthly;
                            });
                          },
                        ),
                        _BillingPeriodButton(
                          label: 'Anual',
                          period: BillingPeriod.yearly,
                          selected: _selectedPeriod == BillingPeriod.yearly,
                          onTap: () {
                            setState(() {
                              _selectedPeriod = BillingPeriod.yearly;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Plans List
                ...Plans.allPlans.map((plan) {
                  if (plan.isAddOn) {
                    // Leader plan is an add-on
                    return _LeaderPlanCard(
                      plan: plan,
                      selectedPeriod: _selectedPeriod,
                      subscriptionProvider: subscriptionProvider,
                      onSubscribe: () => _handleSubscribe(plan, subscriptionProvider),
                    );
                  } else {
                    return _PlanCard(
                      plan: plan,
                      selectedPeriod: _selectedPeriod,
                      subscriptionProvider: subscriptionProvider,
                      onSubscribe: () => _handleSubscribe(plan, subscriptionProvider),
                    );
                  }
                }),

                const SizedBox(height: 24),

                // Payment Provider Selection
                if (_selectedPeriod == BillingPeriod.monthly || 
                    (_selectedPeriod == BillingPeriod.yearly && 
                     Plans.allPlans.any((p) => p.yearlyPrice != null && p.yearlyPrice! > 0)))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Método de Pagamento',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _PaymentProviderButton(
                              label: 'Stripe',
                              provider: PaymentProvider.stripe,
                              selected: _selectedPaymentProvider == PaymentProvider.stripe,
                              onTap: () {
                                setState(() {
                                  _selectedPaymentProvider = PaymentProvider.stripe;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PaymentProviderButton(
                              label: 'Mercado Pago',
                              provider: PaymentProvider.mercadoPago,
                              selected: _selectedPaymentProvider == PaymentProvider.mercadoPago,
                              onTap: () {
                                setState(() {
                                  _selectedPaymentProvider = PaymentProvider.mercadoPago;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSubscribe(Plan plan, SubscriptionProvider subscriptionProvider) async {
    if (plan.monthlyPrice == 0.0 && plan.type != PlanType.fit) {
      // Free plan - no payment needed
      await subscriptionProvider.subscribeToPlan(
        plan.type,
        _selectedPeriod,
        PaymentProvider.none,
        context,
      );
    } else if (plan.type == PlanType.fit) {
      // Fit plan requires Herbalife ID
      final provider = Provider.of<AppProvider>(context, listen: false);
      final user = provider.currentUser;
      
      if (user?.herbalifeId == null || user!.herbalifeId!.isEmpty) {
        // Show dialog to enter Herbalife ID
        _showHerbalifeIdDialog(plan, subscriptionProvider);
        return;
      } else {
        await subscriptionProvider.subscribeToPlan(
          plan.type,
          _selectedPeriod,
          PaymentProvider.none,
          context,
        );
      }
    } else {
      // Paid plan - show payment dialog
      setState(() {
        _isLoading = true;
      });
      
      try {
        await subscriptionProvider.subscribeToPlan(
          plan.type,
          _selectedPeriod,
          _selectedPaymentProvider,
          context,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showHerbalifeIdDialog(Plan plan, SubscriptionProvider subscriptionProvider) {
    final herbalifeIdController = TextEditingController();
    final selectedPeriod = _selectedPeriod; // Capture current value
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ID Herbalife'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Para usar o plano Fit, você precisa inserir seu ID Herbalife.'),
            const SizedBox(height: 16),
            TextField(
              controller: herbalifeIdController,
              decoration: const InputDecoration(
                labelText: 'ID Herbalife',
                hintText: 'Digite seu ID Herbalife',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (herbalifeIdController.text.isNotEmpty) {
                final appProvider = Provider.of<AppProvider>(context, listen: false);
                // Update herbalife ID in user profile
                final user = appProvider.currentUser;
                if (user != null) {
                  final updatedUser = user.copyWith(herbalifeId: herbalifeIdController.text);
                  appProvider.setCurrentUser(updatedUser);
                  // Save to API
                  final apiService = ApiService();
                  await apiService.saveUser(updatedUser);
                }
                Navigator.pop(dialogContext);
                await subscriptionProvider.subscribeToPlan(
                  plan.type,
                  selectedPeriod,
                  PaymentProvider.none,
                  context,
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Plan plan;
  final BillingPeriod selectedPeriod;
  final SubscriptionProvider subscriptionProvider;
  final VoidCallback onSubscribe;

  const _PlanCard({
    required this.plan,
    required this.selectedPeriod,
    required this.subscriptionProvider,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final price = selectedPeriod == BillingPeriod.yearly && plan.yearlyPrice != null
        ? plan.yearlyPrice!
        : plan.monthlyPrice;
    final isCurrentPlan = subscriptionProvider.currentSubscription?.planType == plan.type;

    return Card(
      elevation: isCurrentPlan ? 8 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrentPlan
            ? BorderSide(color: plan.color, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              plan.color.withOpacity(0.1),
              plan.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan Header
              Row(
                children: [
                  Text(
                    plan.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PLANO ${plan.name}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: plan.color,
                          ),
                        ),
                        if (isCurrentPlan)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: plan.color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Plano Atual',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'R\$',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    NumberFormat('#,##0.00', 'pt_BR').format(price),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: plan.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '/ ${selectedPeriod == BillingPeriod.yearly ? 'ano' : 'mês'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              if (plan.yearlySavings != null && selectedPeriod == BillingPeriod.yearly)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    plan.yearlySavings!,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Description
              Text(
                plan.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Features
              ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: plan.color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),

              if (plan.herbalifeIdRequired != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          plan.herbalifeIdRequired!,
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Subscribe Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrentPlan ? null : onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isCurrentPlan
                        ? 'Plano Atual'
                        : plan.monthlyPrice == 0.0
                            ? 'Assinar Grátis'
                            : 'Assinar Agora',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderPlanCard extends StatelessWidget {
  final Plan plan;
  final BillingPeriod selectedPeriod;
  final SubscriptionProvider subscriptionProvider;
  final VoidCallback onSubscribe;

  const _LeaderPlanCard({
    required this.plan,
    required this.selectedPeriod,
    required this.subscriptionProvider,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final price = selectedPeriod == BillingPeriod.yearly && plan.yearlyPrice != null
        ? plan.yearlyPrice!
        : plan.monthlyPrice;
    final isCurrentPlan = subscriptionProvider.currentSubscription?.isLeaderPlan == true;

    return Card(
      elevation: isCurrentPlan ? 8 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrentPlan
            ? BorderSide(color: plan.color, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              plan.color.withOpacity(0.2),
              plan.color.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add-on Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: plan.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ADICIONAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Plan Header
              Row(
                children: [
                  Text(
                    plan.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PLANO ${plan.name}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: plan.color,
                          ),
                        ),
                        Text(
                          '(Adicional a qualquer plano)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'R\$',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    NumberFormat('#,##0.00', 'pt_BR').format(price),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: plan.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '/ ${selectedPeriod == BillingPeriod.yearly ? 'ano' : 'mês'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.orange[700], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Promoção de lançamento: R\$ 49 no 1º mês',
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (plan.yearlySavings != null && selectedPeriod == BillingPeriod.yearly)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    plan.yearlySavings!,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Description
              Text(
                plan.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Features
              ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: plan.color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),

              const SizedBox(height: 16),

              // Subscribe Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrentPlan ? null : onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isCurrentPlan
                        ? 'Plano Ativo'
                        : 'Adicionar Plano',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillingPeriodButton extends StatelessWidget {
  final String label;
  final BillingPeriod period;
  final bool selected;
  final VoidCallback onTap;

  const _BillingPeriodButton({
    required this.label,
    required this.period,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _PaymentProviderButton extends StatelessWidget {
  final String label;
  final PaymentProvider provider;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentProviderButton({
    required this.label,
    required this.provider,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.green : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[700],
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../models/plan.dart';
import '../services/api_service.dart';
import '../services/payment_service.dart';
import '../providers/app_provider.dart';

class SubscriptionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PaymentService _paymentService = PaymentService();

  Subscription? _currentSubscription;
  Subscription? get currentSubscription => _currentSubscription;

  List<Subscription> _subscriptions = [];
  List<Subscription> get subscriptions => _subscriptions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> initialize() async {
    await _paymentService.initialize();
    await loadCurrentSubscription();
  }

  Future<void> loadCurrentSubscription() async {
    final user = _apiService.currentUser;
    if (user == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSubscription = await _apiService.getActiveSubscription(user.id);
      if (_currentSubscription != null) {
        _subscriptions = await _apiService.getUserSubscriptions(user.id);
      }
    } catch (e) {
      _error = 'Erro ao carregar assinatura: $e';
      print('Error loading subscription: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> subscribeToPlan(
    PlanType planType,
    BillingPeriod billingPeriod,
    PaymentProvider paymentProvider,
    BuildContext context,
  ) async {
    final user = _apiService.currentUser;
    if (user == null) {
      _error = 'Usuário não autenticado';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final plan = Plans.getPlanByType(planType);
      final amount = _paymentService.getPlanAmount(plan, billingPeriod);

      // Handle free plans
      if (amount == 0.0 && planType != PlanType.fit) {
        // Free plan - no payment needed
        final subscription = Subscription(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: user.id,
          planType: planType,
          status: SubscriptionStatus.active,
          startDate: DateTime.now(),
          endDate: null,
          nextBillingDate: null,
          billingPeriod: billingPeriod,
          paymentProvider: PaymentProvider.none,
          amount: amount,
          createdAt: DateTime.now(),
        );

        await _apiService.saveSubscription(subscription);
        await _updateUserPlan(user.id, planType);
        _currentSubscription = subscription;
        await loadCurrentSubscription();
        _showSuccessMessage(context, 'Plano ativado com sucesso!');
        return;
      }

      // Handle Fit plan (requires Herbalife ID)
      if (planType == PlanType.fit) {
        // Check if user has Herbalife ID
        final userData = await _apiService.getUser(user.id);
        if (userData?.herbalifeId == null || userData!.herbalifeId!.isEmpty) {
          _error = 'ID Herbalife é obrigatório para o plano Fit';
          notifyListeners();
          return;
        }

        final subscription = Subscription(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: user.id,
          planType: planType,
          status: SubscriptionStatus.active,
          startDate: DateTime.now(),
          endDate: null,
          nextBillingDate: null,
          billingPeriod: billingPeriod,
          paymentProvider: PaymentProvider.none,
          amount: amount,
          herbalifeId: userData.herbalifeId,
          createdAt: DateTime.now(),
        );

        await _apiService.saveSubscription(subscription);
        await _updateUserPlan(user.id, planType);
        _currentSubscription = subscription;
        await loadCurrentSubscription();
        _showSuccessMessage(context, 'Plano Fit ativado com sucesso!');
        return;
      }

      // Handle paid plans
      String? paymentId;
      String? transactionId;

      if (paymentProvider == PaymentProvider.stripe) {
        // Process Stripe payment
        paymentId = await _processStripePayment(
          plan,
          billingPeriod,
          amount,
          user.id,
        );
        if (paymentId == null) {
          _error = 'Erro ao processar pagamento com Stripe';
          notifyListeners();
          return;
        }
        transactionId = paymentId;
      } else if (paymentProvider == PaymentProvider.mercadoPago) {
        // Process Mercado Pago payment
        final result = await _processMercadoPagoPayment(
          plan,
          billingPeriod,
          amount,
          user.id,
        );
        if (result == null) {
          _error = 'Erro ao processar pagamento com Mercado Pago';
          notifyListeners();
          return;
        }
        paymentId = result['preferenceId'];
        transactionId = result['transactionId'];
      }

      // Calculate next billing date
      DateTime nextBillingDate;
      if (billingPeriod == BillingPeriod.monthly) {
        nextBillingDate = DateTime.now().add(const Duration(days: 30));
      } else {
        nextBillingDate = DateTime.now().add(const Duration(days: 365));
      }

      // Create subscription
      final subscription = Subscription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        planType: planType,
        status: SubscriptionStatus.active,
        startDate: DateTime.now(),
        endDate: null,
        nextBillingDate: nextBillingDate,
        billingPeriod: billingPeriod,
        paymentProvider: paymentProvider,
        paymentId: paymentId,
        transactionId: transactionId,
        amount: amount,
        isLeaderPlan: planType == PlanType.leader,
        createdAt: DateTime.now(),
      );

      await _apiService.saveSubscription(subscription);
      await _updateUserPlan(user.id, planType);
      _currentSubscription = subscription;
      await loadCurrentSubscription();
      _showSuccessMessage(context, 'Assinatura ativada com sucesso!');
    } catch (e) {
      _error = 'Erro ao assinar plano: $e';
      print('Error subscribing to plan: $e');
      _showErrorMessage(context, _error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> _processStripePayment(
    Plan plan,
    BillingPeriod billingPeriod,
    double amount,
    String userId,
  ) async {
    try {
      // Create payment intent
      final paymentIntent = await _paymentService.createStripePaymentIntent(
        amount: amount,
        currency: 'BRL',
        userId: userId,
        planType: plan.type,
        billingPeriod: billingPeriod,
      );

      if (paymentIntent == null) {
        return null;
      }

      // In a real implementation, you would:
      // 1. Show Stripe payment sheet
      // 2. Collect payment method from user
      // 3. Confirm payment
      // 4. Return payment ID

      // For now, return mock payment ID
      return paymentIntent['paymentIntentId'] ?? 'mock_stripe_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Error processing Stripe payment: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _processMercadoPagoPayment(
    Plan plan,
    BillingPeriod billingPeriod,
    double amount,
    String userId,
  ) async {
    try {
      // Create Mercado Pago preference
      final preference = await _paymentService.createMercadoPagoPreference(
        amount: amount,
        userId: userId,
        planType: plan.type,
        billingPeriod: billingPeriod,
      );

      if (preference == null) {
        return null;
      }

      // In a real implementation, you would:
      // 1. Show Mercado Pago checkout
      // 2. Process payment
      // 3. Verify payment status
      // 4. Return transaction ID

      // For now, return mock transaction ID
      return {
        'preferenceId': preference['preferenceId'] ?? 'mock_mp_${DateTime.now().millisecondsSinceEpoch}',
        'transactionId': 'mock_transaction_${DateTime.now().millisecondsSinceEpoch}',
      };
    } catch (e) {
      print('Error processing Mercado Pago payment: $e');
      return null;
    }
  }

  Future<void> _updateUserPlan(String userId, PlanType planType) async {
    final user = await _apiService.getUser(userId);
    if (user != null) {
      final updatedUser = user.copyWith(currentPlan: planType.name);
      await _apiService.saveUser(updatedUser);
    }
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement cancel subscription endpoint in API
      // For now, update locally
      if (_currentSubscription?.id == subscriptionId) {
        _currentSubscription = null;
      }
      _subscriptions.removeWhere((s) => s.id == subscriptionId);
      await loadCurrentSubscription();
    } catch (e) {
      _error = 'Erro ao cancelar assinatura: $e';
      print('Error cancelling subscription: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Check if user has access to a feature based on their plan
  bool hasAccessToFeature(String feature) {
    if (_currentSubscription == null || !_currentSubscription!.isActive) {
      return false;
    }

    final planType = _currentSubscription!.planType;

    // Define feature access based on plan type
    switch (feature) {
      case 'full_body_metrics':
        return planType != PlanType.free;
      case 'detailed_charts':
        return planType != PlanType.free;
      case 'community_challenges':
        return planType != PlanType.free;
      case 'ai_chat':
        return planType == PlanType.personal || planType == PlanType.personalPlus;
      case 'unlimited_ai_chat':
        return planType == PlanType.personalPlus;
      case 'leader_features':
        return _currentSubscription!.isLeaderPlan;
      default:
        return false;
    }
  }
}

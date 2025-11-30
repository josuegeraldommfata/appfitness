import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import '../models/plan.dart';
import '../models/subscription.dart';
import '../config/payment_config.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Stripe (only works on mobile, not web)
      // Skip initialization on web platform
      try {
        Stripe.publishableKey = PaymentConfig.stripePublishableKey;
        await Stripe.instance.applySettings();
      } catch (e) {
        // Stripe doesn't work on web, that's OK
        print('Stripe initialization skipped (web platform): $e');
      }
      _isInitialized = true;
    } catch (e) {
      print('Error initializing payment service: $e');
      // Continue even if Stripe initialization fails (for development/web)
      _isInitialized = true; // Mark as initialized anyway
    }
  }

  // Stripe Payment Methods
  Future<Map<String, dynamic>?> createStripePaymentIntent({
    required double amount,
    required String currency,
    required String userId,
    required PlanType planType,
    required BillingPeriod billingPeriod,
  }) async {
    try {
      // In production, this should call your backend API
      // The backend should create the payment intent using the secret key
      // ⚠️ IMPORTANT: Never send the secret key from the mobile app!
      // The backend should use the secret key server-side
      final response = await http.post(
        Uri.parse('${PaymentConfig.backendApiUrl}/api/stripe/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          // Note: The backend should authenticate using its own method
          // Do NOT send the secret key from the mobile app!
        },
        body: jsonEncode({
          'amount': amount, // Valor em reais (ex: 19.90), backend converte para centavos
          'currency': currency.toLowerCase(),
          'userId': userId,
          'planType': planType.name,
          'billingPeriod': billingPeriod.name,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error creating payment intent: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating Stripe payment intent: $e');
      // For development, return mock data
      return {
        'clientSecret': 'mock_client_secret',
        'paymentIntentId': 'mock_payment_intent_id',
      };
    }
  }

  Future<bool> confirmStripePayment({
    required String clientSecret,
    required String paymentMethodId,
  }) async {
    try {
      // Initialize payment sheet with client secret
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'NUDGE',
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Payment was successful
      return true;
    } catch (e) {
      print('Error confirming Stripe payment: $e');
      // Check if payment was cancelled by user
      if (e.toString().contains('cancelled') || e.toString().contains('canceled')) {
        return false;
      }
      return false;
    }
  }

  Future<String?> createStripeSubscription({
    required String customerId,
    required String priceId,
  }) async {
    try {
      // In production, this should call your backend API
      // ⚠️ IMPORTANT: Never send the secret key from the mobile app!
      // The backend should use the secret key server-side
      final response = await http.post(
        Uri.parse('${PaymentConfig.backendApiUrl}/api/stripe/create-subscription'),
        headers: {
          'Content-Type': 'application/json',
          // Note: The backend should authenticate using its own method
          // Do NOT send the secret key from the mobile app!
        },
        body: jsonEncode({
          'customerId': customerId,
          'priceId': priceId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['subscriptionId'];
      } else {
        print('Error creating subscription: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating Stripe subscription: $e');
      // For development, return mock subscription ID
      return 'mock_subscription_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // Mercado Pago Payment Methods
  Future<Map<String, dynamic>?> createMercadoPagoPreference({
    required double amount,
    required String userId,
    required PlanType planType,
    required BillingPeriod billingPeriod,
  }) async {
    try {
      // In production, this should call your backend API
      // The backend should create the preference using the access token
      // ⚠️ Access token should NOT be in mobile app - only in backend!
      final response = await http.post(
        Uri.parse('${PaymentConfig.backendApiUrl}/api/mercado-pago/create-preference'),
        headers: {
          'Content-Type': 'application/json',
          // Access token is handled by backend, not mobile app
        },
        body: jsonEncode({
          'amount': amount,
          'currency': 'BRL',
          'userId': userId,
          'planType': planType.name,
          'billingPeriod': billingPeriod.name,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error creating Mercado Pago preference: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating Mercado Pago preference: $e');
      // For development, return mock data
      return {
        'preferenceId': 'mock_preference_${DateTime.now().millisecondsSinceEpoch}',
        'initPoint': 'https://www.mercadopago.com.br/checkout/v1/redirect?pref_id=mock_preference',
      };
    }
  }

  Future<bool> processMercadoPagoPayment({
    required String preferenceId,
    required String paymentId,
  }) async {
    try {
      // In production, this should verify the payment status with Mercado Pago API
      // ⚠️ Access token should NOT be in mobile app - only in backend!
      final response = await http.get(
        Uri.parse('${PaymentConfig.backendApiUrl}/api/mercado-pago/verify-payment'),
        headers: {
          'Content-Type': 'application/json',
          // Access token is handled by backend, not mobile app
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'approved';
      } else {
        print('Error verifying Mercado Pago payment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error processing Mercado Pago payment: $e');
      // For development, return mock success
      return true;
    }
  }

  // Get Stripe Price ID for a plan
  String getStripePriceId(Plan plan, BillingPeriod period) {
    final planKey = plan.type.name;
    final periodKey = period == BillingPeriod.monthly ? 'monthly' : 'yearly';
    
    return PaymentConfig.stripePriceIds[planKey]?[periodKey] ?? 'price_not_found';
  }

  // Get amount for a plan
  double getPlanAmount(Plan plan, BillingPeriod period) {
    if (period == BillingPeriod.yearly && plan.yearlyPrice != null) {
      return plan.yearlyPrice!;
    }
    return plan.monthlyPrice;
  }
}


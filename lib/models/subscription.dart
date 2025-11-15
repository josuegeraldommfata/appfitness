import 'package:cloud_firestore/cloud_firestore.dart';
import 'plan.dart';

enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  trial,
  pending,
}

enum PaymentProvider {
  stripe,
  mercadoPago,
  none,
}

enum BillingPeriod {
  monthly,
  yearly,
}

class Subscription {
  final String id;
  final String userId;
  final PlanType planType;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final BillingPeriod billingPeriod;
  final PaymentProvider paymentProvider;
  final String? paymentId; // Stripe subscription ID or Mercado Pago subscription ID
  final String? transactionId;
  final double amount;
  final String? herbalifeId;
  final bool isLeaderPlan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.planType,
    required this.status,
    required this.startDate,
    this.endDate,
    this.nextBillingDate,
    required this.billingPeriod,
    required this.paymentProvider,
    this.paymentId,
    this.transactionId,
    required this.amount,
    this.herbalifeId,
    this.isLeaderPlan = false,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isActive => status == SubscriptionStatus.active;
  bool get isExpired => status == SubscriptionStatus.expired || (endDate != null && endDate!.isBefore(DateTime.now()));
  bool get isTrial => status == SubscriptionStatus.trial;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planType': planType.name,
      'status': status.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'nextBillingDate': nextBillingDate != null ? Timestamp.fromDate(nextBillingDate!) : null,
      'billingPeriod': billingPeriod.name,
      'paymentProvider': paymentProvider.name,
      'paymentId': paymentId,
      'transactionId': transactionId,
      'amount': amount,
      'herbalifeId': herbalifeId,
      'isLeaderPlan': isLeaderPlan,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['userId'],
      planType: PlanType.values.firstWhere((e) => e.name == json['planType']),
      status: SubscriptionStatus.values.firstWhere((e) => e.name == json['status']),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      nextBillingDate: json['nextBillingDate'] != null ? (json['nextBillingDate'] as Timestamp).toDate() : null,
      billingPeriod: BillingPeriod.values.firstWhere((e) => e.name == json['billingPeriod']),
      paymentProvider: PaymentProvider.values.firstWhere((e) => e.name == json['paymentProvider']),
      paymentId: json['paymentId'],
      transactionId: json['transactionId'],
      amount: (json['amount'] as num).toDouble(),
      herbalifeId: json['herbalifeId'],
      isLeaderPlan: json['isLeaderPlan'] ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  Subscription copyWith({
    String? id,
    String? userId,
    PlanType? planType,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    BillingPeriod? billingPeriod,
    PaymentProvider? paymentProvider,
    String? paymentId,
    String? transactionId,
    double? amount,
    String? herbalifeId,
    bool? isLeaderPlan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planType: planType ?? this.planType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      paymentId: paymentId ?? this.paymentId,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      herbalifeId: herbalifeId ?? this.herbalifeId,
      isLeaderPlan: isLeaderPlan ?? this.isLeaderPlan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


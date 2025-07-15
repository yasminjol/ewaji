import 'package:equatable/equatable.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  disputed,
}

enum PaymentMethod {
  card,
  applePay,
  googlePay,
  splitPay,
}

enum PaymentStatus {
  pending,
  depositPaid,
  fullPaid,
  refunded,
  failed,
}

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.clientId,
    required this.timeSlotId,
    required this.serviceTitle,
    required this.totalAmount,
    required this.depositAmount,
    required this.remainingAmount,
    required this.depositPercent,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.notes,
    this.cancellationReason,
    this.providerNotes,
    this.clientNotes,
    this.isSplitPayment = false,
    this.splitPaymentPlan,
    this.estimatedDuration,
    this.actualDuration,
    this.serviceFee,
    this.taxes,
    this.tips,
  });

  final String id;
  final String serviceId;
  final String providerId;
  final String clientId;
  final String timeSlotId;
  final String serviceTitle;
  final double totalAmount;
  final double depositAmount;
  final double remainingAmount;
  final double depositPercent;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? notes;
  final String? cancellationReason;
  final String? providerNotes;
  final String? clientNotes;
  final bool isSplitPayment;
  final SplitPaymentPlan? splitPaymentPlan;
  final Duration? estimatedDuration;
  final Duration? actualDuration;
  final double? serviceFee;
  final double? taxes;
  final double? tips;

  @override
  List<Object?> get props => [
        id,
        serviceId,
        providerId,
        clientId,
        timeSlotId,
        serviceTitle,
        totalAmount,
        depositAmount,
        remainingAmount,
        depositPercent,
        status,
        paymentStatus,
        paymentMethod,
        createdAt,
        confirmedAt,
        startedAt,
        completedAt,
        cancelledAt,
        notes,
        cancellationReason,
        providerNotes,
        clientNotes,
        isSplitPayment,
        splitPaymentPlan,
        estimatedDuration,
        actualDuration,
        serviceFee,
        taxes,
        tips,
      ];

  Booking copyWith({
    String? id,
    String? serviceId,
    String? providerId,
    String? clientId,
    String? timeSlotId,
    String? serviceTitle,
    double? totalAmount,
    double? depositAmount,
    double? remainingAmount,
    double? depositPercent,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? notes,
    String? cancellationReason,
    String? providerNotes,
    String? clientNotes,
    bool? isSplitPayment,
    SplitPaymentPlan? splitPaymentPlan,
    Duration? estimatedDuration,
    Duration? actualDuration,
    double? serviceFee,
    double? taxes,
    double? tips,
  }) {
    return Booking(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      providerId: providerId ?? this.providerId,
      clientId: clientId ?? this.clientId,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      totalAmount: totalAmount ?? this.totalAmount,
      depositAmount: depositAmount ?? this.depositAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      depositPercent: depositPercent ?? this.depositPercent,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      providerNotes: providerNotes ?? this.providerNotes,
      clientNotes: clientNotes ?? this.clientNotes,
      isSplitPayment: isSplitPayment ?? this.isSplitPayment,
      splitPaymentPlan: splitPaymentPlan ?? this.splitPaymentPlan,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      serviceFee: serviceFee ?? this.serviceFee,
      taxes: taxes ?? this.taxes,
      tips: tips ?? this.tips,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'provider_id': providerId,
      'client_id': clientId,
      'time_slot_id': timeSlotId,
      'service_title': serviceTitle,
      'total_amount': totalAmount,
      'deposit_amount': depositAmount,
      'remaining_amount': remainingAmount,
      'deposit_percent': depositPercent,
      'status': status.name,
      'payment_status': paymentStatus.name,
      'payment_method': paymentMethod.name,
      'created_at': createdAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'notes': notes,
      'cancellation_reason': cancellationReason,
      'provider_notes': providerNotes,
      'client_notes': clientNotes,
      'is_split_payment': isSplitPayment,
      'split_payment_plan': splitPaymentPlan?.toJson(),
      'estimated_duration': estimatedDuration?.inMinutes,
      'actual_duration': actualDuration?.inMinutes,
      'service_fee': serviceFee,
      'taxes': taxes,
      'tips': tips,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      providerId: json['provider_id'] as String,
      clientId: json['client_id'] as String,
      timeSlotId: json['time_slot_id'] as String,
      serviceTitle: json['service_title'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      depositAmount: (json['deposit_amount'] as num).toDouble(),
      remainingAmount: (json['remaining_amount'] as num).toDouble(),
      depositPercent: (json['deposit_percent'] as num).toDouble(),
      status: BookingStatus.values.firstWhere((e) => e.name == json['status']),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['payment_status']),
      paymentMethod: PaymentMethod.values.firstWhere((e) => e.name == json['payment_method']),
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] != null ? DateTime.parse(json['confirmed_at'] as String) : null,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      providerNotes: json['provider_notes'] as String?,
      clientNotes: json['client_notes'] as String?,
      isSplitPayment: json['is_split_payment'] as bool? ?? false,
      splitPaymentPlan: json['split_payment_plan'] != null 
          ? SplitPaymentPlan.fromJson(json['split_payment_plan'] as Map<String, dynamic>)
          : null,
      estimatedDuration: json['estimated_duration'] != null 
          ? Duration(minutes: json['estimated_duration'] as int)
          : null,
      actualDuration: json['actual_duration'] != null 
          ? Duration(minutes: json['actual_duration'] as int)
          : null,
      serviceFee: (json['service_fee'] as num?)?.toDouble(),
      taxes: (json['taxes'] as num?)?.toDouble(),
      tips: (json['tips'] as num?)?.toDouble(),
    );
  }
}

class SplitPaymentPlan extends Equatable {
  const SplitPaymentPlan({
    required this.numberOfPayments,
    required this.paymentAmount,
    required this.installments,
    this.interestRate = 0.0,
    this.processingFee = 0.0,
  });

  final int numberOfPayments;
  final double paymentAmount;
  final List<PaymentInstallment> installments;
  final double interestRate;
  final double processingFee;

  @override
  List<Object?> get props => [numberOfPayments, paymentAmount, installments, interestRate, processingFee];

  Map<String, dynamic> toJson() {
    return {
      'number_of_payments': numberOfPayments,
      'payment_amount': paymentAmount,
      'installments': installments.map((e) => e.toJson()).toList(),
      'interest_rate': interestRate,
      'processing_fee': processingFee,
    };
  }

  factory SplitPaymentPlan.fromJson(Map<String, dynamic> json) {
    return SplitPaymentPlan(
      numberOfPayments: json['number_of_payments'] as int,
      paymentAmount: (json['payment_amount'] as num).toDouble(),
      installments: (json['installments'] as List)
          .map((e) => PaymentInstallment.fromJson(e as Map<String, dynamic>))
          .toList(),
      interestRate: (json['interest_rate'] as num?)?.toDouble() ?? 0.0,
      processingFee: (json['processing_fee'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PaymentInstallment extends Equatable {
  const PaymentInstallment({
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.paidAt,
    this.paymentIntentId,
  });

  final int installmentNumber;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  final DateTime? paidAt;
  final String? paymentIntentId;

  @override
  List<Object?> get props => [installmentNumber, amount, dueDate, status, paidAt, paymentIntentId];

  Map<String, dynamic> toJson() {
    return {
      'installment_number': installmentNumber,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'status': status.name,
      'paid_at': paidAt?.toIso8601String(),
      'payment_intent_id': paymentIntentId,
    };
  }

  factory PaymentInstallment.fromJson(Map<String, dynamic> json) {
    return PaymentInstallment(
      installmentNumber: json['installment_number'] as int,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date'] as String),
      status: PaymentStatus.values.firstWhere((e) => e.name == json['status']),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      paymentIntentId: json['payment_intent_id'] as String?,
    );
  }
}

class PaymentIntent extends Equatable {
  const PaymentIntent({
    required this.id,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentMethodId,
    this.setupFutureUsage,
  });

  final String id;
  final String clientSecret;
  final int amount; // Amount in cents
  final String currency;
  final String status;
  final String? paymentMethodId;
  final String? setupFutureUsage;

  @override
  List<Object?> get props => [id, clientSecret, amount, currency, status, paymentMethodId, setupFutureUsage];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_secret': clientSecret,
      'amount': amount,
      'currency': currency,
      'status': status,
      'payment_method_id': paymentMethodId,
      'setup_future_usage': setupFutureUsage,
    };
  }

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentMethodId: json['payment_method_id'] as String?,
      setupFutureUsage: json['setup_future_usage'] as String?,
    );
  }
}

class SetupIntent extends Equatable {
  const SetupIntent({
    required this.id,
    required this.clientSecret,
    required this.status,
    this.paymentMethodId,
    this.usage,
  });

  final String id;
  final String clientSecret;
  final String status;
  final String? paymentMethodId;
  final String? usage;

  @override
  List<Object?> get props => [id, clientSecret, status, paymentMethodId, usage];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_secret': clientSecret,
      'status': status,
      'payment_method_id': paymentMethodId,
      'usage': usage,
    };
  }

  factory SetupIntent.fromJson(Map<String, dynamic> json) {
    return SetupIntent(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String,
      status: json['status'] as String,
      paymentMethodId: json['payment_method_id'] as String?,
      usage: json['usage'] as String?,
    );
  }
}

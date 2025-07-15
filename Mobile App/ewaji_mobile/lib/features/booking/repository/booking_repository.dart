import 'package:retry/retry.dart';
import '../models/booking.dart';

abstract class BookingRepository {
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
    required String customerId,
    bool isSplitPayment = false,
  });
  
  Future<Booking> createBooking({
    required String serviceId,
    required String providerId,
    required String clientId,
    required String timeSlotId,
    required String serviceTitle,
    required double totalAmount,
    required double depositAmount,
    required double depositPercent,
    required PaymentMethod paymentMethod,
    required String paymentIntentId,
    String? notes,
    bool isSplitPayment = false,
    SplitPaymentPlan? splitPaymentPlan,
  });
  
  Future<bool> confirmPayment(String paymentIntentId);
  
  Future<Booking> updateBookingStatus(String bookingId, BookingStatus status);
  
  Future<List<Booking>> getClientBookings(String clientId);
  
  Future<List<Booking>> getProviderBookings(String providerId);
  
  Future<Booking?> getBooking(String bookingId);
  
  Future<bool> checkSplitPayEligibility(String clientId);
  
  Future<SplitPaymentPlan> createSplitPaymentPlan({
    required double totalAmount,
    required int numberOfPayments,
  });
  
  Future<void> sendBookingNotification({
    required String bookingId,
    required String recipientId,
    required String type,
    Map<String, dynamic>? data,
  });
}

class BookingRepositoryImpl implements BookingRepository {
  // In a real implementation, this would use Supabase client and Stripe SDK
  final RetryOptions _retryOptions = const RetryOptions(
    delayFactor: Duration(milliseconds: 200),
    maxDelay: Duration(seconds: 30),
    maxAttempts: 3,
  );

  @override
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
    required String customerId,
    bool isSplitPayment = false,
  }) async {
    return await _retryOptions.retry(
      () async {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Mock payment intent creation
        // In real implementation, this would call your backend API
        // which would create a Stripe Payment Intent
        final amountInCents = (amount * 100).toInt();
        
        // Simulate potential network failures
        if (DateTime.now().millisecond % 10 == 0) {
          throw Exception('Network error');
        }
        
        return PaymentIntent(
          id: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
          clientSecret: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret_mock',
          amount: amountInCents,
          currency: currency,
          status: 'requires_payment_method',
          setupFutureUsage: isSplitPayment ? 'off_session' : null,
        );
      },
      retryIf: (e) => e.toString().contains('Network') || e.toString().contains('timeout'),
    );
  }

  @override
  Future<Booking> createBooking({
    required String serviceId,
    required String providerId,
    required String clientId,
    required String timeSlotId,
    required String serviceTitle,
    required double totalAmount,
    required double depositAmount,
    required double depositPercent,
    required PaymentMethod paymentMethod,
    required String paymentIntentId,
    String? notes,
    bool isSplitPayment = false,
    SplitPaymentPlan? splitPaymentPlan,
  }) async {
    return await _retryOptions.retry(
      () async {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 1200));
        
        // Simulate potential failures
        if (DateTime.now().millisecond % 15 == 0) {
          throw Exception('Database error');
        }
        
        final booking = Booking(
          id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
          serviceId: serviceId,
          providerId: providerId,
          clientId: clientId,
          timeSlotId: timeSlotId,
          serviceTitle: serviceTitle,
          totalAmount: totalAmount,
          depositAmount: depositAmount,
          remainingAmount: totalAmount - depositAmount,
          depositPercent: depositPercent,
          status: BookingStatus.pending,
          paymentStatus: PaymentStatus.depositPaid,
          paymentMethod: paymentMethod,
          createdAt: DateTime.now(),
          notes: notes,
          isSplitPayment: isSplitPayment,
          splitPaymentPlan: splitPaymentPlan,
          estimatedDuration: const Duration(hours: 1, minutes: 30),
          serviceFee: totalAmount * 0.1, // 10% service fee
          taxes: totalAmount * 0.08, // 8% tax
        );
        
        // In real implementation:
        // 1. Insert booking into Supabase
        // 2. Update time slot availability
        // 3. Create payment record
        // 4. Set up webhooks for payment confirmation
        
        print('Booking created: ${booking.id}');
        return booking;
      },
      retryIf: (e) => e.toString().contains('Database') || e.toString().contains('network'),
    );
  }

  @override
  Future<bool> confirmPayment(String paymentIntentId) async {
    return await _retryOptions.retry(
      () async {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Simulate payment confirmation with Stripe
        // In real implementation, this would confirm the payment intent
        final success = DateTime.now().millisecond % 20 != 0; // 95% success rate
        
        if (!success) {
          throw Exception('Payment failed');
        }
        
        print('Payment confirmed: $paymentIntentId');
        return true;
      },
      retryIf: (e) => e.toString().contains('Payment') || e.toString().contains('network'),
    );
  }

  @override
  Future<Booking> updateBookingStatus(String bookingId, BookingStatus status) async {
    return await _retryOptions.retry(
      () async {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 400));
        
        // Mock booking update
        // In real implementation, this would update the booking in Supabase
        final now = DateTime.now();
        
        return Booking(
          id: bookingId,
          serviceId: 'service_001',
          providerId: 'provider_123',
          clientId: 'client_456',
          timeSlotId: 'slot_123',
          serviceTitle: 'Professional Hair Styling & Cut',
          totalAmount: 75.0,
          depositAmount: 22.5,
          remainingAmount: 52.5,
          depositPercent: 30.0,
          status: status,
          paymentStatus: PaymentStatus.depositPaid,
          paymentMethod: PaymentMethod.card,
          createdAt: now.subtract(const Duration(minutes: 5)),
          confirmedAt: status == BookingStatus.confirmed ? now : null,
        );
      },
      retryIf: (e) => e.toString().contains('Database') || e.toString().contains('connection'),
    );
  }

  @override
  Future<List<Booking>> getClientBookings(String clientId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Return mock bookings
    return [];
  }

  @override
  Future<List<Booking>> getProviderBookings(String providerId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Return mock bookings
    return [];
  }

  @override
  Future<Booking?> getBooking(String bookingId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Return mock booking or null if not found
    return null;
  }

  @override
  Future<bool> checkSplitPayEligibility(String clientId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Mock eligibility check
    // In real implementation, this would check:
    // - Credit score
    // - Payment history
    // - Account age
    // - Current outstanding payments
    final eligible = DateTime.now().millisecond % 3 != 0; // 67% eligible
    
    print('Split pay eligibility for $clientId: $eligible');
    return eligible;
  }

  @override
  Future<SplitPaymentPlan> createSplitPaymentPlan({
    required double totalAmount,
    required int numberOfPayments,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    final paymentAmount = totalAmount / numberOfPayments;
    final installments = <PaymentInstallment>[];
    
    for (int i = 0; i < numberOfPayments; i++) {
      installments.add(PaymentInstallment(
        installmentNumber: i + 1,
        amount: paymentAmount,
        dueDate: DateTime.now().add(Duration(days: (i + 1) * 14)), // Bi-weekly payments
        status: i == 0 ? PaymentStatus.pending : PaymentStatus.pending,
      ));
    }
    
    return SplitPaymentPlan(
      numberOfPayments: numberOfPayments,
      paymentAmount: paymentAmount,
      installments: installments,
      interestRate: 0.0, // 0% interest for now
      processingFee: totalAmount * 0.02, // 2% processing fee
    );
  }

  @override
  Future<void> sendBookingNotification({
    required String bookingId,
    required String recipientId,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Mock FCM notification
    // In real implementation, this would send push notification via Firebase
    print('Notification sent: $type to $recipientId for booking $bookingId');
    
    // Mock notification data
    final notificationData = {
      'type': type,
      'booking_id': bookingId,
      'recipient_id': recipientId,
      'timestamp': DateTime.now().toIso8601String(),
      ...?data,
    };
    
    print('Notification data: $notificationData');
  }
}

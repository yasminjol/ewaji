import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../models/booking.dart' as booking;

class PaymentService {
  static PaymentService? _instance;
  static PaymentService get instance => _instance ??= PaymentService._();
  PaymentService._();

  /// Initialize Stripe SDK
  Future<void> initializeStripe() async {
    stripe.Stripe.publishableKey = 'pk_test_your_publishable_key'; // Replace with your actual key
    await stripe.Stripe.instance.applySettings();
  }

  /// Process card payment (mock implementation for demo)
  Future<booking.PaymentIntent> processCardPayment({
    required String clientSecret,
    required double amount,
    String? customerId,
    bool saveCard = false,
  }) async {
    try {
      // Mock card payment for demo
      await Future.delayed(const Duration(milliseconds: 1000));
      
      return booking.PaymentIntent(
        id: 'pi_card_${DateTime.now().millisecondsSinceEpoch}',
        clientSecret: clientSecret,
        status: 'succeeded',
        amount: (amount * 100).toInt(), // Convert to cents
        currency: 'usd',
        paymentMethodId: 'pm_card_demo',
      );
    } catch (e) {
      throw PaymentException('Card payment failed: ${e.toString()}');
    }
  }

  /// Process Apple Pay payment (mock implementation)
  Future<booking.PaymentIntent> processApplePayPayment({
    required String clientSecret,
    required double amount,
    required String merchantIdentifier,
  }) async {
    try {
      // Mock Apple Pay success for demo
      await Future.delayed(const Duration(milliseconds: 800));
      
      return booking.PaymentIntent(
        id: 'pi_apple_${DateTime.now().millisecondsSinceEpoch}',
        clientSecret: clientSecret,
        status: 'succeeded',
        amount: (amount * 100).toInt(), // Convert to cents
        currency: 'usd',
        paymentMethodId: 'pm_apple_pay',
      );
    } catch (e) {
      throw PaymentException('Apple Pay payment failed: ${e.toString()}');
    }
  }

  /// Process Google Pay payment (mock implementation)
  Future<booking.PaymentIntent> processGooglePayPayment({
    required String clientSecret,
    required double amount,
  }) async {
    try {
      // Mock Google Pay success for demo
      await Future.delayed(const Duration(milliseconds: 800));
      
      return booking.PaymentIntent(
        id: 'pi_google_${DateTime.now().millisecondsSinceEpoch}',
        clientSecret: clientSecret,
        status: 'succeeded',
        amount: (amount * 100).toInt(), // Convert to cents
        currency: 'usd',
        paymentMethodId: 'pm_google_pay',
      );
    } catch (e) {
      throw PaymentException('Google Pay payment failed: ${e.toString()}');
    }
  }

  /// Check if Apple Pay is available
  Future<bool> isApplePaySupported() async {
    try {
      // Mock Apple Pay support check for demo
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if Google Pay is available
  Future<bool> isGooglePaySupported() async {
    try {
      // Mock Google Pay support check for demo
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Setup future payments (for split payments)
  Future<booking.SetupIntent> setupFuturePayments({
    required String clientSecret,
    required String customerId,
  }) async {
    try {
      // Mock setup intent for demo
      return booking.SetupIntent(
        id: 'si_${DateTime.now().millisecondsSinceEpoch}',
        clientSecret: clientSecret,
        status: 'succeeded',
        paymentMethodId: 'pm_card_demo',
        usage: 'off_session',
      );
    } catch (e) {
      throw PaymentException('Setup intent failed: ${e.toString()}');
    }
  }

  /// Get payment methods for a customer
  Future<List<stripe.PaymentMethodData>> getPaymentMethods(String customerId) async {
    try {
      // Mock payment methods for demo
      return [
        stripe.PaymentMethodData(
          billingDetails: const stripe.BillingDetails(
            email: 'customer@example.com',
          ),
        ),
      ];
    } catch (e) {
      throw PaymentException('Failed to get payment methods: ${e.toString()}');
    }
  }

  /// Process split payment installment
  Future<booking.PaymentIntent> processInstallmentPayment({
    required String clientSecret,
    required String paymentMethodId,
    required double amount,
  }) async {
    try {
      // Mock installment payment for demo
      await Future.delayed(const Duration(milliseconds: 600));
      
      return booking.PaymentIntent(
        id: 'pi_installment_${DateTime.now().millisecondsSinceEpoch}',
        clientSecret: clientSecret,
        status: 'succeeded',
        amount: (amount * 100).toInt(), // Convert to cents
        currency: 'usd',
        paymentMethodId: paymentMethodId,
      );
    } catch (e) {
      throw PaymentException('Installment payment failed: ${e.toString()}');
    }
  }

  /// Handle payment errors
  String getPaymentErrorMessage(stripe.StripeException error) {
    final errorMessage = error.error.message;
    if (errorMessage != null) {
      if (errorMessage.toLowerCase().contains('card')) {
        return 'Your card was declined. Please try a different card.';
      } else if (errorMessage.toLowerCase().contains('expired')) {
        return 'Your card has expired. Please try a different card.';
      } else if (errorMessage.toLowerCase().contains('funds')) {
        return 'Your card has insufficient funds. Please try a different card.';
      } else if (errorMessage.toLowerCase().contains('cvc') || errorMessage.toLowerCase().contains('security')) {
        return 'Your card\'s security code is incorrect. Please try again.';
      }
    }
    return 'Payment failed. Please try again.';
  }
}

class PaymentException implements Exception {
  const PaymentException(this.message);
  final String message;

  @override
  String toString() => message;
}

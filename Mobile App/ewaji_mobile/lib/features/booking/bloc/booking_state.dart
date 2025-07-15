import 'package:equatable/equatable.dart';
import '../models/booking.dart';

enum BookingStateStatus {
  initial,
  loading,
  paymentIntentCreated,
  paymentConfirmed,
  bookingCreated,
  success,
  failure,
}

class BookingState extends Equatable {
  const BookingState({
    this.status = BookingStateStatus.initial,
    this.paymentIntent,
    this.booking,
    this.isSplitPayEligible = false,
    this.splitPaymentPlan,
    this.errorMessage,
    this.isCheckingEligibility = false,
    this.isCreatingPaymentIntent = false,
    this.isConfirmingPayment = false,
    this.isCreatingBooking = false,
    this.isSendingNotification = false,
    this.retryCount = 0,
  });

  final BookingStateStatus status;
  final PaymentIntent? paymentIntent;
  final Booking? booking;
  final bool isSplitPayEligible;
  final SplitPaymentPlan? splitPaymentPlan;
  final String? errorMessage;
  final bool isCheckingEligibility;
  final bool isCreatingPaymentIntent;
  final bool isConfirmingPayment;
  final bool isCreatingBooking;
  final bool isSendingNotification;
  final int retryCount;

  @override
  List<Object?> get props => [
        status,
        paymentIntent,
        booking,
        isSplitPayEligible,
        splitPaymentPlan,
        errorMessage,
        isCheckingEligibility,
        isCreatingPaymentIntent,
        isConfirmingPayment,
        isCreatingBooking,
        isSendingNotification,
        retryCount,
      ];

  BookingState copyWith({
    BookingStateStatus? status,
    PaymentIntent? paymentIntent,
    Booking? booking,
    bool? isSplitPayEligible,
    SplitPaymentPlan? splitPaymentPlan,
    String? errorMessage,
    bool? isCheckingEligibility,
    bool? isCreatingPaymentIntent,
    bool? isConfirmingPayment,
    bool? isCreatingBooking,
    bool? isSendingNotification,
    int? retryCount,
  }) {
    return BookingState(
      status: status ?? this.status,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      booking: booking ?? this.booking,
      isSplitPayEligible: isSplitPayEligible ?? this.isSplitPayEligible,
      splitPaymentPlan: splitPaymentPlan ?? this.splitPaymentPlan,
      errorMessage: errorMessage ?? this.errorMessage,
      isCheckingEligibility: isCheckingEligibility ?? this.isCheckingEligibility,
      isCreatingPaymentIntent: isCreatingPaymentIntent ?? this.isCreatingPaymentIntent,
      isConfirmingPayment: isConfirmingPayment ?? this.isConfirmingPayment,
      isCreatingBooking: isCreatingBooking ?? this.isCreatingBooking,
      isSendingNotification: isSendingNotification ?? this.isSendingNotification,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  bool get isLoading => 
      isCheckingEligibility ||
      isCreatingPaymentIntent ||
      isConfirmingPayment ||
      isCreatingBooking ||
      isSendingNotification;

  bool get canRetry => retryCount < 3;

  bool get hasError => status == BookingStateStatus.failure && errorMessage != null;

  bool get isReadyForPayment => 
      status == BookingStateStatus.paymentIntentCreated && 
      paymentIntent != null;

  bool get isBookingComplete => 
      status == BookingStateStatus.success && 
      booking != null;
}

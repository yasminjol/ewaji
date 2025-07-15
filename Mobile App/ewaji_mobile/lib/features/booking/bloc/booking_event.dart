import 'package:equatable/equatable.dart';
import '../models/booking.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentIntent extends BookingEvent {
  const CreatePaymentIntent({
    required this.amount,
    required this.currency,
    required this.customerId,
    this.isSplitPayment = false,
  });

  final double amount;
  final String currency;
  final String customerId;
  final bool isSplitPayment;

  @override
  List<Object?> get props => [amount, currency, customerId, isSplitPayment];
}

class CreateBooking extends BookingEvent {
  const CreateBooking({
    required this.serviceId,
    required this.providerId,
    required this.clientId,
    required this.timeSlotId,
    required this.serviceTitle,
    required this.totalAmount,
    required this.depositAmount,
    required this.depositPercent,
    required this.paymentMethod,
    required this.paymentIntentId,
    this.notes,
    this.isSplitPayment = false,
    this.splitPaymentPlan,
  });

  final String serviceId;
  final String providerId;
  final String clientId;
  final String timeSlotId;
  final String serviceTitle;
  final double totalAmount;
  final double depositAmount;
  final double depositPercent;
  final PaymentMethod paymentMethod;
  final String paymentIntentId;
  final String? notes;
  final bool isSplitPayment;
  final SplitPaymentPlan? splitPaymentPlan;

  @override
  List<Object?> get props => [
        serviceId,
        providerId,
        clientId,
        timeSlotId,
        serviceTitle,
        totalAmount,
        depositAmount,
        depositPercent,
        paymentMethod,
        paymentIntentId,
        notes,
        isSplitPayment,
        splitPaymentPlan,
      ];
}

class ConfirmPayment extends BookingEvent {
  const ConfirmPayment(this.paymentIntentId);

  final String paymentIntentId;

  @override
  List<Object?> get props => [paymentIntentId];
}

class CheckSplitPayEligibility extends BookingEvent {
  const CheckSplitPayEligibility(this.clientId);

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

class CreateSplitPaymentPlan extends BookingEvent {
  const CreateSplitPaymentPlan({
    required this.totalAmount,
    required this.numberOfPayments,
  });

  final double totalAmount;
  final int numberOfPayments;

  @override
  List<Object?> get props => [totalAmount, numberOfPayments];
}

class UpdateBookingStatus extends BookingEvent {
  const UpdateBookingStatus({
    required this.bookingId,
    required this.status,
  });

  final String bookingId;
  final BookingStatus status;

  @override
  List<Object?> get props => [bookingId, status];
}

class SendBookingNotification extends BookingEvent {
  const SendBookingNotification({
    required this.bookingId,
    required this.recipientId,
    required this.type,
    this.data,
  });

  final String bookingId;
  final String recipientId;
  final String type;
  final Map<String, dynamic>? data;

  @override
  List<Object?> get props => [bookingId, recipientId, type, data];
}

class ResetBookingState extends BookingEvent {
  const ResetBookingState();
}

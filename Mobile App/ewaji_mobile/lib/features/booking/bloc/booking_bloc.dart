import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/booking.dart';
import '../repository/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc({
    required BookingRepository bookingRepository,
  })  : _bookingRepository = bookingRepository,
        super(const BookingState()) {
    on<CreatePaymentIntent>(_onCreatePaymentIntent);
    on<CreateBooking>(_onCreateBooking);
    on<ConfirmPayment>(_onConfirmPayment);
    on<CheckSplitPayEligibility>(_onCheckSplitPayEligibility);
    on<CreateSplitPaymentPlan>(_onCreateSplitPaymentPlan);
    on<UpdateBookingStatus>(_onUpdateBookingStatus);
    on<SendBookingNotification>(_onSendBookingNotification);
    on<ResetBookingState>(_onResetBookingState);
  }

  final BookingRepository _bookingRepository;

  Future<void> _onCreatePaymentIntent(
    CreatePaymentIntent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      isCreatingPaymentIntent: true,
      errorMessage: null,
    ));

    try {
      final paymentIntent = await _bookingRepository.createPaymentIntent(
        amount: event.amount,
        currency: event.currency,
        customerId: event.customerId,
        isSplitPayment: event.isSplitPayment,
      );

      emit(state.copyWith(
        status: BookingStateStatus.paymentIntentCreated,
        paymentIntent: paymentIntent,
        isCreatingPaymentIntent: false,
        retryCount: 0,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: BookingStateStatus.failure,
        errorMessage: 'Failed to create payment intent: ${error.toString()}',
        isCreatingPaymentIntent: false,
        retryCount: state.retryCount + 1,
      ));
    }
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      isCreatingBooking: true,
      errorMessage: null,
    ));

    try {
      final booking = await _bookingRepository.createBooking(
        serviceId: event.serviceId,
        providerId: event.providerId,
        clientId: event.clientId,
        timeSlotId: event.timeSlotId,
        serviceTitle: event.serviceTitle,
        totalAmount: event.totalAmount,
        depositAmount: event.depositAmount,
        depositPercent: event.depositPercent,
        paymentMethod: event.paymentMethod,
        paymentIntentId: event.paymentIntentId,
        notes: event.notes,
        isSplitPayment: event.isSplitPayment,
        splitPaymentPlan: event.splitPaymentPlan,
      );

      emit(state.copyWith(
        status: BookingStateStatus.bookingCreated,
        booking: booking,
        isCreatingBooking: false,
        retryCount: 0,
      ));

      // Send notification to provider
      add(SendBookingNotification(
        bookingId: booking.id,
        recipientId: booking.providerId,
        type: 'booking_created',
        data: {
          'client_id': booking.clientId,
          'service_title': booking.serviceTitle,
          'time_slot_id': booking.timeSlotId,
          'total_amount': booking.totalAmount,
        },
      ));
    } catch (error) {
      emit(state.copyWith(
        status: BookingStateStatus.failure,
        errorMessage: 'Failed to create booking: ${error.toString()}',
        isCreatingBooking: false,
        retryCount: state.retryCount + 1,
      ));
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPayment event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      isConfirmingPayment: true,
      errorMessage: null,
    ));

    try {
      final success = await _bookingRepository.confirmPayment(event.paymentIntentId);

      if (success) {
        emit(state.copyWith(
          status: BookingStateStatus.paymentConfirmed,
          isConfirmingPayment: false,
          retryCount: 0,
        ));
      } else {
        throw Exception('Payment confirmation failed');
      }
    } catch (error) {
      emit(state.copyWith(
        status: BookingStateStatus.failure,
        errorMessage: 'Payment confirmation failed: ${error.toString()}',
        isConfirmingPayment: false,
        retryCount: state.retryCount + 1,
      ));
    }
  }

  Future<void> _onCheckSplitPayEligibility(
    CheckSplitPayEligibility event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      isCheckingEligibility: true,
      errorMessage: null,
    ));

    try {
      final isEligible = await _bookingRepository.checkSplitPayEligibility(event.clientId);

      emit(state.copyWith(
        isSplitPayEligible: isEligible,
        isCheckingEligibility: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to check eligibility: ${error.toString()}',
        isCheckingEligibility: false,
        isSplitPayEligible: false,
      ));
    }
  }

  Future<void> _onCreateSplitPaymentPlan(
    CreateSplitPaymentPlan event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      isCreatingPaymentIntent: true, // Reuse this flag for split payment plan
      errorMessage: null,
    ));

    try {
      final splitPaymentPlan = await _bookingRepository.createSplitPaymentPlan(
        totalAmount: event.totalAmount,
        numberOfPayments: event.numberOfPayments,
      );

      emit(state.copyWith(
        splitPaymentPlan: splitPaymentPlan,
        isCreatingPaymentIntent: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to create split payment plan: ${error.toString()}',
        isCreatingPaymentIntent: false,
      ));
    }
  }

  Future<void> _onUpdateBookingStatus(
    UpdateBookingStatus event,
    Emitter<BookingState> emit,
  ) async {
    try {
      final updatedBooking = await _bookingRepository.updateBookingStatus(
        event.bookingId,
        event.status,
      );

      emit(state.copyWith(
        booking: updatedBooking,
        status: event.status == BookingStatus.confirmed 
            ? BookingStateStatus.success 
            : BookingStateStatus.bookingCreated,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to update booking status: ${error.toString()}',
      ));
    }
  }

  Future<void> _onSendBookingNotification(
    SendBookingNotification event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      isSendingNotification: true,
    ));

    try {
      await _bookingRepository.sendBookingNotification(
        bookingId: event.bookingId,
        recipientId: event.recipientId,
        type: event.type,
        data: event.data,
      );

      emit(state.copyWith(
        isSendingNotification: false,
        status: BookingStateStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        isSendingNotification: false,
        errorMessage: 'Failed to send notification: ${error.toString()}',
      ));
    }
  }

  void _onResetBookingState(
    ResetBookingState event,
    Emitter<BookingState> emit,
  ) {
    emit(const BookingState());
  }
}

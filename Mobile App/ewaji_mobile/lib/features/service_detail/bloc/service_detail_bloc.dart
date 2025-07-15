import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/service_detail.dart';
import '../repository/service_detail_repository.dart';
import 'service_detail_event.dart';
import 'service_detail_state.dart';

class ServiceDetailBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  ServiceDetailBloc({
    required ServiceDetailRepository serviceDetailRepository,
  })  : _serviceDetailRepository = serviceDetailRepository,
        super(const ServiceDetailState()) {
    on<LoadServiceDetail>(_onLoadServiceDetail);
    on<LoadAvailability>(_onLoadAvailability);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<RefreshAvailability>(_onRefreshAvailability);
    on<SubscribeToAvailability>(_onSubscribeToAvailability);
    on<UnsubscribeFromAvailability>(_onUnsubscribeFromAvailability);
    on<UpdateAvailabilityFromRealtime>(_onUpdateAvailabilityFromRealtime);
  }

  final ServiceDetailRepository _serviceDetailRepository;
  StreamSubscription<List<TimeSlot>>? _availabilitySubscription;

  @override
  Future<void> close() {
    _availabilitySubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadServiceDetail(
    LoadServiceDetail event,
    Emitter<ServiceDetailState> emit,
  ) async {
    emit(state.copyWith(status: ServiceDetailStatus.loading));

    try {
      final serviceDetail = await _serviceDetailRepository.getServiceDetail(event.serviceId);
      
      emit(state.copyWith(
        status: ServiceDetailStatus.success,
        serviceDetail: serviceDetail,
      ));

      // Auto-load availability for today
      final today = DateTime.now();
      add(LoadAvailability(serviceId: event.serviceId, date: today));
      
    } catch (error) {
      emit(state.copyWith(
        status: ServiceDetailStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoadAvailability(
    LoadAvailability event,
    Emitter<ServiceDetailState> emit,
  ) async {
    try {
      final timeSlots = await _serviceDetailRepository.getAvailability(
        serviceId: event.serviceId,
        date: event.date,
      );

      emit(state.copyWith(
        timeSlots: timeSlots,
        selectedDate: event.date,
        selectedTimeSlot: null, // Reset selection when changing date
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: error.toString(),
      ));
    }
  }

  void _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<ServiceDetailState> emit,
  ) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));
  }

  Future<void> _onRefreshAvailability(
    RefreshAvailability event,
    Emitter<ServiceDetailState> emit,
  ) async {
    if (state.serviceDetail != null && state.selectedDate != null) {
      add(LoadAvailability(
        serviceId: state.serviceDetail!.id,
        date: state.selectedDate!,
      ));
    }
  }

  Future<void> _onSubscribeToAvailability(
    SubscribeToAvailability event,
    Emitter<ServiceDetailState> emit,
  ) async {
    try {
      // Cancel existing subscription
      await _availabilitySubscription?.cancel();

      // Subscribe to real-time availability updates
      _availabilitySubscription = _serviceDetailRepository
          .subscribeToAvailability(event.serviceId)
          .listen((timeSlots) {
        add(UpdateAvailabilityFromRealtime(timeSlots));
      });

      emit(state.copyWith(isSubscribedToRealtime: true));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to subscribe to real-time updates: $error',
      ));
    }
  }

  Future<void> _onUnsubscribeFromAvailability(
    UnsubscribeFromAvailability event,
    Emitter<ServiceDetailState> emit,
  ) async {
    await _availabilitySubscription?.cancel();
    _availabilitySubscription = null;
    emit(state.copyWith(isSubscribedToRealtime: false));
  }

  void _onUpdateAvailabilityFromRealtime(
    UpdateAvailabilityFromRealtime event,
    Emitter<ServiceDetailState> emit,
  ) {
    // Update time slots with real-time data
    final updatedTimeSlots = <TimeSlot>[];
    
    for (final existingSlot in state.timeSlots) {
      final updatedSlot = event.timeSlots.firstWhere(
        (newSlot) => newSlot.id == existingSlot.id,
        orElse: () => existingSlot,
      );
      updatedTimeSlots.add(updatedSlot);
    }

    // Check if selected slot is still available
    TimeSlot? updatedSelectedSlot = state.selectedTimeSlot;
    if (updatedSelectedSlot != null) {
      final currentSlot = updatedTimeSlots.firstWhere(
        (slot) => slot.id == updatedSelectedSlot!.id,
        orElse: () => updatedSelectedSlot!,
      );
      
      // If slot is no longer available, clear selection
      if (!currentSlot.isAvailable) {
        updatedSelectedSlot = null;
      } else {
        updatedSelectedSlot = currentSlot;
      }
    }

    emit(state.copyWith(
      timeSlots: updatedTimeSlots,
      selectedTimeSlot: updatedSelectedSlot,
    ));
  }
}

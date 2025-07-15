import 'package:equatable/equatable.dart';
import '../models/service_detail.dart';

abstract class ServiceDetailEvent extends Equatable {
  const ServiceDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadServiceDetail extends ServiceDetailEvent {
  const LoadServiceDetail(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

class LoadAvailability extends ServiceDetailEvent {
  const LoadAvailability({
    required this.serviceId,
    required this.date,
  });

  final String serviceId;
  final DateTime date;

  @override
  List<Object?> get props => [serviceId, date];
}

class SelectTimeSlot extends ServiceDetailEvent {
  const SelectTimeSlot(this.timeSlot);

  final TimeSlot timeSlot;

  @override
  List<Object?> get props => [timeSlot];
}

class RefreshAvailability extends ServiceDetailEvent {
  const RefreshAvailability();
}

class RefreshAvailabilityRequested extends ServiceDetailEvent {
  const RefreshAvailabilityRequested(this.providerId);

  final String providerId;

  @override
  List<Object?> get props => [providerId];
}

class SubscribeToAvailability extends ServiceDetailEvent {
  const SubscribeToAvailability(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

class UnsubscribeFromAvailability extends ServiceDetailEvent {
  const UnsubscribeFromAvailability();
}

class UpdateAvailabilityFromRealtime extends ServiceDetailEvent {
  const UpdateAvailabilityFromRealtime(this.timeSlots);

  final List<TimeSlot> timeSlots;

  @override
  List<Object?> get props => [timeSlots];
}

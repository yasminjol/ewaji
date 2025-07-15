import 'package:equatable/equatable.dart';
import '../models/service_detail.dart';

enum ServiceDetailStatus { initial, loading, success, failure }

class ServiceDetailState extends Equatable {
  const ServiceDetailState({
    this.status = ServiceDetailStatus.initial,
    this.serviceDetail,
    this.timeSlots = const [],
    this.selectedDate,
    this.selectedTimeSlot,
    this.errorMessage,
    this.isSubscribedToRealtime = false,
  });

  final ServiceDetailStatus status;
  final ServiceDetail? serviceDetail;
  final List<TimeSlot> timeSlots;
  final DateTime? selectedDate;
  final TimeSlot? selectedTimeSlot;
  final String? errorMessage;
  final bool isSubscribedToRealtime;

  @override
  List<Object?> get props => [
        status,
        serviceDetail,
        timeSlots,
        selectedDate,
        selectedTimeSlot,
        errorMessage,
        isSubscribedToRealtime,
      ];

  ServiceDetailState copyWith({
    ServiceDetailStatus? status,
    ServiceDetail? serviceDetail,
    List<TimeSlot>? timeSlots,
    DateTime? selectedDate,
    TimeSlot? selectedTimeSlot,
    String? errorMessage,
    bool? isSubscribedToRealtime,
  }) {
    return ServiceDetailState(
      status: status ?? this.status,
      serviceDetail: serviceDetail ?? this.serviceDetail,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubscribedToRealtime: isSubscribedToRealtime ?? this.isSubscribedToRealtime,
    );
  }

  // Helper getters
  List<TimeSlot> get availableTimeSlots => 
      timeSlots.where((slot) => slot.isAvailable).toList();

  bool get hasAvailableSlots => availableTimeSlots.isNotEmpty;

  double? get finalPrice {
    if (selectedTimeSlot?.price != null) {
      return selectedTimeSlot!.price!;
    }
    return serviceDetail?.price;
  }

  double? get discountAmount {
    if (selectedTimeSlot?.discountPercent != null && finalPrice != null) {
      return finalPrice! * (selectedTimeSlot!.discountPercent! / 100);
    }
    return null;
  }

  double? get discountedPrice {
    if (discountAmount != null && finalPrice != null) {
      return finalPrice! - discountAmount!;
    }
    return finalPrice;
  }
}

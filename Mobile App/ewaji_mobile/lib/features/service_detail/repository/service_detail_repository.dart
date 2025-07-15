import '../models/service_detail.dart';

abstract class ServiceDetailRepository {
  Future<ServiceDetail> getServiceDetail(String serviceId);
  
  Future<List<TimeSlot>> getAvailability({
    required String serviceId,
    required DateTime date,
  });
  
  Stream<List<TimeSlot>> subscribeToAvailability(String serviceId);
  
  Future<void> bookTimeSlot({
    required String serviceId,
    required String timeSlotId,
    required Map<String, dynamic> bookingDetails,
  });
}

class ServiceDetailRepositoryImpl implements ServiceDetailRepository {
  // In a real implementation, this would use Supabase client
  // For now, we'll use mock data

  @override
  Future<ServiceDetail> getServiceDetail(String serviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock service detail data
    return ServiceDetail(
      id: serviceId,
      providerId: 'provider_123',
      title: 'Professional Hair Styling & Cut',
      description: 'Transform your look with our expert hair styling services. We provide complete hair care including consultation, washing, cutting, styling, and finishing touches to give you the perfect look for any occasion.',
      price: 75.0,
      duration: const Duration(hours: 1, minutes: 30),
      category: 'Beauty & Personal Care',
      subcategory: 'Hair Services',
      rating: 4.8,
      reviewCount: 143,
      mediaItems: [
        MediaItem(
          id: 'media_1',
          url: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=800',
          type: MediaType.image,
          caption: 'Modern hair styling studio',
          order: 0,
        ),
        MediaItem(
          id: 'media_2',
          url: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800',
          type: MediaType.image,
          caption: 'Professional hair cutting',
          order: 1,
        ),
        MediaItem(
          id: 'media_3',
          url: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
          type: MediaType.video,
          thumbnailUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
          caption: 'Hair styling process demo',
          duration: const Duration(seconds: 30),
          order: 2,
        ),
        MediaItem(
          id: 'media_4',
          url: 'https://images.unsplash.com/photo-1519699047748-de8e457a634e?w=800',
          type: MediaType.image,
          caption: 'Before and after transformation',
          order: 3,
        ),
      ],
      preparationChecklist: [
        ChecklistItem(
          id: 'prep_1',
          title: 'Clean Hair',
          description: 'Wash your hair 1-2 days before the appointment for best results',
          iconName: 'wash',
          isOptional: false,
          estimatedTime: const Duration(minutes: 15),
          order: 0,
        ),
        ChecklistItem(
          id: 'prep_2',
          title: 'Reference Photos',
          description: 'Bring photos of desired hairstyles or inspiration images',
          iconName: 'photo_library',
          isOptional: true,
          estimatedTime: const Duration(minutes: 5),
          order: 1,
        ),
        ChecklistItem(
          id: 'prep_3',
          title: 'Hair History',
          description: 'Inform about recent chemical treatments, coloring, or allergies',
          iconName: 'history',
          isOptional: false,
          order: 2,
        ),
        ChecklistItem(
          id: 'prep_4',
          title: 'Comfortable Clothing',
          description: 'Wear clothes that can get slightly wet or stained',
          iconName: 'checkroom',
          isOptional: true,
          order: 3,
        ),
        ChecklistItem(
          id: 'prep_5',
          title: 'Arrive 10 Minutes Early',
          description: 'Come a bit early for consultation and preparation',
          iconName: 'schedule',
          isOptional: false,
          estimatedTime: const Duration(minutes: 10),
          order: 4,
        ),
      ],
      requirements: [
        'Must be 18 years or older, or accompanied by a guardian',
        'No recent hair chemical treatments within 48 hours',
        'Inform about any scalp conditions or allergies',
      ],
      inclusions: [
        'Hair consultation and analysis',
        'Professional hair washing and conditioning',
        'Hair cutting and styling',
        'Blow dry and finishing',
        'Basic hair care advice',
        'Style maintenance tips',
      ],
      exclusions: [
        'Hair coloring or chemical treatments',
        'Hair extensions installation',
        'Deep conditioning treatments',
        'Hair products for home use',
      ],
      additionalInfo: 'Please note that extensive color corrections may require a separate appointment. We use only premium hair care products and tools to ensure the best results.',
      tags: ['trending', 'popular', 'expert-recommended'],
      location: ServiceLocation(
        address: '123 Style Street, Fashion District',
        latitude: 37.7749,
        longitude: -122.4194,
        city: 'San Francisco',
        state: 'CA',
        zipCode: '94102',
        country: 'USA',
      ),
      serviceArea: 15.0, // 15km radius
    );
  }

  @override
  Future<List<TimeSlot>> getAvailability({
    required String serviceId,
    required DateTime date,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock time slots for the given date
    final timeSlots = <TimeSlot>[];
    final baseDate = DateTime(date.year, date.month, date.day);

    // Morning slots (9 AM - 12 PM)
    for (int hour = 9; hour < 12; hour++) {
      final startTime = baseDate.add(Duration(hours: hour));
      final endTime = startTime.add(const Duration(hours: 1, minutes: 30));
      
      timeSlots.add(TimeSlot(
        id: 'slot_${serviceId}_$hour',
        startTime: startTime,
        endTime: endTime,
        isAvailable: _isSlotAvailable(hour),
        price: hour == 10 ? 85.0 : null, // Premium morning slot
        totalSpots: 3,
        availableSpots: _getAvailableSpots(hour, 3),
      ));
    }

    // Afternoon slots (2 PM - 6 PM)
    for (int hour = 14; hour < 18; hour++) {
      final startTime = baseDate.add(Duration(hours: hour));
      final endTime = startTime.add(const Duration(hours: 1, minutes: 30));
      
      timeSlots.add(TimeSlot(
        id: 'slot_${serviceId}_$hour',
        startTime: startTime,
        endTime: endTime,
        isAvailable: _isSlotAvailable(hour),
        discountPercent: hour >= 16 ? 10.0 : null, // Evening discount
        totalSpots: 3,
        availableSpots: _getAvailableSpots(hour, 3),
      ));
    }

    return timeSlots;
  }

  bool _isSlotAvailable(int hour) {
    // Simulate some slots being unavailable
    final unavailableHours = [10, 15, 17]; // 10 AM, 3 PM, 5 PM are booked
    return !unavailableHours.contains(hour);
  }

  int _getAvailableSpots(int hour, int totalSpots) {
    // Simulate different availability levels
    if (!_isSlotAvailable(hour)) return 0;
    
    // Some hours have limited spots
    if ([9, 14, 16].contains(hour)) return 1; // Limited availability
    if ([11, 18].contains(hour)) return totalSpots - 1; // Almost full
    
    return totalSpots; // Full availability
  }

  @override
  Stream<List<TimeSlot>> subscribeToAvailability(String serviceId) {
    // Simulate real-time updates using a periodic stream
    return Stream.periodic(const Duration(seconds: 30), (count) {
      // Simulate random availability changes
      return _generateRandomTimeSlots(serviceId);
    }).asyncMap((_) async {
      // Get current availability
      final today = DateTime.now();
      return await getAvailability(serviceId: serviceId, date: today);
    });
  }

  List<TimeSlot> _generateRandomTimeSlots(String serviceId) {
    // This would be replaced with actual Supabase real-time data
    final timeSlots = <TimeSlot>[];
    final baseDate = DateTime.now();
    final baseDay = DateTime(baseDate.year, baseDate.month, baseDate.day);

    for (int hour = 9; hour < 18; hour++) {
      if (hour >= 12 && hour < 14) continue; // Lunch break

      final startTime = baseDay.add(Duration(hours: hour));
      final endTime = startTime.add(const Duration(hours: 1, minutes: 30));
      
      timeSlots.add(TimeSlot(
        id: 'slot_${serviceId}_$hour',
        startTime: startTime,
        endTime: endTime,
        isAvailable: DateTime.now().millisecond % 3 != 0, // Random availability
        totalSpots: 3,
        availableSpots: _getAvailableSpots(hour, 3),
      ));
    }

    return timeSlots;
  }

  @override
  Future<void> bookTimeSlot({
    required String serviceId,
    required String timeSlotId,
    required Map<String, dynamic> bookingDetails,
  }) async {
    // Simulate booking API call
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // In a real implementation, this would:
    // 1. Create booking record in Supabase
    // 2. Update time slot availability
    // 3. Send confirmation notifications
    // 4. Return booking confirmation details
    
    // For now, just simulate success
    print('Booking created for slot $timeSlotId with details: $bookingDetails');
  }
}

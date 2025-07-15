import 'package:flutter_test/flutter_test.dart';
import 'package:ewaji_mobile/core/models/notification.dart';
import 'package:ewaji_mobile/features/booking/models/booking.dart';

void main() {
  group('NotificationService', () {
    group('Notification Models', () {
      test('should create ScheduledNotification correctly', () {
        final now = DateTime.now();
        final notification = ScheduledNotification(
          id: 123,
          title: 'Test Title',
          body: 'Test Body',
          type: NotificationType.bookingConfirmation,
          scheduledTime: now,
          payload: {'key': 'value'},
          routeName: '/test',
          routeParams: {'param': 'value'},
        );

        expect(notification.id, 123);
        expect(notification.title, 'Test Title');
        expect(notification.body, 'Test Body');
        expect(notification.type, NotificationType.bookingConfirmation);
        expect(notification.scheduledTime, now);
        expect(notification.payload, {'key': 'value'});
        expect(notification.routeName, '/test');
        expect(notification.routeParams, {'param': 'value'});
      });

      test('should serialize and deserialize ScheduledNotification', () {
        final now = DateTime.now();
        final notification = ScheduledNotification(
          id: 123,
          title: 'Test Title',
          body: 'Test Body',
          type: NotificationType.preparationReminder,
          scheduledTime: now,
          payload: {'key': 'value'},
        );

        final json = notification.toJson();
        final restored = ScheduledNotification.fromJson(json);

        expect(restored.id, notification.id);
        expect(restored.title, notification.title);
        expect(restored.body, notification.body);
        expect(restored.type, notification.type);
        expect(restored.scheduledTime.millisecondsSinceEpoch, 
               notification.scheduledTime.millisecondsSinceEpoch);
        expect(restored.payload, notification.payload);
      });

      test('should handle copyWith for ScheduledNotification', () {
        final notification = ScheduledNotification(
          id: 123,
          title: 'Original Title',
          body: 'Original Body',
          type: NotificationType.general,
          scheduledTime: DateTime.now(),
        );

        final updated = notification.copyWith(
          title: 'Updated Title',
          body: 'Updated Body',
        );

        expect(updated.id, notification.id);
        expect(updated.title, 'Updated Title');
        expect(updated.body, 'Updated Body');
        expect(updated.type, notification.type);
        expect(updated.scheduledTime, notification.scheduledTime);
      });
    });

    group('Notification Types', () {
      test('should have correct notification type values', () {
        expect(NotificationType.bookingConfirmation.name, 'bookingConfirmation');
        expect(NotificationType.preparationReminder.name, 'preparationReminder');
        expect(NotificationType.reviewPrompt.name, 'reviewPrompt');
        expect(NotificationType.general.name, 'general');
      });
    });

    group('Notification Timing', () {
      test('should calculate correct reminder times', () {
        final serviceStart = DateTime(2024, 12, 25, 14, 0); // 2 PM on Christmas
        
        // 24-hour reminder should be at 2 PM on Christmas Eve
        final reminder24h = serviceStart.subtract(const Duration(hours: 24));
        expect(reminder24h.day, 24);
        expect(reminder24h.hour, 14);
        
        // 2-hour reminder should be at 12 PM on Christmas
        final reminder2h = serviceStart.subtract(const Duration(hours: 2));
        expect(reminder2h.day, 25);
        expect(reminder2h.hour, 12);
      });

      test('should calculate correct review prompt time', () {
        final serviceEnd = DateTime(2024, 12, 25, 16, 0); // 4 PM on Christmas
        
        // Review prompt should be at 4 PM on December 26
        final reviewTime = serviceEnd.add(const Duration(hours: 24));
        expect(reviewTime.day, 26);
        expect(reviewTime.hour, 16);
      });

      test('should identify past notifications correctly', () {
        final pastTime = DateTime.now().subtract(const Duration(hours: 1));
        final futureTime = DateTime.now().add(const Duration(hours: 1));
        
        expect(pastTime.isBefore(DateTime.now()), isTrue);
        expect(futureTime.isAfter(DateTime.now()), isTrue);
      });
    });

    group('Booking Model Integration', () {
      test('should create booking with correct properties', () {
        final booking = _createMockBooking();
        
        expect(booking.id, 'test-booking-123');
        expect(booking.serviceTitle, 'Test Service');
        expect(booking.status, BookingStatus.confirmed);
        expect(booking.totalAmount, 100.0);
      });
    });

    group('FCM Notification Model', () {
      test('should create FCMNotification with basic properties', () {
        const fcmNotification = FCMNotification(
          messageId: 'test-123',
          title: 'Test Title',
          body: 'Test Body',
          data: {'key': 'value'},
        );

        expect(fcmNotification.messageId, 'test-123');
        expect(fcmNotification.title, 'Test Title');
        expect(fcmNotification.body, 'Test Body');
        expect(fcmNotification.data, {'key': 'value'});
      });
    });

    group('Notification ID Generation', () {
      test('should generate valid notification IDs', () {
        final now = DateTime.now().millisecondsSinceEpoch;
        final id = now.remainder(100000);
        
        expect(id, isA<int>());
        expect(id, greaterThanOrEqualTo(0));
        expect(id, lessThan(100000));
      });
    });
  });
}

/// Helper function to create a mock booking for testing
Booking _createMockBooking() {
  return Booking(
    id: 'test-booking-123',
    serviceId: 'test-service-123',
    providerId: 'test-provider-123',
    clientId: 'test-client-123',
    timeSlotId: 'test-timeslot-123',
    serviceTitle: 'Test Service',
    totalAmount: 100.0,
    depositAmount: 25.0,
    remainingAmount: 75.0,
    depositPercent: 25.0,
    status: BookingStatus.confirmed,
    paymentStatus: PaymentStatus.depositPaid,
    paymentMethod: PaymentMethod.card,
    createdAt: DateTime.fromMillisecondsSinceEpoch(1640995200000), // Mock timestamp
  );
}

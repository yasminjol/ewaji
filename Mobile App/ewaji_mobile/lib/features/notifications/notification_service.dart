import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ewaji_mobile/core/models/notification.dart';
import 'package:ewaji_mobile/features/booking/index.dart';

/// Singleton service for managing notifications
class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._internal();
    return _instance!;
  }

  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _localNotifications;
  late FirebaseMessaging _firebaseMessaging;
  
  final StreamController<FCMNotification> _fcmNotificationController =
      StreamController<FCMNotification>.broadcast();
  final StreamController<ScheduledNotification> _localNotificationController =
      StreamController<ScheduledNotification>.broadcast();

  /// Stream for FCM notifications received when app is in foreground
  Stream<FCMNotification> get fcmNotificationStream =>
      _fcmNotificationController.stream;

  /// Stream for local notification selections
  Stream<ScheduledNotification> get localNotificationStream =>
      _localNotificationController.stream;

  bool _initialized = false;
  BuildContext? _navigationContext;

  /// Initialize the notification service
  Future<void> initialize({BuildContext? navigationContext}) async {
    if (_initialized) return;

    _navigationContext = navigationContext;
    _firebaseMessaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();

    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();

    _initialized = true;
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: null,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Booking confirmation channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'booking_confirmation',
        'Booking Confirmations',
        description: 'Notifications for booking confirmations',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    );

    // Preparation reminder channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'preparation_reminder',
        'Preparation Reminders',
        description: 'Reminders to prepare for upcoming bookings',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    );

    // Review prompt channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'review_prompt',
        'Review Prompts',
        description: 'Prompts to review completed bookings',
        importance: Importance.defaultImportance,
        enableVibration: false,
        playSound: false,
      ),
    );

    // General notifications channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'general',
        'General Notifications',
        description: 'General app notifications',
        importance: Importance.defaultImportance,
        enableVibration: true,
        playSound: true,
      ),
    );
  }

  /// Initialize Firebase Cloud Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Request permissions for iOS
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final fcmNotification = FCMNotification.fromRemoteMessage(message);
      _fcmNotificationController.add(fcmNotification);
      
      // Show local notification when app is in foreground
      _showForegroundNotification(message);
    });

    // Handle message opened app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });

    // Handle message when app is terminated
    _checkForInitialMessage();
  }

  /// Check for initial message when app is opened from terminated state
  Future<void> _checkForInitialMessage() async {
    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    
    if (initialMessage != null) {
      _handleNotificationNavigation(initialMessage.data);
    }
  }

  /// Show notification when app is in foreground
  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'general',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _handleNotificationNavigation(data);
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  /// Handle navigation from notification
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (_navigationContext == null) return;

    final routeName = data['routeName'] as String?;
    final routeParams = data['routeParams'] as Map<String, dynamic>?;

    if (routeName != null) {
      // TODO: Implement navigation using your router
      // Example: context.push(routeName, extra: routeParams);
      debugPrint('Navigate to: $routeName with params: $routeParams');
    }
  }

  /// Request notification permissions
  Future<NotificationPermissionStatus> requestPermissions() async {
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          return NotificationPermissionStatus.granted;
        case AuthorizationStatus.denied:
          return NotificationPermissionStatus.denied;
        case AuthorizationStatus.notDetermined:
          return NotificationPermissionStatus.notDetermined;
        case AuthorizationStatus.provisional:
          return NotificationPermissionStatus.provisional;
      }
    } else if (Platform.isAndroid) {
      // For Android 13+ (API level 33+)
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        return granted == true 
            ? NotificationPermissionStatus.granted 
            : NotificationPermissionStatus.denied;
      }
    }

    return NotificationPermissionStatus.granted; // Default for older Android
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Schedule booking confirmation notification (immediate)
  Future<void> scheduleBookingConfirmation(Booking booking, {DateTime? serviceStartTime}) async {
    final notification = ScheduledNotification(
      id: _generateNotificationId(),
      title: 'Booking Confirmed!',
      body: 'Your booking for ${booking.serviceTitle} has been confirmed.',
      type: NotificationType.bookingConfirmation,
      scheduledTime: DateTime.now(),
      payload: {
        'bookingId': booking.id,
        'serviceId': booking.serviceId,
      },
      routeName: '/booking-details',
      routeParams: {'bookingId': booking.id},
    );

    await _scheduleNotification(notification);
  }

  /// Schedule preparation reminder notifications
  Future<void> schedulePreparationReminders(Booking booking, DateTime serviceStartTime) async {
    final serviceName = booking.serviceTitle;

    // 24-hour reminder
    final reminder24h = ScheduledNotification(
      id: _generateNotificationId(),
      title: 'Service Tomorrow!',
      body: 'Don\'t forget about your $serviceName appointment tomorrow.',
      type: NotificationType.preparationReminder,
      scheduledTime: serviceStartTime.subtract(const Duration(hours: 24)),
      payload: {
        'bookingId': booking.id,
        'serviceId': booking.serviceId,
        'reminderType': '24h',
      },
      routeName: '/booking-details',
      routeParams: {'bookingId': booking.id},
    );

    // 2-hour reminder
    final reminder2h = ScheduledNotification(
      id: _generateNotificationId(),
      title: 'Service Today!',
      body: 'Your $serviceName appointment is in 2 hours. Time to prepare!',
      type: NotificationType.preparationReminder,
      scheduledTime: serviceStartTime.subtract(const Duration(hours: 2)),
      payload: {
        'bookingId': booking.id,
        'serviceId': booking.serviceId,
        'reminderType': '2h',
      },
      routeName: '/booking-details',
      routeParams: {'bookingId': booking.id},
    );

    await _scheduleNotification(reminder24h);
    await _scheduleNotification(reminder2h);
  }

  /// Schedule review prompt notification (24 hours after service)
  Future<void> scheduleReviewPrompt(Booking booking, DateTime serviceEndTime) async {
    final serviceName = booking.serviceTitle;

    final reviewPrompt = ScheduledNotification(
      id: _generateNotificationId(),
      title: 'How was your experience?',
      body: 'Please rate your $serviceName experience and help others!',
      type: NotificationType.reviewPrompt,
      scheduledTime: serviceEndTime.add(const Duration(hours: 24)),
      payload: {
        'bookingId': booking.id,
        'serviceId': booking.serviceId,
      },
      routeName: '/review',
      routeParams: {
        'bookingId': booking.id,
        'serviceId': booking.serviceId,
      },
    );

    await _scheduleNotification(reviewPrompt);
  }

  /// Schedule all booking-related notifications
  Future<void> scheduleBookingNotifications(Booking booking, DateTime serviceStartTime, DateTime serviceEndTime) async {
    await scheduleBookingConfirmation(booking, serviceStartTime: serviceStartTime);
    await schedulePreparationReminders(booking, serviceStartTime);
    await scheduleReviewPrompt(booking, serviceEndTime);
  }

  /// Schedule a notification
  Future<void> _scheduleNotification(ScheduledNotification notification) async {
    // Don't schedule past notifications
    if (notification.scheduledTime.isBefore(DateTime.now())) {
      debugPrint('Skipping past notification: ${notification.title}');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      _getChannelId(notification.type),
      _getChannelName(notification.type),
      channelDescription: _getChannelDescription(notification.type),
      importance: _getImportance(notification.type),
      enableVibration: notification.type != NotificationType.reviewPrompt,
      playSound: notification.type != NotificationType.reviewPrompt,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      _convertToTZDateTime(notification.scheduledTime),
      details,
      payload: jsonEncode(notification.toJson()),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('Scheduled notification: ${notification.title} at ${notification.scheduledTime}');
  }

  /// Convert DateTime to TZDateTime (using local timezone)
  dynamic _convertToTZDateTime(DateTime dateTime) {
    // Note: In a real app, you'd use timezone package for proper timezone handling
    // For now, using the basic zonedSchedule with local time
    return dateTime;
  }

  /// Get channel ID for notification type
  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmation:
        return 'booking_confirmation';
      case NotificationType.preparationReminder:
        return 'preparation_reminder';
      case NotificationType.reviewPrompt:
        return 'review_prompt';
      case NotificationType.general:
        return 'general';
    }
  }

  /// Get channel name for notification type
  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmation:
        return 'Booking Confirmations';
      case NotificationType.preparationReminder:
        return 'Preparation Reminders';
      case NotificationType.reviewPrompt:
        return 'Review Prompts';
      case NotificationType.general:
        return 'General Notifications';
    }
  }

  /// Get channel description for notification type
  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmation:
        return 'Notifications for booking confirmations';
      case NotificationType.preparationReminder:
        return 'Reminders to prepare for upcoming bookings';
      case NotificationType.reviewPrompt:
        return 'Prompts to review completed bookings';
      case NotificationType.general:
        return 'General app notifications';
    }
  }

  /// Get importance for notification type
  Importance _getImportance(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmation:
      case NotificationType.preparationReminder:
        return Importance.high;
      case NotificationType.reviewPrompt:
      case NotificationType.general:
        return Importance.defaultImportance;
    }
  }

  /// Generate unique notification ID
  int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Show immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.general,
    Map<String, dynamic>? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _getChannelId(type),
      _getChannelName(type),
      channelDescription: _getChannelDescription(type),
      importance: _getImportance(type),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      _generateNotificationId(),
      title,
      body,
      details,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Schedule a notification to be shown at a specific time
  Future<void> scheduleNotification({
    required DateTime scheduledTime,
    required String title,
    required String body,
    NotificationType type = NotificationType.general,
    Map<String, dynamic>? payload,
  }) async {
    final notification = ScheduledNotification(
      id: _generateNotificationId(),
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      type: type,
      payload: payload,
    );

    await _scheduleNotification(notification);
  }

  /// Dispose resources
  void dispose() {
    _fcmNotificationController.close();
    _localNotificationController.close();
  }
}

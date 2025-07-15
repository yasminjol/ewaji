import 'package:equatable/equatable.dart';

/// Represents different types of notifications in the app
enum NotificationType {
  bookingConfirmation,
  preparationReminder,
  reviewPrompt,
  general,
}

/// Represents a scheduled notification
class ScheduledNotification extends Equatable {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime scheduledTime;
  final Map<String, dynamic>? payload;
  final String? routeName;
  final Map<String, String>? routeParams;

  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.scheduledTime,
    this.payload,
    this.routeName,
    this.routeParams,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        scheduledTime,
        payload,
        routeName,
        routeParams,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'scheduledTime': scheduledTime.toIso8601String(),
      'payload': payload,
      'routeName': routeName,
      'routeParams': routeParams,
    };
  }

  factory ScheduledNotification.fromJson(Map<String, dynamic> json) {
    return ScheduledNotification(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      payload: json['payload'] as Map<String, dynamic>?,
      routeName: json['routeName'] as String?,
      routeParams: (json['routeParams'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  ScheduledNotification copyWith({
    int? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? scheduledTime,
    Map<String, dynamic>? payload,
    String? routeName,
    Map<String, String>? routeParams,
  }) {
    return ScheduledNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      payload: payload ?? this.payload,
      routeName: routeName ?? this.routeName,
      routeParams: routeParams ?? this.routeParams,
    );
  }
}

/// Represents notification permission status
enum NotificationPermissionStatus {
  granted,
  denied,
  notDetermined,
  provisional,
}

/// Represents a Firebase Cloud Messaging notification
class FCMNotification extends Equatable {
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final DateTime? sentTime;
  final String? imageUrl;

  const FCMNotification({
    this.messageId,
    this.title,
    this.body,
    this.data,
    this.sentTime,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        messageId,
        title,
        body,
        data,
        sentTime,
        imageUrl,
      ];

  factory FCMNotification.fromRemoteMessage(dynamic remoteMessage) {
    return FCMNotification(
      messageId: remoteMessage.messageId,
      title: remoteMessage.notification?.title,
      body: remoteMessage.notification?.body,
      data: remoteMessage.data,
      sentTime: remoteMessage.sentTime,
      imageUrl: remoteMessage.notification?.apple?.imageUrl ??
          remoteMessage.notification?.android?.imageUrl,
    );
  }
}

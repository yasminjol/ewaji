# Notification System - M-FR-05

This document describes the complete notification system implementation for the ewaji mobile app, including Firebase Cloud Messaging (FCM), local notifications, permission handling, and deep-linking capabilities.

## Features

### ✅ Core Functionality
- **FCM Integration**: Firebase Cloud Messaging for push notifications
- **Local Notifications**: Scheduled local notifications with flutter_local_notifications
- **Permission Management**: iOS and Android 13+ permission handling
- **Deep Linking**: Navigation to specific screens from notifications
- **Notification Types**: Booking confirmations, preparation reminders, review prompts
- **Scheduling**: Automatic notification scheduling based on booking times

### ✅ Notification Types

#### 1. Booking Confirmation (Immediate)
- **Trigger**: Immediately after booking confirmation
- **Content**: "Your booking for [Service] has been confirmed"
- **Action**: Deep link to booking details
- **Priority**: High

#### 2. Preparation Reminders
- **24-Hour Reminder**: "Service Tomorrow! Don't forget about your [Service] appointment tomorrow"
- **2-Hour Reminder**: "Service Today! Your [Service] appointment is in 2 hours. Time to prepare!"
- **Priority**: High
- **Action**: Deep link to booking details

#### 3. Review Prompt (24 hours after service)
- **Trigger**: 24 hours after service completion
- **Content**: "How was your experience? Please rate your [Service] experience and help others!"
- **Action**: Deep link to review screen
- **Priority**: Normal

## Architecture

### NotificationService (Singleton)
The main service that handles all notification operations:

```dart
class NotificationService {
  static NotificationService get instance => _instance ??= NotificationService._internal();
  
  // Core methods
  Future<void> initialize({BuildContext? navigationContext});
  Future<void> scheduleBookingNotifications(Booking booking, DateTime serviceStartTime, DateTime serviceEndTime);
  Future<NotificationPermissionStatus> requestPermissions();
  Future<void> showNotification({required String title, required String body, ...});
}
```

### Models

#### ScheduledNotification
```dart
class ScheduledNotification {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime scheduledTime;
  final Map<String, dynamic>? payload;
  final String? routeName;
  final Map<String, String>? routeParams;
}
```

#### NotificationType
```dart
enum NotificationType {
  bookingConfirmation,
  preparationReminder,
  reviewPrompt,
  general,
}
```

## Usage Examples

### Basic Initialization
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final notificationService = NotificationService.instance;
  await notificationService.initialize();
  
  runApp(MyApp());
}
```

### Request Permissions
```dart
Future<void> requestNotificationPermissions(BuildContext context) async {
  final granted = await NotificationPermissionHandler.requestPermissionsWithDialog(context);
  if (granted) {
    print('Notifications enabled!');
  }
}
```

### Schedule Booking Notifications
```dart
Future<void> onBookingConfirmed(Booking booking, TimeSlot timeSlot) async {
  final notificationService = NotificationService.instance;
  
  await notificationService.scheduleBookingNotifications(
    booking,
    timeSlot.startTime,
    timeSlot.endTime,
  );
}
```

### Send Immediate Notification
```dart
Future<void> sendCustomNotification() async {
  final notificationService = NotificationService.instance;
  
  await notificationService.showNotification(
    title: 'Important Update',
    body: 'Your service provider has sent you a message',
    type: NotificationType.general,
    payload: {'messageId': '123'},
  );
}
```

## Android Configuration

### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<!-- Android 13+ notification permission -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<application>
  <!-- Firebase Messaging Service -->
  <service
    android:name=".MyFirebaseMessagingService"
    android:exported="false">
    <intent-filter>
      <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
  </service>
  
  <!-- Notification channels are created programmatically -->
</application>
```

### Notification Channels
The system automatically creates these Android notification channels:

1. **booking_confirmation** - High priority, sound + vibration
2. **preparation_reminder** - High priority, sound + vibration  
3. **review_prompt** - Normal priority, no sound/vibration
4. **general** - Normal priority, sound + vibration

## iOS Configuration

### Info.plist
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

### Capabilities
- Background Modes: Remote notifications
- Push Notifications capability in Xcode

## Testing

### Unit Tests
Run the notification service tests:
```bash
flutter test test/core/services/notification_service_test.dart
```

### Demo App
Use the notification demo screen to test all functionality:
```dart
import 'package:ewaji_mobile/notification_demo.dart';

// Navigate to NotificationDemoScreen in your app
Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDemoScreen()));
```

### Test Scenarios
1. **Permission Flow**: Test permission request on both iOS and Android
2. **Immediate Notifications**: Test showNotification method
3. **Scheduled Notifications**: Test booking notification scheduling
4. **Deep Linking**: Test navigation from notification taps
5. **Foreground Handling**: Test FCM notifications while app is open

## Production Considerations

### Firebase Setup
1. Create Firebase project
2. Add iOS and Android apps
3. Download configuration files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
4. Set up Firebase Cloud Messaging
5. Configure APNs certificates for iOS

### Error Handling
- Network failures are handled gracefully
- Permission denials are properly managed
- Invalid notification scheduling is prevented

### Performance
- Notifications are batched when possible
- Past notifications are automatically skipped
- Minimal battery impact with exact scheduling

### Security
- FCM tokens are securely managed
- Notification payloads are validated
- Deep links are verified before navigation

## Dependencies

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^17.2.3
  
# Platform-specific permissions handled automatically
```

## Troubleshooting

### Common Issues

1. **Notifications not appearing**
   - Check permissions are granted
   - Verify Firebase configuration
   - Ensure app is not in battery optimization

2. **Deep linking not working**
   - Verify route names are correct
   - Check navigation context is set
   - Ensure router is properly configured

3. **iOS notifications not working**
   - Verify APNs certificates
   - Check iOS simulator limitations
   - Ensure proper Info.plist configuration

### Debug Commands
```bash
# Check pending notifications
flutter test --plain-name "should get pending notifications"

# Test notification scheduling
flutter test --plain-name "should schedule notifications"

# Verify channel creation
flutter test --plain-name "should create notification channels"
```

## Future Enhancements

1. **Rich Notifications**: Images, actions, custom layouts
2. **Notification History**: Track sent/received notifications
3. **Smart Scheduling**: AI-based optimal timing
4. **Grouping**: Group related notifications
5. **Analytics**: Track notification open rates

## File Structure

```
lib/
├── core/
│   ├── models/
│   │   └── notification.dart
│   ├── services/
│   │   └── notification_service.dart
│   └── utils/
│       └── notification_permissions.dart
├── notification_demo.dart
└── ...

test/
└── core/
    └── services/
        └── notification_service_test.dart
```

## Validation Checklist

- ✅ NotificationService singleton implemented
- ✅ FCM integration configured
- ✅ Local notifications with flutter_local_notifications
- ✅ Permission handling for iOS and Android 13+
- ✅ Deep-link navigation support
- ✅ Booking confirmation (immediate)
- ✅ Preparation reminders (T-24h, T-2h)
- ✅ Review prompt (T+24h)
- ✅ Notification channels created
- ✅ Unit tests implemented
- ✅ Demo screen for testing
- ✅ Error handling and edge cases
- ✅ Documentation and examples

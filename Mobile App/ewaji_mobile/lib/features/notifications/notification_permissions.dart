import 'dart:io';

import 'package:flutter/material.dart';
import 'notification_service.dart';
import '../../core/models/notification.dart';

/// Utility class for handling notification permissions
class NotificationPermissionHandler {
  static final NotificationService _notificationService = NotificationService.instance;

  /// Show permission request dialog and handle the result
  static Future<bool> requestPermissionsWithDialog(BuildContext context) async {
    // First check if we should show rationale on Android
    if (Platform.isAndroid) {
      final shouldShowRationale = await _shouldShowPermissionRationale(context);
      if (shouldShowRationale) {
        if (!context.mounted) return false;
        final userWantsToGrant = await _showPermissionRationale(context);
        if (!userWantsToGrant) {
          return false;
        }
      }
    }

    // Request permissions
    final status = await _notificationService.requestPermissions();
    
    if (!context.mounted) return false;
    
    switch (status) {
      case NotificationPermissionStatus.granted:
        _showPermissionGrantedSnackBar(context);
        return true;
        
      case NotificationPermissionStatus.denied:
        await _showPermissionDeniedDialog(context);
        return false;
        
      case NotificationPermissionStatus.notDetermined:
        // This shouldn't happen after requesting, but handle it
        return false;
        
      case NotificationPermissionStatus.provisional:
        // iOS provisional authorization
        _showProvisionalPermissionSnackBar(context);
        return true;
    }
  }

  /// Check if we should show permission rationale
  static Future<bool> _shouldShowPermissionRationale(BuildContext context) async {
    // In a real app, you'd check if this is the first time asking
    // For now, we'll show rationale for demonstration
    return true;
  }

  /// Show permission rationale dialog
  static Future<bool> _showPermissionRationale(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To provide you with the best experience, we\'d like to send you notifications for:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              _PermissionReasonItem(
                icon: Icons.check_circle,
                text: 'Booking confirmations',
                color: Colors.green,
              ),
              _PermissionReasonItem(
                icon: Icons.access_time,
                text: 'Service reminders',
                color: Colors.blue,
              ),
              _PermissionReasonItem(
                icon: Icons.star,
                text: 'Review prompts',
                color: Colors.orange,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Not Now'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Show permission denied dialog with settings option
  static Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notifications Disabled'),
          content: const Text(
            'You\'ve disabled notifications for this app. To receive important updates about your bookings, please enable notifications in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, you'd open app settings
                // AppSettings.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  /// Show permission granted snack bar
  static void _showPermissionGrantedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Notifications enabled successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Show provisional permission snack bar (iOS)
  static void _showProvisionalPermissionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text('Notifications enabled. You can manage them in Settings.'),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 4),
      ),
    );
  }

  /// Check current permission status
  static Future<NotificationPermissionStatus> checkPermissionStatus() async {
    // This would require additional implementation to check current status
    // For now, we'll request permissions to get the current status
    return await _notificationService.requestPermissions();
  }

  /// Show permission status in a user-friendly way
  static String getPermissionStatusMessage(NotificationPermissionStatus status) {
    switch (status) {
      case NotificationPermissionStatus.granted:
        return 'Notifications are enabled';
      case NotificationPermissionStatus.denied:
        return 'Notifications are disabled';
      case NotificationPermissionStatus.notDetermined:
        return 'Notification permissions not requested';
      case NotificationPermissionStatus.provisional:
        return 'Notifications are enabled (provisional)';
    }
  }
}

/// Widget for showing permission reason items
class _PermissionReasonItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _PermissionReasonItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

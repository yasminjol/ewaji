import 'package:flutter/material.dart';
import 'package:ewaji_mobile/core/services/notification_service.dart';
import 'package:ewaji_mobile/core/models/notification.dart';
import 'package:ewaji_mobile/core/utils/notification_permissions.dart';
import 'package:ewaji_mobile/features/booking/models/booking.dart';

/// Demo screen for testing notification functionality
class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final NotificationService _notificationService = NotificationService.instance;
  bool _initialized = false;
  String? _fcmToken;
  NotificationPermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initialize(navigationContext: context);
      final token = await _notificationService.getFCMToken();
      final status = await NotificationPermissionHandler.checkPermissionStatus();
      
      setState(() {
        _initialized = true;
        _fcmToken = token;
        _permissionStatus = status;
      });
    } catch (e) {
      setState(() {
        _initialized = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing notifications: $e')),
        );
      }
    }
  }

  Future<void> _requestPermissions() async {
    final granted = await NotificationPermissionHandler.requestPermissionsWithDialog(context);
    if (granted) {
      final status = await NotificationPermissionHandler.checkPermissionStatus();
      setState(() {
        _permissionStatus = status;
      });
    }
  }

  Future<void> _testImmediateNotification() async {
    await _notificationService.showNotification(
      title: 'Test Notification',
      body: 'This is a test notification sent immediately!',
      type: NotificationType.general,
      payload: {'test': 'data'},
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification sent!')),
      );
    }
  }

  Future<void> _testBookingNotifications() async {
    final booking = _createTestBooking();
    final serviceStartTime = DateTime.now().add(const Duration(minutes: 5));
    final serviceEndTime = serviceStartTime.add(const Duration(hours: 2));

    await _notificationService.scheduleBookingNotifications(
      booking,
      serviceStartTime,
      serviceEndTime,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking notifications scheduled! Check in a few minutes.'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _testReminderNotifications() async {
    final booking = _createTestBooking();
    
    // Schedule reminders for near future for testing
    final serviceStartTime = DateTime.now().add(const Duration(minutes: 2));
    await _notificationService.schedulePreparationReminders(booking, serviceStartTime);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder notifications scheduled for 2 minutes from now!'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _viewPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pending Notifications (${pending.length})'),
          content: SizedBox(
            width: double.maxFinite,
            child: pending.isEmpty
                ? const Text('No pending notifications')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final notification = pending[index];
                      return ListTile(
                        title: Text(notification.title ?? 'No title'),
                        subtitle: Text(notification.body ?? 'No body'),
                        trailing: Text('ID: ${notification.id}'),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications cancelled!')),
      );
    }
  }

  Booking _createTestBooking() {
    return Booking(
      id: 'demo-booking-${DateTime.now().millisecondsSinceEpoch}',
      serviceId: 'demo-service-123',
      providerId: 'demo-provider-123',
      clientId: 'demo-client-123',
      timeSlotId: 'demo-timeslot-123',
      serviceTitle: 'Demo House Cleaning',
      totalAmount: 120.0,
      depositAmount: 30.0,
      remainingAmount: 90.0,
      depositPercent: 25.0,
      status: BookingStatus.confirmed,
      paymentStatus: PaymentStatus.depositPaid,
      paymentMethod: PaymentMethod.card,
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 16),
                  _buildTestSection(),
                  const SizedBox(height: 16),
                  _buildManagementSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              'Initialized',
              _initialized ? 'Yes' : 'No',
              _initialized ? Colors.green : Colors.red,
            ),
            _buildStatusRow(
              'Permissions',
              _permissionStatus != null 
                  ? NotificationPermissionHandler.getPermissionStatusMessage(_permissionStatus!)
                  : 'Unknown',
              _permissionStatus == NotificationPermissionStatus.granted 
                  ? Colors.green 
                  : Colors.orange,
            ),
            _buildStatusRow(
              'FCM Token',
              _fcmToken != null ? 'Available' : 'Not available',
              _fcmToken != null ? Colors.green : Colors.orange,
            ),
            if (_fcmToken != null) ...[
              const SizedBox(height: 8),
              Text(
                'Token: ${_fcmToken!.substring(0, 20)}...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Notifications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Test different types of notifications to verify they work correctly.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (_permissionStatus != NotificationPermissionStatus.granted) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _requestPermissions,
                  icon: const Icon(Icons.notifications),
                  label: const Text('Request Permissions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testImmediateNotification,
                icon: const Icon(Icons.send),
                label: const Text('Send Test Notification'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testBookingNotifications,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Schedule Booking Notifications'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testReminderNotifications,
                icon: const Icon(Icons.alarm),
                label: const Text('Schedule Reminder (2 min)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'View and manage your scheduled notifications.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _viewPendingNotifications,
                icon: const Icon(Icons.list),
                label: const Text('View Pending Notifications'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _cancelAllNotifications,
                icon: const Icon(Icons.clear_all),
                label: const Text('Cancel All Notifications'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose the singleton service
    super.dispose();
  }
}

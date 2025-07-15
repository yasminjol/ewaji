import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/service_detail/presentation/pages/service_detail_screen.dart';
import 'features/service_detail/repository/service_detail_repository.dart';
import 'features/service_detail/bloc/service_detail_bloc.dart';
import 'features/booking/services/payment_service.dart';

void main() {
  runApp(const BookingDemoApp());
}

class BookingDemoApp extends StatelessWidget {
  const BookingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EWAJI Booking & Escrow Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BookingDemoScreen(),
    );
  }
}

class BookingDemoScreen extends StatefulWidget {
  const BookingDemoScreen({super.key});

  @override
  State<BookingDemoScreen> createState() => _BookingDemoScreenState();
}

class _BookingDemoScreenState extends State<BookingDemoScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize Stripe SDK
    PaymentService.instance.initializeStripe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EWAJI Booking & Escrow Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'M-FR-03: Transparent Offer ✅',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Service detail screen with media carousel\n'
              '• Preparation checklist\n'
              '• Real-time availability grid\n'
              '• Share deep-link functionality\n'
              '• Comprehensive service information',
            ),
            const SizedBox(height: 24),
            
            Text(
              'M-FR-04: Booking & Escrow ✅',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Stripe SDK integration (Apple/Google Pay)\n'
              '• Split-pay toggle (Pay in 4)\n'
              '• Deposit-only payment flow\n'
              '• Supabase booking creation\n'
              '• FCM push notifications\n'
              '• Exponential backoff retry logic\n'
              '• Comprehensive error handling',
            ),
            const SizedBox(height: 32),
            
            Text(
              'Demo Features:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              'Service Detail & Booking',
              'Complete booking flow with payment integration',
              Icons.calendar_today,
              () => _navigateToServiceDetail(),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              'Payment Methods',
              'Apple Pay, Google Pay, and Card payments',
              Icons.payment,
              () => _showPaymentInfo(),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              'Split Payment',
              'Pay in 4 installments with eligibility check',
              Icons.splitscreen,
              () => _showSplitPayInfo(),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              'Real-time Updates',
              'Live availability and booking notifications',
              Icons.notifications_active,
              () => _showRealTimeInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _navigateToServiceDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ServiceDetailBloc(
            serviceDetailRepository: ServiceDetailRepositoryImpl(),
          ),
          child: const ServiceDetailScreen(serviceId: 'service_demo'),
        ),
      ),
    );
  }

  void _showPaymentInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Methods'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🍎 Apple Pay'),
            Text('• Touch ID / Face ID authentication'),
            Text('• Secure payment tokenization'),
            SizedBox(height: 12),
            Text('🎯 Google Pay'),
            Text('• Android device integration'),
            Text('• Contactless payment'),
            SizedBox(height: 12),
            Text('💳 Credit/Debit Cards'),
            Text('• Stripe secure processing'),
            Text('• PCI DSS compliance'),
            SizedBox(height: 12),
            Text('🔐 Security Features'),
            Text('• End-to-end encryption'),
            Text('• 3D Secure authentication'),
            Text('• Fraud detection'),
          ],
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

  void _showSplitPayInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Split Payment (Pay in 4)'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💰 How it works:'),
            Text('• 25% deposit paid today'),
            Text('• Remaining 75% split into 3 payments'),
            Text('• Payments every 2 weeks'),
            Text('• No interest or fees'),
            SizedBox(height: 12),
            Text('✅ Eligibility Requirements:'),
            Text('• Minimum order amount'),
            Text('• Good payment history'),
            Text('• Credit check (soft inquiry)'),
            SizedBox(height: 12),
            Text('🎯 Benefits:'),
            Text('• Better cash flow management'),
            Text('• Access to higher-value services'),
            Text('• Automatic payment scheduling'),
          ],
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

  void _showRealTimeInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Real-time Features'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📊 Live Availability:'),
            Text('• Real-time slot updates'),
            Text('• Provider availability changes'),
            Text('• Instant booking confirmations'),
            SizedBox(height: 12),
            Text('🔔 Push Notifications:'),
            Text('• Booking confirmations'),
            Text('• Payment receipts'),
            Text('• Service reminders'),
            Text('• Status updates'),
            SizedBox(height: 12),
            Text('🔄 Auto-retry Logic:'),
            Text('• Exponential backoff'),
            Text('• Network error handling'),
            Text('• Payment retry mechanism'),
            Text('• Graceful degradation'),
          ],
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

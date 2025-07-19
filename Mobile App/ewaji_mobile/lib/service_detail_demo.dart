import 'package:flutter/material.dart';
import 'features/service_detail/index.dart';

class ServiceDetailDemo extends StatelessWidget {
  const ServiceDetailDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Detail Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Detail Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Service Detail Screen Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ServiceDetailScreen(
                      serviceId: 'service_001',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('View Service Detail'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This demo shows the complete M-FR-03 "Transparent Offer" implementation with:\n\n'
                '• Media carousel with images/videos\n'
                '• Preparation checklist\n'
                '• Real-time availability grid\n'
                '• Booking flow with time slot selection\n'
                '• Share functionality with deep links\n'
                '• Responsive UI design',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

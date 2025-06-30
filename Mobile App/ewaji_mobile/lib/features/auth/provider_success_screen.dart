import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderSuccessScreen extends StatelessWidget {
  const ProviderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Success!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/provider/dashboard'),
              child: const Text('Continue to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

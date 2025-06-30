import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderPhoneOTPScreen extends StatelessWidget {
  const ProviderPhoneOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1C1E)),
          onPressed: () => context.go('/provider/categories'),
        ),
      ),
      body: const Center(
        child: Text(
          'Provider Phone OTP',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

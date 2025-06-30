import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientRegisterStep1Screen extends StatelessWidget {
  const ClientRegisterStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1C1E)),
          onPressed: () => context.go('/client/login'),
        ),
      ),
      body: const Center(
        child: Text(
          'Client Register Step 1',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

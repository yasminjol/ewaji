import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderCategorySelectionScreen extends StatelessWidget {
  const ProviderCategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1C1E)),
          onPressed: () => context.go('/provider/register-step2'),
        ),
      ),
      body: const Center(
        child: Text(
          'Provider Category Selection',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

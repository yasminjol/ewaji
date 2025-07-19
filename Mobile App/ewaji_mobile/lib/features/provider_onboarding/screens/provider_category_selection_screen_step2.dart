import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/index.dart';

/// Provider onboarding step 2/4: Primary Category Selection Screen
class ProviderCategorySelectionScreenStep2 extends StatelessWidget {
  final VoidCallback? onContinue;

  const ProviderCategorySelectionScreenStep2({
    super.key,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrimaryCategoryCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Step 2 of 4',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LinearProgressIndicator(
                  value: 2 / 4, // Step 2 of 4
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5E50A1),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              const SizedBox(height: 32),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: PrimaryCategorySelector(
                    title: 'Choose Your Specialty',
                    subtitle: 'Select 1-2 primary service categories that best describe your expertise. You can expand into additional categories later.',
                    onContinue: () => _handleContinue(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    final cubit = context.read<PrimaryCategoryCubit>();
    final selectedCategories = cubit.getSelectedCategories();
    
    // Save selected categories to SignUpBloc or service
    // TODO: Integrate with SignUpBloc.savePrimaryCategories(selectedCategories)
    print('Selected categories: ${selectedCategories.map((c) => c.name).join(', ')}');
    
    // Call external onContinue callback or navigate to next step
    if (onContinue != null) {
      onContinue!();
    } else {
      // Default navigation to next onboarding step
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selected: ${selectedCategories.map((c) => '${c.emoji} ${c.label}').join(', ')}',
          ),
          backgroundColor: const Color(0xFF5E50A1),
        ),
      );
    }
  }
}

/// Standalone demo for testing the category selector
class PrimaryCategoryDemo extends StatelessWidget {
  const PrimaryCategoryDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrimaryCategoryDemoScreen();
  }
}

class PrimaryCategoryDemoScreen extends StatelessWidget {
  const PrimaryCategoryDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderCategorySelectionScreenStep2();
  }
}

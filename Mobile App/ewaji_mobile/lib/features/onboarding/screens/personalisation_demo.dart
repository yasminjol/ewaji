import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/personalisation_cubit.dart';
import '../cubit/personalisation_state.dart';
import '../models/user_preferences.dart';
import '../screens/personalisation_wizard_screen.dart';

/// Demo page showing how to integrate the Personalisation Wizard
class PersonalisationDemo extends StatelessWidget {
  const PersonalisationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalisation Demo'),
        backgroundColor: const Color(0xFF5E50A1),
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => PersonalisationCubit(),
        child: BlocListener<PersonalisationCubit, PersonalisationState>(
          listener: (context, state) {
            if (state is PersonalisationCompleted) {
              // Handle completion - navigate to main app, show success, etc.
              _showCompletionDialog(context, state.preferences);
            }
          },
          child: const PersonalisationWizardScreen(),
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, UserPreferences preferences) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          '🎉 Personalisation Complete!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your preferences have been saved:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Categories
            if (preferences.preferredCategories.isNotEmpty) ...[
              const Text(
                'Preferred Categories:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              ...preferences.preferredCategories.map((category) => 
                Text('• ${category.displayName}', style: const TextStyle(fontSize: 14))),
              const SizedBox(height: 12),
            ],
            
            // Budget
            Text(
              'Budget Range:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'R${preferences.minBudget.toInt()} - R${preferences.maxBudget.toInt()}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            
            // Distance
            const Text(
              'Maximum Distance:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${preferences.maxDistance.toInt()} km',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Return to previous screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

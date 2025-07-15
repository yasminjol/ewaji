import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/personalisation_cubit.dart';
import '../cubit/personalisation_state.dart';
import '../cubit/personalisation_event.dart';
import '../widgets/services_selection_page.dart';
import '../widgets/budget_selection_page.dart';
import '../widgets/distance_selection_page.dart';

/// Client Personalisation Wizard - 3-step onboarding flow
class PersonalisationWizardScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const PersonalisationWizardScreen({
    super.key,
    this.onComplete,
    this.onSkip,
  });

  @override
  State<PersonalisationWizardScreen> createState() => _PersonalisationWizardScreenState();
}

class _PersonalisationWizardScreenState extends State<PersonalisationWizardScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalisationCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<PersonalisationCubit, PersonalisationState>(
            listener: (context, state) {
              if (state is PersonalisationCompleted) {
                // Onboarding completed
                if (widget.onComplete != null) {
                  widget.onComplete!();
                } else {
                  Navigator.of(context).pop();
                }
              } else if (state is PersonalisationInProgress) {
                // Animate to current step
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    state.currentStep,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is PersonalisationLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PersonalisationInProgress) {
                return _buildWizardContent(context, state);
              }

              if (state is PersonalisationError) {
                return _buildErrorView(context, state.message);
              }

              // Initial state - start wizard
              return _buildWelcomeView(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite,
            size: 80,
            color: Color(0xFF5E50A1),
          ),
          const SizedBox(height: 24),
          const Text(
            'Let\'s Personalize Your Experience',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tell us about your preferences to get the best service recommendations tailored just for you.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<PersonalisationCubit>().add(LoadPreferences());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.read<PersonalisationCubit>().add(SkipOnboarding());
            },
            child: const Text(
              'Skip for Now',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWizardContent(BuildContext context, PersonalisationInProgress state) {
    return Column(
      children: [
        // Header with progress and skip
        _buildHeader(context, state),
        
        // Page indicator dots
        _buildPageIndicator(state.currentStep),
        
        // Page content
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
            children: const [
              ServicesSelectionPage(),
              BudgetSelectionPage(),
              DistanceSelectionPage(),
            ],
          ),
        ),
        
        // Navigation buttons
        _buildNavigationButtons(context, state),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, PersonalisationInProgress state) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (state.currentStep > 0)
            IconButton(
              onPressed: () {
                context.read<PersonalisationCubit>().previousStep();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
            )
          else
            const SizedBox(width: 48),
          
          Expanded(
            child: Text(
              'Step ${state.currentStep + 1} of 3',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          TextButton(
            onPressed: () {
              context.read<PersonalisationCubit>().add(SkipOnboarding());
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int currentStep) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(
                right: index < 2 ? 8 : 0,
              ),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF5E50A1) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, PersonalisationInProgress state) {
    final isLastStep = state.currentStep == 2;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.read<PersonalisationCubit>().previousStep();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5E50A1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Color(0xFF5E50A1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          
          if (state.currentStep > 0) const SizedBox(width: 16),
          
          Expanded(
            flex: state.currentStep > 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: state.canContinue ? () {
                if (isLastStep) {
                  context.read<PersonalisationCubit>().add(CompleteOnboarding());
                } else {
                  context.read<PersonalisationCubit>().nextStep();
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLastStep ? 'Complete' : 'Continue',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 24),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<PersonalisationCubit>().add(ResetPreferences());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

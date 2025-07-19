import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../onboarding/index.dart';
import 'client_app.dart';

/// Wrapper that checks personalisation status before showing main client app
class ClientAppWithPersonalisation extends StatelessWidget {
  final String initialTab;
  
  const ClientAppWithPersonalisation({
    super.key, 
    this.initialTab = 'home',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalisationCubit()..loadExistingPreferences(),
      child: BlocListener<PersonalisationCubit, PersonalisationState>(
        listener: (context, state) {
          // If personalisation is not complete, redirect to wizard
          if (state is PersonalisationInProgress && !state.preferences.isOnboardingComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/client/personalisation');
            });
          }
        },
        child: BlocBuilder<PersonalisationCubit, PersonalisationState>(
          builder: (context, state) {
            // Show loading while checking personalisation status
            if (state is PersonalisationInitial) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF5E50A1),
                  ),
                ),
              );
            }
            
            // If personalisation is complete, show main app
            if (state is PersonalisationInProgress && state.preferences.isOnboardingComplete) {
              return ClientApp(initialTab: initialTab);
            }
            
            if (state is PersonalisationCompleted) {
              return ClientApp(initialTab: initialTab);
            }
            
            // Fallback - show main app (this shouldn't happen due to listener)
            return ClientApp(initialTab: initialTab);
          },
        ),
      ),
    );
  }
}

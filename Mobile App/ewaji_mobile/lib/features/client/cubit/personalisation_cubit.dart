import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../models/user_preferences.dart';
import 'personalisation_event.dart';
import 'personalisation_state.dart';

/// Cubit for managing client personalisation wizard
class PersonalisationCubit extends HydratedCubit<PersonalisationState> {
  static const int maxServices = 3;
  static const int totalSteps = 3;

  PersonalisationCubit() : super(PersonalisationInitial()) {
    // Load existing preferences on initialization
    add(LoadPreferences());
  }

  /// Add an event to the cubit
  void add(PersonalisationEvent event) {
    if (event is UpdatePreferredCategories) {
      _updatePreferredCategories(event.categories);
    } else if (event is UpdateBudgetRange) {
      _updateBudgetRange(event.minBudget, event.maxBudget);
    } else if (event is UpdateMaxDistance) {
      _updateMaxDistance(event.distance);
    } else if (event is CompleteOnboarding) {
      _completeOnboarding();
    } else if (event is SkipOnboarding) {
      _skipOnboarding();
    } else if (event is LoadPreferences) {
      _loadPreferences();
    } else if (event is ResetPreferences) {
      _resetPreferences();
    }
  }

  void _loadPreferences() {
    // Check if user has completed onboarding
    final currentState = state;
    if (currentState is PersonalisationCompleted) {
      // Already completed, keep current state
      return;
    }

    // Start fresh onboarding
    emit(PersonalisationInProgress(
      preferences: const UserPreferences(),
      currentStep: 0,
      canContinue: false,
    ));
  }

  void _updatePreferredCategories(List<ServiceCategory> categories) {
    final currentState = state;
    if (currentState is! PersonalisationInProgress) return;

    // Limit to max 3 categories
    final limitedCategories = categories.take(maxServices).toList();
    
    final updatedPrefs = currentState.preferences.copyWith(
      preferredCategories: limitedCategories,
    );

    emit(currentState.copyWith(
      preferences: updatedPrefs,
      canContinue: _canContinueFromStep(0, updatedPrefs),
    ));
  }

  void _updateBudgetRange(double minBudget, double maxBudget) {
    final currentState = state;
    if (currentState is! PersonalisationInProgress) return;

    final updatedPrefs = currentState.preferences.copyWith(
      minBudget: minBudget,
      maxBudget: maxBudget,
    );

    emit(currentState.copyWith(
      preferences: updatedPrefs,
      canContinue: _canContinueFromStep(1, updatedPrefs),
    ));
  }

  void _updateMaxDistance(double distance) {
    final currentState = state;
    if (currentState is! PersonalisationInProgress) return;

    final updatedPrefs = currentState.preferences.copyWith(
      maxDistance: distance,
    );

    emit(currentState.copyWith(
      preferences: updatedPrefs,
      canContinue: _canContinueFromStep(2, updatedPrefs),
    ));
  }

  bool _canContinueFromStep(int step, UserPreferences prefs) {
    switch (step) {
      case 0: // Services step - optional, can always continue
        return true;
      case 1: // Budget step - always valid range
        return prefs.minBudget <= prefs.maxBudget;
      case 2: // Distance step - always valid
        return prefs.maxDistance >= 5.0;
      default:
        return false;
    }
  }

  void nextStep() {
    final currentState = state;
    if (currentState is! PersonalisationInProgress) return;

    final nextStep = currentState.currentStep + 1;
    if (nextStep >= totalSteps) {
      _completeOnboarding();
      return;
    }

    emit(currentState.copyWith(
      currentStep: nextStep,
      canContinue: _canContinueFromStep(nextStep, currentState.preferences),
    ));
  }

  void previousStep() {
    final currentState = state;
    if (currentState is! PersonalisationInProgress) return;

    final prevStep = currentState.currentStep - 1;
    if (prevStep < 0) return;

    emit(currentState.copyWith(
      currentStep: prevStep,
      canContinue: _canContinueFromStep(prevStep, currentState.preferences),
    ));
  }

  void _completeOnboarding() {
    final currentState = state;
    if (currentState is! PersonalisationInProgress) return;

    final completedPrefs = currentState.preferences.copyWith(
      isOnboardingComplete: true,
    );

    emit(PersonalisationCompleted(
      preferences: completedPrefs,
      wasSkipped: false,
    ));

    // TODO: Persist to Supabase user_prefs table
    _persistPreferences(completedPrefs);
  }

  void _skipOnboarding() {
    final defaultPrefs = UserPreferences.defaultPrefs();
    
    emit(PersonalisationCompleted(
      preferences: defaultPrefs,
      wasSkipped: true,
    ));

    // TODO: Persist defaults to Supabase
    _persistPreferences(defaultPrefs);
  }

  void _resetPreferences() {
    emit(PersonalisationInProgress(
      preferences: const UserPreferences(),
      currentStep: 0,
      canContinue: false,
    ));
  }

  Future<void> _persistPreferences(UserPreferences prefs) async {
    try {
      // TODO: Implement Supabase persistence
      // await supabase.from('user_prefs').upsert(prefs.toJson());
      print('Preferences saved: $prefs');
    } catch (e) {
      print('Failed to save preferences: $e');
    }
  }

  /// Get current preferences
  UserPreferences? get currentPreferences {
    final currentState = state;
    if (currentState is PersonalisationInProgress) {
      return currentState.preferences;
    } else if (currentState is PersonalisationCompleted) {
      return currentState.preferences;
    }
    return null;
  }

  /// Check if onboarding is complete
  bool get isOnboardingComplete {
    return state is PersonalisationCompleted;
  }

  /// Load existing preferences and check completion status
  void loadExistingPreferences() {
    // This will automatically load from HydratedBloc storage
    // If user has completed onboarding, emit completed state
    final currentPrefs = currentPreferences;
    
    if (currentPrefs != null && currentPrefs.isOnboardingComplete) {
      emit(PersonalisationCompleted(preferences: currentPrefs));
    } else {
      // Start onboarding process
      emit(PersonalisationInProgress(
        preferences: currentPrefs ?? const UserPreferences(),
        currentStep: 0,
        canContinue: false,
      ));
    }
  }

  @override
  PersonalisationState? fromJson(Map<String, dynamic> json) {
    try {
      final stateType = json['type'] as String?;
      
      if (stateType == 'completed') {
        final prefsJson = json['preferences'] as Map<String, dynamic>;
        final preferences = UserPreferences.fromJson(prefsJson);
        final wasSkipped = json['wasSkipped'] as bool? ?? false;
        
        return PersonalisationCompleted(
          preferences: preferences,
          wasSkipped: wasSkipped,
        );
      } else if (stateType == 'inProgress') {
        final prefsJson = json['preferences'] as Map<String, dynamic>;
        final preferences = UserPreferences.fromJson(prefsJson);
        final currentStep = json['currentStep'] as int? ?? 0;
        final canContinue = json['canContinue'] as bool? ?? false;
        
        return PersonalisationInProgress(
          preferences: preferences,
          currentStep: currentStep,
          canContinue: canContinue,
        );
      }
      
      return PersonalisationInitial();
    } catch (e) {
      return PersonalisationInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(PersonalisationState state) {
    if (state is PersonalisationCompleted) {
      return {
        'type': 'completed',
        'preferences': state.preferences.toJson(),
        'wasSkipped': state.wasSkipped,
      };
    } else if (state is PersonalisationInProgress) {
      return {
        'type': 'inProgress',
        'preferences': state.preferences.toJson(),
        'currentStep': state.currentStep,
        'canContinue': state.canContinue,
      };
    }
    return null;
  }
}

import 'package:equatable/equatable.dart';
import '../models/user_preferences.dart';

/// States for the Personalisation Wizard
abstract class PersonalisationState extends Equatable {
  const PersonalisationState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class PersonalisationInitial extends PersonalisationState {}

/// Loading state
class PersonalisationLoading extends PersonalisationState {}

/// Wizard in progress state
class PersonalisationInProgress extends PersonalisationState {
  final UserPreferences preferences;
  final int currentStep;
  final bool canContinue;
  final String? errorMessage;

  const PersonalisationInProgress({
    required this.preferences,
    this.currentStep = 0,
    this.canContinue = false,
    this.errorMessage,
  });

  PersonalisationInProgress copyWith({
    UserPreferences? preferences,
    int? currentStep,
    bool? canContinue,
    String? errorMessage,
  }) {
    return PersonalisationInProgress(
      preferences: preferences ?? this.preferences,
      currentStep: currentStep ?? this.currentStep,
      canContinue: canContinue ?? this.canContinue,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [preferences, currentStep, canContinue, errorMessage];
}

/// Onboarding completed state
class PersonalisationCompleted extends PersonalisationState {
  final UserPreferences preferences;
  final bool wasSkipped;

  const PersonalisationCompleted({
    required this.preferences,
    this.wasSkipped = false,
  });

  @override
  List<Object?> get props => [preferences, wasSkipped];
}

/// Error state
class PersonalisationError extends PersonalisationState {
  final String message;

  const PersonalisationError(this.message);

  @override
  List<Object?> get props => [message];
}

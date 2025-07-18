import '../models/user_preferences.dart';

/// Events for the Personalisation Wizard
abstract class PersonalisationEvent {}

/// Update selected service categories (max 3)
class UpdatePreferredCategories extends PersonalisationEvent {
  final List<ServiceCategory> categories;
  UpdatePreferredCategories(this.categories);
}

/// Update budget range
class UpdateBudgetRange extends PersonalisationEvent {
  final double minBudget;
  final double maxBudget;
  
  UpdateBudgetRange({
    required this.minBudget,
    required this.maxBudget,
  });
}

/// Update maximum distance
class UpdateMaxDistance extends PersonalisationEvent {
  final double distance;
  UpdateMaxDistance(this.distance);
}

/// Complete onboarding with current preferences
class CompleteOnboarding extends PersonalisationEvent {}

/// Skip onboarding and use defaults
class SkipOnboarding extends PersonalisationEvent {}

/// Load existing preferences
class LoadPreferences extends PersonalisationEvent {}

/// Reset to defaults
class ResetPreferences extends PersonalisationEvent {}

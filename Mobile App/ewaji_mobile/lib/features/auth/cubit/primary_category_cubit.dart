import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../models/primary_category.dart';

/// Cubit for managing primary category selection with persistence
class PrimaryCategoryCubit extends HydratedCubit<Set<PrimaryCategory>> {
  PrimaryCategoryCubit() : super(<PrimaryCategory>{});

  /// Maximum number of categories that can be selected (2)
  static const int maxCategories = 2;

  /// Toggle a category selection
  void toggleCategory(PrimaryCategory category) {
    final currentCategories = Set<PrimaryCategory>.from(state);
    
    if (currentCategories.contains(category)) {
      // Remove if already selected
      currentCategories.remove(category);
    } else {
      // Add if not at max capacity
      if (currentCategories.length < maxCategories) {
        currentCategories.add(category);
      }
      // Ignore if trying to add a 3rd category
    }
    
    emit(currentCategories);
  }

  /// Clear all selected categories
  void clearAll() {
    emit(<PrimaryCategory>{});
  }

  /// Check if a category is selected
  bool isSelected(PrimaryCategory category) {
    return state.contains(category);
  }

  /// Check if maximum categories are selected
  bool isAtMaxCapacity() {
    return state.length >= maxCategories;
  }

  /// Check if can continue (at least 1 category selected)
  bool canContinue() {
    return state.isNotEmpty;
  }

  /// Get list of selected categories
  List<PrimaryCategory> getSelectedCategories() {
    return state.toList();
  }

  @override
  Set<PrimaryCategory> fromJson(Map<String, dynamic> json) {
    try {
      final List<String> categoryStrings = List<String>.from(json['categories'] ?? []);
      return categoryStrings
          .map((categoryString) => PrimaryCategory.values.firstWhere(
                (category) => category.name == categoryString,
                orElse: () => throw ArgumentError('Invalid category: $categoryString'),
              ))
          .toSet();
    } catch (e) {
      // Return empty set if deserialization fails
      return <PrimaryCategory>{};
    }
  }

  @override
  Map<String, dynamic> toJson(Set<PrimaryCategory> state) {
    return {
      'categories': state.map((category) => category.name).toList(),
    };
  }
}

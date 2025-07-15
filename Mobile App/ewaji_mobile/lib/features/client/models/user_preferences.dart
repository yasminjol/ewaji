/// User preferences model for client personalization
class UserPreferences {
  final List<ServiceCategory> preferredCategories;
  final double minBudget;
  final double maxBudget;
  final double maxDistance;
  final bool isOnboardingComplete;

  const UserPreferences({
    this.preferredCategories = const [],
    this.minBudget = 20.0,
    this.maxBudget = 600.0,
    this.maxDistance = 25.0,
    this.isOnboardingComplete = false,
  });

  /// Default preferences for skipped onboarding
  factory UserPreferences.defaultPrefs() {
    return const UserPreferences(
      preferredCategories: [],
      minBudget: 20.0,
      maxBudget: 600.0,
      maxDistance: 25.0,
      isOnboardingComplete: true,
    );
  }

  UserPreferences copyWith({
    List<ServiceCategory>? preferredCategories,
    double? minBudget,
    double? maxBudget,
    double? maxDistance,
    bool? isOnboardingComplete,
  }) {
    return UserPreferences(
      preferredCategories: preferredCategories ?? this.preferredCategories,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      maxDistance: maxDistance ?? this.maxDistance,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferred_categories': preferredCategories.map((c) => c.index).toList(),
      'min_budget': minBudget,
      'max_budget': maxBudget,
      'max_distance': maxDistance,
      'is_onboarding_complete': isOnboardingComplete,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    // Handle legacy format migration
    if (json.containsKey('desired_services')) {
      return migrateLegacy(json);
    }
    
    final categoryIndices = List<int>.from(json['preferred_categories'] ?? []);
    final categories = categoryIndices.map((index) {
      if (index >= 0 && index < ServiceCategory.values.length) {
        return ServiceCategory.values[index];
      }
      return null;
    }).whereType<ServiceCategory>().toList();
    
    return UserPreferences(
      preferredCategories: categories,
      minBudget: (json['min_budget'] ?? 20.0).toDouble(),
      maxBudget: (json['max_budget'] ?? 600.0).toDouble(),
      maxDistance: (json['max_distance'] ?? 25.0).toDouble(),
      isOnboardingComplete: json['is_onboarding_complete'] ?? false,
    );
  }

  /// Migration helper for legacy string-based category lists
  static UserPreferences migrateLegacy(Map<String, dynamic> oldJson) {
    final legacyServices = List<String>.from(oldJson['desired_services'] ?? []);
    final categories = <ServiceCategory>[];
    
    // Map legacy service names to new categories
    for (final service in legacyServices) {
      final category = _mapLegacyServiceToCategory(service);
      if (category != null && !categories.contains(category)) {
        categories.add(category);
      }
    }
    
    return UserPreferences(
      preferredCategories: categories,
      minBudget: (oldJson['min_budget'] ?? 20.0).toDouble(),
      maxBudget: (oldJson['max_budget'] ?? 600.0).toDouble(),
      maxDistance: (oldJson['max_distance'] ?? 25.0).toDouble(),
      isOnboardingComplete: oldJson['is_onboarding_complete'] ?? false,
    );
  }

  /// Maps legacy service names to new ServiceCategory enum
  static ServiceCategory? _mapLegacyServiceToCategory(String legacyService) {
    final normalized = legacyService.toLowerCase().trim();
    
    if (normalized.contains('braid')) return ServiceCategory.braids;
    if (normalized.contains('loc')) return ServiceCategory.locs;
    if (normalized.contains('barber') || normalized.contains('cut')) return ServiceCategory.barber;
    if (normalized.contains('wig')) return ServiceCategory.wigs;
    if (normalized.contains('nail')) return ServiceCategory.nails;
    if (normalized.contains('lash') || normalized.contains('eyelash')) return ServiceCategory.lashes;
    
    return null; // Unmappable legacy services are dropped
  }

  @override
  String toString() {
    return 'UserPreferences(categories: $preferredCategories, budget: \$${minBudget.toInt()}-\$${maxBudget.toInt()}, distance: ${maxDistance}km, complete: $isOnboardingComplete)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.preferredCategories == preferredCategories &&
        other.minBudget == minBudget &&
        other.maxBudget == maxBudget &&
        other.maxDistance == maxDistance &&
        other.isOnboardingComplete == isOnboardingComplete;
  }

  @override
  int get hashCode {
    return Object.hash(
      preferredCategories,
      minBudget,
      maxBudget,
      maxDistance,
      isOnboardingComplete,
    );
  }
}

/// Available service categories for selection
enum ServiceCategory {
  braids,   // 🌀 Braids
  locs,     // 🔒 Locs
  barber,   // ✂️ Barber
  wigs,     // 👩🏾‍🦱 Wigs
  nails,    // 💅🏽 Nails
  lashes,   // 👁️ Lashes
}

extension ServiceCategoryX on ServiceCategory {
  String get label => switch (this) {
    ServiceCategory.braids => 'Braids',
    ServiceCategory.locs   => 'Locs',
    ServiceCategory.barber => 'Barber',
    ServiceCategory.wigs   => 'Wigs',
    ServiceCategory.nails  => 'Nails',
    ServiceCategory.lashes => 'Lashes',
  };
  
  String get emoji => switch (this) {
    ServiceCategory.braids => '🌀',
    ServiceCategory.locs   => '🔒',
    ServiceCategory.barber => '✂️',
    ServiceCategory.wigs   => '�🏾‍🦱',
    ServiceCategory.nails  => '💅🏽',
    ServiceCategory.lashes => '�️',
  };
  
  String get displayName => '$emoji $label';
}

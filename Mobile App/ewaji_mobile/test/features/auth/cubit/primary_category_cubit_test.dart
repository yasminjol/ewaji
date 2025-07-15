import 'package:flutter_test/flutter_test.dart';
import 'package:ewaji_mobile/features/auth/models/primary_category.dart';

/// Simple test class that mimics the cubit logic without hydration
class TestPrimaryCategorySelector {
  final Set<PrimaryCategory> _selectedCategories = <PrimaryCategory>{};
  static const int maxCategories = 2;

  Set<PrimaryCategory> get selectedCategories => Set.from(_selectedCategories);

  void toggleCategory(PrimaryCategory category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      if (_selectedCategories.length < maxCategories) {
        _selectedCategories.add(category);
      }
    }
  }

  void clearAll() {
    _selectedCategories.clear();
  }

  bool isSelected(PrimaryCategory category) {
    return _selectedCategories.contains(category);
  }

  bool isAtMaxCapacity() {
    return _selectedCategories.length >= maxCategories;
  }

  bool canContinue() {
    return _selectedCategories.isNotEmpty;
  }

  List<PrimaryCategory> getSelectedCategories() {
    return _selectedCategories.toList();
  }
}

void main() {
  group('PrimaryCategorySelector Logic', () {
    late TestPrimaryCategorySelector selector;

    setUp(() {
      selector = TestPrimaryCategorySelector();
    });

    test('initial state is empty', () {
      expect(selector.selectedCategories, isEmpty);
      expect(selector.canContinue(), false);
      expect(selector.isAtMaxCapacity(), false);
    });

    test('can select first category', () {
      selector.toggleCategory(PrimaryCategory.braids);
      
      expect(selector.selectedCategories, contains(PrimaryCategory.braids));
      expect(selector.selectedCategories.length, 1);
      expect(selector.canContinue(), true);
      expect(selector.isAtMaxCapacity(), false);
    });

    test('can select second category', () {
      selector.toggleCategory(PrimaryCategory.braids);
      selector.toggleCategory(PrimaryCategory.nails);
      
      expect(selector.selectedCategories, containsAll([PrimaryCategory.braids, PrimaryCategory.nails]));
      expect(selector.selectedCategories.length, 2);
      expect(selector.canContinue(), true);
      expect(selector.isAtMaxCapacity(), true);
    });

    test('cannot select third category (cap logic)', () {
      // Select first two categories
      selector.toggleCategory(PrimaryCategory.braids);
      selector.toggleCategory(PrimaryCategory.nails);
      
      expect(selector.selectedCategories.length, 2);
      expect(selector.isAtMaxCapacity(), true);
      
      // Try to select third category - should be ignored
      selector.toggleCategory(PrimaryCategory.locs);
      
      expect(selector.selectedCategories.length, 2);
      expect(selector.selectedCategories, containsAll([PrimaryCategory.braids, PrimaryCategory.nails]));
      expect(selector.selectedCategories, isNot(contains(PrimaryCategory.locs)));
    });

    test('can deselect category', () {
      selector.toggleCategory(PrimaryCategory.braids);
      selector.toggleCategory(PrimaryCategory.nails);
      
      expect(selector.selectedCategories.length, 2);
      
      // Deselect one category
      selector.toggleCategory(PrimaryCategory.braids);
      
      expect(selector.selectedCategories.length, 1);
      expect(selector.selectedCategories, contains(PrimaryCategory.nails));
      expect(selector.selectedCategories, isNot(contains(PrimaryCategory.braids)));
      expect(selector.isAtMaxCapacity(), false);
    });

    test('can select third category after deselecting one', () {
      // Select two categories
      selector.toggleCategory(PrimaryCategory.braids);
      selector.toggleCategory(PrimaryCategory.nails);
      
      // Try to select third - should be ignored
      selector.toggleCategory(PrimaryCategory.locs);
      expect(selector.selectedCategories.length, 2);
      expect(selector.selectedCategories, isNot(contains(PrimaryCategory.locs)));
      
      // Deselect one
      selector.toggleCategory(PrimaryCategory.braids);
      expect(selector.selectedCategories.length, 1);
      
      // Now can select the third
      selector.toggleCategory(PrimaryCategory.locs);
      expect(selector.selectedCategories.length, 2);
      expect(selector.selectedCategories, containsAll([PrimaryCategory.nails, PrimaryCategory.locs]));
    });

    test('clearAll removes all categories', () {
      selector.toggleCategory(PrimaryCategory.braids);
      selector.toggleCategory(PrimaryCategory.nails);
      
      expect(selector.selectedCategories.length, 2);
      
      selector.clearAll();
      
      expect(selector.selectedCategories, isEmpty);
      expect(selector.canContinue(), false);
      expect(selector.isAtMaxCapacity(), false);
    });

    test('isSelected returns correct value', () {
      expect(selector.isSelected(PrimaryCategory.braids), false);
      
      selector.toggleCategory(PrimaryCategory.braids);
      
      expect(selector.isSelected(PrimaryCategory.braids), true);
      expect(selector.isSelected(PrimaryCategory.nails), false);
    });

    test('getSelectedCategories returns correct list', () {
      selector.toggleCategory(PrimaryCategory.braids);
      selector.toggleCategory(PrimaryCategory.nails);
      
      final selected = selector.getSelectedCategories();
      
      expect(selected.length, 2);
      expect(selected, containsAll([PrimaryCategory.braids, PrimaryCategory.nails]));
    });

    test('canContinue returns true only when at least one category selected', () {
      expect(selector.canContinue(), false);
      
      selector.toggleCategory(PrimaryCategory.braids);
      expect(selector.canContinue(), true);
      
      selector.toggleCategory(PrimaryCategory.nails);
      expect(selector.canContinue(), true);
      
      selector.clearAll();
      expect(selector.canContinue(), false);
    });
  });

  group('PrimaryCategory Extensions', () {
    test('emoji returns correct emoji for each category', () {
      expect(PrimaryCategory.braids.emoji, '🌀');
      expect(PrimaryCategory.locs.emoji, '🔒');
      expect(PrimaryCategory.barber.emoji, '✂️');
      expect(PrimaryCategory.wigs.emoji, '👩🏾‍🦱');
      expect(PrimaryCategory.nails.emoji, '💅🏽');
      expect(PrimaryCategory.lashes.emoji, '👁️');
    });

    test('label returns correct label for each category', () {
      expect(PrimaryCategory.braids.label, 'Braids');
      expect(PrimaryCategory.locs.label, 'Locs');
      expect(PrimaryCategory.barber.label, 'Barber');
      expect(PrimaryCategory.wigs.label, 'Wigs');
      expect(PrimaryCategory.nails.label, 'Nails');
      expect(PrimaryCategory.lashes.label, 'Lashes');
    });

    test('displayName combines emoji and label', () {
      expect(PrimaryCategory.braids.displayName, '🌀 Braids');
      expect(PrimaryCategory.nails.displayName, '💅🏽 Nails');
    });
  });

  group('Service Tree', () {
    test('service tree contains all primary categories', () {
      for (final category in PrimaryCategory.values) {
        expect(kServiceTree.containsKey(category), true,
            reason: 'Service tree missing category: $category');
      }
    });

    test('service tree has expected structure', () {
      // Test a few key categories
      expect(kServiceTree[PrimaryCategory.braids]!.keys, 
          containsAll(['Twists', 'Boho Braids', 'Scalp Braids', 'Individual Braids']));
      
      expect(kServiceTree[PrimaryCategory.nails]!.keys,
          containsAll(['Acrylic Services', 'Gel Services', 'Natural Nail Care', 'Add-ons & Art']));
      
      // Test sub-services exist
      expect(kServiceTree[PrimaryCategory.braids]!['Twists'],
          containsAll(['Passion Twists', 'Senegalese Twists']));
    });

    test('service tree depth is ≤ 3', () {
      // Primary category (depth 1) → Sub-category (depth 2) → Sub-sub-category (depth 3)
      for (final category in kServiceTree.keys) {
        for (final subCategory in kServiceTree[category]!.keys) {
          final subServices = kServiceTree[category]![subCategory]!;
          expect(subServices, isA<List<String>>(),
              reason: 'Service tree depth exceeded for $category → $subCategory');
        }
      }
    });
  });
}

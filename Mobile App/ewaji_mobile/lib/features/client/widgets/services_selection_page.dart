import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/personalisation_cubit.dart';
import '../cubit/personalisation_state.dart';
import '../cubit/personalisation_event.dart';
import '../models/user_preferences.dart';

/// Step 1: Services Selection Page
class ServicesSelectionPage extends StatelessWidget {
  const ServicesSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalisationCubit, PersonalisationState>(
      builder: (context, state) {
        final preferences = context.read<PersonalisationCubit>().currentPreferences;
        final selectedCategories = preferences?.preferredCategories ?? [];

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What services are you interested in?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose up to ${PersonalisationCubit.maxServices} services you\'d like to book. You can always update this later.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              // Selection counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5E50A1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF5E50A1).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF5E50A1),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Selected: ${selectedCategories.length}/${PersonalisationCubit.maxServices}',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF5E50A1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Services grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: ServiceCategory.values.length,
                  itemBuilder: (context, index) {
                    final category = ServiceCategory.values[index];
                    final isSelected = selectedCategories.contains(category);
                    final isEnabled = isSelected || selectedCategories.length < PersonalisationCubit.maxServices;
                    
                    return ServiceChip(
                      category: category,
                      isSelected: isSelected,
                      isEnabled: isEnabled,
                      onTap: isEnabled ? () => _toggleCategory(context, category, selectedCategories) : null,
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Skip hint
              const Center(
                child: Text(
                  'Or skip this step to see all services',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleCategory(BuildContext context, ServiceCategory category, List<ServiceCategory> currentCategories) {
    final updatedCategories = List<ServiceCategory>.from(currentCategories);
    
    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      if (updatedCategories.length < PersonalisationCubit.maxServices) {
        updatedCategories.add(category);
      }
    }
    
    context.read<PersonalisationCubit>().add(UpdatePreferredCategories(updatedCategories));
  }
}

/// Individual service chip widget
class ServiceChip extends StatelessWidget {
  final ServiceCategory category;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  const ServiceChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF5E50A1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF5E50A1)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category.emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF5E50A1),
                    size: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

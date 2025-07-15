import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/primary_category_cubit.dart';
import '../models/primary_category.dart';

/// Widget for selecting primary service categories
class PrimaryCategorySelector extends StatelessWidget {
  final VoidCallback? onContinue;
  final String? title;
  final String? subtitle;

  const PrimaryCategorySelector({
    super.key,
    this.onContinue,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrimaryCategoryCubit, Set<PrimaryCategory>>(
      builder: (context, selectedCategories) {
        final cubit = context.read<PrimaryCategoryCubit>();
        final isAtMaxCapacity = cubit.isAtMaxCapacity();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E50A1),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Selection info
            Container(
              padding: const EdgeInsets.all(16),
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
                      'Select 1-2 primary categories. You can add a 3rd category later with an upgrade.',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF5E50A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Selection counter
            Text(
              'Selected: ${selectedCategories.length}/${PrimaryCategoryCubit.maxCategories}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: selectedCategories.isEmpty 
                    ? Colors.grey[600]
                    : const Color(0xFF5E50A1),
              ),
            ),
            
            const SizedBox(height: 16),

            // Category chips
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: PrimaryCategory.values.map((category) {
                final isSelected = cubit.isSelected(category);
                final isEnabled = isSelected || !isAtMaxCapacity;
                
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // Two columns with spacing
                  child: CategoryChip(
                    category: category,
                    isSelected: isSelected,
                    isEnabled: isEnabled,
                    onTap: isEnabled 
                        ? () => cubit.toggleCategory(category)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: cubit.canContinue() ? onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E50A1),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Individual category chip widget
class CategoryChip extends StatelessWidget {
  final PrimaryCategory category;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  const CategoryChip({
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF5E50A1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF5E50A1)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.3,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF5E50A1),
                    size: 16,
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

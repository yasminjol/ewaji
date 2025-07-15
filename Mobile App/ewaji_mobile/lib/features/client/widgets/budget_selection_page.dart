import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/personalisation_cubit.dart';
import '../cubit/personalisation_state.dart';
import '../cubit/personalisation_event.dart';

/// Step 2: Budget Selection Page
class BudgetSelectionPage extends StatefulWidget {
  const BudgetSelectionPage({super.key});

  @override
  State<BudgetSelectionPage> createState() => _BudgetSelectionPageState();
}

class _BudgetSelectionPageState extends State<BudgetSelectionPage> {
  static const double minBudget = 0;
  static const double maxBudget = 500;
  
  late RangeValues _currentRange;
  
  @override
  void initState() {
    super.initState();
    final preferences = context.read<PersonalisationCubit>().currentPreferences;
    _currentRange = RangeValues(
      preferences?.minBudget ?? 50,
      preferences?.maxBudget ?? 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalisationCubit, PersonalisationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What\'s your budget range?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Set your preferred price range to see services that fit your budget.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              
              // Budget display
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E50A1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _formatBudgetRange(_currentRange),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E50A1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'per service',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Range slider
              Column(
                children: [
                  RangeSlider(
                    values: _currentRange,
                    min: minBudget,
                    max: maxBudget,
                    divisions: 50,
                    activeColor: const Color(0xFF5E50A1),
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRange = values;
                      });
                      
                      context.read<PersonalisationCubit>().add(
                        UpdateBudgetRange(
                          minBudget: values.start,
                          maxBudget: values.end,
                        ),
                      );
                    },
                  ),
                  
                  // Min/Max labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${minBudget.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '\$${maxBudget.toInt()}+',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Preset budget options
              const Text(
                'Popular ranges:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildPresetChip('Budget-friendly', 25, 75),
                  _buildPresetChip('Mid-range', 75, 150),
                  _buildPresetChip('Premium', 150, 300),
                  _buildPresetChip('Luxury', 300, 500),
                ],
              ),
              
              const Spacer(),
              
              // Info text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'You can always filter by price when browsing services.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPresetChip(String label, double min, double max) {
    final isSelected = _currentRange.start == min && _currentRange.end == max;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRange = RangeValues(min, max);
        });
        
        context.read<PersonalisationCubit>().add(
          UpdateBudgetRange(minBudget: min, maxBudget: max),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5E50A1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF5E50A1) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          '$label (\$${min.toInt()}-\$${max.toInt()})',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  String _formatBudgetRange(RangeValues range) {
    final start = range.start.toInt();
    final end = range.end.toInt();
    
    if (start == 0 && end >= maxBudget) {
      return 'Any budget';
    } else if (start == 0) {
      return 'Up to \$$end';
    } else if (end >= maxBudget) {
      return '\$$start+';
    } else {
      return '\$$start - \$$end';
    }
  }
}

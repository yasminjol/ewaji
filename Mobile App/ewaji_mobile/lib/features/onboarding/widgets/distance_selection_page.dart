import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/personalisation_cubit.dart';
import '../cubit/personalisation_state.dart';
import '../cubit/personalisation_event.dart';

/// Step 3: Distance Selection Page
class DistanceSelectionPage extends StatefulWidget {
  const DistanceSelectionPage({super.key});

  @override
  State<DistanceSelectionPage> createState() => _DistanceSelectionPageState();
}

class _DistanceSelectionPageState extends State<DistanceSelectionPage> {
  static const double minDistance = 5;
  static const double maxDistance = 100;
  
  late double _currentDistance;
  
  @override
  void initState() {
    super.initState();
    final preferences = context.read<PersonalisationCubit>().currentPreferences;
    _currentDistance = preferences?.maxDistance ?? 25.0;
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
                'How far would you travel?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Set your maximum travel distance to find nearby service providers.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              
              // Distance display
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E50A1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_currentDistance.toInt()} km',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E50A1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'maximum distance',
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
              
              // Distance slider
              Column(
                children: [
                  Slider(
                    value: _currentDistance,
                    min: minDistance,
                    max: maxDistance,
                    divisions: 19, // 5km increments
                    activeColor: const Color(0xFF5E50A1),
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (double value) {
                      setState(() {
                        _currentDistance = value;
                      });
                      
                      context.read<PersonalisationCubit>().add(
                        UpdateMaxDistance(value),
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
                          '${minDistance.toInt()} km',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${maxDistance.toInt()} km',
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
              
              // Preset distance options
              const Text(
                'Quick options:',
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
                  _buildPresetChip('Nearby', 10, Icons.location_on),
                  _buildPresetChip('Local area', 25, Icons.location_city),
                  _buildPresetChip('Extended area', 50, Icons.map),
                  _buildPresetChip('Anywhere', 100, Icons.public),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Distance comparison
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Travel time estimate:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getTimeEstimate(_currentDistance),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Location permission info
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
                      Icons.my_location,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'We\'ll use your location to show nearby providers and accurate distances.',
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

  Widget _buildPresetChip(String label, double distance, IconData icon) {
    final isSelected = _currentDistance == distance;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentDistance = distance;
        });
        
        context.read<PersonalisationCubit>().add(
          UpdateMaxDistance(distance),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5E50A1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF5E50A1) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              '$label (${distance.toInt()} km)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeEstimate(double distance) {
    // Rough estimate: 30 km/h average speed in city
    final timeInHours = distance / 30;
    final timeInMinutes = (timeInHours * 60).round();
    
    if (timeInMinutes < 60) {
      return '$timeInMinutes minutes by car';
    } else {
      final hours = (timeInMinutes / 60).floor();
      final minutes = timeInMinutes % 60;
      if (minutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''} by car';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''} $minutes minutes by car';
      }
    }
  }
}

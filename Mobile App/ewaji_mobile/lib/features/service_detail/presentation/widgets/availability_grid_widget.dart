import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/service_detail.dart';
import '../../bloc/service_detail_bloc.dart';
import '../../bloc/service_detail_event.dart';

class AvailabilityGridWidget extends StatelessWidget {
  const AvailabilityGridWidget({
    super.key,
    required this.providerId,
    required this.timeSlots,
    required this.onSlotSelected,
  });

  final String providerId;
  final List<TimeSlot> timeSlots;
  final Function(TimeSlot) onSlotSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Available Times',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<ServiceDetailBloc>().add(
                          RefreshAvailabilityRequested(providerId),
                        );
                  },
                  icon: const Icon(Icons.refresh),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (timeSlots.isEmpty) ...[
              _buildEmptyState(),
            ] else ...[
              _buildAvailabilityGrid(),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 120,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'No available times',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Check back later or contact the provider',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityGrid() {
    // Group slots by date
    final groupedSlots = _groupSlotsByDate();
    
    return Column(
      children: groupedSlots.entries.map((entry) {
        final date = entry.key;
        final slots = entry.value;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) => _TimeSlotChip(
                slot: slot,
                onTap: () => onSlotSelected(slot),
              )).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LegendItem(
          color: Colors.green,
          label: 'Available',
          icon: Icons.circle,
        ),
        _LegendItem(
          color: Colors.orange,
          label: 'Limited',
          icon: Icons.circle,
        ),
        _LegendItem(
          color: Colors.grey,
          label: 'Unavailable',
          icon: Icons.circle,
        ),
      ],
    );
  }

  Map<DateTime, List<TimeSlot>> _groupSlotsByDate() {
    final Map<DateTime, List<TimeSlot>> grouped = {};
    
    for (final slot in timeSlots) {
      final date = DateTime(
        slot.startTime.year,
        slot.startTime.month,
        slot.startTime.day,
      );
      
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(slot);
    }
    
    // Sort slots within each day
    for (final slots in grouped.values) {
      slots.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date == today) {
      return 'Today';
    } else if (date == tomorrow) {
      return 'Tomorrow';
    } else {
      final weekday = _getWeekdayName(date.weekday);
      final month = _getMonthName(date.month);
      return '$weekday, $month ${date.day}';
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.slot,
    required this.onTap,
  });

  final TimeSlot slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    switch (slot.status) {
      case TimeSlotStatus.available:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade700;
        borderColor = Colors.green.shade300;
        break;
      case TimeSlotStatus.limited:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange.shade700;
        borderColor = Colors.orange.shade300;
        break;
      case TimeSlotStatus.unavailable:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey.shade600;
        borderColor = Colors.grey.shade300;
        break;
    }

    return GestureDetector(
      onTap: slot.status != TimeSlotStatus.unavailable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(slot.startTime),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (slot.status == TimeSlotStatus.limited) ...[
              const SizedBox(height: 2),
              Text(
                '${slot.availableSpots} left',
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

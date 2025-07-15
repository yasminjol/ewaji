import 'package:flutter/material.dart';
import '../../models/service_detail.dart';

class PreparationChecklistWidget extends StatelessWidget {
  const PreparationChecklistWidget({
    super.key,
    required this.checklistItems,
  });

  final List<ChecklistItem> checklistItems;

  @override
  Widget build(BuildContext context) {
    if (checklistItems.isEmpty) {
      return const SizedBox.shrink();
    }

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
                  Icons.checklist_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preparation Checklist',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...checklistItems.map((item) => _ChecklistItemTile(item: item)),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItemTile extends StatelessWidget {
  const _ChecklistItemTile({
    required this.item,
  });

  final ChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(),
              color: _getIconColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
                if (item.estimatedTime != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 12,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(item.estimatedTime!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
                if (item.isOptional) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Optional',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Required',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: item.isOptional ? Colors.blue : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData() {
    // Convert iconName string to actual IconData
    // This is a simple mapping, you could extend this or use a more sophisticated approach
    switch (item.iconName.toLowerCase()) {
      case 'location_on':
      case 'location':
        return Icons.location_on_outlined;
      case 'build':
      case 'tools':
      case 'equipment':
        return Icons.build_outlined;
      case 'schedule':
      case 'time':
      case 'clock':
        return Icons.schedule_outlined;
      case 'description':
      case 'document':
      case 'docs':
        return Icons.description_outlined;
      case 'camera':
        return Icons.camera_alt_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'person':
      case 'people':
        return Icons.person_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'car':
        return Icons.directions_car_outlined;
      case 'clean':
      case 'cleaning':
        return Icons.cleaning_services_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  Color _getIconColor() {
    // Color based on icon type
    switch (item.iconName.toLowerCase()) {
      case 'location_on':
      case 'location':
      case 'home':
        return Colors.blue;
      case 'build':
      case 'tools':
      case 'equipment':
        return Colors.green;
      case 'schedule':
      case 'time':
      case 'clock':
        return Colors.orange;
      case 'description':
      case 'document':
      case 'docs':
        return Colors.purple;
      case 'camera':
        return Colors.teal;
      case 'phone':
        return Colors.indigo;
      case 'person':
      case 'people':
        return Colors.pink;
      case 'car':
        return Colors.red;
      case 'clean':
      case 'cleaning':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

import 'package:flutter/material.dart';
import '../models/review_model.dart';

class TagSelectionWidget extends StatelessWidget {
  final List<String> selectedTags;
  final Function(String) onTagToggle;

  const TagSelectionWidget({
    super.key,
    required this.selectedTags,
    required this.onTagToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ReviewTags.allTags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        final displayName = ReviewTags.getDisplayName(tag);
        
        return FilterChip(
          label: Text(
            displayName,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF5E50A1),
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) => onTagToggle(tag),
          backgroundColor: Colors.grey[100],
          selectedColor: const Color(0xFF5E50A1),
          checkmarkColor: Colors.white,
          elevation: 0,
          pressElevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? const Color(0xFF5E50A1) : Colors.grey[300]!,
              width: 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DisplayTagsWidget extends StatelessWidget {
  final List<String> tags;
  final int maxTags;
  final double fontSize;

  const DisplayTagsWidget({
    super.key,
    required this.tags,
    this.maxTags = 5,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final displayTags = tags.take(maxTags).toList();
    final remainingCount = tags.length - maxTags;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        ...displayTags.map((tag) {
          final displayName = ReviewTags.getDisplayName(tag);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF5E50A1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF5E50A1).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              displayName,
              style: TextStyle(
                color: const Color(0xFF5E50A1),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              '+$remainingCount',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

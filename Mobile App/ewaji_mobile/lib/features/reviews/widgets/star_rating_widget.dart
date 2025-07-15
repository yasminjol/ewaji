import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final double size;
  final Function(int) onRatingChanged;
  final bool enabled;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = 32,
    required this.onRatingChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isSelected = starNumber <= rating;
        
        return GestureDetector(
          onTap: enabled ? () => onRatingChanged(starNumber) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              isSelected ? Icons.star : Icons.star_border,
              size: size,
              color: isSelected ? Colors.amber : Colors.grey[400],
            ),
          ),
        );
      }),
    );
  }
}

class DisplayStarRating extends StatelessWidget {
  final double rating;
  final double size;
  final int maxStars;
  final Color? activeColor;
  final Color? inactiveColor;

  const DisplayStarRating({
    super.key,
    required this.rating,
    this.size = 16,
    this.maxStars = 5,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starNumber = index + 1;
        final isFullStar = starNumber <= rating.floor();
        final isHalfStar = starNumber == rating.ceil() && rating % 1 != 0;
        
        return Icon(
          isFullStar 
              ? Icons.star 
              : isHalfStar 
                  ? Icons.star_half 
                  : Icons.star_border,
          size: size,
          color: (isFullStar || isHalfStar) 
              ? (activeColor ?? Colors.amber) 
              : (inactiveColor ?? Colors.grey[400]),
        );
      }),
    );
  }
}

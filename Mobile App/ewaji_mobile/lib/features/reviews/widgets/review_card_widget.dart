import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../widgets/star_rating_widget.dart';
import '../widgets/tag_selection_widget.dart';
import '../widgets/image_gallery_widget.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final bool showProviderInfo;
  final bool showClientInfo;

  const ReviewCard({
    super.key,
    required this.review,
    this.showProviderInfo = false,
    this.showClientInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info and rating
            _buildHeader(),
            const SizedBox(height: 12),

            // Rating and tags
            _buildRatingAndTags(),
            
            // Comment
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildComment(),
            ],

            // Images
            if (review.beforeImages.isNotEmpty || review.afterImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildImages(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // User avatar placeholder
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF5E50A1).withOpacity(0.1),
          child: const Icon(
            Icons.person,
            color: Color(0xFF5E50A1),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                showClientInfo ? 'Client Review' : 'Your Review',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                _formatDate(review.createdAt),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Face blur indicator
        if (review.faceBlurEnabled && 
            (review.beforeImages.isNotEmpty || review.afterImages.isNotEmpty))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.blur_on,
                  size: 14,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 4),
                Text(
                  'Face Blur',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRatingAndTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating
        Row(
          children: [
            DisplayStarRating(
              rating: review.rating.toDouble(),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              '${review.rating}/5',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        
        // Tags
        if (review.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          DisplayTagsWidget(tags: review.tags),
        ],
      ],
    );
  }

  Widget _buildComment() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        review.comment!,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Before images
        if (review.beforeImages.isNotEmpty) ...[
          const Text(
            'Before',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ReviewImageCarousel(
            imageUrls: review.beforeImages,
            height: 150,
          ),
          const SizedBox(height: 12),
        ],

        // After images
        if (review.afterImages.isNotEmpty) ...[
          const Text(
            'After',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ReviewImageCarousel(
            imageUrls: review.afterImages,
            height: 150,
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class ReviewSummaryCard extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  const ReviewSummaryCard({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                // Average rating display
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5E50A1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '/ 5',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      DisplayStarRating(
                        rating: averageRating,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalReviews review${totalReviews == 1 ? '' : 's'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rating distribution
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 5; i >= 1; i--)
                        _buildRatingBar(i, ratingDistribution[i] ?? 0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count) {
    final percentage = totalReviews > 0 ? count / totalReviews : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.star,
            size: 12,
            color: Colors.amber,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E50A1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

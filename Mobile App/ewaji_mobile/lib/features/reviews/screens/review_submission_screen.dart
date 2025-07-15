import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';
import '../widgets/star_rating_widget.dart';
import '../widgets/tag_selection_widget.dart';
import '../widgets/image_gallery_widget.dart';

class ReviewSubmissionScreen extends StatefulWidget {
  final String bookingId;
  final String clientId;
  final String providerId;
  final String providerName;
  final String serviceName;

  const ReviewSubmissionScreen({
    super.key,
    required this.bookingId,
    required this.clientId,
    required this.providerId,
    required this.providerName,
    required this.serviceName,
  });

  @override
  State<ReviewSubmissionScreen> createState() => _ReviewSubmissionScreenState();
}

class _ReviewSubmissionScreenState extends State<ReviewSubmissionScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviewForm(
      bookingId: widget.bookingId,
      clientId: widget.clientId,
      providerId: widget.providerId,
    ));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Write Review'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1C1C1E),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSubmitted) {
            _showSuccessDialog();
          } else if (state is ReviewSubmissionError) {
            _showErrorSnackBar(state.message);
          } else if (state is ReviewFormLoaded && state.errorMessage != null) {
            _showErrorSnackBar(state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state is ReviewFormLoaded) {
            return _buildReviewForm(state);
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildReviewForm(ReviewFormLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Info Card
          _buildServiceInfoCard(),
          const SizedBox(height: 24),

          // Rating Section
          _buildRatingSection(state),
          const SizedBox(height: 24),

          // Tags Section
          _buildTagsSection(state),
          const SizedBox(height: 24),

          // Comment Section
          _buildCommentSection(state),
          const SizedBox(height: 24),

          // Images Section
          _buildImagesSection(state),
          const SizedBox(height: 24),

          // Face Blur Toggle
          _buildFaceBlurToggle(state),
          const SizedBox(height: 32),

          // Submit Button
          _buildSubmitButton(state),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF5E50A1).withOpacity(0.1),
              child: Text(
                widget.providerName.isNotEmpty ? widget.providerName[0].toUpperCase() : 'P',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E50A1),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.providerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.serviceName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(ReviewFormLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: StarRatingWidget(
                rating: state.rating,
                size: 40,
                onRatingChanged: (rating) {
                  context.read<ReviewBloc>().add(UpdateRating(rating));
                },
              ),
            ),
            if (state.rating > 0) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  _getRatingText(state.rating),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection(ReviewFormLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What did you love most?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select all that apply',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TagSelectionWidget(
              selectedTags: state.selectedTags,
              onTagToggle: (tag) {
                context.read<ReviewBloc>().add(ToggleTag(tag));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection(ReviewFormLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us more (optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share details about your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(0xFF5E50A1)),
                ),
              ),
              onChanged: (value) {
                context.read<ReviewBloc>().add(UpdateComment(value));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection(ReviewFormLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Before & After Photos (optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Show off your amazing transformation! Max 3 photos each.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Before Images
            _buildImageSection(
              title: 'Before',
              images: state.beforeImages,
              canAdd: state.canAddBeforeImage,
              onAddPressed: () => _pickImage(isBeforeImage: true),
              onRemove: (index) {
                context.read<ReviewBloc>().add(RemoveBeforeImage(index));
              },
            ),
            const SizedBox(height: 16),

            // After Images
            _buildImageSection(
              title: 'After',
              images: state.afterImages,
              canAdd: state.canAddAfterImage,
              onAddPressed: () => _pickImage(isBeforeImage: false),
              onRemove: (index) {
                context.read<ReviewBloc>().add(RemoveAfterImage(index));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection({
    required String title,
    required List<String> images,
    required bool canAdd,
    required VoidCallback onAddPressed,
    required Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ImageGalleryWidget(
          images: images,
          canAdd: canAdd,
          onAddPressed: onAddPressed,
          onRemove: onRemove,
        ),
      ],
    );
  }

  Widget _buildFaceBlurToggle(ReviewFormLoaded state) {
    if (state.beforeImages.isEmpty && state.afterImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.blur_on,
              color: const Color(0xFF5E50A1),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blur faces in photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Automatically blur faces for privacy',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: state.faceBlurEnabled,
              onChanged: (value) {
                context.read<ReviewBloc>().add(ToggleFaceBlur(value));
              },
              activeColor: const Color(0xFF5E50A1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ReviewFormLoaded state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isValid && !state.isSubmitting
            ? () => context.read<ReviewBloc>().add(const SubmitReview())
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5E50A1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: state.isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _pickImage({required bool isBeforeImage}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        if (isBeforeImage) {
          context.read<ReviewBloc>().add(AddBeforeImage(image.path));
        } else {
          context.read<ReviewBloc>().add(AddAfterImage(image.path));
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Review Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for your feedback!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close review screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

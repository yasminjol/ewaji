import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';
import '../repository/review_repository.dart';
import '../screens/review_submission_screen.dart';

/// Example of how to integrate the Reviews & Ratings feature
/// This shows how to trigger the review flow after a booking is completed

class BookingCompletedScreen extends StatelessWidget {
  final String bookingId;
  final String clientId;
  final String providerId;
  final String providerName;
  final String serviceName;

  const BookingCompletedScreen({
    super.key,
    required this.bookingId,
    required this.clientId,
    required this.providerId,
    required this.providerName,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Completed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Service Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your $serviceName service with $providerName has been completed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            
            // Review Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _openReviewScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E50A1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Write a Review',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Skip Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
          ],
        ),
      ),
    );
  }

  void _openReviewScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(        create: (context) => ReviewBloc(
          reviewRepository: MockReviewRepository(),
        ),
          child: ReviewSubmissionScreen(
            bookingId: bookingId,
            clientId: clientId,
            providerId: providerId,
            providerName: providerName,
            serviceName: serviceName,
          ),
        ),
      ),
    );
  }
}

/// Example of how to show reviews for a provider
class ProviderReviewsScreen extends StatelessWidget {
  final String providerId;
  final String providerName;

  const ProviderReviewsScreen({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(
        reviewRepository: MockReviewRepository(),
      )..add(LoadProviderReviews(providerId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$providerName Reviews'),
        ),
        body: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewsLoaded) {
              if (state.reviews.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.reviews.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final review = state.reviews[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text('${review.rating} stars'),
                      subtitle: Text(
                        review.comment ?? 'No comment',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '${review.createdAt.day}/${review.createdAt.month}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ReviewsLoadError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ReviewBloc>().add(LoadProviderReviews(providerId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

/// TODO: Add these features for complete M-FR-06 implementation:
/// 
/// 1. **Push Notification Integration**:
///    - Trigger review notification 24h after booking completion
///    - Use firebase_messaging and flutter_local_notifications
///    - Deep-link to review screen from notification
/// 
/// 2. **Supabase Database Schema**:
///    ```sql
///    CREATE TABLE reviews (
///      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
///      booking_id UUID REFERENCES bookings(id),
///      client_id UUID REFERENCES users(id),
///      provider_id UUID REFERENCES providers(id),
///      rating INTEGER CHECK (rating >= 1 AND rating <= 5),
///      tags TEXT[],
///      comment TEXT,
///      before_images TEXT[],
///      after_images TEXT[],
///      face_blur_enabled BOOLEAN DEFAULT false,
///      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
///      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
///    );
///    
///    CREATE OR REPLACE FUNCTION get_provider_average_rating(provider_id UUID)
///    RETURNS DECIMAL AS $$
///    BEGIN
///      RETURN (
///        SELECT AVG(rating)::DECIMAL(3,2)
///        FROM reviews
///        WHERE provider_id = $1
///      );
///    END;
///    $$ LANGUAGE plpgsql;
///    ```
/// 
/// 3. **Integration Points**:
///    - Add review button to booking completion screen
///    - Show average rating in provider profile
///    - Display reviews in provider detail screen
///    - Add review stats to provider dashboard

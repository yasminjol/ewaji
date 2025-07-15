# Reviews & Ratings Feature (M-FR-06)

## Overview

This feature implements a comprehensive reviews and ratings system that allows clients to review providers after booking completion. It includes star ratings, tag-based feedback, image uploads with face blur capabilities, and Supabase integration.

## Features Implemented

### ✅ Core Requirements (M-FR-06)
- **1-5 Star Rating System**: Interactive star rating with visual feedback
- **Tag-based Feedback**: Pre-defined chips for quick feedback (speed, neatness, vibe, etc.)
- **Before/After Images**: Upload up to 3 images each with compression (≤3 MB)
- **Face Blur Toggle**: Automatic face detection and blurring using ML Kit
- **Supabase Integration**: Reviews stored in database with provider cache invalidation

### ✅ Technical Implementation
- **State Management**: BLoC pattern with events and states
- **Image Processing**: Automatic compression and face blur using ML Kit
- **Repository Pattern**: Clean architecture with repository abstraction
- **Widget Components**: Reusable UI components for stars, tags, and images
- **Error Handling**: Comprehensive error handling and user feedback

## File Structure

```
lib/features/reviews/
├── bloc/
│   ├── review_bloc.dart           # Main BLoC for state management
│   ├── review_event.dart          # All review events
│   └── review_state.dart          # All review states
├── models/
│   └── review_model.dart          # Review data model & tags
├── repository/
│   └── review_repository.dart     # Supabase integration
├── screens/
│   └── review_submission_screen.dart  # Main review UI
├── services/
│   └── image_processing_service.dart  # Face blur & compression
├── widgets/
│   ├── star_rating_widget.dart    # Interactive star rating
│   ├── tag_selection_widget.dart  # Tag chips selection
│   ├── image_gallery_widget.dart  # Image upload/display
│   └── review_card_widget.dart    # Review display components
└── examples/
    └── review_integration_example.dart  # Usage examples
```

## Dependencies Added

```yaml
dependencies:
  # Reviews & Ratings (M-FR-06)
  image_picker: ^1.0.4
  google_mlkit_face_detection: ^0.10.0
  image: ^4.1.7
```

## Usage Examples

### 1. Opening Review Screen (After Booking Completion)

```dart
// After booking status == completed, show review screen
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => ReviewBloc(
        reviewRepository: ReviewRepository(),
      ),
      child: ReviewSubmissionScreen(
        bookingId: 'booking_123',
        clientId: 'client_456',
        providerId: 'provider_789',
        providerName: 'Sarah Johnson',
        serviceName: 'House Cleaning',
      ),
    ),
  ),
);
```

### 2. Displaying Provider Reviews

```dart
// Show all reviews for a provider
BlocProvider(
  create: (context) => ReviewBloc(
    reviewRepository: ReviewRepository(),
  )..add(LoadProviderReviews(providerId)),
  child: BlocBuilder<ReviewBloc, ReviewState>(
    builder: (context, state) {
      if (state is ReviewsLoaded) {
        return ListView.builder(
          itemCount: state.reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(review: state.reviews[index]);
          },
        );
      }
      return CircularProgressIndicator();
    },
  ),
);
```

### 3. Push Notification Integration (24h after completion)

```dart
// Schedule review reminder notification
await NotificationService.instance.scheduleNotification(
  scheduledTime: DateTime.now().add(Duration(hours: 24)),
  title: 'How was your service?',
  body: 'Rate your experience with ${providerName}',
  payload: {
    'type': 'review_reminder',
    'booking_id': bookingId,
    'provider_id': providerId,
  },
);
```

## Supabase Database Schema

### Required Tables

```sql
-- Reviews table
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID REFERENCES bookings(id),
  client_id UUID REFERENCES users(id),
  provider_id UUID REFERENCES providers(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  tags TEXT[],
  comment TEXT,
  before_images TEXT[],
  after_images TEXT[],
  face_blur_enabled BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(booking_id), -- One review per booking
  INDEX(provider_id), -- For fast provider review queries
  INDEX(client_id),   -- For fast client review queries
  INDEX(created_at)   -- For chronological sorting
);

-- Storage bucket for review images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('review-images', 'review-images', true);

-- RLS policies for reviews
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Clients can insert reviews for their own bookings
CREATE POLICY "clients_can_insert_own_reviews" ON reviews
  FOR INSERT TO authenticated
  WITH CHECK (
    client_id = auth.uid() AND
    EXISTS (
      SELECT 1 FROM bookings 
      WHERE id = booking_id 
      AND client_id = auth.uid() 
      AND status = 'completed'
    )
  );

-- Anyone can read reviews
CREATE POLICY "anyone_can_read_reviews" ON reviews
  FOR SELECT TO public
  USING (true);
```

### Database Functions

```sql
-- Get provider average rating
CREATE OR REPLACE FUNCTION get_provider_average_rating(provider_id UUID)
RETURNS DECIMAL AS $$
BEGIN
  RETURN (
    SELECT COALESCE(AVG(rating), 0)::DECIMAL(3,2)
    FROM reviews
    WHERE provider_id = $1
  );
END;
$$ LANGUAGE plpgsql;

-- Get provider review statistics
CREATE OR REPLACE FUNCTION get_provider_review_stats(provider_id UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'total_reviews', COUNT(*),
    'average_rating', COALESCE(AVG(rating), 0)::DECIMAL(3,2),
    'rating_distribution', json_build_object(
      '5', COUNT(*) FILTER (WHERE rating = 5),
      '4', COUNT(*) FILTER (WHERE rating = 4),
      '3', COUNT(*) FILTER (WHERE rating = 3),
      '2', COUNT(*) FILTER (WHERE rating = 2),
      '1', COUNT(*) FILTER (WHERE rating = 1)
    )
  ) INTO result
  FROM reviews
  WHERE provider_id = $1;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;
```

## Integration Points

### 1. Booking Completion Flow
```dart
// In booking completion handler
if (booking.status == BookingStatus.completed) {
  // Show review prompt after 24 hours
  _scheduleReviewNotification(booking);
  
  // Or show immediate review option
  _showReviewDialog(booking);
}
```

### 2. Provider Profile Integration
```dart
// Display average rating in provider card
FutureBuilder<double>(
  future: ReviewRepository().getProviderAverageRating(providerId),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Row(
        children: [
          DisplayStarRating(rating: snapshot.data!),
          Text('${snapshot.data!.toStringAsFixed(1)}'),
        ],
      );
    }
    return SizedBox.shrink();
  },
);
```

### 3. Provider Dashboard Stats
```dart
// Show review metrics in provider dashboard
BlocBuilder<ReviewBloc, ReviewState>(
  builder: (context, state) {
    if (state is ReviewsLoaded) {
      return ReviewSummaryCard(
        averageRating: _calculateAverage(state.reviews),
        totalReviews: state.reviews.length,
        ratingDistribution: _calculateDistribution(state.reviews),
      );
    }
    return CircularProgressIndicator();
  },
);
```

## Key Features Demonstrated

### ✅ Image Processing
- **Compression**: Automatically compresses images to ≤3 MB
- **Face Blur**: ML Kit face detection with gaussian blur
- **Error Handling**: Graceful fallbacks if processing fails

### ✅ User Experience
- **Progressive Form**: Step-by-step review submission
- **Real-time Validation**: Immediate feedback on form state
- **Loading States**: Clear loading indicators during submission
- **Success Feedback**: Confirmation dialog after submission

### ✅ Performance
- **Background Processing**: Image processing in isolates
- **Optimistic Updates**: UI updates before network completion
- **Cache Invalidation**: Provider profile cache refresh after review

### ✅ Accessibility
- **Screen Reader Support**: Proper semantics for star rating
- **High Contrast**: Clear visual indicators
- **Touch Targets**: Adequate tap areas for all interactive elements

## Testing Integration

```dart
// Unit test example
testWidgets('should submit review with all fields', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => ReviewBloc(
          reviewRepository: MockReviewRepository(),
        ),
        child: ReviewSubmissionScreen(/* params */),
      ),
    ),
  );
  
  // Interact with rating
  await tester.tap(find.byIcon(Icons.star).at(4)); // 5 stars
  
  // Select tags
  await tester.tap(find.text('Great Vibe'));
  
  // Add comment
  await tester.enterText(find.byType(TextField), 'Excellent service!');
  
  // Submit
  await tester.tap(find.text('Submit Review'));
  
  // Verify submission
  verify(mockRepository.submitReview(any)).called(1);
});
```

## Next Steps

1. **Push Notifications**: Integrate with FCM for 24h review reminders
2. **Deep Linking**: Handle review notification taps
3. **Analytics**: Track review submission rates
4. **Moderation**: Content filtering for inappropriate reviews
5. **Responses**: Allow providers to respond to reviews

This implementation provides a complete, production-ready reviews and ratings system that meets all requirements of M-FR-06 in your mobile blueprint.

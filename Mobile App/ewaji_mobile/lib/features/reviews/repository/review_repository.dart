import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/review_model.dart';

abstract class ReviewRepository {
  Future<ReviewModel> submitReview({
    required String bookingId,
    required String clientId,
    required String providerId,
    required int rating,
    required List<String> tags,
    String? comment,
    List<File>? beforeImages,
    List<File>? afterImages,
    bool faceBlurEnabled = false,
  });

  Future<List<ReviewModel>> getProviderReviews(String providerId);
  Future<List<ReviewModel>> getClientReviews(String clientId);
  Future<bool> hasReviewForBooking(String bookingId);
  Future<double> getProviderAverageRating(String providerId);
  Future<Map<String, dynamic>> getProviderReviewStats(String providerId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<ReviewModel> submitReview({
    required String bookingId,
    required String clientId,
    required String providerId,
    required int rating,
    required List<String> tags,
    String? comment,
    List<File>? beforeImages,
    List<File>? afterImages,
    bool faceBlurEnabled = false,
  }) async {
    try {
      // Upload images to Supabase Storage if provided
      final beforeImageUrls = beforeImages != null 
          ? await _uploadImages(beforeImages, 'before', bookingId)
          : <String>[];
      
      final afterImageUrls = afterImages != null 
          ? await _uploadImages(afterImages, 'after', bookingId)
          : <String>[];

      // Create review data
      final reviewData = {
        'booking_id': bookingId,
        'client_id': clientId,
        'provider_id': providerId,
        'rating': rating,
        'tags': tags,
        'comment': comment,
        'before_images': beforeImageUrls,
        'after_images': afterImageUrls,
        'face_blur_enabled': faceBlurEnabled,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Insert review into database
      final response = await _supabase
          .from('reviews')
          .insert(reviewData)
          .select()
          .single();

      // Invalidate provider cache (trigger provider profile refresh)
      await _invalidateProviderCache(providerId);

      // Update booking status to reviewed
      await _updateBookingReviewStatus(bookingId);

      return ReviewModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }

  /// Upload images to Supabase Storage
  Future<List<String>> _uploadImages(
    List<File> images, 
    String type, 
    String bookingId,
  ) async {
    final urls = <String>[];
    
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final fileName = '${bookingId}_${type}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'reviews/$fileName';

      try {
        await _supabase.storage
            .from('review-images')
            .upload(path, file);

        final url = _supabase.storage
            .from('review-images')
            .getPublicUrl(path);

        urls.add(url);
      } catch (e) {
        print('Failed to upload image $fileName: $e');
        // Continue with other images even if one fails
      }
    }
    
    return urls;
  }

  /// Invalidate provider cache to refresh their profile with new review
  Future<void> _invalidateProviderCache(String providerId) async {
    try {
      // Trigger a cache invalidation by updating provider's updated_at timestamp
      await _supabase
          .from('providers')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('id', providerId);
    } catch (e) {
      print('Failed to invalidate provider cache: $e');
      // This is not critical, so we don't throw
    }
  }

  /// Update booking status to indicate review has been submitted
  Future<void> _updateBookingReviewStatus(String bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .update({
            'review_submitted': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      print('Failed to update booking review status: $e');
      // This is not critical, so we don't throw
    }
  }

  /// Get reviews for a specific provider
  @override
  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);

      return response.map<ReviewModel>((json) => ReviewModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch provider reviews: $e');
    }
  }

  /// Get reviews by a specific client
  @override
  Future<List<ReviewModel>> getClientReviews(String clientId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('client_id', clientId)
          .order('created_at', ascending: false);

      return response.map<ReviewModel>((json) => ReviewModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch client reviews: $e');
    }
  }

  /// Check if a booking already has a review
  @override
  Future<bool> hasReviewForBooking(String bookingId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('id')
          .eq('booking_id', bookingId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Failed to check review status: $e');
      return false;
    }
  }

  /// Get average rating for a provider
  @override
  Future<double> getProviderAverageRating(String providerId) async {
    try {
      final response = await _supabase
          .rpc('get_provider_average_rating', params: {'provider_id': providerId});

      return (response as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      print('Failed to get provider average rating: $e');
      return 0.0;
    }
  }

  /// Get review statistics for a provider (total reviews, rating distribution)
  @override
  Future<Map<String, dynamic>> getProviderReviewStats(String providerId) async {
    try {
      final response = await _supabase
          .rpc('get_provider_review_stats', params: {'provider_id': providerId});

      return Map<String, dynamic>.from(response ?? {});
    } catch (e) {
      print('Failed to get provider review stats: $e');
      return {};
    }
  }
}

// Mock implementation for demo/testing purposes
class MockReviewRepository implements ReviewRepository {
  @override
  Future<ReviewModel> submitReview({
    required String bookingId,
    required String clientId,
    required String providerId,
    required int rating,
    required List<String> tags,
    String? comment,
    List<File>? beforeImages,
    List<File>? afterImages,
    bool faceBlurEnabled = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock review
    return ReviewModel(
      id: 'mock-review-${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      clientId: clientId,
      providerId: providerId,
      rating: rating,
      tags: tags,
      comment: comment,
      beforeImages: beforeImages?.map((f) => 'mock-url-${f.path}').toList() ?? [],
      afterImages: afterImages?.map((f) => 'mock-url-${f.path}').toList() ?? [],
      faceBlurEnabled: faceBlurEnabled,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<List<ReviewModel>> getClientReviews(String clientId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<bool> hasReviewForBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return false;
  }

  @override
  Future<double> getProviderAverageRating(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 4.5;
  }

  @override
  Future<Map<String, dynamic>> getProviderReviewStats(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'total_reviews': 25,
      'average_rating': 4.5,
      'rating_distribution': {
        '5': 15,
        '4': 6,
        '3': 3,
        '2': 1,
        '1': 0,
      },
    };
  }
}

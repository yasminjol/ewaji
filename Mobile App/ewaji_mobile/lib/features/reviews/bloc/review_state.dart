import 'package:equatable/equatable.dart';
import '../models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewFormLoaded extends ReviewState {
  final String bookingId;
  final String clientId;
  final String providerId;
  final int rating;
  final List<String> selectedTags;
  final String comment;
  final List<String> beforeImages;
  final List<String> afterImages;
  final bool faceBlurEnabled;
  final bool isSubmitting;
  final String? errorMessage;

  const ReviewFormLoaded({
    required this.bookingId,
    required this.clientId,
    required this.providerId,
    this.rating = 0,
    this.selectedTags = const [],
    this.comment = '',
    this.beforeImages = const [],
    this.afterImages = const [],
    this.faceBlurEnabled = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  ReviewFormLoaded copyWith({
    String? bookingId,
    String? clientId,
    String? providerId,
    int? rating,
    List<String>? selectedTags,
    String? comment,
    List<String>? beforeImages,
    List<String>? afterImages,
    bool? faceBlurEnabled,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return ReviewFormLoaded(
      bookingId: bookingId ?? this.bookingId,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
      rating: rating ?? this.rating,
      selectedTags: selectedTags ?? this.selectedTags,
      comment: comment ?? this.comment,
      beforeImages: beforeImages ?? this.beforeImages,
      afterImages: afterImages ?? this.afterImages,
      faceBlurEnabled: faceBlurEnabled ?? this.faceBlurEnabled,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  bool get isValid => rating > 0 && selectedTags.isNotEmpty;
  bool get canAddBeforeImage => beforeImages.length < 3;
  bool get canAddAfterImage => afterImages.length < 3;

  @override
  List<Object?> get props => [
        bookingId,
        clientId,
        providerId,
        rating,
        selectedTags,
        comment,
        beforeImages,
        afterImages,
        faceBlurEnabled,
        isSubmitting,
        errorMessage,
      ];
}

class ReviewSubmitted extends ReviewState {
  final ReviewModel review;

  const ReviewSubmitted(this.review);

  @override
  List<Object> get props => [review];
}

class ReviewSubmissionError extends ReviewState {
  final String message;

  const ReviewSubmissionError(this.message);

  @override
  List<Object> get props => [message];
}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  final bool isLoading;

  const ReviewsLoaded({
    required this.reviews,
    this.isLoading = false,
  });

  ReviewsLoaded copyWith({
    List<ReviewModel>? reviews,
    bool? isLoading,
  }) {
    return ReviewsLoaded(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [reviews, isLoading];
}

class ReviewsLoadError extends ReviewState {
  final String message;

  const ReviewsLoadError(this.message);

  @override
  List<Object> get props => [message];
}

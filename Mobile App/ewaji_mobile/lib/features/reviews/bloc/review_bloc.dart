import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/review_repository.dart';
import '../services/image_utils.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc({
    required ReviewRepository reviewRepository,
  })  : _reviewRepository = reviewRepository,
        super(ReviewInitial()) {
    on<LoadReviewForm>(_onLoadReviewForm);
    on<UpdateRating>(_onUpdateRating);
    on<ToggleTag>(_onToggleTag);
    on<UpdateComment>(_onUpdateComment);
    on<AddBeforeImage>(_onAddBeforeImage);
    on<AddAfterImage>(_onAddAfterImage);
    on<RemoveBeforeImage>(_onRemoveBeforeImage);
    on<RemoveAfterImage>(_onRemoveAfterImage);
    on<ToggleFaceBlur>(_onToggleFaceBlur);
    on<SubmitReview>(_onSubmitReview);
    on<LoadProviderReviews>(_onLoadProviderReviews);
    on<LoadClientReviews>(_onLoadClientReviews);
  }

  void _onLoadReviewForm(LoadReviewForm event, Emitter<ReviewState> emit) {
    emit(ReviewFormLoaded(
      bookingId: event.bookingId,
      clientId: event.clientId,
      providerId: event.providerId,
    ));
  }

  void _onUpdateRating(UpdateRating event, Emitter<ReviewState> emit) {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      emit(currentState.copyWith(rating: event.rating));
    }
  }

  void _onToggleTag(ToggleTag event, Emitter<ReviewState> emit) {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      final tags = List<String>.from(currentState.selectedTags);
      
      if (tags.contains(event.tag)) {
        tags.remove(event.tag);
      } else {
        tags.add(event.tag);
      }
      
      emit(currentState.copyWith(selectedTags: tags));
    }
  }

  void _onUpdateComment(UpdateComment event, Emitter<ReviewState> emit) {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      emit(currentState.copyWith(comment: event.comment));
    }
  }

  void _onAddBeforeImage(AddBeforeImage event, Emitter<ReviewState> emit) async {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      
      if (!currentState.canAddBeforeImage) return;

      try {
        // Compress the image first
        final imageFile = File(event.imagePath);
        final compressedFile = await ImageCompressionService.compressImage(imageFile);
        
        final images = List<String>.from(currentState.beforeImages);
        images.add(compressedFile.path);
        
        emit(currentState.copyWith(beforeImages: images));
      } catch (e) {
        emit(currentState.copyWith(
          errorMessage: 'Failed to process image: $e',
        ));
      }
    }
  }

  void _onAddAfterImage(AddAfterImage event, Emitter<ReviewState> emit) async {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      
      if (!currentState.canAddAfterImage) return;

      try {
        // Compress the image first
        final imageFile = File(event.imagePath);
        final compressedFile = await ImageCompressionService.compressImage(imageFile);
        
        final images = List<String>.from(currentState.afterImages);
        images.add(compressedFile.path);
        
        emit(currentState.copyWith(afterImages: images));
      } catch (e) {
        emit(currentState.copyWith(
          errorMessage: 'Failed to process image: $e',
        ));
      }
    }
  }

  void _onRemoveBeforeImage(RemoveBeforeImage event, Emitter<ReviewState> emit) {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      final images = List<String>.from(currentState.beforeImages);
      
      if (event.index >= 0 && event.index < images.length) {
        images.removeAt(event.index);
        emit(currentState.copyWith(beforeImages: images));
      }
    }
  }

  void _onRemoveAfterImage(RemoveAfterImage event, Emitter<ReviewState> emit) {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      final images = List<String>.from(currentState.afterImages);
      
      if (event.index >= 0 && event.index < images.length) {
        images.removeAt(event.index);
        emit(currentState.copyWith(afterImages: images));
      }
    }
  }

  void _onToggleFaceBlur(ToggleFaceBlur event, Emitter<ReviewState> emit) {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      emit(currentState.copyWith(faceBlurEnabled: event.enabled));
    }
  }

  void _onSubmitReview(SubmitReview event, Emitter<ReviewState> emit) async {
    if (state is ReviewFormLoaded) {
      final currentState = state as ReviewFormLoaded;
      
      if (!currentState.isValid) {
        emit(currentState.copyWith(
          errorMessage: 'Please provide a rating and select at least one tag',
        ));
        return;
      }

      emit(currentState.copyWith(isSubmitting: true, errorMessage: null));

      try {
        // Process images with face blur if enabled
        List<File>? beforeFiles;
        List<File>? afterFiles;

        if (currentState.beforeImages.isNotEmpty) {
          beforeFiles = [];
          for (final imagePath in currentState.beforeImages) {
            final file = File(imagePath);
            if (currentState.faceBlurEnabled) {
              final blurredFile = await FaceBlurService.blurFacesInImage(file);
              beforeFiles.add(blurredFile);
            } else {
              beforeFiles.add(file);
            }
          }
        }

        if (currentState.afterImages.isNotEmpty) {
          afterFiles = [];
          for (final imagePath in currentState.afterImages) {
            final file = File(imagePath);
            if (currentState.faceBlurEnabled) {
              final blurredFile = await FaceBlurService.blurFacesInImage(file);
              afterFiles.add(blurredFile);
            } else {
              afterFiles.add(file);
            }
          }
        }

        // Submit review
        final review = await _reviewRepository.submitReview(
          bookingId: currentState.bookingId,
          clientId: currentState.clientId,
          providerId: currentState.providerId,
          rating: currentState.rating,
          tags: currentState.selectedTags,
          comment: currentState.comment.isNotEmpty ? currentState.comment : null,
          beforeImages: beforeFiles,
          afterImages: afterFiles,
          faceBlurEnabled: currentState.faceBlurEnabled,
        );

        emit(ReviewSubmitted(review));
      } catch (e) {
        emit(currentState.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to submit review: $e',
        ));
      }
    }
  }

  void _onLoadProviderReviews(LoadProviderReviews event, Emitter<ReviewState> emit) async {
    emit(const ReviewsLoaded(reviews: [], isLoading: true));

    try {
      final reviews = await _reviewRepository.getProviderReviews(event.providerId);
      emit(ReviewsLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewsLoadError('Failed to load reviews: $e'));
    }
  }

  void _onLoadClientReviews(LoadClientReviews event, Emitter<ReviewState> emit) async {
    emit(const ReviewsLoaded(reviews: [], isLoading: true));

    try {
      final reviews = await _reviewRepository.getClientReviews(event.clientId);
      emit(ReviewsLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewsLoadError('Failed to load reviews: $e'));
    }
  }
}

import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviewForm extends ReviewEvent {
  final String bookingId;
  final String clientId;
  final String providerId;

  const LoadReviewForm({
    required this.bookingId,
    required this.clientId,
    required this.providerId,
  });

  @override
  List<Object> get props => [bookingId, clientId, providerId];
}

class UpdateRating extends ReviewEvent {
  final int rating;

  const UpdateRating(this.rating);

  @override
  List<Object> get props => [rating];
}

class ToggleTag extends ReviewEvent {
  final String tag;

  const ToggleTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class UpdateComment extends ReviewEvent {
  final String comment;

  const UpdateComment(this.comment);

  @override
  List<Object> get props => [comment];
}

class AddBeforeImage extends ReviewEvent {
  final String imagePath;

  const AddBeforeImage(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class AddAfterImage extends ReviewEvent {
  final String imagePath;

  const AddAfterImage(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class RemoveBeforeImage extends ReviewEvent {
  final int index;

  const RemoveBeforeImage(this.index);

  @override
  List<Object> get props => [index];
}

class RemoveAfterImage extends ReviewEvent {
  final int index;

  const RemoveAfterImage(this.index);

  @override
  List<Object> get props => [index];
}

class ToggleFaceBlur extends ReviewEvent {
  final bool enabled;

  const ToggleFaceBlur(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class SubmitReview extends ReviewEvent {
  const SubmitReview();
}

class LoadProviderReviews extends ReviewEvent {
  final String providerId;

  const LoadProviderReviews(this.providerId);

  @override
  List<Object> get props => [providerId];
}

class LoadClientReviews extends ReviewEvent {
  final String clientId;

  const LoadClientReviews(this.clientId);

  @override
  List<Object> get props => [clientId];
}

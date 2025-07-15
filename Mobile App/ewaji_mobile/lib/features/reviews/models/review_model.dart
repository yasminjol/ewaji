class ReviewModel {
  final String id;
  final String bookingId;
  final String clientId;
  final String providerId;
  final int rating; // 1-5 stars
  final List<String> tags; // speed, neatness, vibe, etc.
  final String? comment;
  final List<String> beforeImages;
  final List<String> afterImages;
  final bool faceBlurEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.clientId,
    required this.providerId,
    required this.rating,
    required this.tags,
    this.comment,
    required this.beforeImages,
    required this.afterImages,
    required this.faceBlurEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      bookingId: json['booking_id'],
      clientId: json['client_id'],
      providerId: json['provider_id'],
      rating: json['rating'],
      tags: List<String>.from(json['tags'] ?? []),
      comment: json['comment'],
      beforeImages: List<String>.from(json['before_images'] ?? []),
      afterImages: List<String>.from(json['after_images'] ?? []),
      faceBlurEnabled: json['face_blur_enabled'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'client_id': clientId,
      'provider_id': providerId,
      'rating': rating,
      'tags': tags,
      'comment': comment,
      'before_images': beforeImages,
      'after_images': afterImages,
      'face_blur_enabled': faceBlurEnabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    String? id,
    String? bookingId,
    String? clientId,
    String? providerId,
    int? rating,
    List<String>? tags,
    String? comment,
    List<String>? beforeImages,
    List<String>? afterImages,
    bool? faceBlurEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      comment: comment ?? this.comment,
      beforeImages: beforeImages ?? this.beforeImages,
      afterImages: afterImages ?? this.afterImages,
      faceBlurEnabled: faceBlurEnabled ?? this.faceBlurEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Available review tags
class ReviewTags {
  static const String speed = 'speed';
  static const String neatness = 'neatness';
  static const String vibe = 'vibe';
  static const String communication = 'communication';
  static const String punctuality = 'punctuality';
  static const String professionalism = 'professionalism';
  static const String valueForMoney = 'value_for_money';
  static const String creativity = 'creativity';
  static const String cleanliness = 'cleanliness';
  static const String followedInstructions = 'followed_instructions';

  static const List<String> allTags = [
    speed,
    neatness,
    vibe,
    communication,
    punctuality,
    professionalism,
    valueForMoney,
    creativity,
    cleanliness,
    followedInstructions,
  ];

  static String getDisplayName(String tag) {
    switch (tag) {
      case speed:
        return 'Quick & Efficient';
      case neatness:
        return 'Clean & Neat';
      case vibe:
        return 'Great Vibe';
      case communication:
        return 'Good Communication';
      case punctuality:
        return 'On Time';
      case professionalism:
        return 'Professional';
      case valueForMoney:
        return 'Great Value';
      case creativity:
        return 'Creative';
      case cleanliness:
        return 'Clean Setup';
      case followedInstructions:
        return 'Followed Instructions';
      default:
        return tag;
    }
  }
}

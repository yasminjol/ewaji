import 'package:equatable/equatable.dart';

class Provider extends Equatable {
  const Provider({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.businessName,
    required this.categories,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.priceRange,
    required this.isVerified,
    required this.isAvailable,
    this.badge,
    this.portfolioImages = const [],
    this.videoReels = const [],
    this.bio,
    this.nextAvailable,
  });

  final String id;
  final String name;
  final String profileImageUrl;
  final String businessName;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final double distance; // in kilometers
  final double latitude;
  final double longitude;
  final PriceRange priceRange;
  final bool isVerified;
  final bool isAvailable;
  final ProviderBadge? badge;
  final List<String> portfolioImages;
  final List<VideoReel> videoReels;
  final String? bio;
  final DateTime? nextAvailable;

  @override
  List<Object?> get props => [
        id,
        name,
        profileImageUrl,
        businessName,
        categories,
        rating,
        reviewCount,
        distance,
        latitude,
        longitude,
        priceRange,
        isVerified,
        isAvailable,
        badge,
        portfolioImages,
        videoReels,
        bio,
        nextAvailable,
      ];

  Provider copyWith({
    String? id,
    String? name,
    String? profileImageUrl,
    String? businessName,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    double? distance,
    double? latitude,
    double? longitude,
    PriceRange? priceRange,
    bool? isVerified,
    bool? isAvailable,
    ProviderBadge? badge,
    List<String>? portfolioImages,
    List<VideoReel>? videoReels,
    String? bio,
    DateTime? nextAvailable,
  }) {
    return Provider(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      businessName: businessName ?? this.businessName,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceRange: priceRange ?? this.priceRange,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      badge: badge ?? this.badge,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      videoReels: videoReels ?? this.videoReels,
      bio: bio ?? this.bio,
      nextAvailable: nextAvailable ?? this.nextAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'businessName': businessName,
      'categories': categories,
      'rating': rating,
      'reviewCount': reviewCount,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
      'priceRange': priceRange.name,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'badge': badge?.name,
      'portfolioImages': portfolioImages,
      'videoReels': videoReels.map((v) => v.toJson()).toList(),
      'bio': bio,
      'nextAvailable': nextAvailable?.toIso8601String(),
    };
  }

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      businessName: json['businessName'] as String,
      categories: List<String>.from(json['categories'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      priceRange: PriceRange.values.firstWhere(
        (e) => e.name == json['priceRange'],
        orElse: () => PriceRange.medium,
      ),
      isVerified: json['isVerified'] as bool,
      isAvailable: json['isAvailable'] as bool,
      badge: json['badge'] != null
          ? ProviderBadge.values.firstWhere((e) => e.name == json['badge'])
          : null,
      portfolioImages: List<String>.from(json['portfolioImages'] as List? ?? []),
      videoReels: (json['videoReels'] as List? ?? [])
          .map((v) => VideoReel.fromJson(v as Map<String, dynamic>))
          .toList(),
      bio: json['bio'] as String?,
      nextAvailable: json['nextAvailable'] != null
          ? DateTime.parse(json['nextAvailable'] as String)
          : null,
    );
  }
}

enum PriceRange { low, medium, high, luxury }

enum ProviderBadge { topRated, verified, popular, newProvider }

class VideoReel extends Equatable {
  const VideoReel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    this.title,
    this.description,
    this.likes = 0,
    this.views = 0,
  });

  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final Duration duration;
  final String? title;
  final String? description;
  final int likes;
  final int views;

  @override
  List<Object?> get props => [
        id,
        videoUrl,
        thumbnailUrl,
        duration,
        title,
        description,
        likes,
        views,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration.inSeconds,
      'title': title,
      'description': description,
      'likes': likes,
      'views': views,
    };
  }

  factory VideoReel.fromJson(Map<String, dynamic> json) {
    return VideoReel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      duration: Duration(seconds: json['duration'] as int),
      title: json['title'] as String?,
      description: json['description'] as String?,
      likes: json['likes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
    );
  }
}

class UserPreferences extends Equatable {
  const UserPreferences({
    required this.serviceTypes,
    required this.budgetRange,
    required this.searchRadius,
    this.latitude,
    this.longitude,
    this.preferredProviderBadges = const [],
    this.sortBy = SortBy.distance,
  });

  final List<String> serviceTypes;
  final PriceRange budgetRange;
  final double searchRadius; // in kilometers
  final double? latitude;
  final double? longitude;
  final List<ProviderBadge> preferredProviderBadges;
  final SortBy sortBy;

  @override
  List<Object?> get props => [
        serviceTypes,
        budgetRange,
        searchRadius,
        latitude,
        longitude,
        preferredProviderBadges,
        sortBy,
      ];

  UserPreferences copyWith({
    List<String>? serviceTypes,
    PriceRange? budgetRange,
    double? searchRadius,
    double? latitude,
    double? longitude,
    List<ProviderBadge>? preferredProviderBadges,
    SortBy? sortBy,
  }) {
    return UserPreferences(
      serviceTypes: serviceTypes ?? this.serviceTypes,
      budgetRange: budgetRange ?? this.budgetRange,
      searchRadius: searchRadius ?? this.searchRadius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      preferredProviderBadges: preferredProviderBadges ?? this.preferredProviderBadges,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceTypes': serviceTypes,
      'budgetRange': budgetRange.name,
      'searchRadius': searchRadius,
      'latitude': latitude,
      'longitude': longitude,
      'preferredProviderBadges': preferredProviderBadges.map((b) => b.name).toList(),
      'sortBy': sortBy.name,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      serviceTypes: List<String>.from(json['serviceTypes'] as List),
      budgetRange: PriceRange.values.firstWhere(
        (e) => e.name == json['budgetRange'],
        orElse: () => PriceRange.medium,
      ),
      searchRadius: (json['searchRadius'] as num).toDouble(),
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      preferredProviderBadges: (json['preferredProviderBadges'] as List? ?? [])
          .map((b) => ProviderBadge.values.firstWhere((e) => e.name == b))
          .toList(),
      sortBy: SortBy.values.firstWhere(
        (e) => e.name == json['sortBy'],
        orElse: () => SortBy.distance,
      ),
    );
  }
}

enum SortBy { distance, rating, price, availability }

class SearchFilters extends Equatable {
  const SearchFilters({
    this.query = '',
    this.categories = const [],
    this.priceRange,
    this.minRating = 0.0,
    this.maxDistance = 50.0,
    this.isAvailableNow = false,
    this.sortBy = SortBy.distance,
  });

  final String query;
  final List<String> categories;
  final PriceRange? priceRange;
  final double minRating;
  final double maxDistance;
  final bool isAvailableNow;
  final SortBy sortBy;

  @override
  List<Object?> get props => [
        query,
        categories,
        priceRange,
        minRating,
        maxDistance,
        isAvailableNow,
        sortBy,
      ];

  SearchFilters copyWith({
    String? query,
    List<String>? categories,
    PriceRange? priceRange,
    double? minRating,
    double? maxDistance,
    bool? isAvailableNow,
    SortBy? sortBy,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      categories: categories ?? this.categories,
      priceRange: priceRange ?? this.priceRange,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
      isAvailableNow: isAvailableNow ?? this.isAvailableNow,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

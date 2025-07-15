import 'package:equatable/equatable.dart';

class ServiceDetail extends Equatable {
  const ServiceDetail({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.subcategory,
    required this.mediaItems,
    required this.preparationChecklist,
    required this.requirements,
    required this.inclusions,
    required this.exclusions,
    this.additionalInfo,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    this.location,
    this.serviceArea,
  });

  final String id;
  final String providerId;
  final String title;
  final String description;
  final double price;
  final Duration duration;
  final String category;
  final String subcategory;
  final List<MediaItem> mediaItems;
  final List<ChecklistItem> preparationChecklist;
  final List<String> requirements;
  final List<String> inclusions;
  final List<String> exclusions;
  final String? additionalInfo;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final ServiceLocation? location;
  final double? serviceArea; // radius in km

  @override
  List<Object?> get props => [
        id,
        providerId,
        title,
        description,
        price,
        duration,
        category,
        subcategory,
        mediaItems,
        preparationChecklist,
        requirements,
        inclusions,
        exclusions,
        additionalInfo,
        tags,
        rating,
        reviewCount,
        isActive,
        location,
        serviceArea,
      ];

  ServiceDetail copyWith({
    String? id,
    String? providerId,
    String? title,
    String? description,
    double? price,
    Duration? duration,
    String? category,
    String? subcategory,
    List<MediaItem>? mediaItems,
    List<ChecklistItem>? preparationChecklist,
    List<String>? requirements,
    List<String>? inclusions,
    List<String>? exclusions,
    String? additionalInfo,
    List<String>? tags,
    double? rating,
    int? reviewCount,
    bool? isActive,
    ServiceLocation? location,
    double? serviceArea,
  }) {
    return ServiceDetail(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      mediaItems: mediaItems ?? this.mediaItems,
      preparationChecklist: preparationChecklist ?? this.preparationChecklist,
      requirements: requirements ?? this.requirements,
      inclusions: inclusions ?? this.inclusions,
      exclusions: exclusions ?? this.exclusions,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      location: location ?? this.location,
      serviceArea: serviceArea ?? this.serviceArea,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration.inMinutes,
      'category': category,
      'subcategory': subcategory,
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
      'preparationChecklist': preparationChecklist.map((item) => item.toJson()).toList(),
      'requirements': requirements,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'additionalInfo': additionalInfo,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'location': location?.toJson(),
      'serviceArea': serviceArea,
    };
  }

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: Duration(minutes: json['duration'] as int),
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      mediaItems: (json['mediaItems'] as List)
          .map((item) => MediaItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      preparationChecklist: (json['preparationChecklist'] as List)
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      requirements: List<String>.from(json['requirements'] as List),
      inclusions: List<String>.from(json['inclusions'] as List),
      exclusions: List<String>.from(json['exclusions'] as List),
      additionalInfo: json['additionalInfo'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      location: json['location'] != null
          ? ServiceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      serviceArea: (json['serviceArea'] as num?)?.toDouble(),
    );
  }
}

class MediaItem extends Equatable {
  const MediaItem({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnailUrl,
    this.caption,
    this.duration,
    this.order = 0,
  });

  final String id;
  final String url;
  final MediaType type;
  final String? thumbnailUrl;
  final String? caption;
  final Duration? duration;
  final int order;

  @override
  List<Object?> get props => [id, url, type, thumbnailUrl, caption, duration, order];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type.name,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'duration': duration?.inSeconds,
      'order': order,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      url: json['url'] as String,
      type: MediaType.values.firstWhere((e) => e.name == json['type']),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      duration: json['duration'] != null 
          ? Duration(seconds: json['duration'] as int) 
          : null,
      order: json['order'] as int? ?? 0,
    );
  }
}

enum MediaType { image, video }

class ChecklistItem extends Equatable {
  const ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isOptional = false,
    this.estimatedTime,
    this.order = 0,
  });

  final String id;
  final String title;
  final String description;
  final String iconName; // Material icon name
  final bool isOptional;
  final Duration? estimatedTime;
  final int order;

  @override
  List<Object?> get props => [id, title, description, iconName, isOptional, estimatedTime, order];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isOptional': isOptional,
      'estimatedTime': estimatedTime?.inMinutes,
      'order': order,
    };
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
      isOptional: json['isOptional'] as bool? ?? false,
      estimatedTime: json['estimatedTime'] != null
          ? Duration(minutes: json['estimatedTime'] as int)
          : null,
      order: json['order'] as int? ?? 0,
    );
  }
}

class ServiceLocation extends Equatable {
  const ServiceLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  final String address;
  final double latitude;
  final double longitude;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  @override
  List<Object?> get props => [address, latitude, longitude, city, state, zipCode, country];

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    return ServiceLocation(
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
    );
  }
}

enum TimeSlotStatus { available, limited, unavailable }

class TimeSlot extends Equatable {
  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.price,
    this.discountPercent,
    this.totalSpots = 1,
    this.availableSpots = 1,
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final double? price; // Override service price if different
  final double? discountPercent;
  final int totalSpots;
  final int availableSpots;

  Duration get duration => endTime.difference(startTime);
  
  TimeSlotStatus get status {
    if (!isAvailable || availableSpots <= 0) {
      return TimeSlotStatus.unavailable;
    } else if (availableSpots <= totalSpots * 0.3) {
      return TimeSlotStatus.limited;
    } else {
      return TimeSlotStatus.available;
    }
  }

  @override
  List<Object?> get props => [id, startTime, endTime, isAvailable, price, discountPercent, totalSpots, availableSpots];

  TimeSlot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    double? price,
    double? discountPercent,
    int? totalSpots,
    int? availableSpots,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      discountPercent: discountPercent ?? this.discountPercent,
      totalSpots: totalSpots ?? this.totalSpots,
      availableSpots: availableSpots ?? this.availableSpots,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
      'price': price,
      'discountPercent': discountPercent,
      'totalSpots': totalSpots,
      'availableSpots': availableSpots,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      totalSpots: json['totalSpots'] as int? ?? 1,
      availableSpots: json['availableSpots'] as int? ?? 1,
    );
  }
}

import '../models/provider.dart';
import '../bloc/feed_state.dart';

abstract class DiscoveryRepository {
  Future<List<Provider>> getProviders({
    required int page,
    required int limit,
    SearchFilters? filters,
    UserPreferences? userPreferences,
    Location? userLocation,
  });

  Future<List<VideoReel>> getVideoReels({
    required int page,
    required int limit,
    SearchFilters? filters,
  });

  Future<Provider> getProviderById(String id);

  Future<List<String>> getServiceCategories();

  Future<List<Provider>> searchProviders({
    required String query,
    SearchFilters? filters,
    Location? userLocation,
  });
}

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  // This would typically inject an API service
  // For now, we'll use mock data for demonstration

  @override
  Future<List<Provider>> getProviders({
    required int page,
    required int limit,
    SearchFilters? filters,
    UserPreferences? userPreferences,
    Location? userLocation,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - in real implementation, this would call an API
    final mockProviders = _generateMockProviders(userLocation);

    // Apply filters
    var filteredProviders = mockProviders;

    if (filters != null) {
      filteredProviders = filteredProviders.where((provider) {
        // Query filter
        if (filters.query.isNotEmpty) {
          final query = filters.query.toLowerCase();
          if (!provider.name.toLowerCase().contains(query) &&
              !provider.businessName.toLowerCase().contains(query) &&
              !provider.categories.any((cat) => cat.toLowerCase().contains(query))) {
            return false;
          }
        }

        // Category filter
        if (filters.categories.isNotEmpty) {
          if (!provider.categories.any((cat) => filters.categories.contains(cat))) {
            return false;
          }
        }

        // Price range filter
        if (filters.priceRange != null && provider.priceRange != filters.priceRange) {
          return false;
        }

        // Rating filter
        if (provider.rating < filters.minRating) {
          return false;
        }

        // Distance filter
        if (provider.distance > filters.maxDistance) {
          return false;
        }

        // Availability filter
        if (filters.isAvailableNow && !provider.isAvailable) {
          return false;
        }

        return true;
      }).toList();

      // Apply sorting
      switch (filters.sortBy) {
        case SortBy.distance:
          filteredProviders.sort((a, b) => a.distance.compareTo(b.distance));
          break;
        case SortBy.rating:
          filteredProviders.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case SortBy.price:
          filteredProviders.sort((a, b) => a.priceRange.index.compareTo(b.priceRange.index));
          break;
        case SortBy.availability:
          filteredProviders.sort((a, b) => b.isAvailable ? 1 : -1);
          break;
      }
    }

    // Paginate
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, filteredProviders.length);

    if (startIndex >= filteredProviders.length) {
      return [];
    }

    return filteredProviders.sublist(startIndex, endIndex);
  }

  @override
  Future<List<VideoReel>> getVideoReels({
    required int page,
    required int limit,
    SearchFilters? filters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _generateMockVideoReels();
  }

  @override
  Future<Provider> getProviderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final providers = _generateMockProviders(null);
    return providers.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<String>> getServiceCategories() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return [
      'Hair & Beauty',
      'Fitness & Wellness',
      'Home Services',
      'Photography',
      'Event Planning',
      'Tutoring',
      'Pet Care',
      'Automotive',
      'Health & Medical',
      'Legal Services',
    ];
  }

  @override
  Future<List<Provider>> searchProviders({
    required String query,
    SearchFilters? filters,
    Location? userLocation,
  }) async {
    final searchFilters = (filters ?? const SearchFilters()).copyWith(query: query);
    
    return getProviders(
      page: 0,
      limit: 50,
      filters: searchFilters,
      userLocation: userLocation,
    );
  }

  List<Provider> _generateMockProviders(Location? userLocation) {
    // Base location (if user location not available, use default)
    final baseLatitude = userLocation?.latitude ?? 37.7749;
    final baseLongitude = userLocation?.longitude ?? -122.4194;

    return [
      Provider(
        id: '1',
        name: 'Sarah Johnson',
        profileImageUrl: 'https://example.com/sarah.jpg',
        businessName: 'Sarah\'s Hair Studio',
        categories: ['Hair & Beauty', 'Styling'],
        rating: 4.8,
        reviewCount: 127,
        distance: 0.8,
        latitude: baseLatitude + 0.01,
        longitude: baseLongitude + 0.01,
        priceRange: PriceRange.medium,
        isVerified: true,
        isAvailable: true,
        badge: ProviderBadge.topRated,
        portfolioImages: [
          'https://example.com/portfolio1.jpg',
          'https://example.com/portfolio2.jpg',
        ],
        videoReels: [
          VideoReel(
            id: 'v1',
            videoUrl: 'https://example.com/video1.mp4',
            thumbnailUrl: 'https://example.com/thumb1.jpg',
            duration: const Duration(seconds: 15),
            title: 'Hair transformation',
            likes: 45,
            views: 234,
          ),
        ],
        bio: 'Professional hair stylist with 10+ years experience',
      ),
      Provider(
        id: '2',
        name: 'Mike Chen',
        profileImageUrl: 'https://example.com/mike.jpg',
        businessName: 'FitLife Personal Training',
        categories: ['Fitness & Wellness', 'Personal Training'],
        rating: 4.9,
        reviewCount: 89,
        distance: 1.2,
        latitude: baseLatitude - 0.015,
        longitude: baseLongitude + 0.02,
        priceRange: PriceRange.high,
        isVerified: true,
        isAvailable: false,
        badge: ProviderBadge.verified,
        portfolioImages: [
          'https://example.com/fitness1.jpg',
          'https://example.com/fitness2.jpg',
        ],
        videoReels: [
          VideoReel(
            id: 'v2',
            videoUrl: 'https://example.com/video2.mp4',
            thumbnailUrl: 'https://example.com/thumb2.jpg',
            duration: const Duration(seconds: 12),
            title: 'Home workout routine',
            likes: 78,
            views: 456,
          ),
        ],
        bio: 'Certified personal trainer specializing in strength training',
        nextAvailable: DateTime.now().add(const Duration(hours: 3)),
      ),
      Provider(
        id: '3',
        name: 'Emma Rodriguez',
        profileImageUrl: 'https://example.com/emma.jpg',
        businessName: 'Capture Moments Photography',
        categories: ['Photography', 'Events'],
        rating: 4.7,
        reviewCount: 156,
        distance: 2.1,
        latitude: baseLatitude + 0.02,
        longitude: baseLongitude - 0.01,
        priceRange: PriceRange.luxury,
        isVerified: true,
        isAvailable: true,
        badge: ProviderBadge.popular,
        portfolioImages: [
          'https://example.com/photo1.jpg',
          'https://example.com/photo2.jpg',
          'https://example.com/photo3.jpg',
        ],
        videoReels: [
          VideoReel(
            id: 'v3',
            videoUrl: 'https://example.com/video3.mp4',
            thumbnailUrl: 'https://example.com/thumb3.jpg',
            duration: const Duration(seconds: 14),
            title: 'Behind the scenes',
            likes: 92,
            views: 612,
          ),
        ],
        bio: 'Award-winning photographer for weddings and events',
      ),
      // Add more mock providers...
      Provider(
        id: '4',
        name: 'David Kim',
        profileImageUrl: 'https://example.com/david.jpg',
        businessName: 'HomeFix Pro',
        categories: ['Home Services', 'Repair'],
        rating: 4.6,
        reviewCount: 203,
        distance: 0.5,
        latitude: baseLatitude - 0.005,
        longitude: baseLongitude - 0.008,
        priceRange: PriceRange.medium,
        isVerified: false,
        isAvailable: true,
        badge: ProviderBadge.newProvider,
        portfolioImages: [
          'https://example.com/home1.jpg',
          'https://example.com/home2.jpg',
        ],
        videoReels: [],
        bio: 'Reliable home repair and maintenance services',
      ),
      Provider(
        id: '5',
        name: 'Lisa Thompson',
        profileImageUrl: 'https://example.com/lisa.jpg',
        businessName: 'Pawsome Pet Care',
        categories: ['Pet Care', 'Dog Walking'],
        rating: 4.9,
        reviewCount: 67,
        distance: 1.8,
        latitude: baseLatitude + 0.018,
        longitude: baseLongitude + 0.015,
        priceRange: PriceRange.low,
        isVerified: true,
        isAvailable: true,
        badge: ProviderBadge.topRated,
        portfolioImages: [
          'https://example.com/pet1.jpg',
          'https://example.com/pet2.jpg',
        ],
        videoReels: [
          VideoReel(
            id: 'v4',
            videoUrl: 'https://example.com/video4.mp4',
            thumbnailUrl: 'https://example.com/thumb4.jpg',
            duration: const Duration(seconds: 13),
            title: 'Happy dogs at the park',
            likes: 134,
            views: 789,
          ),
        ],
        bio: 'Loving pet care services for your furry friends',
      ),
    ];
  }

  List<VideoReel> _generateMockVideoReels() {
    return [
      VideoReel(
        id: 'reel1',
        videoUrl: 'https://example.com/reel1.mp4',
        thumbnailUrl: 'https://example.com/reel_thumb1.jpg',
        duration: const Duration(seconds: 15),
        title: 'Quick makeup tutorial',
        description: 'Get ready in 5 minutes!',
        likes: 245,
        views: 1234,
      ),
      VideoReel(
        id: 'reel2',
        videoUrl: 'https://example.com/reel2.mp4',
        thumbnailUrl: 'https://example.com/reel_thumb2.jpg',
        duration: const Duration(seconds: 12),
        title: 'Home workout challenge',
        description: 'Try this quick cardio routine',
        likes: 189,
        views: 987,
      ),
      VideoReel(
        id: 'reel3',
        videoUrl: 'https://example.com/reel3.mp4',
        thumbnailUrl: 'https://example.com/reel_thumb3.jpg',
        duration: const Duration(seconds: 14),
        title: 'DIY home decoration',
        description: 'Transform your space easily',
        likes: 156,
        views: 654,
      ),
    ];
  }
}

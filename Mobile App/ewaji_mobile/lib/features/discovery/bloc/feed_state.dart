import 'package:equatable/equatable.dart';
import '../models/provider.dart';

enum FeedStatus { initial, loading, success, failure, refreshing }

class FeedState extends Equatable {
  const FeedState({
    this.status = FeedStatus.initial,
    this.providers = const [],
    this.videoReels = const [],
    this.hasReachedMax = false,
    this.userPreferences,
    this.searchFilters = const SearchFilters(),
    this.currentLocation,
    this.isMapView = false,
    this.selectedProvider,
    this.errorMessage,
  });

  final FeedStatus status;
  final List<Provider> providers;
  final List<VideoReel> videoReels;
  final bool hasReachedMax;
  final UserPreferences? userPreferences;
  final SearchFilters searchFilters;
  final Location? currentLocation;
  final bool isMapView;
  final Provider? selectedProvider;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        providers,
        videoReels,
        hasReachedMax,
        userPreferences,
        searchFilters,
        currentLocation,
        isMapView,
        selectedProvider,
        errorMessage,
      ];

  FeedState copyWith({
    FeedStatus? status,
    List<Provider>? providers,
    List<VideoReel>? videoReels,
    bool? hasReachedMax,
    UserPreferences? userPreferences,
    SearchFilters? searchFilters,
    Location? currentLocation,
    bool? isMapView,
    Provider? selectedProvider,
    String? errorMessage,
  }) {
    return FeedState(
      status: status ?? this.status,
      providers: providers ?? this.providers,
      videoReels: videoReels ?? this.videoReels,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      userPreferences: userPreferences ?? this.userPreferences,
      searchFilters: searchFilters ?? this.searchFilters,
      currentLocation: currentLocation ?? this.currentLocation,
      isMapView: isMapView ?? this.isMapView,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class Location extends Equatable {
  const Location({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [latitude, longitude];
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import '../repository/discovery_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({
    required DiscoveryRepository discoveryRepository,
  })  : _discoveryRepository = discoveryRepository,
        super(const FeedState()) {
    on<LoadInitialFeed>(_onLoadInitialFeed);
    on<LoadMoreProviders>(_onLoadMoreProviders);
    on<RefreshFeed>(_onRefreshFeed);
    on<SearchProviders>(
      _onSearchProviders,
      transformer: _debounceSearch(),
    );
    on<UpdateSearchFilters>(_onUpdateSearchFilters);
    on<UpdateUserPreferences>(_onUpdateUserPreferences);
    on<UpdateLocation>(_onUpdateLocation);
    on<ToggleMapView>(_onToggleMapView);
    on<SelectProvider>(_onSelectProvider);

    // Initialize location and feed
    _initializeLocation();
  }

  final DiscoveryRepository _discoveryRepository;
  static const int _providersPerPage = 20;

  // 300ms debounce for search as specified in requirements
  EventTransformer<SearchProviders> _debounceSearch() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(mapper);
  }

  Future<void> _initializeLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      add(UpdateLocation(position.latitude, position.longitude));
      add(const LoadInitialFeed());
    } catch (e) {
      // Fallback to default location or show error
      add(const LoadInitialFeed());
    }
  }

  Future<void> _onLoadInitialFeed(
    LoadInitialFeed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));

    try {
      final providers = await _discoveryRepository.getProviders(
        page: 0,
        limit: _providersPerPage,
        filters: state.searchFilters,
        userPreferences: state.userPreferences,
        userLocation: state.currentLocation,
      );

      final videoReels = await _discoveryRepository.getVideoReels(
        page: 0,
        limit: 10,
        filters: state.searchFilters,
      );

      emit(state.copyWith(
        status: FeedStatus.success,
        providers: providers,
        videoReels: videoReels,
        hasReachedMax: providers.length < _providersPerPage,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreProviders(
    LoadMoreProviders event,
    Emitter<FeedState> emit,
  ) async {
    if (state.hasReachedMax || state.status == FeedStatus.loading) return;

    try {
      final providers = await _discoveryRepository.getProviders(
        page: (state.providers.length / _providersPerPage).floor(),
        limit: _providersPerPage,
        filters: state.searchFilters,
        userPreferences: state.userPreferences,
        userLocation: state.currentLocation,
      );

      if (providers.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          status: FeedStatus.success,
          providers: [...state.providers, ...providers],
          hasReachedMax: providers.length < _providersPerPage,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onRefreshFeed(
    RefreshFeed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.refreshing));

    try {
      final providers = await _discoveryRepository.getProviders(
        page: 0,
        limit: _providersPerPage,
        filters: state.searchFilters,
        userPreferences: state.userPreferences,
        userLocation: state.currentLocation,
      );

      final videoReels = await _discoveryRepository.getVideoReels(
        page: 0,
        limit: 10,
        filters: state.searchFilters,
      );

      emit(state.copyWith(
        status: FeedStatus.success,
        providers: providers,
        videoReels: videoReels,
        hasReachedMax: providers.length < _providersPerPage,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onSearchProviders(
    SearchProviders event,
    Emitter<FeedState> emit,
  ) async {
    final updatedFilters = state.searchFilters.copyWith(query: event.query);
    emit(state.copyWith(
      searchFilters: updatedFilters,
      status: FeedStatus.loading,
    ));

    try {
      final providers = await _discoveryRepository.getProviders(
        page: 0,
        limit: _providersPerPage,
        filters: updatedFilters,
        userPreferences: state.userPreferences,
        userLocation: state.currentLocation,
      );

      emit(state.copyWith(
        status: FeedStatus.success,
        providers: providers,
        hasReachedMax: providers.length < _providersPerPage,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onUpdateSearchFilters(
    UpdateSearchFilters event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(searchFilters: event.filters));
    add(const LoadInitialFeed());
  }

  void _onUpdateUserPreferences(
    UpdateUserPreferences event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(userPreferences: event.preferences));
    add(const LoadInitialFeed());
  }

  void _onUpdateLocation(
    UpdateLocation event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(
      currentLocation: Location(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    ));
  }

  void _onToggleMapView(
    ToggleMapView event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(isMapView: !state.isMapView));
  }

  void _onSelectProvider(
    SelectProvider event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(selectedProvider: event.provider));
  }
}

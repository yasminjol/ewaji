import 'package:equatable/equatable.dart';
import '../models/provider.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialFeed extends FeedEvent {
  const LoadInitialFeed();
}

class LoadMoreProviders extends FeedEvent {
  const LoadMoreProviders();
}

class RefreshFeed extends FeedEvent {
  const RefreshFeed();
}

class SearchProviders extends FeedEvent {
  const SearchProviders(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class UpdateSearchFilters extends FeedEvent {
  const UpdateSearchFilters(this.filters);

  final SearchFilters filters;

  @override
  List<Object?> get props => [filters];
}

class UpdateUserPreferences extends FeedEvent {
  const UpdateUserPreferences(this.preferences);

  final UserPreferences preferences;

  @override
  List<Object?> get props => [preferences];
}

class UpdateLocation extends FeedEvent {
  const UpdateLocation(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];
}

class ToggleMapView extends FeedEvent {
  const ToggleMapView();
}

class SelectProvider extends FeedEvent {
  const SelectProvider(this.provider);

  final Provider provider;

  @override
  List<Object?> get props => [provider];
}

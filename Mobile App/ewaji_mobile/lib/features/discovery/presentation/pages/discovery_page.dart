import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/feed_bloc.dart';
import '../../bloc/feed_event.dart';
import '../../bloc/feed_state.dart';
import '../../repository/discovery_repository.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/map_view_widget.dart';
import '../widgets/provider_list_widget.dart';
import '../widgets/video_reels_widget.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(
        discoveryRepository: DiscoveryRepositoryImpl(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBarWidget(),
              ),

              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).primaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.map_outlined),
                      text: 'Discover',
                    ),
                    Tab(
                      icon: Icon(Icons.play_circle_outline),
                      text: 'Reels',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Discovery Tab (Map + List)
                    _DiscoveryTabContent(),

                    // Reels Tab
                    BlocBuilder<FeedBloc, FeedState>(
                      builder: (context, state) {
                        return VideoReelsWidget(
                          videoReels: state.videoReels,
                          isLoading: state.status == FeedStatus.loading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                context.read<FeedBloc>().add(const ToggleMapView());
              },
              child: Icon(
                state.isMapView ? Icons.list : Icons.map,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DiscoveryTabContent extends StatelessWidget {
  const _DiscoveryTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state.status == FeedStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == FeedStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Please try again',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<FeedBloc>().add(const RefreshFeed());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return state.isMapView
            ? MapViewWidget(
                providers: state.providers,
                currentLocation: state.currentLocation,
                onProviderSelected: (provider) {
                  context.read<FeedBloc>().add(SelectProvider(provider));
                },
              )
            : Column(
                children: [
                  // Quick stats
                  if (state.providers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${state.providers.length} providers found',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              _showFilterBottomSheet(context);
                            },
                          ),
                        ],
                      ),
                    ),

                  // Provider List
                  Expanded(
                    child: ProviderListWidget(
                      providers: state.providers,
                      hasReachedMax: state.hasReachedMax,
                      isLoading: state.status == FeedStatus.loading,
                      onLoadMore: () {
                        context.read<FeedBloc>().add(const LoadMoreProviders());
                      },
                      onRefresh: () async {
                        context.read<FeedBloc>().add(const RefreshFeed());
                      },
                      onProviderTap: (provider) {
                        // Navigate to provider details
                        // Navigator.pushNamed(context, '/provider-details', arguments: provider);
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Filter content would go here
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // Categories filter
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      // Category chips would go here
                      
                      const SizedBox(height: 24),

                      // Price range filter
                      Text(
                        'Price Range',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      // Price range slider would go here

                      const SizedBox(height: 24),

                      // Rating filter
                      Text(
                        'Minimum Rating',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      // Rating selector would go here

                      const SizedBox(height: 24),

                      // Distance filter
                      Text(
                        'Maximum Distance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      // Distance slider would go here

                      const SizedBox(height: 32),

                      // Apply button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Apply filters
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

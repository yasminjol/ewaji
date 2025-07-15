import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/provider.dart';

class ProviderListWidget extends StatefulWidget {
  const ProviderListWidget({
    super.key,
    required this.providers,
    required this.hasReachedMax,
    required this.isLoading,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onProviderTap,
  });

  final List<Provider> providers;
  final bool hasReachedMax;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final Function(Provider) onProviderTap;

  @override
  State<ProviderListWidget> createState() => _ProviderListWidgetState();
}

class _ProviderListWidgetState extends State<ProviderListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoading) {
      widget.onLoadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.providers.length + (widget.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= widget.providers.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final provider = widget.providers[index];
          return ProviderCard(
            provider: provider,
            onTap: () => widget.onProviderTap(provider),
          );
        },
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.provider,
    required this.onTap,
  });

  final Provider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with provider info
              Row(
                children: [
                  // Profile image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: provider.profileImageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Provider details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            if (provider.badge != null) ...[
                              const SizedBox(width: 8),
                              _buildBadge(context, provider.badge!),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.businessName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${provider.rating}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              ' (${provider.reviewCount})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${provider.distance.toStringAsFixed(1)} km',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const Spacer(),
                            _buildAvailabilityIndicator(context, provider),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Categories
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: provider.categories.take(3).map((category) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  );
                }).toList(),
              ),

              // Portfolio images if available
              if (provider.portfolioImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.portfolioImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          right: index < provider.portfolioImages.length - 1 ? 8 : 0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: provider.portfolioImages[index],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Bottom row with price and action buttons
              Row(
                children: [
                  // Price indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriceColor(provider.priceRange).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getPriceText(provider.priceRange),
                      style: TextStyle(
                        color: _getPriceColor(provider.priceRange),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Action buttons
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to chat
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(60, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Chat', style: TextStyle(fontSize: 12)),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: provider.isAvailable
                        ? () {
                            // Navigate to booking
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(70, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      provider.isAvailable ? 'Book' : 'Busy',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, ProviderBadge badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getBadgeColor(badge),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getBadgeText(badge),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAvailabilityIndicator(BuildContext context, Provider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: provider.isAvailable ? Colors.green : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          provider.isAvailable ? 'Available' : 'Busy',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: provider.isAvailable ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Color _getBadgeColor(ProviderBadge badge) {
    switch (badge) {
      case ProviderBadge.topRated:
        return Colors.amber[700]!;
      case ProviderBadge.verified:
        return Colors.blue[600]!;
      case ProviderBadge.popular:
        return Colors.purple[600]!;
      case ProviderBadge.newProvider:
        return Colors.green[600]!;
    }
  }

  String _getBadgeText(ProviderBadge badge) {
    switch (badge) {
      case ProviderBadge.topRated:
        return 'TOP';
      case ProviderBadge.verified:
        return 'VERIFIED';
      case ProviderBadge.popular:
        return 'HOT';
      case ProviderBadge.newProvider:
        return 'NEW';
    }
  }

  Color _getPriceColor(PriceRange priceRange) {
    switch (priceRange) {
      case PriceRange.low:
        return Colors.green;
      case PriceRange.medium:
        return Colors.orange;
      case PriceRange.high:
        return Colors.red;
      case PriceRange.luxury:
        return Colors.purple;
    }
  }

  String _getPriceText(PriceRange priceRange) {
    switch (priceRange) {
      case PriceRange.low:
        return '\$';
      case PriceRange.medium:
        return '\$\$';
      case PriceRange.high:
        return '\$\$\$';
      case PriceRange.luxury:
        return '\$\$\$\$';
    }
  }
}

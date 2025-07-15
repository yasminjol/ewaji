import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/provider.dart';
import '../../bloc/feed_state.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({
    super.key,
    required this.providers,
    this.currentLocation,
    this.onProviderSelected,
  });

  final List<Provider> providers;
  final Location? currentLocation;
  final Function(Provider)? onProviderSelected;

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(MapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.providers != widget.providers) {
      _createMarkers();
    }
  }

  Future<void> _createMarkers() async {
    final markers = <Marker>{};

    for (final provider in widget.providers) {
      final markerId = MarkerId(provider.id);
      final markerIcon = await _createProviderMarker(provider);
      
      markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(provider.latitude, provider.longitude),
          icon: markerIcon,
          onTap: () {
            if (widget.onProviderSelected != null) {
              widget.onProviderSelected!(provider);
            }
            _showProviderBottomSheet(provider);
          },
          infoWindow: InfoWindow(
            title: provider.name,
            snippet: '${provider.rating}★ • ${provider.distance.toStringAsFixed(1)}km',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }
  }

  Future<BitmapDescriptor> _createProviderMarker(Provider provider) async {
    // For simplicity, use default markers with different colors based on provider status
    if (provider.isAvailable) {
      if (provider.badge == ProviderBadge.topRated) {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      } else if (provider.badge == ProviderBadge.verified) {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      }
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.currentLocation != null
        ? LatLng(widget.currentLocation!.latitude, widget.currentLocation!.longitude)
        : const LatLng(37.7749, -122.4194); // Default to San Francisco

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // Top half of screen
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          // Map controller ready
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
      ),
    );
  }

  void _showProviderBottomSheet(Provider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
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

                // Provider info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(provider.profileImageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  provider.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              if (provider.badge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getBadgeColor(provider.badge!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getBadgeText(provider.badge!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            provider.businessName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Text(
                                ' ${provider.rating} (${provider.reviewCount})',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${provider.distance.toStringAsFixed(1)} km',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: provider.isAvailable ? Colors.green : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                provider.isAvailable ? ' Available' : ' Busy',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: provider.isAvailable ? Colors.green : Colors.red,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Categories
                Wrap(
                  spacing: 8,
                  children: provider.categories.map((category) {
                    return Chip(
                      label: Text(category),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Bio
                if (provider.bio != null) ...[
                  Text(
                    provider.bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],

                // Next available
                if (!provider.isAvailable && provider.nextAvailable != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Next available: ${_formatDateTime(provider.nextAvailable!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to chat
                        },
                        child: const Text('Message'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: provider.isAvailable
                            ? () {
                                Navigator.pop(context);
                                // Navigate to booking
                              }
                            : null,
                        child: Text(
                          provider.isAvailable ? 'Book Now' : 'Not Available',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getBadgeColor(ProviderBadge badge) {
    switch (badge) {
      case ProviderBadge.topRated:
        return Colors.amber;
      case ProviderBadge.verified:
        return Colors.blue;
      case ProviderBadge.popular:
        return Colors.purple;
      case ProviderBadge.newProvider:
        return Colors.green;
    }
  }

  String _getBadgeText(ProviderBadge badge) {
    switch (badge) {
      case ProviderBadge.topRated:
        return 'TOP';
      case ProviderBadge.verified:
        return 'VERIFIED';
      case ProviderBadge.popular:
        return 'POPULAR';
      case ProviderBadge.newProvider:
        return 'NEW';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

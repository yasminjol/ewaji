import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../bloc/service_detail_bloc.dart';
import '../../bloc/service_detail_event.dart';
import '../../bloc/service_detail_state.dart';
import '../../repository/service_detail_repository.dart';
import '../widgets/media_carousel_widget.dart';
import '../widgets/preparation_checklist_widget.dart';
import '../widgets/availability_grid_widget.dart';
import '../widgets/booking_sheet_widget.dart';
import '../widgets/service_info_widget.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
  });

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceDetailBloc(
        serviceDetailRepository: ServiceDetailRepositoryImpl(),
      )..add(LoadServiceDetail(serviceId)),
      child: _ServiceDetailView(serviceId: serviceId),
    );
  }
}

class _ServiceDetailView extends StatefulWidget {
  const _ServiceDetailView({required this.serviceId});

  final String serviceId;

  @override
  State<_ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends State<_ServiceDetailView> {
  @override
  void initState() {
    super.initState();
    // Subscribe to real-time availability updates
    context.read<ServiceDetailBloc>().add(SubscribeToAvailability(widget.serviceId));
  }

  @override
  void dispose() {
    // Unsubscribe from real-time updates
    context.read<ServiceDetailBloc>().add(const UnsubscribeFromAvailability());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ServiceDetailBloc, ServiceDetailState>(
        listener: (context, state) {
          if (state.status == ServiceDetailStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ServiceDetailStatus.loading) {
            return const _LoadingView();
          }

          if (state.status == ServiceDetailStatus.failure) {
            return _ErrorView(
              message: state.errorMessage ?? 'An error occurred',
              onRetry: () {
                context.read<ServiceDetailBloc>().add(LoadServiceDetail(widget.serviceId));
              },
            );
          }

          if (state.serviceDetail == null) {
            return const _LoadingView();
          }

          return _ServiceDetailContent(serviceDetail: state.serviceDetail!);
        },
      ),
      bottomNavigationBar: BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
        builder: (context, state) {
          if (state.serviceDetail == null) return const SizedBox.shrink();

          return _BottomBookingBar(
            serviceDetail: state.serviceDetail!,
            selectedTimeSlot: state.selectedTimeSlot,
            finalPrice: state.discountedPrice ?? state.finalPrice,
            onBookNow: () {
              _showBookingSheet(context, state);
            },
          );
        },
      ),
    );
  }

  void _showBookingSheet(BuildContext context, ServiceDetailState state) {
    if (state.selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingSheetWidget(
        serviceDetail: state.serviceDetail!,
        selectedTimeSlot: state.selectedTimeSlot!,
        onBookingConfirmed: (providerId, slot, bookingData) {
          // Handle booking confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking confirmed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Close the booking sheet
          Navigator.of(context).pop(); // Return to previous screen
        },
      ),
    );
  }
}

class _ServiceDetailContent extends StatelessWidget {
  const _ServiceDetailContent({required this.serviceDetail});

  final serviceDetail;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar with media carousel
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: MediaCarouselWidget(
              mediaItems: serviceDetail.mediaItems,
            ),
          ),
          actions: [
            // Real-time indicator
            BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
              builder: (context, state) {
                if (state.isSubscribedToRealtime) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(
                      Icons.wifi,
                      color: Colors.green,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Share button
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareService(context, serviceDetail),
            ),
          ],
        ),

        // Service information
        SliverToBoxAdapter(
          child: ServiceInfoWidget(serviceDetail: serviceDetail),
        ),

        // Preparation checklist
        SliverToBoxAdapter(
          child: PreparationChecklistWidget(
            checklistItems: serviceDetail.preparationChecklist,
          ),
        ),

        // Availability grid
        SliverToBoxAdapter(
          child: BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
            builder: (context, state) {
              return AvailabilityGridWidget(
                providerId: serviceDetail.providerId,
                timeSlots: state.timeSlots,
                onSlotSelected: (slot) {
                  context.read<ServiceDetailBloc>().add(SelectTimeSlot(slot));
                },
              );
            },
          ),
        ),

        // Additional info sections
        SliverToBoxAdapter(
          child: _AdditionalInfoSections(serviceDetail: serviceDetail),
        ),

        // Bottom padding for floating action
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  void _shareService(BuildContext context, serviceDetail) {
    final url = 'https://ewaji.app/service/${serviceDetail.id}';
    final text = '${serviceDetail.title} - ${serviceDetail.description}\n\nBook now: $url';
    
    Share.share(
      text,
      subject: 'Check out this service on EWAJI',
    );
  }
}

class _AdditionalInfoSections extends StatelessWidget {
  const _AdditionalInfoSections({required this.serviceDetail});

  final serviceDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // What's included
        _InfoSection(
          title: 'What\'s Included',
          icon: Icons.check_circle_outline,
          items: serviceDetail.inclusions,
          color: Colors.green,
        ),

        // Requirements
        _InfoSection(
          title: 'Requirements',
          icon: Icons.info_outline,
          items: serviceDetail.requirements,
          color: Colors.blue,
        ),

        // What's NOT included
        _InfoSection(
          title: 'Not Included',
          icon: Icons.cancel_outlined,
          items: serviceDetail.exclusions,
          color: Colors.red,
        ),

        // Additional information
        if (serviceDetail.additionalInfo != null) ...[
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  serviceDetail.additionalInfo!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.color,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading service details...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBookingBar extends StatelessWidget {
  const _BottomBookingBar({
    required this.serviceDetail,
    required this.selectedTimeSlot,
    required this.finalPrice,
    required this.onBookNow,
  });

  final serviceDetail;
  final selectedTimeSlot;
  final double? finalPrice;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price display
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (finalPrice != null) ...[
                    Text(
                      '\$${finalPrice!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      '${serviceDetail.duration.inHours}h ${serviceDetail.duration.inMinutes % 60}m',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ],
              ),
            ),

            // Book now button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: selectedTimeSlot != null ? onBookNow : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  selectedTimeSlot != null ? 'Book Now' : 'Select Time Slot',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

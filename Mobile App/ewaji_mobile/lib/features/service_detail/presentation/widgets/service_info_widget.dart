import 'package:flutter/material.dart';
import '../../models/service_detail.dart';

class ServiceInfoWidget extends StatelessWidget {
  const ServiceInfoWidget({
    super.key,
    required this.serviceDetail,
  });

  final ServiceDetail serviceDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and rating
          _buildHeader(context),
          const SizedBox(height: 16),
          
          // Description
          _buildDescription(context),
          const SizedBox(height: 24),
          
          // Key details
          _buildKeyDetails(context),
          const SizedBox(height: 24),
          
          // Inclusions
          if (serviceDetail.inclusions.isNotEmpty) ...[
            _buildInclusions(context),
            const SizedBox(height: 24),
          ],
          
          // Exclusions
          if (serviceDetail.exclusions.isNotEmpty) ...[
            _buildExclusions(context),
            const SizedBox(height: 24),
          ],
          
          // Requirements
          if (serviceDetail.requirements.isNotEmpty) ...[
            _buildRequirements(context),
            const SizedBox(height: 24),
          ],
          
          // Additional info
          if (serviceDetail.additionalInfo != null) ...[
            _buildAdditionalInfo(context),
            const SizedBox(height: 24),
          ],
          
          // Tags
          if (serviceDetail.tags.isNotEmpty) ...[
            _buildTags(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          serviceDetail.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (serviceDetail.rating > 0) ...[
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    serviceDetail.rating.toStringAsFixed(1),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${serviceDetail.reviewCount} reviews)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                serviceDetail.category,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          serviceDetail.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyDetails(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    context,
                    Icons.schedule,
                    'Duration',
                    _formatDuration(serviceDetail.duration),
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    context,
                    Icons.attach_money,
                    'Price',
                    '\$${serviceDetail.price.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
            if (serviceDetail.location != null) ...[
              const SizedBox(height: 16),
              _buildDetailItem(
                context,
                Icons.location_on,
                'Location',
                serviceDetail.location!.address,
              ),
            ],
            if (serviceDetail.serviceArea != null) ...[
              const SizedBox(height: 16),
              _buildDetailItem(
                context,
                Icons.my_location,
                'Service Area',
                '${serviceDetail.serviceArea!.toStringAsFixed(0)} km radius',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInclusions(BuildContext context) {
    return _buildListSection(
      context,
      'What\'s Included',
      serviceDetail.inclusions,
      Icons.check_circle_outline,
      Colors.green,
    );
  }

  Widget _buildExclusions(BuildContext context) {
    return _buildListSection(
      context,
      'What\'s Not Included',
      serviceDetail.exclusions,
      Icons.cancel_outlined,
      Colors.red,
    );
  }

  Widget _buildRequirements(BuildContext context) {
    return _buildListSection(
      context,
      'Requirements',
      serviceDetail.requirements,
      Icons.info_outline,
      Colors.blue,
    );
  }

  Widget _buildListSection(
    BuildContext context,
    String title,
    List<String> items,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                  const SizedBox(width: 8),
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
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
          child: Text(
            serviceDetail.additionalInfo!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: serviceDetail.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  tag,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

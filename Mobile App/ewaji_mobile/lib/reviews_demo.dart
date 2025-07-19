import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/reviews/index.dart';

void main() {
  runApp(const ReviewsDemoApp());
}

class ReviewsDemoApp extends StatelessWidget {
  const ReviewsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EWAJI Reviews & Ratings Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ReviewsDemoScreen(),
    );
  }
}

class ReviewsDemoScreen extends StatelessWidget {
  const ReviewsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-FR-06: Reviews & Ratings Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews & Ratings Feature',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5E50A1),
              ),
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Features Implemented:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            const _FeatureItem(
              icon: Icons.star,
              title: '1-5 Star Rating System',
              description: 'Interactive star rating with visual feedback',
            ),
            
            const _FeatureItem(
              icon: Icons.local_offer,
              title: 'Service Tag Chips',
              description: 'Speed, Neatness, Communication, Value tags',
            ),
            
            const _FeatureItem(
              icon: Icons.photo_camera,
              title: 'Before/After Photos',
              description: 'Optional image upload with compression (≤3MB)',
            ),
            
            const _FeatureItem(
              icon: Icons.face_retouching_natural,
              title: 'Face Blur (Coming Soon)',
              description: 'Privacy protection using ML Kit face detection',
            ),
            
            const _FeatureItem(
              icon: Icons.storage,
              title: 'Supabase Integration',
              description: 'Reviews stored in backend with cache invalidation',
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _openReviewDemo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E50A1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Review Submission',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Note: Face blur functionality temporarily disabled due to dependency conflicts. Will be re-enabled when google_mlkit_face_detection compatibility issues are resolved.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openReviewDemo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ReviewBloc(
            reviewRepository: MockReviewRepository(),
          ),
          child: const ReviewSubmissionScreen(
            bookingId: 'demo-booking-123',
            clientId: 'demo-client-456',
            providerId: 'demo-provider-789',
            providerName: "Sarah's Hair Studio",
            serviceName: 'Balayage & Cut',
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF5E50A1),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

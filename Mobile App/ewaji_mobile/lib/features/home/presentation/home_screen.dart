import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  late PageController _pageController;
  int _currentSlide = 0;

  final List<Map<String, dynamic>> aiPicks = [
    {
      'id': 1,
      'image': 'https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=250&fit=crop',
      'providerName': "Sophia's Hair Studio",
      'service': 'Balayage & Cut',
    },
    {
      'id': 2,
      'image': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=250&fit=crop',
      'providerName': 'Glamour Nails',
      'service': 'Gel Manicure',
    },
    {
      'id': 3,
      'image': 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=400&h=250&fit=crop',
      'providerName': 'Bella Beauty',
      'service': 'Facial Treatment',
    },
  ];

  final List<Map<String, dynamic>> feedPosts = [
    {
      'id': 1,
      'provider': {
        'name': "Sophia's Hair Studio",
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616c5e68b05?w=50&h=50&fit=crop&crop=face',
      },
      'image': 'https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=400&fit=crop',
      'likes': 234,
      'caption': 'Fresh balayage transformation ✨',
    },
    {
      'id': 2,
      'provider': {
        'name': 'Glamour Nails',
        'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50&fit=crop&crop=face',
      },
      'image': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=400&fit=crop',
      'likes': 156,
      'caption': 'Gorgeous gel manicure design 💅',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Auto-scroll carousel
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  void _autoScroll() {
    if (mounted) {
      setState(() {
        _currentSlide = (_currentSlide + 1) % aiPicks.length;
      });
      _pageController.animateToPage(
        _currentSlide,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 4), _autoScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Spacer
                  const Text(
                    'EWAJI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    size: 24,
                    color: Color(0xFF5E50A1),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Picks Carousel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Picks For You',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentSlide = index;
                                });
                              },
                              itemCount: aiPicks.length,
                              itemBuilder: (context, index) {
                                final pick = aiPicks[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: pick['image'],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.6),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 16,
                                          left: 16,
                                          right: 16,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pick['providerName'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                pick['service'],
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ElevatedButton(
                                                onPressed: () => _showBookingDialog(pick),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF5E50A1),
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                child: const Text('Book Now'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Pagination Dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(aiPicks.length, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentSlide
                                      ? const Color(0xFF5E50A1)
                                      : Colors.grey[300],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Main Feed
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: feedPosts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final post = feedPosts[index];
                        return _buildFeedPost(post);
                      },
                    ),
                    
                    const SizedBox(height: 100), // Extra space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedPost(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(
                  post['provider']['avatar'],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                post['provider']['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Post Image
        CachedNetworkImage(
          imageUrl: post['image'],
          width: double.infinity,
          height: 320,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 320,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 320,
            color: Colors.grey[200],
            child: const Icon(Icons.error),
          ),
        ),
        
        // Post Actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 24,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 24,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.share_outlined,
                        size: 24,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.bookmark_border,
                    size: 24,
                    color: Colors.grey[600],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                '${post['likes']} likes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              
              const SizedBox(height: 4),
              
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1C1C1E),
                  ),
                  children: [
                    TextSpan(
                      text: post['provider']['name'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: ' ${post['caption']}'),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showBookingDialog(post),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E50A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBookingDialog(Map<String, dynamic> provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book with ${provider['providerName'] ?? provider['provider']['name']}'),
        content: const Text('Booking feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

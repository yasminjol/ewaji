import 'package:flutter/material.dart';
import '../../notification_demo.dart';
import '../../core/services/notification_service.dart';

class ProviderDashboardTabs extends StatefulWidget {
  const ProviderDashboardTabs({super.key});

  @override
  State<ProviderDashboardTabs> createState() => _ProviderDashboardTabsState();
}

class _ProviderDashboardTabsState extends State<ProviderDashboardTabs> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProviderHomeTab(),
    const ProviderBookingsTab(),
    const ProviderServicesTab(),
    const ProviderInboxTab(),
    const ProviderSettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF5E50A1),
            unselectedItemColor: const Color(0xFFB0B0B8),
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderHomeTab extends StatelessWidget {
  const ProviderHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Color(0xFF1C1C1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF5E50A1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationDemoScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5E50A1), Color(0xFF4F4391)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'You have 3 appointments today',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Today\'s Earnings',
                          '\$240',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Total Bookings',
                          '32',
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Rating',
                          '4.9',
                          Icons.star,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Profile Views',
                          '650',
                          Icons.visibility,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Today's Appointments
                  const Text(
                    'Today\'s Appointments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAppointmentCard(
                    'Maya Johnson',
                    'Protective Braids',
                    '2:00 PM',
                    'pending',
                  ),
                  const SizedBox(height: 8),
                  _buildAppointmentCard(
                    'Zara Williams',
                    'Natural Makeup',
                    '4:30 PM',
                    'confirmed',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6E6E73),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(String clientName, String service, String time, String status) {
    Color statusColor = status == 'confirmed' ? Colors.blue : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text(clientName[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  service,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProviderBookingsTab extends StatefulWidget {
  const ProviderBookingsTab({super.key});

  @override
  State<ProviderBookingsTab> createState() => _ProviderBookingsTabState();
}

class _ProviderBookingsTabState extends State<ProviderBookingsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            title: const Text(
              'Bookings',
              style: TextStyle(
                color: Color(0xFF1C1C1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF5E50A1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationDemoScreen(),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF5E50A1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF5E50A1),
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingBookings(),
                _buildActiveBookings(),
                _buildCompletedBookings(),
                _buildCancelledBookings(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildBookingCard(
          clientName: 'Sarah Johnson',
          service: 'House Cleaning',
          date: 'Tomorrow',
          time: '10:00 AM - 12:00 PM',
          price: '\$120',
          status: 'Confirmed',
          statusColor: Colors.green,
          onTap: () => _showBookingDetails(context, 'upcoming'),
        );
      },
    );
  }

  Widget _buildActiveBookings() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _buildBookingCard(
          clientName: 'Mike Chen',
          service: 'Plumbing Repair',
          date: 'Today',
          time: '2:00 PM - 4:00 PM',
          price: '\$80',
          status: 'In Progress',
          statusColor: Colors.blue,
          onTap: () => _showBookingDetails(context, 'active'),
        );
      },
    );
  }

  Widget _buildCompletedBookings() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 12,
      itemBuilder: (context, index) {
        return _buildBookingCard(
          clientName: 'Emma Wilson',
          service: 'Garden Maintenance',
          date: 'Yesterday',
          time: '9:00 AM - 11:00 AM',
          price: '\$90',
          status: 'Completed',
          statusColor: Colors.grey,
          onTap: () => _showBookingDetails(context, 'completed'),
        );
      },
    );
  }

  Widget _buildCancelledBookings() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildBookingCard(
          clientName: 'John Smith',
          service: 'Electrical Work',
          date: '2 days ago',
          time: '1:00 PM - 3:00 PM',
          price: '\$150',
          status: 'Cancelled',
          statusColor: Colors.red,
          onTap: () => _showBookingDetails(context, 'cancelled'),
        );
      },
    );
  }

  Widget _buildBookingCard({
    required String clientName,
    required String service,
    required String date,
    required String time,
    required String price,
    required String status,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clientName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      '$date • $time',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E50A1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 20),
                const Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Client', 'Sarah Johnson'),
                        _buildDetailRow('Service', 'House Cleaning'),
                        _buildDetailRow('Date', 'Tomorrow, Dec 15'),
                        _buildDetailRow('Time', '10:00 AM - 12:00 PM'),
                        _buildDetailRow('Duration', '2 hours'),
                        _buildDetailRow('Location', '123 Main St, City'),
                        _buildDetailRow('Price', '\$120'),
                        _buildDetailRow('Commission', '\$18 (15%)'),
                        _buildDetailRow('Your Earnings', '\$102'),
                        const SizedBox(height: 20),
                        if (type == 'upcoming') ...[
                          ElevatedButton(
                            onPressed: () => _sendNotificationTest(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5E50A1),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Send Test Notification'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Contact Client'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendNotificationTest(BuildContext context) async {
    try {
      await NotificationService.instance.showNotification(
        title: 'Booking Confirmed',
        body: 'Your service with Sarah Johnson is confirmed for tomorrow at 10:00 AM',
        payload: {'booking_id': '123', 'type': 'booking_confirmation'},
      );
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test notification sent!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ProviderServicesTab extends StatefulWidget {
  const ProviderServicesTab({super.key});

  @override
  State<ProviderServicesTab> createState() => _ProviderServicesTabState();
}

class _ProviderServicesTabState extends State<ProviderServicesTab> {
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'House Cleaning',
      'description': 'Complete home cleaning service',
      'price': '\$80-120',
      'duration': '2-3 hours',
      'rating': 4.9,
      'bookings': 45,
      'active': true,
    },
    {
      'title': 'Plumbing Repair',
      'description': 'Basic plumbing fixes and maintenance',
      'price': '\$60-100',
      'duration': '1-2 hours',
      'rating': 4.8,
      'bookings': 32,
      'active': true,
    },
    {
      'title': 'Garden Maintenance',
      'description': 'Lawn care and garden upkeep',
      'price': '\$70-90',
      'duration': '2-3 hours',
      'rating': 4.7,
      'bookings': 28,
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            title: const Text(
              'My Services',
              style: TextStyle(
                color: Color(0xFF1C1C1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF5E50A1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationDemoScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF5E50A1)),
                onPressed: () => _showAddServiceDialog(),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = _services[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildServiceCard(service, index),
                );
              },
              childCount: _services.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: service['active'],
                  onChanged: (value) {
                    setState(() {
                      _services[index]['active'] = value;
                    });
                    _toggleServiceStatus(service['title'], value);
                  },
                  activeColor: const Color(0xFF5E50A1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(Icons.attach_money, service['price']),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.access_time, service['duration']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${service['rating']}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                const SizedBox(width: 4),
                Text(
                  '${service['bookings']} bookings',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _editService(service),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF5E50A1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF5E50A1)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF5E50A1),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleServiceStatus(String serviceName, bool isActive) {
    NotificationService.instance.showNotification(
      title: isActive ? 'Service Activated' : 'Service Deactivated',
      body: '$serviceName has been ${isActive ? 'activated' : 'deactivated'}',
      payload: {'service': serviceName, 'status': isActive.toString()},
    );
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: const Text('This feature will allow you to add new services to your profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add service feature coming soon!')),
              );
            },
            child: const Text('Coming Soon'),
          ),
        ],
      ),
    );
  }

  void _editService(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 20),
            Text(
              'Edit ${service['title']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Details'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit service feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Update Photos'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo upload feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Set Availability'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Availability feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Test Notification'),
              onTap: () {
                Navigator.pop(context);
                NotificationService.instance.showNotification(
                  title: 'Service Updated',
                  body: '${service['title']} has been updated successfully',
                  payload: {'service_id': service['title']},
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProviderInboxTab extends StatefulWidget {
  const ProviderInboxTab({super.key});

  @override
  State<ProviderInboxTab> createState() => _ProviderInboxTabState();
}

class _ProviderInboxTabState extends State<ProviderInboxTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'Sarah Johnson',
      'message': 'Hi! Can we reschedule tomorrow\'s cleaning?',
      'time': '2 min ago',
      'unread': true,
      'avatar': 'S',
    },
    {
      'name': 'Mike Chen',
      'message': 'Thank you for the excellent plumbing work!',
      'time': '1 hour ago',
      'unread': false,
      'avatar': 'M',
    },
    {
      'name': 'Emma Wilson',
      'message': 'The garden looks amazing! 5 stars ⭐',
      'time': '3 hours ago',
      'unread': true,
      'avatar': 'E',
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Booking Request',
      'message': 'You have a new booking request for House Cleaning',
      'time': '5 min ago',
      'type': 'booking',
      'unread': true,
    },
    {
      'title': 'Payment Received',
      'message': 'Payment of \$120 has been processed',
      'time': '2 hours ago',
      'type': 'payment',
      'unread': false,
    },
    {
      'title': 'Service Review',
      'message': 'You received a 5-star review from Emma Wilson',
      'time': '1 day ago',
      'type': 'review',
      'unread': false,
    },
  ];

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
    return Container(
      color: Colors.grey[50],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            title: const Text(
              'Inbox',
              style: TextStyle(
                color: Color(0xFF1C1C1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF5E50A1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationDemoScreen(),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF5E50A1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF5E50A1),
              tabs: const [
                Tab(text: 'Messages'),
                Tab(text: 'Notifications'),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessagesTab(),
                _buildNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageCard(message);
      },
    );
  }

  Widget _buildNotificationsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _sendTestNotification(),
                  icon: const Icon(Icons.send),
                  label: const Text('Send Test Notification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E50A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _markAllAsRead(),
                icon: const Icon(Icons.done_all),
                label: const Text('Mark All Read'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationCard(notification, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: message['unread'] ? 3 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF5E50A1),
            child: Text(
              message['avatar'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            message['name'],
            style: TextStyle(
              fontWeight: message['unread'] ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          subtitle: Text(
            message['message'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: message['unread'] ? Colors.black87 : Colors.grey[600],
              fontWeight: message['unread'] ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (message['unread']) ...[
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5E50A1),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          onTap: () => _openMessage(message),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    IconData icon;
    Color iconColor;
    
    switch (notification['type']) {
      case 'booking':
        icon = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      case 'payment':
        icon = Icons.attach_money;
        iconColor = Colors.green;
        break;
      case 'review':
        icon = Icons.star;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: notification['unread'] ? 3 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['unread'] ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          subtitle: Text(
            notification['message'],
            style: TextStyle(
              color: notification['unread'] ? Colors.black87 : Colors.grey[600],
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notification['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (notification['unread']) ...[
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5E50A1),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          onTap: () => _markNotificationAsRead(index),
        ),
      ),
    );
  }

  void _openMessage(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF5E50A1),
                      child: Text(
                        message['avatar'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message['time'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'This is a demo message thread. Full messaging functionality will be implemented in future updates.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _sendQuickReply(message['name']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E50A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Quick Reply'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Close'),
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

  void _sendTestNotification() {
    NotificationService.instance.showNotification(
      title: 'Test Notification',
      body: 'This is a test notification from the Provider Inbox',
      payload: {'source': 'provider_inbox', 'timestamp': DateTime.now().toString()},
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['unread'] = false;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _markNotificationAsRead(int index) {
    setState(() {
      _notifications[index]['unread'] = false;
    });
  }

  void _sendQuickReply(String clientName) {
    NotificationService.instance.showNotification(
      title: 'Message Sent',
      body: 'Quick reply sent to $clientName',
      payload: {'type': 'message_sent', 'client': clientName},
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quick reply sent!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class ProviderSettingsTab extends StatefulWidget {
  const ProviderSettingsTab({super.key});

  @override
  State<ProviderSettingsTab> createState() => _ProviderSettingsTabState();
}

class _ProviderSettingsTabState extends State<ProviderSettingsTab> {
  bool _bookingNotifications = true;
  bool _messageNotifications = true;
  bool _promotionalNotifications = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF1C1C1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF5E50A1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationDemoScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSectionCard(
                    'Notification Settings',
                    [
                      _buildSwitchListTile(
                        'Booking Notifications',
                        'Get notified about new bookings and updates',
                        _bookingNotifications,
                        (value) => setState(() => _bookingNotifications = value),
                        Icons.calendar_today,
                      ),
                      _buildSwitchListTile(
                        'Message Notifications',
                        'Get notified about new messages from clients',
                        _messageNotifications,
                        (value) => setState(() => _messageNotifications = value),
                        Icons.message,
                      ),
                      _buildSwitchListTile(
                        'Push Notifications',
                        'Receive push notifications on your device',
                        _pushNotifications,
                        (value) => setState(() => _pushNotifications = value),
                        Icons.notifications,
                      ),
                      _buildSwitchListTile(
                        'Email Notifications',
                        'Receive notifications via email',
                        _emailNotifications,
                        (value) => setState(() => _emailNotifications = value),
                        Icons.email,
                      ),
                      _buildSwitchListTile(
                        'Promotional Notifications',
                        'Get updates about new features and promotions',
                        _promotionalNotifications,
                        (value) => setState(() => _promotionalNotifications = value),
                        Icons.local_offer,
                      ),
                    ],
                  ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Notification Demo',
            [
              ListTile(
                leading: const Icon(Icons.send, color: Color(0xFF5E50A1)),
                title: const Text('Test Notifications'),
                subtitle: const Text('Send test notifications to verify settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showNotificationTestDialog(),
              ),
              ListTile(
                leading: const Icon(Icons.schedule, color: Color(0xFF5E50A1)),
                title: const Text('Schedule Demo'),
                subtitle: const Text('Test scheduled notification features'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showScheduleDemo(),
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Color(0xFF5E50A1)),
                title: const Text('Notification History'),
                subtitle: const Text('View recent notification activity'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showNotificationHistory(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Account',
            [
              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF5E50A1)),
                title: const Text('Profile Settings'),
                subtitle: const Text('Manage your profile information'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showComingSoon('Profile Settings'),
              ),
              ListTile(
                leading: const Icon(Icons.security, color: Color(0xFF5E50A1)),
                title: const Text('Privacy & Security'),
                subtitle: const Text('Manage your privacy settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showComingSoon('Privacy & Security'),
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Color(0xFF5E50A1)),
                title: const Text('Payment Settings'),
                subtitle: const Text('Manage payment methods and earnings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showComingSoon('Payment Settings'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Support',
            [
              ListTile(
                leading: const Icon(Icons.help, color: Color(0xFF5E50A1)),
                title: const Text('Help Center'),
                subtitle: const Text('Get help and support'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showComingSoon('Help Center'),
              ),
              ListTile(
                leading: const Icon(Icons.feedback, color: Color(0xFF5E50A1)),
                title: const Text('Send Feedback'),
                subtitle: const Text('Share your thoughts with us'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showComingSoon('Send Feedback'),
              ),
            ],
          ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchListTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5E50A1)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          onChanged(newValue);
          _notifySettingChange(title, newValue);
        },
        activeColor: const Color(0xFF5E50A1),
      ),
    );
  }

  void _notifySettingChange(String setting, bool enabled) {
    NotificationService.instance.showNotification(
      title: 'Settings Updated',
      body: '$setting ${enabled ? 'enabled' : 'disabled'}',
      payload: {'setting': setting, 'enabled': enabled.toString()},
    );
  }

  void _showNotificationTestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Notifications'),
        content: const Text('Choose which type of notification to test:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _sendTestBookingNotification();
            },
            child: const Text('Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _sendTestMessageNotification();
            },
            child: const Text('Message'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _sendTestPaymentNotification();
            },
            child: const Text('Payment'),
          ),
        ],
      ),
    );
  }

  void _sendTestBookingNotification() {
    NotificationService.instance.showNotification(
      title: 'New Booking Request',
      body: 'You have a new booking request for House Cleaning on Dec 15 at 10:00 AM',
      payload: {'type': 'booking_test', 'booking_id': 'test_123'},
    );
  }

  void _sendTestMessageNotification() {
    NotificationService.instance.showNotification(
      title: 'New Message',
      body: 'Sarah Johnson: "Can we reschedule tomorrow\'s appointment?"',
      payload: {'type': 'message_test', 'client': 'Sarah Johnson'},
    );
  }

  void _sendTestPaymentNotification() {
    NotificationService.instance.showNotification(
      title: 'Payment Received',
      body: 'You received \$120 payment for House Cleaning service',
      payload: {'type': 'payment_test', 'amount': '120'},
    );
  }

  void _showScheduleDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Demo Notification'),
        content: const Text('Schedule a demo notification to test the scheduling feature:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _scheduleTestNotification(10); // 10 seconds
            },
            child: const Text('10 seconds'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _scheduleTestNotification(60); // 1 minute
            },
            child: const Text('1 minute'),
          ),
        ],
      ),
    );
  }

  void _scheduleTestNotification(int seconds) async {
    final scheduledTime = DateTime.now().add(Duration(seconds: seconds));
    
    try {
      await NotificationService.instance.scheduleNotification(
        scheduledTime: scheduledTime,
        title: 'Scheduled Test Notification',
        body: 'This notification was scheduled $seconds seconds ago',
        payload: {'type': 'scheduled_test', 'delay': seconds.toString()},
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification scheduled for $seconds seconds from now'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scheduling notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNotificationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 20),
            const Text(
              'Notification History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      index % 3 == 0 ? Icons.calendar_today :
                      index % 3 == 1 ? Icons.message : Icons.attach_money,
                      color: const Color(0xFF5E50A1),
                    ),
                    title: Text('Test notification ${index + 1}'),
                    subtitle: Text('Sent ${index + 1} hour${index == 0 ? '' : 's'} ago'),
                    trailing: const Icon(Icons.check, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon!')),
    );
  }
}

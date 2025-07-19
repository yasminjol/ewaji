import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../reviews/index.dart';

class ClientAppointmentsScreen extends StatefulWidget {
  const ClientAppointmentsScreen({super.key});

  @override
  State<ClientAppointmentsScreen> createState() => _ClientAppointmentsScreenState();
}

class _ClientAppointmentsScreenState extends State<ClientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Map<String, dynamic>>> appointments = {
    'Upcoming': [
      {
        'id': 1,
        'service': 'Balayage & Cut',
        'provider': {
          'name': "Sophia's Hair Studio",
          'avatar': 'https://images.unsplash.com/photo-1494790108755-2616c5e68b05?w=50&h=50&fit=crop&crop=face',
        },
        'date': 'Dec 28, 2024',
        'time': '2:00 PM',
        'status': 'confirmed',
      },
      {
        'id': 2,
        'service': 'Gel Manicure',
        'provider': {
          'name': 'Glamour Nails',
          'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50&fit=crop&crop=face',
        },
        'date': 'Dec 30, 2024',
        'time': '11:00 AM',
        'status': 'pending',
      },
    ],
    'Completed': [
      {
        'id': 3,
        'service': 'Facial Treatment',
        'provider': {
          'name': 'Bella Beauty',
          'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop&crop=face',
        },
        'date': 'Dec 20, 2024',
        'time': '3:00 PM',
        'status': 'completed',
      },
    ],
    'Cancelled': [
      {
        'id': 4,
        'service': 'Eyelash Extensions',
        'provider': {
          'name': 'Elite Lashes',
          'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=50&h=50&fit=crop&crop=face',
        },
        'date': 'Dec 15, 2024',
        'time': '1:00 PM',
        'status': 'cancelled',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF5E50A1),
          unselectedLabelColor: const Color(0xFF6E6E73),
          indicatorColor: const Color(0xFF5E50A1),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList('Upcoming'),
          _buildAppointmentsList('Completed'),
          _buildAppointmentsList('Cancelled'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(String status) {
    final appointmentList = appointments[status] ?? [];

    if (appointmentList.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointmentList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final appointment = appointmentList[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildEmptyState(String status) {
    String message;
    switch (status) {
      case 'Upcoming':
        message = "You don't have any upcoming appointments.";
        break;
      case 'Completed':
        message = "No completed appointments yet.";
        break;
      case 'Cancelled':
        message = "No cancelled appointments.";
        break;
      default:
        message = "No appointments found.";
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(appointment['status']),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Service & Provider
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: Text(appointment['provider']['name'][0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['service'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    Text(
                      appointment['provider']['name'],
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

          const SizedBox(height: 12),

          // Date & Time
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                appointment['date'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                appointment['time'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          if (appointment['status'] == 'confirmed' || appointment['status'] == 'pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5E50A1),
                      side: const BorderSide(color: Color(0xFF5E50A1)),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E50A1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Contact'),
                  ),
                ),
              ],
            ),

          if (appointment['status'] == 'completed')
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5E50A1),
                      side: const BorderSide(color: Color(0xFF5E50A1)),
                    ),
                    child: const Text('Book Again'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openReviewScreen(appointment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E50A1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Write Review'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openReviewScreen(Map<String, dynamic> appointment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ReviewBloc(
            reviewRepository: MockReviewRepository(),
          ),
          child: ReviewSubmissionScreen(
            bookingId: appointment['id'].toString(),
            clientId: 'demo-client-123', // TODO: Get actual client ID
            providerId: 'demo-provider-123', // TODO: Get actual provider ID  
            providerName: appointment['provider']['name'],
            serviceName: appointment['service'],
          ),
        ),
      ),
    );
  }
}

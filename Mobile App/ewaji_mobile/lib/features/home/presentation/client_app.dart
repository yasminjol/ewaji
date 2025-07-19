import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_screen.dart';
import '../../discovery/index.dart';
import '../../booking_management/index.dart';
import '../../inbox/index.dart';
import '../../settings/index.dart';

class ClientApp extends StatefulWidget {
  final String initialTab;
  
  const ClientApp({super.key, this.initialTab = 'home'});

  @override
  State<ClientApp> createState() => _ClientAppState();
}

class _ClientAppState extends State<ClientApp> {
  late int _currentIndex;
  
  final List<Widget> _screens = [
    const ClientHomeScreen(),
    const DiscoveryPage(),
    const ClientAppointmentsScreen(),
    const ClientInboxScreen(),
    const ClientProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = _getIndexFromTab(widget.initialTab);
  }

  int _getIndexFromTab(String tab) {
    switch (tab) {
      case 'home': return 0;
      case 'explore': return 1;
      case 'appointments': return 2;
      case 'inbox': return 3;
      case 'profile': return 4;
      default: return 0;
    }
  }

  String _getTabFromIndex(int index) {
    switch (index) {
      case 0: return 'home';
      case 1: return 'explore';
      case 2: return 'appointments';
      case 3: return 'inbox';
      case 4: return 'profile';
      default: return 'home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          context.go('/client/${_getTabFromIndex(index)}');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5E50A1),
        unselectedItemColor: const Color(0xFF6E6E73),
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
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

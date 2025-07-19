import 'package:flutter/material.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF5E50A1),
                      child: const Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Jane Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'jane.doe@email.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5E50A1),
                        side: const BorderSide(color: Color(0xFF5E50A1)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Profile Options
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.payment,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.location_on,
                      title: 'Addresses',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.favorite,
                      title: 'Favorites',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.star,
                      title: 'Reviews',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Settings
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.help,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildProfileOption(
                      icon: Icons.info,
                      title: 'About',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Sign Out
              Container(
                color: Colors.white,
                child: _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    _showSignOutDialog(context);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // App Version
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? const Color(0xFF5E50A1),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? const Color(0xFF1C1C1E),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF6E6E73),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 56, // Align with text
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle sign out logic here
              // For demo, you might want to navigate back to welcome screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

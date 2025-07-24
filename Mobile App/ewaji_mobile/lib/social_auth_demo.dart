import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize authentication system
  await AuthInitializer.initialize();
  runApp(const SocialAuthDemo());
}

class SocialAuthDemo extends StatelessWidget {
  const SocialAuthDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthRepository.createAuthBloc(),
      child: MaterialApp(
        title: 'EWAJI Social Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: const Color(0xFF5E50A1),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const SocialAuthDemoHome(),
      ),
    );
  }
}

class SocialAuthDemoHome extends StatelessWidget {
  const SocialAuthDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // If user is authenticated, show the main app with enhanced info
        if (state.isAuthenticated && state.user != null) {
          return MainAppScreen(user: state.user!, isNewUser: state.isNewUser);
        }

        // Show authentication flow with enhanced social login
        return AuthFlow(
          onAuthenticated: () {
            print('🎉 User authenticated successfully via social login!');
          },
          initialUserType: UserType.client,
        );
      },
    );
  }
}

class MainAppScreen extends StatelessWidget {
  final AuthUser user;
  final bool isNewUser;

  const MainAppScreen({
    super.key,
    required this.user,
    required this.isNewUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EWAJI - Social Auth Demo'),
        backgroundColor: const Color(0xFF5E50A1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header with new user indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5E50A1), Color(0xFF4F4391)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        isNewUser ? 'Welcome, New User!' : 'Welcome Back!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isNewUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.displayName ?? user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // User information section
            const Text(
              'User Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E50A1),
              ),
            ),
            const SizedBox(height: 12),

            _buildInfoCard('User ID', user.uid),
            _buildInfoCard('Email', user.email),
            if (user.displayName != null)
              _buildInfoCard('Display Name', user.displayName!),
            if (user.phoneNumber != null)
              _buildInfoCard('Phone', user.phoneNumber!),
            _buildInfoCard('User Type', user.userType.name.toUpperCase()),
            _buildInfoCard('Email Verified', user.isEmailVerified ? 'Yes' : 'No'),
            _buildInfoCard('Phone Verified', user.isPhoneVerified ? 'Yes' : 'No'),

            const SizedBox(height: 24),

            // Social Authentication Features Demo
            const Text(
              'Social Authentication Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E50A1),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Social Authentication Active',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '✅ Google & Apple Sign-In implemented\n'
                    '✅ SocialLoginRequested events working\n'
                    '✅ New user detection: ${isNewUser ? 'DETECTED' : 'RETURNING USER'}\n'
                    '✅ Enhanced error handling with retry\n'
                    '✅ Loading states for social login\n'
                    '✅ Onboarding flow ready for new users',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showImplementationDetails(context);
                    },
                    icon: const Icon(Icons.info),
                    label: const Text('Implementation Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E50A1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _testSocialAuth(context);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Test Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImplementationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 Implementation Complete'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'M-FR-01a Social Authentication ✅',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• Google & Apple sign-in buttons implemented'),
              Text('• SocialLoginRequested(provider, userType) events'),
              Text('• SocialLoginInProgress → Success/Failure states'),
              Text('• New user detection with isNewUser flag'),
              Text('• Onboarding navigation logic ready'),
              Text('• Enhanced error handling with retry'),
              Text('• Loading overlay during social auth'),
              SizedBox(height: 12),
              Text(
                'Next Steps:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Connect onboarding flows'),
              Text('• Add client personalization screens'),
              Text('• Add provider category selection'),
              Text('• Integrate with Firebase project'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _testSocialAuth(BuildContext context) {
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/auth_repository.dart';
import 'features/auth/auth_flow.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/models/auth_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize authentication system
  await AuthInitializer.initialize();
  
  runApp(const EwajiAuthDemo());
}

class EwajiAuthDemo extends StatelessWidget {
  const EwajiAuthDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthRepository.createAuthBloc(),
      child: MaterialApp(
        title: 'EWAJI Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: const Color(0xFF5E50A1),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const AuthDemoHome(),
      ),
    );
  }
}

class AuthDemoHome extends StatelessWidget {
  const AuthDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // If user is authenticated, show the main app
        if (state.isAuthenticated) {
          return MainAppScreen(user: state.user!);
        }
        
        // Otherwise, show the auth flow
        return AuthFlow(
          onAuthenticated: () {
            // This callback is called when authentication is successful
            // You can navigate to the main app or perform other actions here
            debugPrint('User authenticated successfully!');
          },
          initialUserType: UserType.client, // Optional: default to client
        );
      },
    );
  }
}

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({
    super.key,
    required this.user,
  });

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EWAJI'),
        backgroundColor: const Color(0xFF5E50A1),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sign_out',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'sign_out') {
                context.read<AuthBloc>().add(const AuthSignOutRequested());
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            
            const SizedBox(height: 24),
            
            // Welcome message
            Text(
              'Welcome ${user.displayName ?? user.email}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // User type
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF5E50A1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.userType == UserType.client ? 'Client' : 'Provider',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // User details
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Email', user.email),
                    if (user.phoneNumber != null)
                      _buildDetailRow('Phone', user.phoneNumber!),
                    _buildDetailRow(
                      'Email Verified',
                      user.isEmailVerified ? 'Yes' : 'No',
                    ),
                    if (user.phoneNumber != null)
                      _buildDetailRow(
                        'Phone Verified',
                        user.isPhoneVerified ? 'Yes' : 'No',
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// EWAJI Authentication System Usage Examples
// This file demonstrates various ways to use the AuthFlow system

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth.dart'; // Import all auth components

// Example 1: Basic usage with automatic UI handling
class BasicAuthExample extends StatelessWidget {
  const BasicAuthExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return HomeScreen(user: state.user!);
        }
        
        return AuthFlow(
          onAuthenticated: () {
            // Optional callback when user authenticates
            print('User authenticated successfully!');
          },
        );
      },
    );
  }
}

// Example 2: Custom authentication handling
class CustomAuthExample extends StatelessWidget {
  const CustomAuthExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          // Navigate to main app
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.hasError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.isLoading) {
            return LoadingScreen();
          }
          
          return AuthFlow(initialUserType: UserType.provider);
        },
      ),
    );
  }
}

// Example 3: Manual authentication triggers
class ManualAuthTriggers extends StatelessWidget {
  const ManualAuthTriggers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email sign-in
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthEmailSignInRequested(
                email: 'user@example.com',
                password: 'password123',
                userType: UserType.client,
              ));
            },
            child: Text('Sign In with Email'),
          ),
          
          // Google sign-in
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthGoogleSignInRequested(
                userType: UserType.provider,
              ));
            },
            child: Text('Sign In with Google'),
          ),
          
          // Phone sign-in
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthPhoneSignInRequested(
                phoneNumber: '+1234567890',
                userType: UserType.client,
              ));
            },
            child: Text('Sign In with Phone'),
          ),
          
          // Biometric unlock
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthBiometricUnlockRequested());
            },
            child: Text('Unlock with Biometrics'),
          ),
          
          // Sign out
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// Example 4: Authentication state monitoring
class AuthStateMonitor extends StatelessWidget {
  const AuthStateMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Auth State Monitor')),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${state.status}'),
                Text('User: ${state.user?.email ?? 'None'}'),
                Text('Biometric Available: ${state.biometricAvailable}'),
                Text('Biometric Enabled: ${state.biometricEnabled}'),
                Text('PIN Enabled: ${state.pinEnabled}'),
                if (state.hasError) Text('Error: ${state.errorMessage}'),
                
                SizedBox(height: 20),
                
                // Status-specific widgets
                if (state.status == AuthStatus.loading)
                  CircularProgressIndicator(),
                
                if (state.status == AuthStatus.phoneVerificationPending)
                  Text('Waiting for SMS verification...'),
                
                if (state.isAuthenticated)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Authenticated User:'),
                          Text('UID: ${state.user!.uid}'),
                          Text('Email: ${state.user!.email}'),
                          Text('Type: ${state.user!.userType}'),
                          Text('Email Verified: ${state.user!.isEmailVerified}'),
                          Text('Phone Verified: ${state.user!.isPhoneVerified}'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Example 5: App initialization with auth
class AuthInitializedApp extends StatelessWidget {
  const AuthInitializedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthInitializer.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: SplashScreen(),
          );
        }
        
        if (snapshot.hasError) {
          return MaterialApp(
            home: ErrorScreen(error: snapshot.error.toString()),
          );
        }
        
        return BlocProvider(
          create: (context) => AuthRepository.createAuthBloc(),
          child: MaterialApp(
            title: 'EWAJI',
            home: BasicAuthExample(),
          ),
        );
      },
    );
  }
}

// Helper widgets
class HomeScreen extends StatelessWidget {
  final AuthUser user;
  
  const HomeScreen({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.displayName ?? user.email}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Type: ${user.userType}'),
            Text('Email Verified: ${user.isEmailVerified}'),
            if (user.phoneNumber != null)
              Text('Phone: ${user.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('EWAJI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({super.key, required this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 20),
            Text('Initialization Error'),
            Text(error),
          ],
        ),
      ),
    );
  }
}

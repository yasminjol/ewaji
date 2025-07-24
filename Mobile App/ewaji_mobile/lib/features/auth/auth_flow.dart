import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'bloc/auth_event.dart';
import 'models/auth_user.dart';
import 'widgets/login_screen.dart';
import 'widgets/biometric_lock_screen.dart';
import 'widgets/pin_lock_screen.dart';
import 'widgets/phone_verification_screen.dart';

/// AuthFlow widget that handles the complete authentication flow
/// 
/// This widget listens to the AuthBloc state and renders the appropriate
/// screen based on the current authentication status:
/// - Unauthenticated: Shows login screen
/// - BiometricLocked: Shows biometric unlock screen
/// - PinLocked: Shows PIN unlock screen
/// - PhoneVerificationPending: Shows phone verification screen
/// - Loading: Shows loading indicator
/// - Error: Shows error message with retry option
class AuthFlow extends StatelessWidget {
  const AuthFlow({
    super.key,
    this.onAuthenticated,
    this.initialUserType,
  });

  /// Callback called when user successfully authenticates
  final VoidCallback? onAuthenticated;
  
  /// Initial user type preference (client or provider)
  final UserType? initialUserType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Call onAuthenticated callback when user is successfully authenticated
        if (state.isAuthenticated && onAuthenticated != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onAuthenticated!();
          });
        }
        
        // Show specific error messages for social login failures
        if (state.hasError) {
          String message = state.errorMessage!;
          String actionLabel = 'Dismiss';
          VoidCallback? retryAction;
          
          // Add retry action for social login failures
          if (message.contains('Social sign-in failed') || 
              message.contains('Google sign-in failed') || 
              message.contains('Apple sign-in failed')) {
            actionLabel = 'Try Again';
            retryAction = () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // Note: Specific retry logic would need to be implemented
              // based on the last attempted social provider
            };
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: retryAction ?? () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
              duration: const Duration(seconds: 6),
            ),
          );
        }
      },
      builder: (context, state) {
        // Show loading indicator for loading and social login states
        if (state.isLoading) {
          return const _LoadingScreen();
        }

        // Handle different authentication states
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.unauthenticated:
            return AuthLoginScreen(initialUserType: initialUserType);

          case AuthStatus.biometricLocked:
            return BiometricLockScreen(
              user: state.user!,
              biometricAvailable: state.biometricAvailable,
              onFallbackToPin: state.pinEnabled
                  ? () => context.read<AuthBloc>().add(
                        const AuthPinUnlockRequested(pin: ''),
                      )
                  : null,
            );

          case AuthStatus.pinLocked:
            return PinLockScreen(
              user: state.user!,
              onFallbackToBiometric: state.biometricEnabled
                  ? () => context.read<AuthBloc>().add(
                        const AuthBiometricUnlockRequested(),
                      )
                  : null,
            );

          case AuthStatus.phoneVerificationPending:
            return PhoneVerificationScreen(
              verificationId: state.verificationId!,
            );

          case AuthStatus.socialLoginInProgress:
            return const _SocialLoginLoadingScreen();

          case AuthStatus.authenticated:
            // Handle new user onboarding navigation
            if (state.isNewUser && state.user != null) {
              return _NewUserOnboardingScreen(user: state.user!);
            }
            // This state should trigger the onAuthenticated callback
            // and the parent widget should handle navigation
            return const _AuthenticatedScreen();

          case AuthStatus.loading:
            return const _LoadingScreen();

          case AuthStatus.error:
            return _ErrorScreen(
              message: state.errorMessage ?? 'An unexpected error occurred',
              onRetry: () {
                context.read<AuthBloc>().add(const AuthStatusRequested());
              },
            );
        }
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E50A1),
              Color(0xFF4F4391),
              Color(0xFF403676),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 24),
              Text(
                'Authenticating...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthenticatedScreen extends StatelessWidget {
  const _AuthenticatedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 24),
            Text(
              'Authentication Successful',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E50A1),
              Color(0xFF4F4391),
              Color(0xFF403676),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Authentication Error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF5E50A1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginLoadingScreen extends StatelessWidget {
  const _SocialLoginLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E50A1),
              Color(0xFF4F4391),
              Color(0xFF403676),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 24),
              Text(
                'Signing in...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Connecting with your social account',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewUserOnboardingScreen extends StatelessWidget {
  const _NewUserOnboardingScreen({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E50A1),
              Color(0xFF4F4391),
              Color(0xFF403676),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to EWAJI!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome ${user.displayName ?? user.email}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(
                  user.userType == UserType.client
                      ? 'Let\'s set up your profile and personalize your experience'
                      : 'Let\'s help you choose your service categories and set up your provider profile',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to appropriate onboarding flow
                    // For client: Navigate to personalization/onboarding
                    // For provider: Navigate to category selection
                    if (user.userType == UserType.client) {
                      // Navigate to client onboarding
                      // Navigator.pushReplacementNamed(context, '/onboarding');
                    } else {
                      // Navigate to provider onboarding/category selection
                      // Navigator.pushReplacementNamed(context, '/provider-onboarding');
                    }
                    
                    // For now, just trigger the authenticated callback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          user.userType == UserType.client
                              ? 'Client onboarding flow would start here'
                              : 'Provider category selection would start here',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF5E50A1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    user.userType == UserType.client
                        ? 'Start Personalization'
                        : 'Choose Categories',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Skip onboarding - go directly to main app
                    // The parent AuthFlow widget will handle this via the onAuthenticated callback
                  },
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

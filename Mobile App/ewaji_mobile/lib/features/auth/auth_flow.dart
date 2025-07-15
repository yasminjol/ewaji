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
        
        // Show error messages
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // Show loading indicator
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

          case AuthStatus.authenticated:
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

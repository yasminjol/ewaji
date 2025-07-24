import 'package:equatable/equatable.dart';
import '../models/auth_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status on app startup
class AuthStatusRequested extends AuthEvent {
  const AuthStatusRequested();
}

/// Email authentication events
class AuthEmailSignInRequested extends AuthEvent {
  const AuthEmailSignInRequested({
    required this.email,
    required this.password,
    required this.userType,
  });

  final String email;
  final String password;
  final UserType userType;

  @override
  List<Object> get props => [email, password, userType];
}

class AuthEmailSignUpRequested extends AuthEvent {
  const AuthEmailSignUpRequested({
    required this.email,
    required this.password,
    required this.userType,
    this.displayName,
  });

  final String email;
  final String password;
  final UserType userType;
  final String? displayName;

  @override
  List<Object?> get props => [email, password, userType, displayName];
}

/// Phone authentication events
class AuthPhoneSignInRequested extends AuthEvent {
  const AuthPhoneSignInRequested({
    required this.phoneNumber,
    required this.userType,
  });

  final String phoneNumber;
  final UserType userType;

  @override
  List<Object> get props => [phoneNumber, userType];
}

class AuthPhoneVerificationCodeSubmitted extends AuthEvent {
  const AuthPhoneVerificationCodeSubmitted({
    required this.verificationId,
    required this.code,
  });

  final String verificationId;
  final String code;

  @override
  List<Object> get props => [verificationId, code];
}

/// Social authentication events
enum SocialProvider { google, apple }

class SocialLoginRequested extends AuthEvent {
  const SocialLoginRequested({
    required this.provider,
    required this.userType,
  });

  final SocialProvider provider;
  final UserType userType;

  @override
  List<Object> get props => [provider, userType];
}

// Legacy events for backward compatibility
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested({required this.userType});

  final UserType userType;

  @override
  List<Object> get props => [userType];
}

class AuthAppleSignInRequested extends AuthEvent {
  const AuthAppleSignInRequested({required this.userType});

  final UserType userType;

  @override
  List<Object> get props => [userType];
}

/// Biometric authentication events
class AuthBiometricUnlockRequested extends AuthEvent {
  const AuthBiometricUnlockRequested();
}

class AuthPinUnlockRequested extends AuthEvent {
  const AuthPinUnlockRequested({required this.pin});

  final String pin;

  @override
  List<Object> get props => [pin];
}

/// General auth events
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

class AuthEmailVerificationRequested extends AuthEvent {
  const AuthEmailVerificationRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  const AuthPasswordResetRequested({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

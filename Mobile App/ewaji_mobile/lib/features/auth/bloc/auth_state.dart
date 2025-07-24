import 'package:equatable/equatable.dart';
import '../models/auth_user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  biometricLocked,
  pinLocked,
  phoneVerificationPending,
  socialLoginInProgress,
  error,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.verificationId,
    this.biometricAvailable = false,
    this.biometricEnabled = false,
    this.pinEnabled = false,
    this.isNewUser = false,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;
  final String? verificationId;
  final bool biometricAvailable;
  final bool biometricEnabled;
  final bool pinEnabled;
  final bool isNewUser;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading || status == AuthStatus.socialLoginInProgress;
  bool get hasError => status == AuthStatus.error && errorMessage != null;
  bool get requiresPhoneVerification => status == AuthStatus.phoneVerificationPending;
  bool get isLocked => status == AuthStatus.biometricLocked || status == AuthStatus.pinLocked;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    String? verificationId,
    bool? biometricAvailable,
    bool? biometricEnabled,
    bool? pinEnabled,
    bool? isNewUser,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      verificationId: verificationId ?? this.verificationId,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'user': user?.toJson(),
      'biometricAvailable': biometricAvailable,
      'biometricEnabled': biometricEnabled,
      'pinEnabled': pinEnabled,
      'isNewUser': isNewUser,
    };
  }

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      status: AuthStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AuthStatus.initial,
      ),
      user: json['user'] != null ? AuthUser.fromJson(json['user']) : null,
      biometricAvailable: json['biometricAvailable'] ?? false,
      biometricEnabled: json['biometricEnabled'] ?? false,
      pinEnabled: json['pinEnabled'] ?? false,
      isNewUser: json['isNewUser'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        verificationId,
        biometricAvailable,
        biometricEnabled,
        pinEnabled,
        isNewUser,
      ];
}

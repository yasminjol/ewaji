import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/auth_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _authStateSubscription;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthState()) {
    
    // Listen to Firebase auth state changes
    _authStateSubscription = _authService.authStateChanges.listen(
      (firebaseUser) => add(const AuthStatusRequested()),
    );

    on<AuthStatusRequested>(_onAuthStatusRequested);
    on<AuthEmailSignInRequested>(_onEmailSignInRequested);
    on<AuthEmailSignUpRequested>(_onEmailSignUpRequested);
    on<AuthPhoneSignInRequested>(_onPhoneSignInRequested);
    on<AuthPhoneVerificationCodeSubmitted>(_onPhoneVerificationCodeSubmitted);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthAppleSignInRequested>(_onAppleSignInRequested);
    on<AuthBiometricUnlockRequested>(_onBiometricUnlockRequested);
    on<AuthPinUnlockRequested>(_onPinUnlockRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);

    // Check initial auth status
    add(const AuthStatusRequested());
  }

  Future<void> _onAuthStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authService.currentUser;
      
      if (user == null) {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ));
        return;
      }

      // Check if biometric/pin lock is enabled
      final biometricAvailable = await _authService.isBiometricAvailable();
      final biometricEnabled = await _authService.isBiometricEnabled();
      final pinEnabled = await _authService.isPinEnabled();

      emit(state.copyWith(
        status: (biometricEnabled || pinEnabled) 
            ? (biometricEnabled ? AuthStatus.biometricLocked : AuthStatus.pinLocked)
            : AuthStatus.authenticated,
        user: user,
        biometricAvailable: biometricAvailable,
        biometricEnabled: biometricEnabled,
        pinEnabled: pinEnabled,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEmailSignInRequested(
    AuthEmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final user = await _authService.signInWithEmail(
        email: event.email,
        password: event.password,
        userType: event.userType,
      );

      final biometricAvailable = await _authService.isBiometricAvailable();
      final biometricEnabled = await _authService.isBiometricEnabled();
      final pinEnabled = await _authService.isPinEnabled();

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        biometricAvailable: biometricAvailable,
        biometricEnabled: biometricEnabled,
        pinEnabled: pinEnabled,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEmailSignUpRequested(
    AuthEmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final user = await _authService.signUpWithEmail(
        email: event.email,
        password: event.password,
        userType: event.userType,
        displayName: event.displayName,
      );

      final biometricAvailable = await _authService.isBiometricAvailable();

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        biometricAvailable: biometricAvailable,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPhoneSignInRequested(
    AuthPhoneSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final verificationId = await _authService.sendPhoneVerification(
        phoneNumber: event.phoneNumber,
        userType: event.userType,
      );

      emit(state.copyWith(
        status: AuthStatus.phoneVerificationPending,
        verificationId: verificationId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPhoneVerificationCodeSubmitted(
    AuthPhoneVerificationCodeSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      // We need to get the user type from somewhere - you might want to store it
      // For now, let's assume client type or get it from storage
      final user = await _authService.verifyPhoneCode(
        verificationId: event.verificationId,
        code: event.code,
        userType: state.user?.userType ?? UserType.client,
      );

      final biometricAvailable = await _authService.isBiometricAvailable();

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        biometricAvailable: biometricAvailable,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final user = await _authService.signInWithGoogle(
        userType: event.userType,
      );

      final biometricAvailable = await _authService.isBiometricAvailable();

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        biometricAvailable: biometricAvailable,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAppleSignInRequested(
    AuthAppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final user = await _authService.signInWithApple(
        userType: event.userType,
      );

      final biometricAvailable = await _authService.isBiometricAvailable();

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        biometricAvailable: biometricAvailable,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onBiometricUnlockRequested(
    AuthBiometricUnlockRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final success = await _authService.authenticateWithBiometrics();
      
      if (success) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Biometric authentication failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPinUnlockRequested(
    AuthPinUnlockRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final success = await _authService.verifyPin(event.pin);
      
      if (success) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Incorrect PIN',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.signOut();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.refreshToken();
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to refresh token: ${e.toString()}',
      ));
    }
  }

  Future<void> _onEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.sendEmailVerification();
      // Optionally emit a success state or keep current state
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.sendPasswordResetEmail(event.email);
      // Optionally emit a success state or keep current state
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthState.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    // Only persist certain states to avoid persisting error states
    if (state.status == AuthStatus.authenticated || 
        state.status == AuthStatus.biometricLocked ||
        state.status == AuthStatus.pinLocked) {
      return state.toJson();
    }
    return null;
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}

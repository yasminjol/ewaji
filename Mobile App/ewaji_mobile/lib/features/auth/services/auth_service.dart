import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_user.dart' as app_models;

class AuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _userTypeKey = 'user_type';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _pinEnabledKey = 'pin_enabled';
  static const String _pinHashKey = 'pin_hash';

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final LocalAuthentication _localAuth;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    LocalAuthentication? localAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _localAuth = localAuth ?? LocalAuthentication();

  /// Get current user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get current authenticated user
  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Convert Firebase User to app AuthUser
  Future<app_models.AuthUser?> get currentUser async {
    final firebaseUser = currentFirebaseUser;
    if (firebaseUser == null) return null;

    final userTypeString = await _storage.read(key: _userTypeKey);
    final userType = userTypeString != null
        ? app_models.UserType.values.firstWhere(
            (e) => e.name == userTypeString,
            orElse: () => app_models.UserType.client,
          )
        : app_models.UserType.client;

    return app_models.AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      phoneNumber: firebaseUser.phoneNumber,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      userType: userType,
      isEmailVerified: firebaseUser.emailVerified,
      isPhoneVerified: firebaseUser.phoneNumber != null,
    );
  }

  /// Email sign in
  Future<app_models.AuthUser> signInWithEmail({
    required String email,
    required String password,
    required app_models.UserType userType,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _storeUserType(userType);

      return _convertToAuthUser(credential.user!, userType);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Email sign up
  Future<app_models.AuthUser> signUpWithEmail({
    required String email,
    required String password,
    required app_models.UserType userType,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      await _storeUserType(userType);

      return _convertToAuthUser(credential.user!, userType);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Google sign in
  Future<app_models.AuthUser> signInWithGoogle({
    required app_models.UserType userType,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      await _storeUserType(userType);

      return _convertToAuthUser(userCredential.user!, userType, isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Apple sign in
  Future<app_models.AuthUser> signInWithApple({
    required app_models.UserType userType,
  }) async {
    if (!Platform.isIOS) {
      throw Exception('Apple Sign In is only available on iOS');
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      await _storeUserType(userType);

      return _convertToAuthUser(userCredential.user!, userType, isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false);
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }

  /// Phone sign in - Step 1: Send verification code
  Future<String> sendPhoneVerification({
    required String phoneNumber,
    required app_models.UserType userType,
  }) async {
    final completer = Completer<String>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        await _firebaseAuth.signInWithCredential(credential);
        await _storeUserType(userType);
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(_mapFirebaseError(e));
      },
      codeSent: (String verificationId, int? resendToken) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
    );

    return completer.future;
  }

  /// Phone sign in - Step 2: Verify code
  Future<app_models.AuthUser> verifyPhoneCode({
    required String verificationId,
    required String code,
    required app_models.UserType userType,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      await _storeUserType(userType);

      return _convertToAuthUser(userCredential.user!, userType);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
    await _clearStoredData();
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Refresh current user token
  Future<void> refreshToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.getIdToken(true);
    }
  }

  /// Biometric authentication methods
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Biometric settings
  Future<bool> isBiometricEnabled() async {
    final enabled = await _storage.read(key: _biometricEnabledKey);
    return enabled == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  /// PIN authentication methods
  Future<bool> isPinEnabled() async {
    final enabled = await _storage.read(key: _pinEnabledKey);
    return enabled == 'true';
  }

  Future<void> setPin(String pin) async {
    final hashedPin = _hashPin(pin);
    await _storage.write(key: _pinHashKey, value: hashedPin);
    await _storage.write(key: _pinEnabledKey, value: 'true');
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _storage.read(key: _pinHashKey);
    if (storedHash == null) return false;
    
    return _hashPin(pin) == storedHash;
  }

  Future<void> removePin() async {
    await _storage.delete(key: _pinHashKey);
    await _storage.write(key: _pinEnabledKey, value: 'false');
  }

  /// Private helper methods
  Future<void> _storeUserType(app_models.UserType userType) async {
    await _storage.write(key: _userTypeKey, value: userType.name);
  }

  Future<void> _clearStoredData() async {
    await _storage.delete(key: _userTypeKey);
  }

  app_models.AuthUser _convertToAuthUser(
    User firebaseUser, 
    app_models.UserType userType, {
    bool isNewUser = false,
  }) {
    return app_models.AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      phoneNumber: firebaseUser.phoneNumber,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      userType: userType,
      isEmailVerified: firebaseUser.emailVerified,
      isPhoneVerified: firebaseUser.phoneNumber != null,
      isNewUser: isNewUser,
    );
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }

  String _hashPin(String pin) {
    // Simple hash for demonstration - use proper crypto in production
    var hash = 0;
    for (var i = 0; i < pin.length; i++) {
      hash = ((hash << 5) - hash) + pin.codeUnitAt(i);
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.toString();
  }
}

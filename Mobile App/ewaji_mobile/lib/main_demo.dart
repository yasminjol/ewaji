import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/index.dart';

void main() {
  runApp(const AuthDemoApp());
}

class AuthDemoApp extends StatelessWidget {
  const AuthDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MockAuthBloc(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('EWAJI Authentication Demo'),
        backgroundColor: const Color(0xFF5E50A1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Authentication Flow Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E50A1),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Demo buttons for different auth screens
            ElevatedButton(
              onPressed: () => _showScreen(context, const AuthLoginScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Login Screen'),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () => _showScreen(context, _createBiometricScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Biometric Lock Screen'),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () => _showScreen(context, _createPinScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('PIN Lock Screen'),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () => _showScreen(context, const PhoneVerificationScreen(verificationId: 'demo-id')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E50A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Phone Verification Screen'),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Features Demonstrated:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5E50A1),
              ),
            ),
            const SizedBox(height: 16),
            
            const Text(
              '✅ Email/password authentication UI\n'
              '✅ Google & Apple sign-in buttons\n'
              '✅ Phone number verification\n'
              '✅ Biometric unlock interface\n'
              '✅ PIN unlock with keypad\n'
              '✅ Modern, responsive design\n'
              '✅ State management with Bloc\n'
              '✅ Error handling & validation',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            
            const Spacer(),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This demo shows the UI components without Firebase integration. '
                    'To enable full functionality, add Firebase configuration files '
                    '(GoogleService-Info.plist for iOS, google-services.json for Android) '
                    'and configure your Firebase project.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _createBiometricScreen() {
    final mockUser = AuthUser(
      uid: 'demo-uid',
      email: 'demo@example.com',
      displayName: 'Demo User',
      userType: UserType.client,
      isEmailVerified: true,
    );
    
    return BiometricLockScreen(
      user: mockUser,
      biometricAvailable: true,
    );
  }

  Widget _createPinScreen() {
    final mockUser = AuthUser(
      uid: 'demo-uid',
      email: 'demo@example.com',
      displayName: 'Demo User',
      userType: UserType.client,
      isEmailVerified: true,
    );
    
    return PinLockScreen(user: mockUser);
  }
}

// Mock AuthBloc for demo purposes
class MockAuthBloc extends Cubit<AuthState> {
  MockAuthBloc() : super(const AuthState());

  void add(AuthEvent event) {
    // Mock implementation - just emit loading then error for demo
    emit(state.copyWith(status: AuthStatus.loading));
    
    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Demo mode - Firebase not configured',
      ));
    });
  }
}

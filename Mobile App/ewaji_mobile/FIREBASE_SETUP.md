# 🔥 Firebase Setup Guide for EWAJI Authentication

## Quick Setup Steps

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `ewaji-mobile`
4. Enable Google Analytics (optional)
5. Create project

### 2. Add iOS App
1. In Firebase console, click "Add app" → iOS
2. **iOS bundle ID**: `com.example.ewajiMobile` (or your bundle ID)
3. **App nickname**: `EWAJI iOS`
4. Download `GoogleService-Info.plist`
5. Add to: `ios/Runner/GoogleService-Info.plist`

### 3. Add Android App
1. In Firebase console, click "Add app" → Android
2. **Android package name**: `com.example.ewaji_mobile` (or your package name)
3. **App nickname**: `EWAJI Android`
4. Download `google-services.json`
5. Add to: `android/app/google-services.json`

### 4. Enable Authentication Methods
1. In Firebase console → Authentication → Sign-in method
2. Enable the following providers:
   - ✅ **Email/Password**
   - ✅ **Phone** (requires SMS configuration)
   - ✅ **Google** (requires OAuth setup)
   - ✅ **Apple** (requires Apple Developer account)

### 5. Configure Google Sign-In

#### iOS Configuration:
1. In Firebase console → Authentication → Sign-in method → Google
2. Copy the **iOS URL scheme** from GoogleService-Info.plist
3. Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

#### Android Configuration:
1. Add SHA-1 fingerprints to Firebase project
2. Download updated `google-services.json`
3. Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.android.gms:play-services-auth'
}
```

### 6. Configure Apple Sign-In (iOS only)

1. **Apple Developer Console:**
   - Enable "Sign In with Apple" capability
   - Create Service ID
   - Configure domains and return URLs

2. **Firebase Console:**
   - Authentication → Sign-in method → Apple
   - Add Service ID and Team ID

3. **Xcode:**
   - Add "Sign In with Apple" capability to Runner target

### 7. Update main.dart

Replace the demo main.dart with the production version:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/auth_flow.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase and HydratedBloc
  await AuthInitializer.initialize();
  
  runApp(const EwajiApp());
}

class EwajiApp extends StatelessWidget {
  const EwajiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthRepository.createAuthBloc(),
      child: MaterialApp(
        title: 'EWAJI',
        theme: ThemeData(
          primaryColor: const Color(0xFF5E50A1),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return MainAppScreen(user: state.user!);
        }
        
        return AuthFlow(
          onAuthenticated: () {
            // Handle successful authentication
          },
          initialUserType: UserType.client,
        );
      },
    );
  }
}

// Your main app screen after authentication
class MainAppScreen extends StatelessWidget {
  final AuthUser user;
  
  const MainAppScreen({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.displayName ?? user.email}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Type: ${user.userType}'),
            Text('Email: ${user.email}'),
            if (user.phoneNumber != null)
              Text('Phone: ${user.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}
```

### 8. Test Authentication

After setup, test each authentication method:

1. **Email/Password**: Sign up and sign in
2. **Google**: Test social sign-in flow
3. **Apple**: Test on iOS device (simulator requires Apple ID)
4. **Phone**: Test SMS verification (requires phone number)
5. **Biometric**: Test on physical device with fingerprint/face ID

### 9. Production Considerations

- **Security Rules**: Set up Firestore security rules
- **Rate Limiting**: Configure authentication rate limits
- **Error Handling**: Customize error messages
- **Analytics**: Track authentication events
- **Testing**: Set up unit and integration tests

---

## 📱 Current Demo Status

**✅ What Works Now:**
- Complete UI for all authentication flows
- State management with Bloc pattern
- Biometric and PIN unlock interfaces
- Phone verification UI
- Email/password sign-in forms
- Social sign-in buttons

**🔧 What Needs Firebase:**
- Actual authentication
- User session management
- Cloud data sync
- Push notifications

---

## 🚀 Ready to Deploy

Once Firebase is configured, your authentication system will be production-ready with enterprise-grade security and all the features specified in M-FR-01!

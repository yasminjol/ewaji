# EWAJI Mobile App

A Flutter mobile application converted from the EWAJI React/TypeScript web app. This app serves both service providers and clients in a service booking platform.

## Features

### Provider Features
- **Complete Registration Flow**: Multi-step registration with personal info, business details, and category selection
- **Phone OTP Verification**: Secure phone number verification with 6-digit OTP
- **Professional Dashboard**: Comprehensive dashboard with earnings, bookings, and analytics
- **Service Management**: Manage services, pricing, and availability
- **Booking Management**: View and manage client bookings
- **Profile Management**: Update business information and settings

### Client Features
- **Easy Registration**: Simple sign-up process for clients
- **Service Discovery**: Browse and search for service providers
- **Booking System**: Schedule appointments with preferred providers
- **Appointment Management**: View upcoming and past appointments  
- **In-app Messaging**: Communicate with service providers
- **Profile Management**: Manage personal information and preferences

### Authentication
- **Dual Login System**: Separate login flows for providers and clients
- **Social Login**: Google and Apple sign-in integration (UI ready)
- **Password Recovery**: Forgot password functionality
- **Remember Me**: Persistent login option

### UI/UX Features
- **Modern Design**: Beautiful gradient backgrounds and clean interfaces
- **Responsive Layout**: Optimized for various screen sizes
- **Smooth Animations**: Engaging transitions and loading states
- **Form Validation**: Comprehensive input validation with error messages
- **Loading States**: User-friendly loading indicators throughout the app

## Technology Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Caching**: Cached Network Image
- **Fonts**: Google Fonts
- **UI Components**: Material Design 3

## Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── features/
│   ├── auth/                # Authentication screens
│   │   ├── provider_login_screen.dart
│   │   ├── client_login_screen.dart
│   │   ├── provider_register_step1_screen.dart
│   │   ├── provider_register_step2_screen.dart
│   │   ├── provider_category_selection_screen.dart
│   │   ├── provider_phone_otp_screen.dart
│   │   └── provider_success_screen.dart
│   ├── provider/            # Provider-specific features
│   │   └── provider_dashboard_tabs.dart
│   └── client/              # Client-specific features
│       ├── client_app.dart
│       ├── client_home_screen.dart
│       ├── client_explore_screen.dart
│       ├── client_appointments_screen.dart
│       ├── client_inbox_screen.dart
│       └── client_profile_screen.dart
├── shared/                  # Shared utilities and widgets
├── core/                    # Core app configuration
└── test/                    # Test files
```

## Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- iOS Simulator or Android Emulator
- Xcode (for iOS development)
- Android Studio (for Android development)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd ewaji/Mobile\ App/ewaji_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For iOS Simulator
   flutter run -d ios

   # For Android Emulator  
   flutter run -d android

   # For a specific device
   flutter devices  # List available devices
   flutter run -d [device-id]
   ```

### Building for Production

**iOS Build:**
```bash
flutter build ios --release
```

**Android Build:**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

## App Navigation Flow

### Provider Flow
1. **Welcome Screen** → Choose "Provider"
2. **Provider Login** → Enter credentials or sign up
3. **Registration Step 1** → Personal information (name, email, password)
4. **Registration Step 2** → Business details (name, address, phone)
5. **Category Selection** → Choose business category and accept terms
6. **Phone OTP** → Verify phone number with 6-digit code
7. **Success Screen** → Registration complete with next steps
8. **Dashboard** → Main provider interface with tabs:
   - Dashboard: Earnings and metrics
   - Bookings: Manage appointments
   - Services: Service management
   - Profile: Account settings

### Client Flow
1. **Welcome Screen** → Choose "Client"
2. **Client Login** → Enter credentials or sign up
3. **Client App** → Bottom navigation with:
   - Home: Featured services and quick booking
   - Explore: Browse all service providers
   - Appointments: View scheduled bookings
   - Inbox: Messages with providers
   - Profile: Account management

## Key Features Implementation

### Provider Registration
- **Step 1**: Full name, email, password with validation
- **Step 2**: Business name, address, city, postal code, phone
- **Categories**: 12 service categories with visual icons
- **OTP Verification**: Auto-advancing 6-digit code input
- **Success**: Animated congratulations with onboarding tips

### Authentication
- **Form Validation**: Real-time validation with error messages
- **Password Visibility**: Toggle for password fields
- **Remember Me**: Checkbox for persistent login
- **Forgot Password**: Modal dialog for password reset
- **Social Login**: Google and Apple buttons (UI ready)

### Dashboard & Management
- **Provider Dashboard**: Earnings cards, booking statistics, recent activity
- **Client Home**: Service carousel, provider feed, quick booking
- **Booking System**: Date/time selection with confirmation
- **Profile Management**: Editable user information

## Testing

Run the test suite:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## Code Quality

Check code analysis:
```bash
flutter analyze
```

Format code:
```bash
flutter format .
```

## Dependencies

### Core Dependencies
```yaml
flutter:
  sdk: flutter
go_router: ^14.6.1          # Navigation
hooks_riverpod: ^2.6.1      # State management  
dio: ^5.7.0                 # HTTP client
cached_network_image: ^3.4.1 # Image caching
google_fonts: ^6.2.1       # Typography
```

### Development Dependencies
```yaml
flutter_test:
  sdk: flutter
flutter_lints: ^5.0.0      # Linting rules
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Known Issues

- Social login integration requires platform-specific setup
- Some deprecation warnings for `withOpacity` (non-critical)
- Backend integration pending for real data

## Future Enhancements

- [ ] Backend API integration
- [ ] Real-time messaging
- [ ] Push notifications
- [ ] Payment processing
- [ ] Location services
- [ ] Advanced search and filtering
- [ ] Review and rating system
- [ ] Multi-language support

## Platform Support

- ✅ iOS (iPhone/iPad)
- ✅ Android (Phone/Tablet)
- ⚠️ Web (Flutter web support available but not optimized)
- ⚠️ Desktop (Windows/macOS/Linux support available but not tested)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Contact the development team
- Check the Flutter documentation: https://flutter.dev/docs

---

**EWAJI Mobile App** - Connecting service providers with clients seamlessly.

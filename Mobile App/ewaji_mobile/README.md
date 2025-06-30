# EWAJI Mobile App

Flutter mobile application for EWAJI - a platform connecting beauty service providers with clients.

## Features

### Client Features
- Browse and discover beauty service providers
- View provider profiles and services
- Book appointments with calendar integration
- Manage appointments and view booking history
- Real-time messaging with providers
- User profile management

### Provider Features
- Complete registration and verification process
- Manage service offerings and pricing
- View and manage bookings
- Dashboard with analytics and metrics
- Client communication through messaging
- Profile and settings management

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core utilities and constants
├── features/
│   ├── auth/                   # Authentication screens
│   ├── client/                 # Client-specific screens
│   └── provider/               # Provider-specific screens
└── shared/                     # Shared widgets and models
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.5.0)
- Dart SDK (>=3.5.0)
- iOS development setup (Xcode, iOS Simulator)
- Android development setup (Android Studio, Android Emulator)

### Installation

1. Clone the repository:
```bash
cd /path/to/ewaji/Mobile\ App/ewaji_mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For specific device
flutter devices  # List available devices
flutter run -d [device-id]
```

### Testing on iPhone

1. **Connect your iPhone** to your Mac via USB
2. **Enable Developer Mode** on your iPhone (Settings > Privacy & Security > Developer Mode)
3. **Trust your Mac** when prompted on the iPhone
4. **Run the app**:
```bash
flutter run -d ios
```

### Building for Release

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
```

## Dependencies

- **go_router**: ^14.6.2 - Navigation and routing
- **flutter_riverpod**: ^2.6.1 - State management
- **cached_network_image**: ^3.4.1 - Image caching
- **table_calendar**: ^3.1.2 - Calendar widget
- **dio**: ^5.7.0 - HTTP client
- **shared_preferences**: ^2.3.3 - Local storage
- **fluttertoast**: ^8.2.8 - Toast notifications

## Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Formatting
```bash
dart format .
```

## Current Status

✅ **Completed:**
- Authentication flows (login, registration, OTP verification)
- Provider dashboard with tabs and metrics
- Client app with bottom navigation
- Core screens and navigation structure
- iOS build configuration

🚧 **In Progress:**
- Backend API integration
- Real booking functionality
- Payment processing
- Push notifications
- Image upload capabilities

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and analysis
5. Submit a pull request

## Support

For issues and questions, please create an issue in the GitHub repository.

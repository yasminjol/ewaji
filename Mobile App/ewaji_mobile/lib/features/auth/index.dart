// Auth Feature Barrel File
// Export all authentication-related components

// Core
export 'auth_flow.dart';
export 'auth_repository.dart';
export 'auth.dart';

// Screens
export 'client_login_screen.dart';
export 'client_register_step1_screen.dart';
export 'client_register_step2_screen.dart';
export 'provider_category_selection_screen.dart';
export 'provider_phone_otp_screen.dart';
export 'provider_register_step1_screen.dart';
export 'provider_register_step2_screen.dart';
export 'provider_success_screen.dart';
export 'welcome_screen.dart';

// Cubit
export 'cubit/primary_category_cubit.dart';

// Models
export 'models/auth_user.dart';
export 'models/primary_category.dart';

// Services
export 'services/auth_service.dart';

// Widgets
export 'widgets/biometric_lock_screen.dart';
export 'widgets/pin_lock_screen.dart';
export 'widgets/primary_category_selector.dart';

// Examples
export 'examples.dart';

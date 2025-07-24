import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'services/auth_service.dart';
import 'bloc/auth_bloc.dart';
import '../../firebase_options.dart';

/// Repository that provides authentication-related dependencies
class AuthRepository {
  static AuthService? _authService;
  
  static AuthService get authService {
    _authService ??= AuthService();
    return _authService!;
  }
  
  static AuthBloc createAuthBloc() {
    return AuthBloc(authService: authService);
  }
}

/// Helper class to initialize the authentication system
class AuthInitializer {
  static Future<void> initialize() async {
    try {
      // Initialize Firebase with default options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('⚠️ Firebase initialization failed: $e');
      print('📝 Note: Using fallback mode - some features may be limited');
      // Continue without crashing - Firebase will be unavailable but app can still run
    }
    
    try {
      // Initialize HydratedBloc storage
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory(),
      );
      print('✅ HydratedBloc storage initialized successfully');
    } catch (e) {
      print('⚠️ HydratedBloc storage initialization failed: $e');
      // This is more critical, but we can still continue
    }
  }
}

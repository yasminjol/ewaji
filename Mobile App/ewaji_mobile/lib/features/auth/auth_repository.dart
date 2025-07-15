import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'services/auth_service.dart';
import 'bloc/auth_bloc.dart';

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
    // Initialize Firebase
    await Firebase.initializeApp();
    
    // Initialize HydratedBloc storage
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
  }
}

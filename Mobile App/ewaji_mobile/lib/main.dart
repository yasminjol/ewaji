import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/index.dart';
import 'features/onboarding/index.dart';
import 'features/home/index.dart';
import 'features/provider_dashboard/index.dart';
import 'features/provider_onboarding/index.dart';
import 'features/discovery/index.dart';
import 'service_detail_demo.dart';
import 'booking_demo.dart';
import 'notification_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase and HydratedBloc storage
  await AuthInitializer.initialize();
  
  runApp(const EwajiApp());
}

class EwajiApp extends StatelessWidget {
  const EwajiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthRepository.createAuthBloc(),
      child: MaterialApp.router(
        title: 'EWAJI',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: const Color(0xFF5E50A1),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    // Demo routes for testing features
    GoRoute(
      path: '/demo/service-detail',
      builder: (context, state) => const ServiceDetailDemo(),
    ),
    GoRoute(
      path: '/demo/booking',
      builder: (context, state) => const BookingDemoScreen(),
    ),
    GoRoute(
      path: '/demo/notifications',
      builder: (context, state) => const NotificationDemoScreen(),
    ),
    GoRoute(
      path: '/demo/personalisation',
      builder: (context, state) => const PersonalisationDemo(),
    ),
    // Auth routes
    GoRoute(
      path: '/provider/login',
      builder: (context, state) => const ProviderLoginScreen(),
    ),
    GoRoute(
      path: '/provider/register-step1',
      builder: (context, state) => const ProviderRegisterStep1Screen(),
    ),
    GoRoute(
      path: '/provider/register-step2',
      builder: (context, state) => const ProviderRegisterStep2Screen(),
    ),
    GoRoute(
      path: '/provider/categories',
      builder: (context, state) => ProviderCategorySelectionScreenStep2(
        onContinue: () {
          // Navigate to phone OTP after category selection
          GoRouter.of(context).go('/provider/phone-otp');
        },
      ),
    ),
    GoRoute(
      path: '/provider/phone-otp',
      builder: (context, state) => const ProviderPhoneOTPScreen(),
    ),
    GoRoute(
      path: '/provider/success',
      builder: (context, state) => const ProviderSuccessScreen(),
    ),
    GoRoute(
      path: '/provider/dashboard',
      builder: (context, state) => const ProviderDashboardTabs(),
    ),
    GoRoute(
      path: '/client/login',
      builder: (context, state) => const ClientLoginScreen(),
    ),
    GoRoute(
      path: '/client/register-step1',
      builder: (context, state) => const ClientRegisterStep1Screen(),
    ),
    GoRoute(
      path: '/client/register-step2',
      builder: (context, state) => const ClientRegisterStep2Screen(),
    ),
    GoRoute(
      path: '/client/personalisation',
      builder: (context, state) => BlocProvider(
        create: (context) => PersonalisationCubit(),
        child: PersonalisationWizardScreen(
          onComplete: () {
            // Navigate to client dashboard after personalisation
            context.go('/client/home');
          },
          onSkip: () {
            // Navigate to client dashboard with default preferences
            context.go('/client/home');
          },
        ),
      ),
    ),
    GoRoute(
      path: '/client/:tab',
      builder: (context, state) {
        final tab = state.pathParameters['tab'] ?? 'home';
        return ClientAppWithPersonalisation(initialTab: tab);
      },
    ),
    GoRoute(
      path: '/discovery',
      builder: (context, state) => const DiscoveryPage(),
    ),
  ],
);

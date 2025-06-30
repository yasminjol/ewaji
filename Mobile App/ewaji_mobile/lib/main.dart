import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/welcome_screen.dart';
import 'features/auth/provider_login_screen.dart';
import 'features/auth/client_login_screen.dart';
import 'features/auth/provider_register_step1_screen.dart';
import 'features/auth/provider_register_step2_screen.dart';
import 'features/auth/provider_category_selection_screen.dart';
import 'features/auth/provider_phone_otp_screen.dart';
import 'features/auth/provider_success_screen.dart';
import 'features/auth/client_register_step1_screen.dart';
import 'features/auth/client_register_step2_screen.dart';
import 'features/provider/provider_dashboard_tabs.dart';
import 'features/client/client_app.dart';

void main() {
  runApp(const ProviderScope(child: EwajiApp()));
}

class EwajiApp extends ConsumerWidget {
  const EwajiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'EWAJI',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color(0xFF5E50A1),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
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
      builder: (context, state) => const ProviderCategorySelectionScreen(),
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
      path: '/client/:tab',
      builder: (context, state) {
        final tab = state.pathParameters['tab'] ?? 'home';
        return ClientApp(initialTab: tab);
      },
    ),
  ],
);
